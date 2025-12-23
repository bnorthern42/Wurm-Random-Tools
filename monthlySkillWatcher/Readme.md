# Wurm Online Skill Tracker (Lua + GTK)

A lightweight, real-time **skill gain tracker** for Wurm Online that tails your local skill log and displays:

* Current skill level
* Total skill gained
* Skill gained in the last 15 minutes
* Skill gained in the last 1 hour
* Average gain rate per hour

Built in **Lua** with a **GTK3 GUI** using `lgi`.

Runs entirely locally.  
No mods. No server interaction.

---

## 📦 Requirements

* Lua 5.3+
* GTK3
* lua-lgi

### Install dependencies

**Arch / Arch-based**
```bash
sudo pacman -S lua lua-lgi gtk3
```

**Debian / Ubuntu**
```bash
sudo apt install lua5.3 lua-lgi gir1.2-gtk-3.0
```

---

## 📂 Wurm Log Location (Important)

Wurm writes skill gains to log files named:

```
_Skills.YYYY-MM.txt
```

These files live in your character’s **logs directory**, for example:

```
Wurm/
└── players/
    └── YourCharacterName/
        └── logs/
            ├── _Skills.2025-09.txt
            ├── _Skills.2025-10.txt
```

This tool reads those files **directly** and does not modify them.

---

## ▶️ How to Run

### Option 1: Run from the logs directory (default behavior)

```bash
cd ~/Wurm/players/YourCharacterName/logs
lua watcher.lua
```

* Uses the current month’s `_Skills.YYYY-MM.txt`
* Automatically switches files when the month changes

---

### Option 2: Specify the logs directory explicitly

```bash
lua watcher.lua ~/Wurm/players/YourCharacterName/logs
```

* Useful if you don’t want to `cd` into the directory
* Still auto-switches monthly skill logs

---

### Option 3: Specify a specific skill log file

```bash
lua watcher.lua ~/Wurm/players/YourCharacterName/logs/_Skills.2025-10.txt
```

* Uses that file only
* **Disables automatic month switching**
* Useful for reviewing past months

---

## 🧠 How the Tool Works

* Reads all existing skill log lines on startup
* Tails the file once per second for new entries
* Detects day rollover using timestamps
* Aggregates skill gain per skill
* Updates the GTK table live
* Automatically switches `_Skills.YYYY-MM.txt` on month change (unless a file is explicitly provided)

All processing is **read-only**.

---

## 🖥️ UI Columns Explained

| Column | Description |
|-----|-----------|
| Skill | Skill name |
| Current Level | Latest recorded level |
| Total Gained | Total skill gained |
| Past 15m | Skill gained in the last 15 minutes |
| Past 1h | Skill gained in the last hour |
| Rate/Hour | Average gain per hour |

Skills are sorted by **Total Gained** (descending).

---

## ⚠️ Notes / Limitations

* Linux only (GTK + lua-lgi)
* Safe to use during gameplay
* No network access

---

## 📜 Disclaimer

This project is **not affiliated with**:
* Wurm Online
* Code Club AB
* Game Chest Group

It only reads local log files already written by the Wurm client.

---

## 💡 Future Improvements 

* CSV export
* Per-skill filtering
* Session reset / timer


---

Happy grinding.
