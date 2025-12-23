-- Lua script with GTK GUI using lgi to tail a Wurm Online log file and track skill gains
-- Requires lgi: sudo pacman -S lua-lgi
-- Usage: lua script.lua [/path/to/logfile.log]
-- If no argument, uses dynamic "_Skills.YYYY-MM.txt" and switches on month change

local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local GLib = lgi.require("GLib")
local GObject = lgi.require("GObject")

local input_path = arg[1]
local current_file_path
local fixed_file = false

-- Helper: check if path is a directory
local function is_dir(path)
	local p = io.popen('[ -d "' .. path .. '" ] && echo dir')
	if not p then return false end
	local result = p:read("*l")
	p:close()
	return result == "dir"
end

if not input_path then
	-- No args: use current dir + dynamic skill file
	current_file_path = "_Skills." .. os.date("%Y-%m") .. ".txt"
	fixed_file = false

elseif is_dir(input_path) then
	-- Argument is a directory: build skill log path
	current_file_path = input_path .. "/_Skills." .. os.date("%Y-%m") .. ".txt"
	fixed_file = false

else
	-- Argument is a file: use exactly as given
	current_file_path = input_path
	fixed_file = true
end


local skills = {} -- skill_name -> {gains = {{time=abs_sec, inc=val}}, total_gain = 0, first_time = nil, last_time = nil, current_level = nil}
local global_last = 0
local current_day_offset = 0
local last_raw_time_sec = -1

-- Function to parse HH:MM:SS to seconds
local function parse_time(time_str)
	local h, m, s = time_str:match("(%d+):(%d+):(%d+)")
	return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
end

-- Function to process a log line
local function process_line(line)
	local time_str, skill, inc_str, level_str = line:match("%[(.+)%] (.-) increased by (%S+) to (%S+)$")
	if not time_str or not skill or not inc_str or not level_str then
		return
	end

	local inc = tonumber(inc_str)
	local raw_time_sec = parse_time(time_str)

	if last_raw_time_sec >= 0 and raw_time_sec < last_raw_time_sec - 300 then
		current_day_offset = current_day_offset + 86400
	end
	last_raw_time_sec = raw_time_sec

	local absolute_time = current_day_offset + raw_time_sec

	if not skills[skill] then
		skills[skill] = {
			gains = {},
			total_gain = 0,
			first_time = absolute_time,
			last_time = absolute_time,
			current_level = tonumber(level_str),
		}
	end

	local data = skills[skill]
	table.insert(data.gains, { time = absolute_time, inc = inc })
	data.total_gain = data.total_gain + inc
	data.first_time = math.min(data.first_time or absolute_time, absolute_time)
	data.last_time = math.max(data.last_time or absolute_time, absolute_time)
	data.current_level = tonumber(level_str)
	global_last = math.max(global_last, absolute_time)
end

-- Function to get stats
local function get_stats()
	local sorted_skills = {}
	for skill, data in pairs(skills) do
		local past_15 = 0
		local past_60 = 0
		for _, g in ipairs(data.gains) do
			if g.time >= global_last - 900 then -- 15 min = 900 sec
				past_15 = past_15 + g.inc
			end
			if g.time >= global_last - 3600 then -- 1 hour = 3600 sec
				past_60 = past_60 + g.inc
			end
		end

		local time_diff = (data.last_time or 0) - (data.first_time or 0)
		local hours = time_diff > 0 and (time_diff / 3600) or 0
		local rate = hours > 0 and (data.total_gain / hours) or 0

		table.insert(sorted_skills, {
			skill = skill,
			current_level = data.current_level or 0,
			total_gain = data.total_gain,
			past_15 = past_15,
			past_60 = past_60,
			rate = rate,
		})
	end

	-- Sort by total_gain descending
	table.sort(sorted_skills, function(a, b)
		return a.total_gain > b.total_gain
	end)
	return sorted_skills
end

-- GUI setup
local app = Gtk.Application.new("org.example.skilltracker", 0)

local window, treeview, liststore, file_handle, last_size, label

app.on_activate = function()
	window = Gtk.Window({
		title = "Wurm Online Skill Tracker",
		default_width = 800,
		default_height = 600,
		on_destroy = function()
			Gtk.main_quit()
		end,
	})

	app:add_window(window) -- Manage window lifetime

	local vbox = Gtk.Box({
		orientation = "VERTICAL",
		spacing = 10,
	})

	label = Gtk.Label({
		label = "Watching file: " .. current_file_path,
	})
	vbox:pack_start(label, false, false, 0)

	liststore = Gtk.ListStore.new({
		GObject.Type.STRING, -- Skill
		GObject.Type.DOUBLE, -- Current Level
		GObject.Type.DOUBLE, -- Total Gained
		GObject.Type.DOUBLE, -- Past 15m
		GObject.Type.DOUBLE, -- Past 1h
		GObject.Type.DOUBLE, -- Rate/Hour
	})

	treeview = Gtk.TreeView({
		model = liststore,
	})

	local columns = { "Skill", "Current Level", "Total Gained", "Past 15m", "Past 1h", "Rate/Hour" }
	for i, col in ipairs(columns) do
		local renderer = Gtk.CellRendererText({})
		local column = Gtk.TreeViewColumn({
			title = col,
			expand = true,
		})
		column:pack_start(renderer, true)
		column:add_attribute(renderer, "text", i - 1) -- 0-based index for model columns
		treeview:append_column(column)
	end

	local scrolled = Gtk.ScrolledWindow({
		shadow_type = "IN",
	})
	scrolled:add(treeview)
	vbox:pack_start(scrolled, true, true, 0)

	window:add(vbox)
	window:show_all()

	-- Open file
	file_handle = io.open(current_file_path, "r")
	if not file_handle then
		error("Cannot open file: " .. current_file_path)
	end

	-- Initial scan to process all existing lines (CHANGE: Now calls process_line for each line to populate gains, total_gain, times, and levels from the entire log)
	file_handle:seek("set", 0)
	while true do
		local line = file_handle:read("*l")
		if not line then
			break
		end
		process_line(line)
	end

	-- Seek to end for tailing new lines
	last_size = file_handle:seek("end")

	-- Timer to check file every second
	GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 1, update_table)
end

-- Function to update table
function update_table()
	-- Check for file switch if dynamic
	if not fixed_file then
		local expected_file_path = "_Skills." .. os.date("%Y-%m") .. ".txt"
		if expected_file_path ~= current_file_path then
			file_handle:close()
			current_file_path = expected_file_path
			file_handle = io.open(current_file_path, "r")
			if not file_handle then
				error("Cannot open new file: " .. current_file_path)
			end
			-- Process all lines in new file (CHANGE: Calls process_line for each line in the new file to include its data)
			file_handle:seek("set", 0)
			while true do
				local line = file_handle:read("*l")
				if not line then
					break
				end
				process_line(line)
			end
			last_size = file_handle:seek("end")
			label:set_label("Watching file: " .. current_file_path) -- Update label
		end
	end

	-- Check for new lines
	local current_size = file_handle:seek("end")
	if current_size > last_size then
		file_handle:seek("set", last_size)
		while true do
			local line = file_handle:read("*l")
			if not line then
				break
			end
			process_line(line)
		end
		last_size = file_handle:seek("end")
	end

	-- Update treeview
	liststore:clear()
	local stats = get_stats()
	for _, entry in ipairs(stats) do
		liststore:append({
			entry.skill,
			entry.current_level,
			entry.total_gain,
			entry.past_15,
			entry.past_60,
			entry.rate,
		})
	end

	return true -- Continue timer
end

app:run({ arg[0] })
