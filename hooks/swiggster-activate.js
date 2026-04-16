#!/usr/bin/env node
// swiggster — Claude Code SessionStart activation hook
//
// Runs on every session start:
//   1. Reads SKILL.md and emits CEO persona context
//   2. Checks for required connector skills
//   3. Injects cross-domain signals reference

const fs = require('fs');
const path = require('path');
const os = require('os');

const pluginRoot = path.resolve(__dirname, '..');
const skillPath = path.join(pluginRoot, 'skills', 'swiggster', 'SKILL.md');
const crossDomainPath = path.join(pluginRoot, 'references', 'cross-domain-signals.md');

// Read SKILL.md
let skillContent = '';
try {
  skillContent = fs.readFileSync(skillPath, 'utf8');
  // Strip YAML frontmatter
  skillContent = skillContent.replace(/^---[\s\S]*?---\s*/, '');
} catch (e) {
  skillContent = 'SWIGGSTER ACTIVE — CEO analytics mode for Swiggy Instamart. Auto-routes to correct domain.';
}

// Read cross-domain signals
let crossDomainContent = '';
try {
  crossDomainContent = fs.readFileSync(crossDomainPath, 'utf8');
} catch (e) {
  crossDomainContent = '';
}

// Check which connector skills are available
const claudeDir = path.join(os.homedir(), '.claude');
const skillsDir = path.join(claudeDir, 'skills');

const connectors = [];
const connectorNames = ['snowflake-connector', 'databricks-connector', 'google-connector'];
for (const c of connectorNames) {
  try {
    if (fs.existsSync(path.join(skillsDir, c))) {
      connectors.push(c);
    }
  } catch (e) {}
}

// Build activation output
let output = 'SWIGGSTER ACTIVE — Swiggy Instamart CEO Analytics Agent\n\n';
output += skillContent;

if (crossDomainContent) {
  output += '\n\n---\n\n## Loaded: Cross-Domain Signal Chains\n\n';
  output += crossDomainContent;
}

if (connectors.length > 0) {
  output += '\n\n---\n\n**Available connectors**: ' + connectors.join(', ');
} else {
  output += '\n\n---\n\n**Note**: No connector skills detected in ~/.claude/skills/. ';
  output += 'Install `snowflake-connector` and/or `databricks-connector` skills to execute queries. ';
  output += 'Swiggster can still write SQL and build analysis frameworks without live connectors.';
}

process.stdout.write(output);
