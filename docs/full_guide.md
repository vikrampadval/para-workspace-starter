# Quick Start: Setting Up a PARA Workspace with Cursor + Claude

## TL;DR

A PARA workspace is a folder of markdown files that gives your AI assistant persistent memory. You organize your work into Projects, Areas, Resources, and Archives, then write context files (`CLAUDE.md`) that tell the AI who you are, what you're working on, and how you like to work. The result: an AI that remembers your projects, stakeholders, and preferences across every session — no re-explaining required.

**Time to set up**: 30 minutes.

---

## What You Need

- **Cursor IDE** — the AI-powered code editor ([cursor.com](https://cursor.com))
- **A folder that persists** — local directory, cloud drive, or git repo. The workspace needs to survive between sessions.

That's it. No dependencies, no build steps. It's just folders and markdown files.

---

## Step 1: Create the Folder Structure

```
my-workspace/
├── CLAUDE.md              # Root context file — the brain
├── 00_inbox/              # Quick capture, unsorted items
│   ├── notes/             # Daily notes, quick thoughts
│   └── meetings/          # Meeting notes before filing
├── 01_projects/           # Active work with deadlines
├── 02_areas/              # Ongoing responsibilities (no end date)
├── 03_resources/          # Reference material
└── 04_archives/           # Completed / inactive work
```

The zero-padded prefixes (`00_`, `01_`, ...) enforce sort order. Inbox first, archives last.

---

## Step 2: Write Your Root CLAUDE.md

This is the most important file. Cursor loads it at the start of every session. It tells the AI who you are and how to work with you.

Create `CLAUDE.md` in your workspace root with these sections:

```markdown
# CLAUDE.md

## About Me
- **Name**: Your name
- **Role**: What you do
- **Team**: Who you work with
- **Focus**: What you're working on right now

## Directory Structure
<!-- Paste your folder layout here so the agent can navigate -->

## Active Projects
| # | Project | Description |
|---|---------|-------------|
| 01 | [Project Name](01_projects/01_project_slug/CLAUDE.md) | One-line summary |

## Writing Style
<!-- How you write — the agent will match your voice in drafts -->
- Direct or formal?
- Bullet points or prose?
- Specific phrases you naturally use
- Things to avoid (jargon, emojis, etc.)

## AI Agent Instructions
- Be direct and concise
- Ask clarifying questions before making assumptions
- Don't create files unless necessary
```

### What makes a good root CLAUDE.md

**Invest time in three areas:**

1. **About Me** — every detail makes the agent smarter. Include acronyms your team uses, key terms, your timezone, your manager's name. The agent will use these correctly in drafts and conversations.

2. **Writing Style** — this is what makes AI drafts sound like you instead of generic AI. Document your patterns: do you lead with a TL;DR? Use numbered lists? Say "brilliant" or "sounds good"? The more specific, the better.

3. **AI Agent Instructions** — behavioral guardrails. Tell the agent what to do (and what not to do) at the start of each session. Example: "Confirm you've loaded my context, then ask what I'm working on."

---

## Step 3: Create Your First Project

Each project gets its own folder under `01_projects/` with its own `CLAUDE.md`:

```
01_projects/
└── 01_my_project/
    ├── CLAUDE.md       # Project context
    ├── docs/           # Documentation
    └── meetings/       # Meeting notes
```

### Project CLAUDE.md template

```markdown
# Project Name

## Overview
<!-- What is this project? Why does it matter? 2-3 sentences. -->

## Current Status
<!-- What phase are you in? What are the key metrics? -->

## Latest Updates
<!-- What happened recently? Keep this fresh — stale context = bad suggestions -->

## Key Stakeholders
| Person | Role |
|--------|------|
| Name   | What they do on this project |

## Key Documents
| Name | Description |
|------|-------------|
| [Doc title](url) | What's in it |
```

The most important section is **Latest Updates**. Update it after key meetings or decisions. This is what the agent reads when you ask it to help with project work, draft comms, or prep for a meeting.

---

## Step 4: Open in Cursor and Test

1. Open Cursor
2. Open your workspace folder as a project
3. Start a new AI chat
4. The agent should pick up your context from `CLAUDE.md`

**Test it**: Ask the agent "What do you know about me?" — it should reference your role, projects, and preferences from the root `CLAUDE.md`.

---

## File Naming Rules

Keep it simple and consistent:

- **No spaces** — use underscores (`project_plan.md`, not `project plan.md`)
- **All lowercase** — `meeting_notes.md`, not `Meeting_Notes.md`
- **Zero-padded numbers** — `01_`, `02_` for sort order
- **Dates as `YYYY_MM_DD`** — `2026_02_26_meeting.md`
- **Every project folder gets a `CLAUDE.md`** — this is the context file the agent reads

---

## How Context Layers Work

```
Root CLAUDE.md              → Who you are, how you work
  └── Project CLAUDE.md     → Deep context for each project
       └── Docs, notes      → Supporting detail
```

The agent reads the root `CLAUDE.md` every session. When you're working on a specific project, it can read the project-level `CLAUDE.md` for deeper context. This means you don't need to cram everything into one file — keep the root high-level and let project files carry the detail.

---

## Keeping It Alive

The system only works if context stays fresh. Build these habits:

| When | Do this |
|------|---------|
| After an important meeting | Update "Latest Updates" in the relevant project CLAUDE.md |
| When priorities shift | Update "Current Status" |
| When you finish a project | Move the folder to `04_archives/` and remove it from Active Projects in root |
| When you start something new | Create a new folder in `01_projects/` with a CLAUDE.md |
| When you notice the agent getting something wrong | Check which context file is stale and fix it |

---

## What Goes Where

| I have... | Put it in... |
|-----------|-------------|
| A quick thought or note | `00_inbox/notes/` |
| Meeting notes for a specific project | `01_projects/XX_project/meetings/` |
| Meeting notes (not project-specific) | `00_inbox/meetings/` |
| An idea that might become a project | `00_inbox/` (or create an `incubator/` subfolder) |
| Career development notes | `02_areas/career/` |
| Notes on a colleague | `03_resources/people/firstname_lastname.md` |
| A finished project | `04_archives/` |
| Templates or reference guides | `03_resources/` |

---

## Slash Commands

Once the workspace is set up, you can build **slash commands** — reusable workflows that the AI executes on demand. In Cursor, these are defined as **skills** (`SKILL.md` files in `~/.cursor/skills/`). When you type the command, the agent reads the skill file and follows the instructions.

Below is the full command set for a PARA workspace. You don't need all of them on day one — start with `/daily`, `/note`, and `/add-context`, then add more as your workflow demands.

### Daily Workflow

#### `/daily` — Build Today's Planner

Generates a daily note at `00_inbox/notes/YYYY_MM_DD.md` with your priorities, schedule, and meeting context.

**What it does:**
1. Fetches your calendar for the day
2. Pulls recent messages from chat and team channels for action items
3. Reads yesterday's daily note for carryover (unchecked items)
4. Reads active project CLAUDE.md files for meeting context
5. Maps each meeting to a project using keyword + attendee matching
6. Flags meetings needing prep (1:1s, reviews, demos)
7. Detects schedule conflicts
8. Writes the daily note

**Output structure:**

```markdown
# Daily Planner — Thursday 26 February 2026

## TL;DR
<!-- 2-3 sentence summary -->

## Today's Priorities
- [ ] `[project_a]` Priority item
- [ ] `[comms]` Action from a message — [link]

### Carried over from yesterday
- [ ] Unfinished item

## Schedule
| Time | Meeting | Project | Prep |
|------|---------|---------|------|
| 09:30 | Name | [project_a] | [1:1] |

## Meeting Notes
### 09:30 — Meeting Title `[project_a]`
**Context**: [pulled from project CLAUDE.md]
**Notes**:
<!-- Fill during/after -->

## Thoughts / Scratch
<!-- Random ideas, follow-ups -->

## End of Day Summary
<!-- Filled by /eod -->
```

**Tip**: The daily note becomes your operating dashboard. Check things off during the day, jot notes in the meeting sections, and let `/eod` close it out.

---

#### `/note` — Quick Capture

Appends a timestamped thought to today's daily note under **Thoughts / Scratch**.

**Usage**: `/note "just realized we need to check the API rate limits before launch"`

**What it does:**
1. Finds (or creates) today's daily note at `00_inbox/notes/YYYY_MM_DD.md`
2. Appends: `- **14:35** — just realized we need to check the API rate limits before launch`

No context-switching, no filing — just capture the thought and move on.

---

#### `/eod` — End of Day Recap

Fills in the End of Day Summary section of today's daily note.

**What it does:**
1. Reads today's daily note
2. Checks which priorities were completed vs still open
3. Reviews meeting notes for key outcomes
4. Scans for decisions ("decided", "agreed", "going with")
5. Identifies carryover items for tomorrow
6. Writes three subsections:
   - **What got done** — completed priorities + meeting outcomes
   - **Key decisions made** — extracted from notes
   - **Carry forward to tomorrow** — seeds the next `/daily`

---

### Context Management

#### `/add-context` — Route Information to the Right Project

Takes any URL or text and adds it to the appropriate project's CLAUDE.md.

**Usage**:
- `/add-context https://docs.google.com/document/d/abc123` — reads the doc and adds it to the right project
- `/add-context "Met with Sarah — agreed to push the launch to March 15"` — routes the decision to the matching project

**What it does:**
1. Loads the content (URL or text)
2. Matches it against active projects in the root CLAUDE.md
3. Reads the target project's CLAUDE.md
4. Updates the right sections: Latest Updates, Key Documents, Key Stakeholders, etc.
5. If it can't determine the project, asks you

**Why it matters**: This is how you keep project context fresh without manually editing CLAUDE.md files. Paste a link, and the system files it.

---

#### `/capture-idea` — Save an Idea for Later

Creates a date-prefixed folder in `00_inbox/incubator/` for an idea that isn't ready to be a project yet.

**Usage**: `/capture-idea "build a dashboard that tracks team velocity across sprints"`

**What it does:**
1. Gathers details from you (brain dump, links, context)
2. Creates `00_inbox/incubator/2026_02_26_velocity_dashboard/`
3. Creates a CLAUDE.md inside with the idea description and any linked resources

**Lifecycle**: Use `/add-context` to accumulate more context over time. When the idea is ready to become a real project, use `/start-project` to promote it.

---

### Project Lifecycle

#### `/start-project` — Create a New Active Project

Creates a full project folder structure from a brain dump or incubator idea.

**What it does:**
1. Gathers context from you (what is it, why does it matter, who's involved)
2. Optionally searches for related documents, posts, or resources
3. Creates project folder: `01_projects/XX_project_name/`
4. Generates project CLAUDE.md with: Overview, Current Status, Key Deliverables, Key Stakeholders, Key Documents
5. Creates subfolders: `docs/`, `meetings/`, `analysis/`, `outputs/`
6. Updates root CLAUDE.md Active Projects table
7. If promoting from incubator, archives the incubator folder

---

#### `/archive-project` — Complete and Archive a Project

Moves a finished project from `01_projects/` to `04_archives/`.

**What it does:**
1. Identifies the project to archive
2. Optionally searches for any remaining related docs or posts to capture
3. Updates the project's CLAUDE.md with final status and completion notes
4. Moves the folder to `04_archives/` with appropriate numbering
5. Updates root CLAUDE.md: moves from Active Projects to Completed Projects table

---

### Meeting Prep

#### `/prepare-meeting` — Research and Build an Agenda

Researches a person, team, or topic and generates a focused meeting agenda with private background notes.

**Usage**: `/prepare-meeting "1:1 with Sarah Chen — she leads the platform team"`

**What it does:**
1. Researches the person/topic (searches docs, posts, prior meeting notes)
2. Cross-references against your active projects to find shared context
3. Generates:
   - Background context (private notes — don't share this part)
   - Suggested talking points linked to active projects
   - Open questions and action items to discuss
   - Time allocation suggestions for a 30-min meeting

---

### Reporting

#### `/generate-hpm` — Write a Highlights/Priorities Update

Generates a periodic highlights and priorities update by discovering your recent work.

**What it does:**
1. Auto-detects the time window from your last update in `02_areas/hpms/`
2. Searches for recent work: docs authored, posts written, tasks closed, key decisions
3. Shows discovered content for your review
4. Generates the update with: Highlights, Priorities, and a personal/development section
5. Saves to `02_areas/hpms/YYYY_MM_DD.md`
6. Iterates based on your feedback

---

#### `/recap` — Weekly Work Summary

Generates a weekly recap of what you shipped, posted, and closed.

**What it does:**
1. Determines the recap window (typically the last week)
2. Searches for: code/diffs landed, posts authored, tasks closed, thanks/kudos received
3. Organizes by project and impact
4. Saves to a weekly recaps folder

---

### How to Create a Skill

Each command is a `SKILL.md` file in `~/.cursor/skills/<command-name>/SKILL.md`. The format:

```markdown
---
name: command-name
description: One sentence — when should the agent use this skill.
---

# Command Name

Brief description of what this command does.

## Instructions

1. Step one
2. Step two
3. Step three
```

The agent reads this file when the command is invoked and follows the instructions. Skills can read/write files, call external tools (calendar, chat, task tracker), spawn sub-agents for parallel work, and follow multi-step workflows.

**Start simple**: Your first skill can be 5 lines of instructions. Add complexity as you learn what works.

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Putting everything in root CLAUDE.md | Keep root high-level. Project detail goes in project CLAUDE.md files. |
| Letting context go stale | Update after key meetings and decisions. Stale context = bad suggestions. |
| Too many active projects | If you're not actively working on it, archive it. 2-4 active projects is ideal. |
| No writing style section | This is what makes drafts sound like you. Worth 10 minutes to write well. |
| Overcomplicating the folder structure | Start with the basic PARA layout. Add subfolders only when you need them. |

---

*30 minutes to set up. Gets better every day you use it.*
