# Wurm Online Imping Calculator (HTML + JavaScript)

A lightweight, **offline imping calculator** for Wurm Online.

Calculates in real time:

* Maximum impable Quality Level (QL) for your current skill
* Skill required to reach a desired QL

Runs entirely in your browser as a **local HTML file**.  
No server. No tracking. No dependencies beyond a browser.

---

## 📦 What This Is

This is a **single-page HTML tool** (`index.html`) backed by simple JavaScript.

It is designed to be:
* Bookmarkable
* Offline-friendly
* Easy on the eyes (dark mode + scaling)
* Safe for long grinding sessions

All calculations happen locally.

---

## 📂 Files

```
index.html
js/
├── max.js
└── skill.js
```

* `index.html` – UI, styling, input handling
* `js/max.js` – maximum impable QL calculation logic
* `js/skill.js` – required skill calculation logic

---

## ▶️ How to Use

### Option 1: Open directly

Double-click `index.html`, or open it in your browser:

```bash
firefox index.html
# or
chromium index.html
```

### Option 2: Bookmark it

Most browsers allow bookmarking local files:

```
file:///home/you/path/to/index.html
```

This is the recommended way to use it during gameplay.

---

## 🧮 Inputs Explained

| Field | Description |
|----|-----------|
| Current Skill | Your current crafting skill (0.00 – 100.00) |
| QL Wanted | Desired item quality (0.00 – 100.00) |
| Imbue | **Work in progress – currently has no effect** |

Input rules:
* No negative values
* Skill and QL are capped at 100
* Decimals are allowed

---

## 📤 Outputs Explained

| Output | Meaning |
|----|-------|
| Maximum Imp QL | Highest QL you can currently improve to |
| Skill Needed | Skill required to reach the desired QL |

Outputs update **live** as you type.

---

## 🚧 Imbue Status (Important)

The **Imbue field is currently a placeholder**.

* It is displayed in the UI
* It is sanitized and stored like other inputs
* **It does not yet affect any calculations**

This is intentional and reserved for future work.

---

## 🎨 UI Features

* Dark theme (eye-friendly)
* Ultra-dark toggle for low-light play
* UI scale slider (no browser zoom needed)
* Big-number mode for outputs
* Visual highlight when values update
* Remembers last inputs and UI settings (local storage)

All settings are stored **locally** in your browser.

---

## 🧠 How It Works

* JavaScript listens to input changes
* Existing calculation logic in `max.js` and `skill.js` runs unchanged
* UI sanitizes input values before calculations
* Results are written back into the form fields



---

## ⚠️ Notes / Limitations

* Designed for desktop browsers
* Tested with Firefox and Chromium
* Calculations reflect known Wurm mechanics but are not guaranteed exact
* Imbue logic is not implemented yet
* No affiliation with Wurm Online or its developers

---

## 📜 Disclaimer

This project is **not affiliated with**:
* Wurm Online
* Code Club AB
* Game Chest Group

It is a community utility built for personal use.

---

## 💡 Future Work

* Imbue calculation logic
* Bulk storage planner
* Skill goal ladder

All of these can be added as additional JS sections without a server.

---

Happy imping.
