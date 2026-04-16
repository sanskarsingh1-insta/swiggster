# Swiggster

Autonomous CEO-mode analytics agent for Swiggy Instamart.

Ask any IM analytics question. Swiggster detects the domain, routes to the right tables, builds a hypothesis tree, runs queries in parallel, and synthesizes findings to business impact — without needing guidance.

## Install

```
claude plugin marketplace add sanskarsingh1-insta/swiggster && claude plugin install swiggster@swiggster
```

Restart Claude Code. Done.

---

## What it covers

| Domain | Key Questions |
|--------|--------------|
| Customer Care / IGCC | CPO trends, refund leakage, fraud tags, bot efficacy, RQC accuracy |
| Growth & Promotions | AAARRR funnel, campaign ROAS, cohort retention, XPoll |
| Delivery Ops | O2D speed, chronic PODs, fleet utilization, SLA breaches |
| Catalog Ops | SPIN health, attribute fill rate, catalog coverage |
| Availability | OOS%, fillrate, DOH, PO/GRN tracking, demand planning |
| Discovery | Search Q2C, null search, surface attribution, brand SOV |
| Pricing | NM/GM, discount decomposition, competitive price gap |

---

## How it works: PLAN → ACTION

Every question runs two mandatory phases.

**PLAN phase** (always first, no queries run):
- Dissects the real business question underneath what was asked
- Builds a hypothesis tree — all possible causes ranked by probability
- Designs the *minimum* query set that proves/disproves each hypothesis
- States assumptions and risks explicitly
- Defines what "done" looks like

**ACTION phase** (immediately after PLAN):
- Executes the query plan in parallel via task graph
- Each query tagged to the hypothesis it tests
- Stops early when top hypothesis confirmed (no speculative extra queries)
- Synthesizes to CEO-level output: ₹/orders impact → RCA → owner → action plan

---

## Usage

Just ask:

```
Why did CC CPO spike this week in Bangalore?
```
```
Give me a growth funnel diagnostic for IM for the last 14 days.
```
```
Why is OOS high for dairy in Mumbai? What's the business impact?
```
```
Run a full availability + discovery correlation for Hyderabad.
```

---

## CEO Mode + Karpathy First-Principles

Swiggster combines CEO framing with Karpathy's engineering discipline:

| CEO Mode | Karpathy Discipline |
|----------|---------------------|
| Business impact in ₹/orders | Think before querying — hypothesis first |
| Cross-domain cascade analysis | Simplicity first — minimum queries |
| Owner attribution for findings | Surgical SQL — no unfiltered large tables |
| Actionable interventions | Goal-driven — stop when answer found |

### Optional: add karpathy-guidelines companion

```powershell
irm https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.ps1 | iex
irm https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/install.ps1 | iex
```

---

## Dependencies

Swiggster writes SQL and builds analysis frameworks standalone. To **execute** queries live:
- Install `snowflake-connector` skill (Snowflake tables)
- Install `databricks-connector` skill (Databricks tables)

---

## License

MIT
