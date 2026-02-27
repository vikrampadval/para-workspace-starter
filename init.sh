#!/bin/bash
set -e

# PARA Workspace Initializer
# Interactive setup that creates a PARA workspace with CLAUDE.md context files
# and Cursor skills, guided step-by-step.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   PARA Workspace Setup                           ║"
echo "║   Persistent AI context for Cursor + Claude      ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "This will walk you through setting up your workspace."
echo "Takes about 5 minutes. You can always edit the files later."
echo ""

# ============================================================
# PHASE 1: About You
# ============================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  STEP 1 of 5: About You"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "Your name: " USER_NAME
read -p "Your role (e.g. Product Manager, Software Engineer): " USER_ROLE
read -p "Your team or org: " USER_TEAM
read -p "Your manager's name (or press Enter to skip): " USER_MANAGER
read -p "Your timezone (e.g. US/Pacific, Europe/London) [UTC]: " USER_TZ
USER_TZ="${USER_TZ:-UTC}"
read -p "What are you focused on right now? (1 sentence): " USER_FOCUS

echo ""

# ============================================================
# PHASE 2: Writing Style
# ============================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  STEP 2 of 5: Writing Style"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This helps the AI draft things that sound like you."
echo ""

read -p "How would you describe your communication style? (e.g. direct, formal, casual, detailed): " STYLE_TONE

read -p "Do you prefer bullet points, numbered lists, or prose? [bullets]: " STYLE_FORMAT
STYLE_FORMAT="${STYLE_FORMAT:-bullet points}"

read -p "Do you start docs with a TL;DR / summary? (y/n) [y]: " STYLE_TLDR
STYLE_TLDR="${STYLE_TLDR:-y}"

read -p "Any phrases you naturally use? (comma-separated, or press Enter to skip): " STYLE_PHRASES

read -p "Anything to avoid in drafts? (e.g. emojis, jargon, passive voice): " STYLE_AVOID

echo ""

# Build writing style block
WRITING_STYLE="### Voice\n- **${STYLE_TONE^}** communication style\n- Prefers **${STYLE_FORMAT}** for structured content"

if [[ "$STYLE_TLDR" == "y" || "$STYLE_TLDR" == "Y" ]]; then
  WRITING_STYLE="$WRITING_STYLE\n- Lead with a **TL;DR** before going deep"
fi

if [[ -n "$STYLE_PHRASES" ]]; then
  WRITING_STYLE="$WRITING_STYLE\n- Natural phrases: ${STYLE_PHRASES}"
fi

if [[ -n "$STYLE_AVOID" ]]; then
  WRITING_STYLE="$WRITING_STYLE\n\n### Avoid\n- ${STYLE_AVOID}"
fi

# ============================================================
# PHASE 3: Key Acronyms
# ============================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  STEP 3 of 5: Key Acronyms & Terms"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Add acronyms your team uses so the AI gets them right."
echo "Format: ACRONYM = definition"
echo "Type 'done' when finished (or press Enter to skip)."
echo ""

ACRONYMS=""
while true; do
  read -p "  Acronym (or 'done'): " ACRO_INPUT
  if [[ "$ACRO_INPUT" == "done" || -z "$ACRO_INPUT" ]]; then
    break
  fi
  read -p "  Definition: " ACRO_DEF
  ACRONYMS="$ACRONYMS\n- **${ACRO_INPUT}**: ${ACRO_DEF}"
  echo "    Added. Next? (or 'done')"
done

if [[ -z "$ACRONYMS" ]]; then
  ACRONYMS="\n<!-- Add acronyms here as: -->\n<!-- - **ACRONYM**: What it stands for -->"
fi

echo ""

# ============================================================
# PHASE 4: First Project
# ============================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  STEP 4 of 5: Your First Project"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Let's set up your first active project."
echo "(Press Enter to skip — you can create projects later with /start-project)"
echo ""

read -p "Project name (e.g. 'Website Redesign'): " PROJ_NAME

PROJ_SLUG=""
PROJ_DESC=""
PROJ_STATUS=""
PROJ_OVERVIEW=""

if [[ -n "$PROJ_NAME" ]]; then
  # Generate slug from name
  PROJ_SLUG=$(echo "$PROJ_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd 'a-z0-9_')

  read -p "One-line description: " PROJ_DESC
  read -p "What phase is it in? (e.g. planning, execution, launch): " PROJ_STATUS
  read -p "Brief overview (2-3 sentences — what is it and why does it matter?): " PROJ_OVERVIEW
  echo ""
  echo "  Project will be created at: 01_projects/01_${PROJ_SLUG}/"
fi

echo ""

# ============================================================
# PHASE 5: Workspace Location
# ============================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  STEP 5 of 5: Create Workspace"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "Where should the workspace be created? [./para-workspace]: " WORKSPACE_DIR
WORKSPACE_DIR="${WORKSPACE_DIR:-./para-workspace}"

echo ""
echo "Creating workspace at: $WORKSPACE_DIR"
echo ""

# ============================================================
# CREATE FOLDER STRUCTURE
# ============================================================

mkdir -p "$WORKSPACE_DIR/00_inbox/meetings"
mkdir -p "$WORKSPACE_DIR/00_inbox/incubator"
mkdir -p "$WORKSPACE_DIR/01_projects"
mkdir -p "$WORKSPACE_DIR/02_areas/hpms"
mkdir -p "$WORKSPACE_DIR/02_areas/career"
mkdir -p "$WORKSPACE_DIR/02_areas/learning"
mkdir -p "$WORKSPACE_DIR/02_areas/team"
mkdir -p "$WORKSPACE_DIR/03_resources/people"
mkdir -p "$WORKSPACE_DIR/03_resources/templates"
mkdir -p "$WORKSPACE_DIR/04_archives"

# ============================================================
# WRITE ROOT CLAUDE.md
# ============================================================

# Build manager line
MANAGER_LINE=""
if [[ -n "$USER_MANAGER" ]]; then
  MANAGER_LINE="- **Manager**: ${USER_MANAGER}"
fi

# Build active projects table
if [[ -n "$PROJ_NAME" ]]; then
  PROJECTS_TABLE="| 01 | [${PROJ_NAME}](01_projects/01_${PROJ_SLUG}/CLAUDE.md) | \`project:${PROJ_SLUG}\` | ${PROJ_DESC} |"
else
  PROJECTS_TABLE="<!-- Add projects here with /start-project -->"
fi

cat > "$WORKSPACE_DIR/CLAUDE.md" << ROOTEOF
# CLAUDE.md

This file provides context for Claude when working in this workspace.

## Session Start Behavior

At the start of every new session:
1. Confirm you've loaded my context (1 line)
2. Ask what I'm working on today

## About Me

- **Name**: ${USER_NAME}
- **Role**: ${USER_ROLE}
- **Team**: ${USER_TEAM}
${MANAGER_LINE}
- **Timezone**: ${USER_TZ}
- **Focus**: ${USER_FOCUS}

### Key Acronyms & Terms
$(echo -e "$ACRONYMS")

## Directory Structure

\`\`\`
workspace/
├── CLAUDE.md                # Root context file
├── 00_inbox/                # Quick capture, unsorted items
│   ├── meetings/            # Meeting notes before filing
│   └── incubator/           # Ideas not ready to start
├── 01_projects/             # Active work with deadlines
├── 02_areas/                # Ongoing responsibilities
│   ├── hpms/                # Highlights, Priorities updates
│   ├── career/              # Career planning
│   ├── learning/            # Learning notes
│   └── team/                # Team-related notes
├── 03_resources/            # Reference material
│   ├── people/              # Colleague profiles
│   └── templates/           # Reusable templates
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
${PROJECTS_TABLE}

## Completed Projects

| # | Project | Tag | Description |
|---|---------|-----|-------------|
<!-- Move projects here when archived -->

## Slash Commands

- \`/add-context\` — Route a URL or text to the right project's CLAUDE.md
- \`/capture-idea\` — Save an idea to the incubator for later
- \`/start-project\` — Create a new active project from a brain dump
- \`/archive-project\` — Move a completed project to archives

## Writing Style

$(echo -e "$WRITING_STYLE")

## AI Agent Instructions

- Be direct and concise. Avoid unnecessary words.
- Ask clarifying questions before making assumptions.
- Don't create files unless necessary.
- When linking documents, use a table with Name and Description columns.
ROOTEOF

echo "  ✓ Root CLAUDE.md"

# ============================================================
# CREATE FIRST PROJECT (if provided)
# ============================================================

if [[ -n "$PROJ_NAME" ]]; then
  PROJ_DIR="$WORKSPACE_DIR/01_projects/01_${PROJ_SLUG}"
  mkdir -p "$PROJ_DIR/docs"
  mkdir -p "$PROJ_DIR/meetings"

  cat > "$PROJ_DIR/CLAUDE.md" << PROJEOF
# ${PROJ_NAME}

**Project Tag**: \`project:${PROJ_SLUG}\`

## Overview

${PROJ_OVERVIEW}

## Current Status

**Phase**: ${PROJ_STATUS^}

## Latest Updates

<!-- Update this after key meetings or decisions. -->
<!-- This is the most important section — the agent reads it for project context. -->

## Key Deliverables

| Name | Description |
|------|-------------|
<!-- | Deliverable name | What it is | -->

## Key Stakeholders

| Person | Role | Team |
|--------|------|------|
| ${USER_NAME} | ${USER_ROLE} | ${USER_TEAM} |
<!-- Add more stakeholders as needed -->

## Key Documents

| Name | Description |
|------|-------------|
<!-- | [Doc title](url) | What's in it | -->

## Project Files

- \`docs/\` — Project documentation
- \`meetings/\` — Meeting notes
PROJEOF

  echo "  ✓ Project: ${PROJ_NAME}"
fi

# ============================================================
# WRITE PROJECT TEMPLATE
# ============================================================

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

## Project Files

- `docs/` — Project documentation
- `meetings/` — Meeting notes
PROJEOF

echo "  ✓ Project template"

# ============================================================
# INSTALL CURSOR SKILLS
# ============================================================

SKILLS_TARGET="$HOME/.cursor/skills"
mkdir -p "$SKILLS_TARGET"

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

echo "  ✓ Cursor skills (4 commands installed to ~/.cursor/skills/)"

# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   Setup complete!                                ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "Your workspace is ready at: $WORKSPACE_DIR"
echo ""
echo "What was created:"
echo "  ✓ PARA folder structure (inbox, projects, areas, resources, archives)"
echo "  ✓ Root CLAUDE.md with your profile, writing style, and acronyms"
if [[ -n "$PROJ_NAME" ]]; then
echo "  ✓ Project: ${PROJ_NAME} (01_projects/01_${PROJ_SLUG}/)"
fi
echo "  ✓ Project template for future projects"
echo "  ✓ 4 slash commands installed to Cursor"
echo ""
echo "Next steps:"
echo ""
echo "  1. Open $WORKSPACE_DIR in Cursor"
echo "  2. Start a chat — the agent should greet you with your context"
echo "  3. Try these commands:"
echo "     /add-context      Route info to a project"
echo "     /capture-idea     Save an idea for later"
echo "     /start-project    Create a new project"
echo "     /archive-project  Archive a finished project"
echo ""
echo "Tip: The more you fill in your CLAUDE.md, the better the AI gets."
echo "     Start with Writing Style and Key Acronyms for the biggest impact."
echo ""
