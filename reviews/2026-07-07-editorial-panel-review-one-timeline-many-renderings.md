# Simulated Peer Review — Editorial Panel & Decision

**Manuscript:** *One Timeline, Many Renderings: A Wolfram Language Paclet for Heterogeneous Musical Output*
**File reviewed:** [`paper.tex`](../paper.tex)
**Type:** Systems / tools paper (artifact-centered "experience report")
**Target venue (inferred):** ICSC 2026 — International Csound Conference (LLNCS format; specialist practitioner + developer + composer community, not a top-tier archival journal). Standards calibrated accordingly: clarity, artifact availability, and idiom-correctness weigh more than empirical/statistical rigor.
**Review date:** 2026-07-07
**Method:** Five-reviewer simulated panel (EIC + Methodology/Reproducibility + Domain + Cross-disciplinary/Perspective + Devil's Advocate), produced with the `academic-paper-reviewer` skill. Simulation only — not a substitute for the venue's actual referees.

---

## Grounding checks (performed against the repository)

| Check | Result |
|---|---|
| Figure `figures/timeline_export` present | ✅ `timeline_export.pdf` (28 KB) and `.png` (100 KB) exist |
| Supplementary artifacts exist | ✅ `drive_upload/` contains the aggregated `.csd`+`.wav`, click `.csd`+`.wav`, OSC JSON, notebook, and `.orc` instruments |
| Supplementary URL in paper | ❌ Placeholder — `paper.tex:20` = `https://drive.google.com/PLACEHOLDER-REPLACE-ME` |
| Page count of built PDF | ⚠️ **5 pages** (branch targets 4: `paper/icsc2026-4pages`) |
| Geometry override | ⚠️ `paper.tex:13` `\usepackage[margin=1.1in]{geometry}` overrides native LLNCS layout |

So the reproducibility package is **real and committed** — the only gap is that the paper still points to a placeholder link.

---

## Phase 0 — Field Analysis & Reviewer Configuration

| Attribute | Assessment |
|---|---|
| Primary field | Sound & Music Computing / computer-music systems |
| Secondary | Software architecture; symbolic music representation |
| Paradigm | Design/engineering artifact ("systems paper"), not empirical or theoretical |
| Maturity | Working system; 3 of 4 backends solid (Csound, Click, OSC), MusicXML in beta |
| Rigor bar | Moderate (specialist practitioner venue) |

**Panel (5 reviewers, independent, non-overlapping angles):** EIC (fit/framing/compliance); R1 (methodology & reproducibility); R2 (CAC/representation literature & novelty); R3 (cross-disciplinary/practical); DA (core-thesis challenge).

---

## R0 — Editor-in-Chief

**Angle: venue fit, contribution framing, compliance.**

A well-written, well-motivated systems paper that fits the ICSC audience squarely: Csound-first, treating the orchestra/score split as the reference idiom and giving the Csound renderer the most detailed treatment. The "heterogeneous output as a projection problem, one source of truth" framing is clear and the prose is disciplined for a 4-page submission. The related-work paragraph (music21, abjad, MEI/Verovio, bach/cage) is genuinely good positioning, and the honest Wolfram trade-off paragraph builds trust.

Concerns are editorial rather than scientific:

1. **Format compliance (must fix).** Current build is **5 pages** vs. a 4-page target. `\usepackage[margin=1.1in]{geometry}` (`paper.tex:13`) overrides the native LLNCS text block — LLNCS venues generally forbid re-setting geometry; reverting restores compliance *and* recovers space.
2. **Double-blind leaks (must fix).** Generic authors/institute correctly kept, but (a) the supplementary link is a personal Google Drive placeholder (`paper.tex:20`) — a Drive URL deanonymizes; (b) the paclet's distinctive name + feature set is likely searchable to a public Wolfram paclet.
3. **Placeholder URL still in source** (`paper.tex:20`) — trivial but submission-blocking.

**Contribution as read:** an *architecture* (immutable rational-beat store + per-backend projection contracts), Csound as the concrete reference. Legitimate for this venue; thin on *evidence* (see R1).

**EIC leaning:** Minor Revision (venue-calibrated), conditional on compliance fixes + modest evaluation strengthening.

---

## R1 — Methodology & Reproducibility Reviewer

**Angle: what evidence supports the claims?**

The paper's weakest dimension, and fixable.

- **The central claim is asserted, not demonstrated.** The abstract says artifacts "stay synchronous because they share one store" (`paper.tex:49–50`); this is never *shown*. The convincing demonstration is cheap: take one edit (retune 440→432 Hz, or move a tempo point) and show that Csound `p2/p4`, OSC `time_ms`, the click track, and MusicXML divisions all move *consistently* and stay aligned. "Synchronous" is currently a design intention, not a verified result.
- **"It compiles and was auditioned" is not an evaluation** (`paper.tex:192–193`). "Compiles without error" is a smoke test; "audio was auditioned" is subjective and unattributed. State what auditioning verified and how a reader reproduces it.
- **No quantitative characterization.** For "one timeline, many renderings," the natural evidence is a coverage matrix (which entity types reach each backend) and the concrete *cost of adding a backend*. The click backend is your best evidence — quantify it (LOC added, Layers I–II touched = 0).
- **Unnamed tooling hurts reproducibility.** "A commercial engraving application" (`paper.tex:220–221`) and "a reference schema" (`paper.tex:48`) — name them and versions (which MusicXML profile?).
- **The single stress fixture carries too much.** Fig. 2 is explicitly "a stress fixture… not a representative composition" (`paper.tex:203–204`). State how many fixtures the suite has and what they cover.
- **Reproducibility positives:** example artifacts genuinely exist. But is the **paclet itself** released? License? Repository? Currently unstated for the software (only the example outputs are packaged).
- **Missing MIDI backend** — the most obvious projection in this domain and a natural correctness cross-check (MIDI vs. Csound onsets). At least acknowledge its absence.

**Score (rigor/evaluation): ~48/100.**

---

## R2 — Domain Reviewer (Computer-Assisted Composition & Music Representation)

**Angle: literature coverage and novelty of the time claim.**

Good framing, but the **central novelty claim is over-broad and under-cited.** The paper positions beat-space rational time as its differentiator, asserting prior systems have time "ultimately notational or measured in seconds" (`paper.tex:92–94`). This is vulnerable:

- **TidalCycles / the Tidal pattern model uses rational time as a first-class citizen** (cycles as exact rationals) — precisely your headline idea, in a widely used system. Its absence is the paper's most significant citation gap. Cite and differentiate (you target heterogeneous *file/score output*; Tidal targets live pattern scheduling).
- **OpenMusic/PWGL maquettes & rhythm trees** carry symbolic, non-seconds temporal structure; "ultimately notational or seconds" is arguably unfair. Sharpen the claim to what is distinctive: *rational beat-space as the shared substrate feeding multiple heterogeneous serializers simultaneously.*
- **Antescofo** and **SuperCollider patterns / Nyquist's stretch-based time** are relevant "musical vs. clock time" comparators that would strengthen positioning.
- The **Koenig/Tenney "scores only" lineage** (`paper.tex:107–109`) is nicely drawn and accurate — a strength; keep it.
- Clarify that model↔projection separation is *not itself* new (MEI does it too); your novelty is the *temporal substrate*.
- Summarize the MusicXML "declared coverage profile" (`paper.tex:220`) in one sentence in-text, not just via citation.

**Score (related work/positioning): ~62/100.**

---

## R3 — Cross-disciplinary / Practical Reviewer

**Angle: transferability, adoption, real-time realism.**

- **The reusable insight is language-agnostic — say so directly.** The transferable contribution is *immutable single-source-of-truth store + late binding to units + restrictive per-backend contracts* — a compiler-with-multiple-backends / single-IR pattern for music. Readers who never touch Wolfram still benefit from the principles; make the portable lesson explicit.
- **Adoption barrier under-stated.** Authoring requires a commercial Wolfram environment (honestly disclosed, `paper.tex:113–120`), so the *authoring* community is Wolfram users — a small subset of the Csound/CAC world. The "emitted artifacts are open" argument covers *consumption*, not *creation*.
- **Real-time / OSC claim needs a caveat.** OSC is called "real-time live electronics" (`paper.tex:49`) yet the backend *pre-samples* curves into a timed JSON list at a control rate (`paper.tex:328–331`) — scheduled/offline control data dispatched over OSC, not closed-loop real-time. Reword as "pre-rendered control stream for real-time dispatch."
- **"Click tracks usually rebuilt by hand in a DAW"** (`paper.tex:341–342`) is plausible lore but asserted — soften ("commonly") or cite.
- **Scalability unaddressed** — one sentence (store O(1) typed access; render linear in events) would preempt the question.

**Score (significance/practical impact): ~66/100.**

---

## DA — Devil's Advocate

### Strongest counter-argument (steel-manned)

> *"This paper proposes a projection / single-source-of-truth architecture — a model–view separation, or equivalently a compiler with one IR and multiple backends — which is standard software engineering, applied to music. Its one music-specific claim (rational beat-space as the primary shared substrate) is neither shown to matter nor clearly novel: TidalCycles already treats time as exact rationals, and MEI/music21 already feed many outputs from one model. The evidence for the headline promise — that heterogeneous outputs 'stay synchronous' — is that the code compiles and someone listened. Strip the framing and what remains is a competent multi-backend serializer for one commercial environment, one of whose four backends is admittedly beta, evaluated on a single synthetic fixture."*

The paper must answer this — it can, but currently doesn't.

### Issue list

- **CRITICAL — thesis untested.** The core value proposition (no drift / synchrony from a shared store) is asserted (`paper.tex:49–50`) and never verified. *Per panel rule, this precludes "Accept" and requires at least a Minor Revision adding a propagation/consistency demonstration.*
- **MAJOR — novelty framing.** "One beat-space infrastructure primary… time is ultimately notational or seconds" (`paper.tex:92–99`) overreaches given TidalCycles' rational time and MEI/music21's multi-output models. Reframe as the *combination* (rational substrate + simultaneous heterogeneous serializers + restrictive contracts).
- **MAJOR — "many renderings" partly aspirational.** MusicXML is beta/lossy (`paper.tex:48, 220`) → effectively 2.5–3 solid projections, and Csound + Click *share a serializer*, so the "cheap further projection" is demonstrated between two *similar* backends, not genuinely divergent ones.
- **MINOR — size-as-evidence.** "fourteen modules… 80 public functions… eleven types" (`paper.tex:124, 173–174`) signals scale, not quality. A coverage matrix would substantiate.
- **MINOR — cherry-picked exemplar.** Conclusions lean on one maximal, explicitly non-representative stress fixture (Fig. 2).

### Ignored alternatives / blind spots
- No MIDI backend as a correctness oracle (stakeholder: DAW/hardware integrators).
- Non-Wolfram implementability of the architecture never discussed — the portable claim is left on the table.

### "So what?" test
Passes *for the venue* (Csound practitioners get a usable, idiom-correct tool + a clean mental model). Weaker for a general SMC/CMJ audience unless the synchrony claim is substantiated and novelty reframed.

---

## Phase 2 — Editorial Synthesis & Decision

### Consolidated scores (0–100)

| Dimension | EIC | R1 | R2 | R3 | DA | Panel |
|---|---|---|---|---|---|---|
| Originality / novelty | 66 | — | 60 | 64 | 55 | **61** |
| Significance / contribution | 70 | — | 66 | 66 | 58 | **65** |
| Rigor / evaluation | 50 | 48 | — | — | 45 | **48** |
| Related work / positioning | 68 | — | 62 | — | — | **62** |
| Clarity / presentation | 82 | — | 78 | 80 | — | **80** |
| Reproducibility | — | 58 | — | 60 | — | **58** |
| Venue fit | 84 | — | 78 | 80 | — | **81** |

### Consensus (≥3 reviewers)
1. Excellent writing, clear architecture, strong venue fit. (EIC, R2, R3)
2. The headline synchrony/no-drift claim is unproven and must be demonstrated. (R1, DA; EIC concurs)
3. Novelty of the time-model is over-claimed and under-cited (missing TidalCycles above all). (R2, DA)
4. Compliance/hygiene blockers: 5→4 pages, placeholder Drive URL, double-blind leaks. (EIC)

### Disagreement / arbitration
- **How damaging is the thin evaluation?** R1/DA treat it as gating; EIC/R3 see it as fixable within venue norms. **Arbitration:** for ICSC it is a *Minor* item (add a propagation demonstration + coverage matrix), not grounds for rejection. A journal (CMJ, JNMR) would rate the same gap **Major**.
- **Does MusicXML-beta undercut "four backends"?** **Arbitration:** keep four, state coverage explicitly, and lean the heterogeneity evidence on the genuinely divergent pair (Csound score-binding vs. OSC ms-streaming), which the paper already contrasts well (`paper.tex:326–338`).

### Editorial Decision: **MINOR REVISION** (venue-calibrated)

> The Devil's Advocate raised a CRITICAL (untested core thesis), which by panel rule bars "Accept" — but it is remediable with modest additions rather than new research, and every other axis (fit, clarity, contribution) is above the venue bar. Hence Minor, not Major. *(A general SMC journal would land this at Major Revision on the evaluation gap alone — relevant if the paper is later retargeted.)*

---

## Revision Roadmap (prioritized)

**P0 — Submission blockers (~1 hour)**
1. Replace the placeholder supplementary URL (`paper.tex:20`) with a real **anonymized** OSF/Zenodo link (not personal Drive).
2. Reach the CfP page limit: remove `\usepackage[margin=1.1in]{geometry}` (`paper.tex:13`) to restore LLNCS layout; confirm ≤4 pages.
3. Close double-blind leaks: anonymized artifact host; consider a neutral working name for the review copy.

**P1 — Substance (addresses the CRITICAL + MAJORs)**
4. Add a **propagation/consistency demonstration**: one edit (432 Hz retune *or* a tempo change) shown to update Csound `p2/p4`, OSC `time_ms`, click, and MusicXML consistently. *(The missing proof; cheap to produce.)* — R1, DA
5. Add a compact **entity × backend coverage matrix** (each of the 11 types: emit / approximate / drop per backend). — R1, DA
6. **Cite TidalCycles** (ideally Antescofo / SC patterns too) and **reframe novelty** as the rational-substrate + simultaneous heterogeneous serializers + restrictive-contracts *combination*; soften "time is ultimately notational or seconds." — R2, DA
7. Quantify the "cheap new backend" claim using the click backend (LOC added, Layers I–II untouched). — R1, R3
8. Name the engraving application + MusicXML profile/version; one-sentence coverage summary. — R1, R2

**P2 — Polish**
9. Reword OSC as "pre-rendered control stream for real-time dispatch." — R3
10. State code/paclet availability + license; acknowledge no-MIDI-backend. — R1
11. One sentence each on scalability and non-Wolfram portability. — R3
12. Soften or cite the "click tracks rebuilt by hand in a DAW" assertion. — R3

---

*Generated by the `academic-paper-reviewer` skill (full mode, 5-reviewer panel). This is a simulated review to strengthen the manuscript before submission; it does not represent the venue's actual referees.*
