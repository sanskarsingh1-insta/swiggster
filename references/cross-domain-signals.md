# Cross-Domain Signal Chains

When any domain metric moves, check these cascade patterns automatically.

## Cascade Map

| Trigger Signal | Domain | Cascades To | What To Check |
|---------------|--------|-------------|---------------|
| Availability OOS% ↑ | Avail | Discovery: Null search ↑, Q2C ↓ | Search queries for OOS brands |
| Availability OOS% ↑ | Avail | CC: WIMO ↑, CC CPO ↑ | IGCC CPO, WIMO % |
| Availability OOS% ↑ | Avail | Growth: F2M ↓ (bad first experience) | New user retention |
| O2D speed ↑ | DelOps | CC: CSAT ↓, EPMO ↑, CC CPO ↑ | Escalation rate, CSAT scores |
| O2D speed ↑ | DelOps | Growth: Churn ↑, C2O ↓ | Retention cohorts post-speed event |
| Campaign spend ↑ | Growth | CC: Coupon abuse, ICA ↑, CC CPO ↑ | Fraud tags on campaign cohort |
| Campaign spend ↑ | Growth | Pricing: Discount burn ↑, NM ↓ | SDPO decomposition for campaign |
| Pricing uncompetitive | Pricing | Discovery: Conversion ↓, Q2C ↓ | Price index vs competitor |
| Pricing uncompetitive | Pricing | Growth: GMV ↓, CAC ↑ | Growth funnel MoM |
| Catalog quality ↓ (CHS ↓) | CatOps | Discovery: Search relevance ↓, null search ↑ | MRR, Q2C for affected SPINs |
| Catalog quality ↓ | CatOps | Avail: Phantom OOS (product exists, not findable) | OOS% for low-CHS SPINs |
| CC CPO spike | CC | Decompose: fraud ↑? bot efficacy ↓? SLA breach ↑? | All CC sub-metrics |
| NM erosion | Pricing | Decompose: SDPO subtype driving? CompBench? Flash? | Discount decomposition |
| Search null rate ↑ | Discovery | Avail: OOS on searched terms? | OOS for top search terms |
| Search null rate ↑ | Discovery | CatOps: Missing catalog for demanded products? | NPI pipeline for searched terms |
| ROAS ↓ | Growth | Pricing: Discount overfunding campaigns? | Campaign SDPO vs organic SDPO |
| Chronic POD flagged | DelOps | CC: High EPMO in that POD | EPMO by POD |
| H-tag refund leakage ↑ | CC | Growth: High-value cohort abuse? | Trust tier breakdown of claimants |
| Agent AHT ↑ | CC | Pricing: Complex pricing issues driving calls? | Issue type: price dispute % |

## Compound Events (Check Multiple Domains Simultaneously)

### Event: Order volume decline
Run domains: **Growth (funnel) + Avail (OOS) + Discovery (search) + DelOps (serviceability)**

### Event: Cost per order spike  
Run domains: **CC (IGCC/CC CPO) + Pricing (NM/discounts) + DelOps (PSLA breaches)**

### Event: City underperformance
Run domains: **DelOps (speed/fleet) + Avail (OOS%) + Discovery (search conv) + Growth (retention)**

### Event: New campaign launch assessment
Run domains: **Growth (funnel/ROAS) + CC (abuse/fraud) + Pricing (NM impact)**

### Event: Competitor attack (Blinkit/Zepto price cut)
Run domains: **Pricing (price gap) + Discovery (conversion drop) + Growth (churn signal)**

## Signal Thresholds (Act If Exceeded)

| Metric | Watch | Alert | Emergency |
|--------|-------|-------|-----------|
| OOS% | >5% | >10% | >15% |
| CC CPO delta | >5% WoW | >10% WoW | >20% WoW |
| Null search rate | >8% | >12% | >18% |
| O2D breach rate | >10% | >15% | >25% |
| ROAS | <1.5x | <1.0x | <0.8x |
| NM | trending ↓ | negative | deeply negative |
| Bot efficacy | <80% | <70% | <60% |
| RQC AI accuracy | <88% | <85% | <80% |
