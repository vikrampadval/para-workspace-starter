# PARA Workspace for Cursor + Claude

A personal productivity workspace that gives your AI assistant persistent memory. Organize your work into Projects, Areas, Resources, and Archives, with context files (`CLAUDE.md`) that tell the AI who you are, what you're working on, and how you like to work.

**The result**: An AI that remembers your projects, stakeholders, and preferences across every session — no re-explaining required.

---

## Quick Install

```bash
git clone https://github.com/vikrampadval/para-workspace-starter.git
cd para-workspace-starter
./init.sh
```

The script walks you through 5 steps:

1. **About You** — name, role, team, manager, timezone, focus
2. **Writing Style** — tone, format, phrases (so AI drafts sound like you)
3. **Key Acronyms** — team-specific terms the AI should know
4. **First Project** — set up your first active project (optional)
5. **Workspace Location** — where to create the folder

Then open the created workspace folder in Cursor and start chatting.

---

## What You Get

### Folder Structure

```
my-workspace/
├── CLAUDE.md              # Root context file — the brain
├── 00_inbox/              # Quick capture, unsorted items
│   ├── meetings/          # Meeting notes before filing
│   └── incubator/         # Ideas not ready to start
├── 01_projects/           # Active work with deadlines
│   └── PROJECT_TEMPLATE.md
├── 02_areas/              # Ongoing responsibilities (no end date)
│   ├── hpms/              # Highlights, Priorities updates
│   ├── career/            # Career planning
│   ├── learning/          # Learning notes
│   └── team/              # Team-related notes
├── 03_resources/          # Reference material
│   ├── people/            # Colleague profiles
│   └── templates/         # Reusable templates
└── 04_archives/           # Completed / inactive work
```

### Slash Commands

| Command | What it does |
|---------|-------------|
| `/add-context` | Route a URL or text to the right project's CLAUDE.md |
| `/capture-idea` | Save an idea to the incubator for later |
| `/start-project` | Create a new project from a brain dump |
| `/archive-project` | Archive a completed project |

---

## After Setup

### 1. Review your CLAUDE.md

The init script fills in your profile, writing style, and acronyms based on your answers. Open `CLAUDE.md` and refine anything that needs more detail.

**Writing Style** is the highest-impact section — this is what makes AI drafts sound like you instead of generic AI.

### 2. Create your first project (if you skipped it)

```bash
mkdir -p 01_projects/01_my_project/docs 01_projects/01_my_project/meetings
cp 01_projects/PROJECT_TEMPLATE.md 01_projects/01_my_project/CLAUDE.md
```

Edit the project `CLAUDE.md` with your project's overview, status, stakeholders, and documents. Then add it to the Active Projects table in the root `CLAUDE.md`.

### 3. Test it

Open the workspace in Cursor and start a new chat. The agent should greet you with your context. Try:
- "What do you know about me?"
- `/capture-idea "build an internal dashboard for team metrics"`
- `/start-project` to create a new project interactively

---

## How It Works

### Context Layers

```
Root CLAUDE.md              → Who you are, how you work
  └── Project CLAUDE.md     → Deep context for each project
       └── Docs, notes      → Supporting detail
```

The agent reads the root `CLAUDE.md` every session. When you work on a specific project, it reads the project-level `CLAUDE.md` for deeper context. Keep the root high-level; let project files carry the detail.

### Project Lifecycle

```
/capture-idea  →  /add-context  →  /start-project  →  work  →  /archive-project
  (incubator)    (accumulate)      (activate)                    (complete)
```

1. **`/capture-idea`** — save a rough idea to `00_inbox/incubator/`
2. **`/add-context`** — paste URLs or text to build up context over time
3. **`/start-project`** — promote to `01_projects/` with full folder structure
4. **Work on it** — update the project CLAUDE.md as you go
5. **`/archive-project`** — move to `04_archives/` when done

---

## File Naming Rules

| Rule | Example |
|------|---------|
| No spaces (use underscores) | `project_plan.md` |
| All lowercase | `meeting_notes.md` |
| Zero-padded numbers | `01_`, `02_` |
| Dates as `YYYY_MM_DD` | `2026_02_26_meeting.md` |
| Every project folder gets a `CLAUDE.md` | `01_projects/01_foo/CLAUDE.md` |

---

## Keeping It Alive

| When | Do this |
|------|---------|
| After an important meeting | Update "Latest Updates" in the project CLAUDE.md |
| When priorities shift | Update "Current Status" |
| When you finish a project | `/archive-project` |
| When you start something new | `/start-project` |
| When the agent gets something wrong | Check which context file is stale |

Stale context is worse than no context. The system gets better every day you use it — but only if you keep the context files honest.

---

## What Goes Where

| I have... | Put it in... |
|-----------|-------------|
| Meeting notes for a project | `01_projects/XX_project/meetings/` |
| Meeting notes (general) | `00_inbox/meetings/` |
| An idea for later | `/capture-idea` → `00_inbox/incubator/` |
| Notes on a colleague | `03_resources/people/firstname_lastname.md` |
| A finished project | `/archive-project` → `04_archives/` |
| Career/development notes | `02_areas/` |
| Reference material | `03_resources/` |

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Everything in root CLAUDE.md | Keep root high-level. Project detail goes in project files. |
| Letting context go stale | Update after key meetings and decisions. |
| Too many active projects | Archive what you're not actively working on. 2-4 is ideal. |
| No writing style section | This is what makes drafts sound like you. Worth 10 minutes. |
| Overcomplicating the structure | Start with the basics. Add subfolders only when needed. |

---

## Full Guide

For the complete walkthrough with detailed explanations, see [the full setup guide](docs/full_guide.md).

---

*5 minutes to set up. Gets better every day you use it.*
