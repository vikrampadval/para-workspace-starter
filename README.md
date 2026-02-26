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

The script will:
1. Ask for your name, role, team, and current focus
2. Create the PARA folder structure with a pre-filled `CLAUDE.md`
3. Install 9 slash commands as Cursor skills (`~/.cursor/skills/`)

Then open the created workspace folder in Cursor and start chatting.

---

## What You Get

### Folder Structure

```
my-workspace/
├── CLAUDE.md              # Root context file — the brain
├── 00_inbox/              # Quick capture, unsorted items
│   ├── notes/             # Daily notes, quick thoughts
│   ├── meetings/          # Meeting notes before filing
│   └── incubator/         # Ideas not ready to start
├── 01_projects/           # Active work with deadlines
│   └── PROJECT_TEMPLATE.md
├── 02_areas/              # Ongoing responsibilities (no end date)
├── 03_resources/          # Reference material
│   └── people/            # Colleague notes
└── 04_archives/           # Completed / inactive work
```

### Slash Commands

| Command | What it does |
|---------|-------------|
| `/daily` | Build today's planner — priorities, schedule, meeting context |
| `/note` | Quick-capture a timestamped thought |
| `/eod` | End-of-day recap — what got done, decisions, carryover |
| `/add-context` | Route a URL or text to the right project |
| `/capture-idea` | Save an idea to the incubator |
| `/start-project` | Create a new project from a brain dump |
| `/archive-project` | Archive a completed project |
| `/prepare-meeting` | Research + agenda for a meeting |
| `/generate-hpm` | Highlights/priorities update from recent work |
| `/recap` | Weekly work summary |

---

## After Setup

### 1. Edit your CLAUDE.md

The init script fills in the basics. Now invest 10 minutes on two sections:

**Writing Style** — This is what makes AI drafts sound like you. Document your patterns:
- Do you lead with a TL;DR?
- Bullet points or numbered lists?
- Formal or casual?
- Phrases you naturally use ("sounds good", "let's ship it", "keen")
- Things to avoid (corporate jargon, emojis)

**Key Acronyms** — Add the acronyms your team uses. The agent will use them correctly in drafts and conversations.

### 2. Create your first project

```bash
mkdir -p 01_projects/01_my_project/docs 01_projects/01_my_project/meetings
cp 01_projects/PROJECT_TEMPLATE.md 01_projects/01_my_project/CLAUDE.md
```

Edit the project `CLAUDE.md` with your project's overview, status, stakeholders, and documents. Then add it to the Active Projects table in the root `CLAUDE.md`.

### 3. Test it

Open the workspace in Cursor and start a new chat. The agent should greet you with your context. Try:
- "What do you know about me?"
- `/daily` to build your first daily planner
- `/note "testing the quick capture"`

---

## How It Works

### Context Layers

```
Root CLAUDE.md              → Who you are, how you work
  └── Project CLAUDE.md     → Deep context for each project
       └── Docs, notes      → Supporting detail
```

The agent reads the root `CLAUDE.md` every session. When you work on a specific project, it reads the project-level `CLAUDE.md` for deeper context. Keep the root high-level; let project files carry the detail.

### Daily Workflow

1. **Morning**: `/daily` builds your planner with priorities, schedule, and meeting context
2. **During the day**: `/note` captures thoughts; `/add-context` routes new info to projects
3. **End of day**: `/eod` recaps what got done and seeds tomorrow's planner

### Project Lifecycle

1. `/capture-idea` — save to incubator
2. `/add-context` — accumulate context over time
3. `/start-project` — promote to active project
4. Work on it (update CLAUDE.md, take meeting notes, create docs)
5. `/archive-project` — move to archives when done

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
| A quick thought | `/note` (appends to daily note) |
| Meeting notes for a project | `01_projects/XX_project/meetings/` |
| Meeting notes (general) | `00_inbox/meetings/` |
| An idea for later | `/capture-idea` |
| Career/development notes | `02_areas/` |
| Notes on a colleague | `03_resources/people/firstname_lastname.md` |
| A finished project | `/archive-project` → `04_archives/` |

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

For the complete walkthrough with detailed command documentation, see [the full setup guide](docs/full_guide.md).

---

*30 minutes to set up. Gets better every day you use it.*
