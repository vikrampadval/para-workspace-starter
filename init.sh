#!/bin/bash
set -e

# PARA Workspace Initializer
# Creates a PARA workspace with CLAUDE.md context files and Cursor skills.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   PARA Workspace Setup                   ║"
echo "║   Persistent AI context for Cursor       ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# --- Gather info ---

read -p "Your name: " USER_NAME
read -p "Your role (e.g. Product Manager, Engineer): " USER_ROLE
read -p "Your team: " USER_TEAM
read -p "What are you focused on right now? (1 sentence): " USER_FOCUS
read -p "Where should the workspace be created? [./para-workspace]: " WORKSPACE_DIR
WORKSPACE_DIR="${WORKSPACE_DIR:-./para-workspace}"

echo ""
echo "Creating workspace at: $WORKSPACE_DIR"
echo ""

# --- Create PARA folder structure ---

mkdir -p "$WORKSPACE_DIR/00_inbox/notes"
mkdir -p "$WORKSPACE_DIR/00_inbox/meetings"
mkdir -p "$WORKSPACE_DIR/00_inbox/incubator"
mkdir -p "$WORKSPACE_DIR/01_projects"
mkdir -p "$WORKSPACE_DIR/02_areas"
mkdir -p "$WORKSPACE_DIR/03_resources/people"
mkdir -p "$WORKSPACE_DIR/04_archives"

# --- Write root CLAUDE.md ---

cat > "$WORKSPACE_DIR/CLAUDE.md" << ROOTEOF
# CLAUDE.md

This file provides context for Claude when working in this workspace.

## Session Start Behavior

At the start of every new session:
1. Confirm you've loaded my context (1 line)
2. Ask what I'm working on today
3. Check if today's daily note exists at \`00_inbox/notes/YYYY_MM_DD.md\`:
   - If it exists: show top 3 priorities + next meeting
   - If it doesn't exist: offer to run \`/daily\`

## About Me

- **Name**: ${USER_NAME}
- **Role**: ${USER_ROLE}
- **Team**: ${USER_TEAM}
- **Focus**: ${USER_FOCUS}

### Key Acronyms & Terms
<!-- Add acronyms your team uses — the agent will use them correctly -->

## Directory Structure

\`\`\`
workspace/
├── CLAUDE.md                # Root context file
├── 00_inbox/                # Quick capture, unsorted items
│   ├── notes/               # Daily notes
│   ├── meetings/            # Meeting notes before filing
│   └── incubator/           # Ideas not ready to start
├── 01_projects/             # Active work with deadlines
├── 02_areas/                # Ongoing responsibilities
├── 03_resources/            # Reference material
│   └── people/              # Colleague notes
└── 04_archives/             # Completed / inactive work
\`\`\`

## File Naming Conventions

| Type            | Convention               | Example                      |
| --------------- | ------------------------ | ---------------------------- |
| PARA folders    | Zero-padded prefix       | \`01_projects/\`, \`02_areas/\`  |
| Project folders | Zero-padded prefix       | \`01_my_project/\`             |
| Files           | \`snake_case\`             | \`meeting_notes.md\`           |
| Dated files     | \`YYYY_MM_DD_description\` | \`2026_02_26_meeting.md\`      |
| People notes    | \`firstname_lastname\`     | \`jane_smith.md\`              |
| Standard files  | Reserved names           | \`CLAUDE.md\`, \`brief.md\`     |

**Rules:**
- No spaces in filenames (use underscores)
- All lowercase
- Zero-padded numbers for sorting (01, 02, not 1, 2)
- Dates as YYYY_MM_DD (with underscores)
- Every project folder gets a \`CLAUDE.md\`

## Active Projects

| # | Project | Tag | Description |
|---|---------|-----|-------------|
<!-- Add projects here as you create them -->
<!-- | 01 | [Project Name](01_projects/01_project_slug/CLAUDE.md) | \`project:slug\` | One-line description | -->

## Completed Projects

| # | Project | Tag | Description |
|---|---------|-----|-------------|
<!-- Move projects here when archived -->

## Custom Slash Commands

- \`/daily\` — Build today's daily planner with priorities, schedule, and meeting context
- \`/note\` — Quick-capture a timestamped thought to today's daily note
- \`/eod\` — End-of-day recap: what got done, decisions made, carryover for tomorrow
- \`/add-context\` — Route a URL or text to the right project's CLAUDE.md
- \`/capture-idea\` — Save an idea to the incubator for later
- \`/start-project\` — Create a new active project from a brain dump
- \`/archive-project\` — Move a completed project to archives
- \`/prepare-meeting\` — Research a person/topic and generate a meeting agenda
- \`/generate-hpm\` — Generate a highlights/priorities update from recent work
- \`/recap\` — Generate a weekly work summary

## Writing Style

<!-- How you write — the agent will match your voice in drafts -->
<!-- Uncomment and edit the patterns that apply to you: -->

<!-- - Direct and action-oriented — get to the point -->
<!-- - Lead with a TL;DR before going deep -->
<!-- - Use numbered lists for structured docs -->
<!-- - Casual in 1:1s, more formal in group comms -->
<!-- - Avoid corporate jargon -->

## AI Agent Instructions

- Be direct and concise. Avoid unnecessary words.
- Ask clarifying questions before making assumptions.
- Don't create files unless necessary.
- When linking documents, use a table with Name and Description columns.

## Daily Planner System (\`/daily\`)

When \`/daily\` is invoked, build \`00_inbox/notes/YYYY_MM_DD.md\`.

### Steps:
1. Fetch today's calendar/meetings
2. Read yesterday's daily note for carryover items
3. Read active project CLAUDE.md files for meeting context
4. Map meetings to projects using keyword + attendee matching
5. Build focused priority list (4-8 items) from carryover + meeting-driven actions
6. Flag meetings needing prep (1:1s, reviews, demos)
7. Detect schedule conflicts
8. Write the daily note

### Daily Note Template:

\`\`\`markdown
# Daily Planner — [Day] [DD] [Month] [YYYY]

## TL;DR
<!-- 2-3 sentence summary -->

## Today's Priorities
- [ ] Priority item
<!-- 4-8 items max -->

### Carried over from yesterday
- [ ] Unfinished item

## Schedule
| Time | Meeting | Project | Prep |
|------|---------|---------|------|

## Meeting Notes
### HH:MM — Meeting Title
**Notes**:

## Thoughts / Scratch

## End of Day Summary

### What got done

### Key decisions made

### Carry forward to tomorrow
\`\`\`

## Quick Note (\`/note\`)

Appends a timestamped entry to today's daily note under **Thoughts / Scratch**.

Format: \`- **HH:MM** — [the note content]\`

If today's daily note doesn't exist, create a minimal one first.

## End of Day (\`/eod\`)

1. Read today's daily note
2. Check completed vs open priorities
3. Review meeting notes for key outcomes
4. Scan for decisions
5. Identify carryover items
6. Write the End of Day Summary
ROOTEOF

echo "  ✓ Root CLAUDE.md"

# --- Write project CLAUDE.md template ---

cat > "$WORKSPACE_DIR/01_projects/PROJECT_TEMPLATE.md" << 'PROJEOF'
# Project Name

**Project Tag**: `project:project_slug`

## Overview
<!-- What is this project? Why does it matter? 2-3 sentences. -->

## Current Status
<!-- What phase are you in? What are the key metrics? -->

## Latest Updates
<!-- What happened recently? Update after key meetings or decisions. -->
<!-- Stale context = bad suggestions. Keep this fresh. -->

## Key Deliverables

| Name | Description |
|------|-------------|
| Deliverable | What it is |

## Key Stakeholders

| Person | Role | Team |
|--------|------|------|
| Name | What they do | Their team |

## Key Documents

| Name | Description |
|------|-------------|
| [Doc title](url) | What's in it |

## Open Tasks
<!-- How to track tasks for this project -->

## Project Files

- `docs/` — Project documentation
- `meetings/` — Meeting notes
PROJEOF

echo "  ✓ Project template"

# --- Write Cursor skills ---

SKILLS_TARGET="$HOME/.cursor/skills"
mkdir -p "$SKILLS_TARGET"

# /daily
mkdir -p "$SKILLS_TARGET/daily"
cat > "$SKILLS_TARGET/daily/SKILL.md" << 'EOF'
---
name: daily
description: Build today's daily planner with priorities, schedule, and meeting context. Use when the user says /daily, asks to build a daily planner, or wants to plan their day.
---

# Daily Planner

Builds `00_inbox/notes/YYYY_MM_DD.md` using the Daily Planner System defined in the workspace CLAUDE.md.

## Instructions

1. Read the workspace `CLAUDE.md` file
2. Find the **Daily Planner System (`/daily`)** section
3. Follow the steps defined there:
   - Fetch today's calendar/meetings
   - Read yesterday's daily note for carryover
   - Read active project CLAUDE.md files for context
   - Map meetings to projects, flag prep needs, detect conflicts
4. Write the output to `00_inbox/notes/YYYY_MM_DD.md`
EOF

# /note
mkdir -p "$SKILLS_TARGET/note"
cat > "$SKILLS_TARGET/note/SKILL.md" << 'EOF'
---
name: note
description: Quick-capture a timestamped note to today's daily planner. Use when the user says /note, wants to jot something down, or capture a quick thought.
---

# Quick Note

Appends a timestamped entry to today's daily note under **Thoughts / Scratch**.

## Instructions

1. Read the workspace `CLAUDE.md` file — find the **Quick Note (`/note`)** section
2. Determine today's date and path `00_inbox/notes/YYYY_MM_DD.md`
3. If the file doesn't exist, create a minimal daily note with header + Thoughts/Scratch + End of Day sections
4. Append the note as: `- **HH:MM** — [the note content]` (24h, user's timezone)
EOF

# /eod
mkdir -p "$SKILLS_TARGET/eod"
cat > "$SKILLS_TARGET/eod/SKILL.md" << 'EOF'
---
name: eod
description: End-of-day recap and carryover. Summarizes what got done, key decisions, and items to carry forward. Use when the user says /eod, wants to wrap up the day, or do an end-of-day review.
---

# End of Day

Fills in the End of Day Summary section of today's daily note.

## Instructions

1. Read the workspace `CLAUDE.md` file — find the **End of Day (`/eod`)** section
2. Read today's daily note at `00_inbox/notes/YYYY_MM_DD.md`
3. Check completed vs open priorities
4. Review meeting notes for key outcomes
5. Scan for decisions ("decided", "agreed", "going with")
6. Identify carryover items (unchecked priorities + new TODOs)
7. Write the End of Day Summary with three subsections: What got done, Key decisions made, Carry forward to tomorrow
EOF

# /add-context
mkdir -p "$SKILLS_TARGET/add-context"
cat > "$SKILLS_TARGET/add-context/SKILL.md" << 'EOF'
---
name: add-context
description: Universal context ingestion. Routes URLs or text to the right PARA project and updates its CLAUDE.md. Use when the user says /add-context, pastes a URL, shares meeting notes, or wants to add context to a project.
---

# Add Context

Routes any URL or text to the appropriate project CLAUDE.md.

## Instructions

1. Accept the input — URL or freeform text
2. Load the content (open the URL, or process text directly)
3. Determine which project the context belongs to by matching against active projects in the root `CLAUDE.md`
4. Read the target project's `CLAUDE.md`
5. Update the appropriate sections: Latest Updates, Key Documents, Key Stakeholders, etc.
6. If the context doesn't match any project, ask the user where to route it
EOF

# /capture-idea
mkdir -p "$SKILLS_TARGET/capture-idea"
cat > "$SKILLS_TARGET/capture-idea/SKILL.md" << 'EOF'
---
name: capture-idea
description: Capture a project idea for incubation in the PARA inbox. Use when the user says /capture-idea, has a new project idea, or wants to save something for later exploration.
---

# Capture Idea

Creates a date-prefixed folder in `00_inbox/incubator/` with a CLAUDE.md for the idea.

## Instructions

1. Gather the idea details from the user (brain dump, links, context)
2. Create folder: `00_inbox/incubator/YYYY_MM_DD_idea_name/`
3. Create `CLAUDE.md` inside with the idea description, context, and any linked resources
4. Remind the user: use `/add-context` to accumulate more context over time, then `/start-project` when ready to activate
EOF

# /start-project
mkdir -p "$SKILLS_TARGET/start-project"
cat > "$SKILLS_TARGET/start-project/SKILL.md" << 'EOF'
---
name: start-project
description: Start a new PARA project. Gathers context, creates project folder structure, and updates root CLAUDE.md. Use when the user says /start-project or wants to create a new active project.
---

# Start Project

Creates a new active project in the PARA workspace.

## Instructions

1. Gather context from the user (what is it, why, who's involved, key docs)
2. Determine the next project number from `01_projects/`
3. Create project folder: `01_projects/XX_project_slug/`
4. Create subfolders: `docs/`, `meetings/`
5. Create project `CLAUDE.md` with: Overview, Current Status, Latest Updates, Key Deliverables, Key Stakeholders, Key Documents, Project Files
6. Update root `CLAUDE.md` Active Projects table with the new project
7. If promoting from incubator, note that the incubator folder can be removed
EOF

# /archive-project
mkdir -p "$SKILLS_TARGET/archive-project"
cat > "$SKILLS_TARGET/archive-project/SKILL.md" << 'EOF'
---
name: archive-project
description: Archive a completed project. Updates CLAUDE.md files and moves folder to archives. Use when the user says /archive-project or wants to complete and archive a project.
---

# Archive Project

Archives a completed project from `01_projects/` to `04_archives/`.

## Instructions

1. Identify the project to archive (ask if not specified)
2. Update the project's `CLAUDE.md` with final status and completion notes
3. Determine the next archive number from `04_archives/`
4. Move the project folder to `04_archives/XX_project_slug/`
5. Update root `CLAUDE.md`: remove from Active Projects, add to Completed Projects table
EOF

# /prepare-meeting
mkdir -p "$SKILLS_TARGET/prepare-meeting"
cat > "$SKILLS_TARGET/prepare-meeting/SKILL.md" << 'EOF'
---
name: prepare-meeting
description: Research a person, team, or project and generate a focused meeting agenda with background notes. Use when the user says /prepare-meeting, needs to prep for a 1:1, or wants meeting research.
---

# Prepare Meeting

Researches context and generates a focused meeting agenda with private background notes.

## Instructions

1. Identify the meeting subject (person, team, or project)
2. Search the workspace for relevant context: project CLAUDE.md files, people notes in `03_resources/people/`, recent meeting notes
3. Cross-reference against active projects to find shared context
4. Generate a meeting agenda with:
   - Background context (private notes — for your eyes only)
   - Suggested talking points linked to active projects
   - Open questions and action items to discuss
   - Time allocation suggestions
EOF

# /generate-hpm
mkdir -p "$SKILLS_TARGET/generate-hpm"
cat > "$SKILLS_TARGET/generate-hpm/SKILL.md" << 'EOF'
---
name: generate-hpm
description: Generate a highlights/priorities update by discovering recent work. Use when the user says /generate-hpm, needs to write a status update, or wants to prepare a highlights summary.
---

# Generate HPM

Generates a Highlights, Priorities, Me update from recent work.

## Instructions

1. Determine the time window: check `02_areas/hpms/` for the last update, cover the gap
2. Search for recent work: project CLAUDE.md latest updates, daily notes, meeting notes, completed tasks
3. Show discovered content for user review
4. Generate the update with three sections:
   - **Highlights**: What you shipped, decided, or unblocked
   - **Priorities**: What's next and what you're focused on
   - **Me**: Personal/development items (optional)
5. Save to `02_areas/hpms/YYYY_MM_DD.md`
6. Iterate based on user feedback
EOF

# /recap
mkdir -p "$SKILLS_TARGET/recap"
cat > "$SKILLS_TARGET/recap/SKILL.md" << 'EOF'
---
name: recap
description: Generate a weekly work summary. Searches daily notes, project updates, and completed tasks. Use when the user says /recap, needs a weekly summary, or wants to review the week.
---

# Weekly Recap

Generates a weekly summary of work completed.

## Instructions

1. Determine the recap window (typically last 5-7 days)
2. Read daily notes from `00_inbox/notes/` for the period
3. Read project CLAUDE.md files for latest updates in that window
4. Compile: key accomplishments, decisions made, meetings attended, items completed
5. Organize by project
6. Save the recap to `00_inbox/notes/` or present to the user
EOF

echo "  ✓ Cursor skills (9 commands installed to ~/.cursor/skills/)"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Setup complete!                        ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo ""
echo "  1. Open $WORKSPACE_DIR in Cursor"
echo "  2. Edit CLAUDE.md — fill in Writing Style and Key Acronyms"
echo "  3. Create your first project:"
echo "     - Copy 01_projects/PROJECT_TEMPLATE.md to"
echo "       01_projects/01_my_project/CLAUDE.md"
echo "     - Fill in the project details"
echo "     - Add it to the Active Projects table in root CLAUDE.md"
echo "  4. Start a chat — the agent should greet you with your context"
echo ""
echo "Commands available:"
echo "  /daily            Build today's planner"
echo "  /note             Quick capture a thought"
echo "  /eod              End of day recap"
echo "  /add-context      Route info to a project"
echo "  /capture-idea     Save an idea for later"
echo "  /start-project    Create a new project"
echo "  /archive-project  Archive a finished project"
echo "  /prepare-meeting  Research + agenda for a meeting"
echo "  /generate-hpm     Highlights/priorities update"
echo "  /recap            Weekly work summary"
echo ""
