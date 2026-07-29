# PraatGen Codebase Audit — Pre-Evaluation Stress Test

**Repo:** github.com/embodied-music-lab/PraatGen @ c2350de · **Audited:** 29 July 2026
**Scope:** Full codebase except COMMANDS_Electroglottogram.txt content (frozen — being rewritten in parallel thread; conflicts flagged, no fixes proposed). Method: five parallel auditors (master prompt internals; registry-vs-source; Praat lint of eml sources; COMMANDS/appendix SOT layer; meta-docs) + independent verification of every critical finding against source.

**Headline:** The canonical clinical values are clean — the pitch floor/ceiling audit held everywhere, whitelist is empty as designed, all 236 procedures pair/parse correctly, no duplicate definitions, all live `@`-calls resolve. The real time bombs are in the **routing layer** (a ghost filename in the retrieval table, a registry indexing 37 procedures that don't exist) and in **gate-logic contradictions** in the master prompt.

---

## TIER 1 — Critical: will misroute or break a session

### C1. Ghost file `EML_DRAWING_PROCEDURES.txt` is still the primary drawing route
The retrieval table's only row for EML drawing routes to a file that does not exist.

| Where | Evidence |
|---|---|
| MASTER_PROMPT:185 | Retrieval row `EML_DRAWING_PROCEDURES.txt` — triggers on "EML Graphs procedures or publication-quality drawing… violins, smooth bands, gridlines, color palettes" |
| APPENDIX_F_UX_STANDARDS.txt:1031, 1241 | "See EML_DRAWING_PROCEDURES.txt" |
| COMMANDS_DemoWindow.txt:590, 965 | Same stale name |
| DEVELOPER_MODE_ADDON.md:55 | Same |
| BEST_PRACTICES_CONFIDENCE_FIGURES.txt:32, 153, 319, 335, 374 | References `EML_DRAWING_PROCEDURES_v2_4.txt` incl. procedure signatures |

Changelog 13.1 claims these references were repointed to EML_PROCEDURE_REGISTRY.md — the sweep missed all of the above. Meanwhile `BEST_PRACTICES_DRAWING.txt` (which the loading protocol at MP:204 says to ALWAYS co-load with Picture output) **has no retrieval-table row at all**. A model that scans the table — the stated trigger mechanism — hits a dead end for drawing and never sees the drawing best-practices file.
**Fix:** Replace MP:185 row with `BEST_PRACTICES_DRAWING.txt` + registry routing; sweep the six PKB files for the stale name.

### C2. Registry indexes 37 ghost procedures; three different totals in circulation
Measured ground truth: **236 procedures across 14 files** (231 public + 5 internal). The Registry header (EML_PROCEDURE_REGISTRY.md:3) claims **251 across 15 files**; its table body contains **273 rows**; MP:194 claims **255 across 14**. None is correct.

Ghost content (defined nowhere in pub/, verified by grep including the UTF-16 file):
- **Entire Wizard section** (REGISTRY:274–293): `scripts/eml-wizard.praat` "15 procedures" — no such file, none of the 15 `@wizard*` procedures exists anywhere.
- **18 ghost rows in the Output section** (REGISTRY:100–117): `emlWrapperCommonFields`, `emlHandleCommonFields`, 16× `emlWizardExplain*`. Section header says 21 (correct); table lists 39.
- **REGISTRY:151–152:** `emlLinearRegression`, `emlTheilSen` — unimplemented (Guide:218 admits "Regression: not yet implemented").
- **REGISTRY:254–255:** `emlReportRegressionAnalysis`, `emlReportNormalityAnalysis` — not in eml-annotation-procedures.praat.

Blast radius: the MP's rule is "Never rewrite procedure code — copy exactly from source" (MP:223). A model routed to a ghost procedure can't find source and must either fail or silently invent an implementation under a name the registry legitimizes — the worst-case behavior for a scored benchmark run.
**Fix:** Delete ghost rows/section; regenerate counts (236/231+5/14); sync MP:194.

### C3. Rule 28 "A–K" residue in the AUTO-mode compliance table
MP:540 (AUTO pre-delivery domain table, Picture row) still says **"Rule 28 A–K"**. The entire point of 13.9.4 was that the font-state invariant (L) "was absent from the Rule-28 A-K checklist the audit keys on." Lines 112, 2240, 2966 correctly say A–L; the AUTO check — the *only* compliance check when gates are suppressed — keys on the pre-fix list. AUTO mode will re-ship exactly the defect 13.9.4 was written to close.
**Fix:** `A–K` → `A–L` at MP:540.

### C4. HARD GATE contradicts Phase 3B on the GO-wait
MP:48–52: "If no thinking change is recommended, continue in the same turn: code and SELF-AUDIT immediately follow the plans." MP:694–705: all three score branches instruct a reply ("Reply GO when ready") and then "Wait for user to reply GO (or equivalent) before proceeding to Phase 3C. This is a hard gate — do not skip it." Both are marked hard; they cannot both be obeyed. Which one a session follows will depend on attention — a nondeterminism you do not want in a published evaluation of gate compliance.
**Fix:** Pick one. Cleanest: make Phase 3B's wait conditional on a recommended settings change, matching HARD GATE.

### C5. AUTO + DEBUGGING: menu offers a forbidden combination
MP:249 (STEP 1 verbatim response): "AUTO … Combines with SANDBOX and DEBUGGING." MP:638: "AUTONOMOUS and DEBUGGING are mutually exclusive." A user replying "AUTO DEBUGGING" per the menu invokes an undefined state.
**Fix:** MP:249 → "Combines with SANDBOX."

### C6. PulseAudio startup is commented out — twice
- MP:401–410: SANDBOX install step 4 (`pulseaudio --start`) is entirely `#`-prefixed; the step list reads 1, 2, 3, 5. apt installs pulseaudio (MP:367) but nothing starts it.
- MP:2027–2030: Rule 24C test template — `pkill Xvfb`, `pulseaudio --start`, `sleep 2` all commented out, contradicting critical detail 5 two paragraphs earlier.

Per the block's own warning: "Without this, `asynchronous Play` hangs indefinitely." Any SANDBOX session touching audio hangs.
**Fix:** Uncomment both blocks (if the comment-out was deliberate, the step numbering and the contradicting prose must say so).

### C7. eml-batch-process.txt is UTF-16BE
The only non-UTF-8 file in the library (`file` confirms: UTF-16 big-endian). Naive grep sees zero procedures in it — which is plausibly how the registry drifted (C2) and how any future mechanical regeneration will silently drop its 3 procedures again. Content lints clean once decoded. Note the batch domain is a scored benchmark task (RIP batch annotation).
**Fix:** `iconv -f UTF-16 -t UTF-8`, resave.

### C8. README setup instructions point at deleted `pkb/` directory
README:82, 148 tell users to "Upload all files from the `pkb/` folder." The folder was deleted (commit 8b9a478) and is now `pub/`. For a repo about to be cited in a publication, the reproduction path is broken at step 2. Related: README:216–228 lists 13 eml source files with `.praat` extensions that are actually `.txt` in pub/.
**Fix:** `pkb/` → `pub/`; correct the extension table.

---

## TIER 2 — Moderate: degrades compliance or invites drift

**M1. DEBUGGING mode has no defining section.** STEP 1 sells it ("requires your approval for any changes…"), STEP 2A/2B/2C define SCAFFOLD/SANDBOX/AUTO, but there is no handler for "user replies DEBUGGING." STEP 4 triggers on an error report, not the keyword, and doesn't state the approval-for-any-changes property. → Add STEP 2D.

**M2. VERBOSE is silently cancelled by GO.** MP:123–124: "Reply GO or EXECUTE to return to compressed" — but GO is also the proceed keyword at every gate. A VERBOSE user replying GO at the thinking gate reverts to SPARSE unintentionally, and SPARSE is already the designated return keyword (MP:58). → Delete the GO/EXECUTE clause.

**M3. SELF-AUDIT templates missing mandated items.** The evidence rule (MP:77–86) names file-output safety (26/27) as a silent-failure item requiring citation — but neither template has a 26/27 line item, so the requirement can never fire. Rule 4B ("SELF-AUDIT must confirm: no pre-existing objects removed") and Rule 37 likewise have no compressed-template slot; compressed Syntax line omits 5E (verbose includes it). Verbose template duplicates the "No unverified commitments" item (MP:2947–2957). → Add `✓ File output (26,27)` + 4B lines; dedupe.

**M4. Demo-window and confidence-figure files unreachable in standard mode.** No retrieval-table rows for `COMMANDS_DemoWindow.txt` or `BEST_PRACTICES_DEMO_WINDOW.md` (cited only in the AUTO domain table + House Rules) — yet the Demo deck is a scored benchmark task. `BEST_PRACTICES_CONFIDENCE_FIGURES.txt` (1,296 lines) has **zero** inbound references from any routing surface, despite README advertising the feature. `COMMANDS_Electroglottogram.txt` also has no retrieval row — **flag for the EGG thread** (a row can be added content-agnostically now). → Add four rows.

**M5. AUTO domain table has no file-output/GUI/UX row.** With SELF-AUDIT suppressed in AUTO, Rules 26/27 (file safety), 18/19/20 (GUI derivation), and 33/App F (UX) have no compliance check at all — an AUTO batch script can hardcode paths and overwrite files with nothing firing. → Add a row.

**M6. Dangling "I know the following commands:" in the mandated verbatim STEP 1 response** (MP:239). Nothing follows it; every session opens with the orphan line. → Delete or complete.

**M7. BEST_PRACTICES_DRAWING.txt contradicts itself on Marks.** Lines 92–93: "NEVER use `Marks left:` or `Marks bottom:`…" Lines 96–101: the very next "# CORRECT:" example uses `Marks left: 5,…` and `Marks bottom: 5,…`. The canonical positive example violates the rule two lines above it. → Rewrite the example with `One mark` nice-number calls (or scope the NEVER rule).

**M8. Demo font-state wording conflict.** MP House Rule (2661): "Set `demo Font size:` exactly once at initialization" vs COMMANDS_DemoWindow.txt:332–355 and BEST_PRACTICES_DEMO_WINDOW.md:22–41 requiring the three-line reset (incl. `demo Font size:`) at the top of *every* frame procedure. Literal reading of the MP flags compliant code. → MP wording: "one fixed value, re-asserted via the three-line reset; never a different value."

**M9. Registry signature drift (1 of 236 — verified as the only one).** `emlReportKWComparison` source (eml-annotation-procedures.praat:2689) takes 6 params incl. `.tableId` (4th); REGISTRY:250 lists 5, dropping `.tableId` — positions 4–6 shift, so a registry-faithful call misbinds three arguments. → Add `.tableId`.

**M10. Guide dead references.** EML_PROCEDURE_GUIDE.md:614 routes vibrato figures to `@emlVibratoDrawFigure` — defined nowhere; :615 cites `vibrato-procedures-manual.md` — no such file. → Repoint/remove.

**M11. Registry/Guide/loader use the plugin path convention, not the PKB layout.** Every REGISTRY `**File:**` entry uses `scripts/…/*.praat` subdir names; eml-graphs.txt's `include ../graphs/….praat` lines can't resolve against flat `pub/*.txt`. Workable inside Project Knowledge search, but a stress-test prompt asking for exact file retrieval by the registry's stated path will miss. → Either sync names to the flat `.txt` layout or add one explicit mapping note ("PKB filenames are flattened `.txt` copies of the plugin tree").

**M12. Praat version drift across the SOT.** Catalogue pinned 6.4.62 (header; internally cites 6.4.65 at L2503); APPENDIX_C_GUI and COMMANDS_Universal cite 6.4.67; scattered 6.4.59–6.4.65 elsewhere; MP says "verified Praat 6.4.67." Also the catalogue's self-stats are wrong on both sides: MP:192 claims "2,089 commands, 336 Formula functions" — neither figure appears in the catalogue, which claims 365 functions in its header and 369 in its own footer. → Re-extract catalogue at 6.4.67 (or add a staleness banner) and make MP:192 match whatever the file actually says.

**M13. Catalogue under-specifies query commands.** Catalogue omits from-time/to-time fields on `Get mean`, `Get minimum`, `Get quantile` (Formant L2262, Pitch L5290–5300) that COMMANDS_Formant.txt:169/178 and COMMANDS_Pitch.txt:39–48 correctly include. A model using the "definitive" fallback for verification would drop the time-range args. → Annotate or correct the catalogue query blocks.

**M14. License incoherence.** Repo/MP declare GPL-3.0-or-later; several eml headers say "Creative Commons Share-Alike"; eml-vibrato-procedures.txt:7 says "Creative Commons **Non-Commercial** with Attribution" — CC-NC is incompatible with GPL and with each other file. For a published artifact this is worth cleaning before reviewers see it. → Normalize headers to GPL-3.0-or-later (or dual-license deliberately).

**M15. Library violates its own forbidden-token rules (runs fine, teaches badly).** eml-vibrato-procedures.txt: 37× `+=` (Praat accepts it; the MP forbids it). eml-inferential.txt:1261, 1322: `elif` (accepted synonym; the other 154 branches use `elsif`). These files are pasted into model context as exemplars — the model sees its own SOT using tokens the prohibition list bans. → Mechanical rewrite.

**M16. Appendix D loose ends.** §9 (L630) still points to nonexistent `HANDOFF_A2_Batch_Analyzer.md §4` even though §10 exists to replace it; §5B says canonical CPPS differs from Praat dialog defaults "on three values" but the true count is five (time averaging 0.01 vs 0.02, quefrency averaging 0.001 vs 0.0005 additionally); `Get CPPS` interpolation capitalization inconsistent (§5B `"parabolic"` vs §10C `"Parabolic"`; COMMANDS uses lowercase). → Three one-line fixes.

**M17. Stale attribution version.** praatgen_references_complete.md:3, 18 cite "v13.5" — and MP:199 routes *script header attribution blocks* through this file, so generated scripts will self-cite v13.5. → Bump to current or make version-agnostic.

---

## TIER 3 — Minor / cosmetic

1. MP:23 "changlog" typo; no filename given (it's PRAATGEN_CHANGELOG.md).
2. MP:174 two retrieval rows jammed on one line (`…tabular data || COMMANDS_Strings.txt…`) — Strings trigger renders as junk.
3. MP:293–295 STEP 2 heading text duplicated as a stray paragraph.
4. MP:667/968/2891 "(Turn 2)"/"(Turn 2 only)" labels stale vs the Turn-2/3 split HARD GATE allows.
5. MP:58 vs 123: VERBOSE invocable "at any execution gate" vs "at any point."
6. MP:2933–2941 verbose FormantModeler sub-bullets mis-indented; Input-validation item jammed on.
7. Rules 8, 13, 16, 21 defined but never referenced anywhere (intentional? worth a pass).
8. PRAATGEN_CHANGELOG.md: two entries both numbered "13.6 — 22 April 2026"; no 13.9.0 or 13.9.2 entries (13.9.2 gap is self-acknowledged at L128); release bump 0.9.3-beta.02 unrecorded (last recorded: beta 1).
9. README:27/196 "3,000+ commands" vs MP:192 "2,089" vs changelog 12.2's audited 2,767 — pick one.
10. README:18 release "4 June 2026" vs :251 PKB snapshot "2026-06-05."
11. `pub/tmp` — 1-byte placeholder from GitHub dir creation; README says "upload the whole folder," so it lands in Project Knowledge. Delete.
12. Open `[NEEDS PASTE]` verification placeholders: COMMANDS_Formant.txt:141, COMMANDS_PowerCepstrogram.txt:84, COMMANDS_Table.txt:198/213/220, COMMANDS_Editor.txt:218.
13. COMMANDS_Formant.txt: "Draw tracks vs. Speckle" behavioral note duplicated near-verbatim (L229–269 and L393–445).
14. BEST_PRACTICES_CONFIDENCE_FIGURES.txt: doubled "END OF…" footer (L1291/1295); residual "Identified but not fixed (TODO-049/050)" at L315 reads as open.
15. HANDOFF_TEMPLATE.md / DEVELOPER_MODE_ADDON.md headers still say "EML Praat Assistant" (legacy branding). DEVELOPER_MODE_ADDON is also a designed orphan — its self-activation ("Claude detects this file's presence") isn't guaranteed under "load only what you need."
16. praatgen_references_complete.md:14 cites `praat/praat.github.io` (the website repo) as the Praat source repo; one "et al." in a reference list.
17. COMMANDS_DemoWindow.txt:860/984 (and COMMANDS_Electroglottogram.txt:328 — **EGG thread**) cite `BEST_PRACTICES_DEMO_WINDOW.txt`; actual extension is `.md`.
18. Em-dashes/ellipses inside string literals across eml files (harmless in UTF-8; several intentional). Only relevant if anything ever re-encodes — moot after C7 is fixed.

---

## Verified clean (checked, not assumed)

- **Canonical clinical values:** pitch floor/ceiling (filtered AC 50/800; raw 75/600), jitter/shimmer, Harmonicity, CPPS, formant ceilings (5500/5000/8000) — consistent across APPENDIX_D, COMMANDS_*, APPENDIX_F, catalogue, and (read-only) the EGG file. The earlier canonical-values fix held.
- **WHITELIST_CURRENT.txt:** empty as designed ("Status: CLEAN"); FormantPath/FormantModeler absorption into COMMANDS_Formant.txt v2.0 confirmed.
- **All 236 procedures:** block pairing (procedure/if/for/while/repeat) balances in all 14 files; zero duplicate names within or across files; all 792 live `@`-calls resolve; all Formula commands carry `~`; no C-escapes, `==`, `print(`, `return`, uppercase-initial variables; no truncated files. (Leading `...` continuation lines are valid modern syntax — not the legacy form.)
- **Changelog mirror:** 13.9.4 and 13.9.3 entries faithfully mirrored in PRAATGEN_CHANGELOG.md.
- **Canary:** present (MP:2996–3003), value referenced correctly by PRE-FLIGHT Item 5.
- **Appendix D §-numbering:** every §-ref from the MP (§0–§8 incl. §4D) resolves.
- **FormantPath routing decision:** present in COMMANDS_Formant.txt L12–55 as the MP claims.
- **README model framing:** matches the MP's 4.8/4.6/4.7 recommendation; LICENSE is GPL-3 as claimed.

---

## Suggested fix order for the benchmark freeze

1. **Routing integrity first** (C1, C2, M4, M9 — plus M10/M11 if time): these directly determine whether a scored session can find its SOT.
2. **Gate-logic contradictions** (C3, C4, C5, M1, M2): these determine whether gate-compliance scoring is even well-defined.
3. **Mechanical repairs** (C6, C7, C8, M3): one sitting.
4. **SOT hygiene** (M12, M13, M16): matters most if a benchmark task hits the catalogue fallback path.
5. **Publication cosmetics** (M14 license, M17, Tier 3): before reviewers, not before the frozen run.

EGG-thread flags to carry over: retrieval-table row for COMMANDS_Electroglottogram.txt (M4); `.txt`→`.md` demo-window reference at its line 328 (Tier 3 #17).

---
---

# ADDENDUM — EGG thread landed + encoding fix (29 July 2026)

**Purpose:** This addendum only *adds* what was learned after the c2350de audit. The body above is unchanged. Two files arrived from the parallel EGG thread — a rewritten `COMMANDS_Electroglottogram.txt` and a new `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md` — and the UTF-16 file was fixed at source. Item IDs below (E-prefix) are new; existing IDs are cross-referenced where status changes.

**Scope change:** EGG content is no longer frozen. The "no fixes proposed" restriction on the EGG layer is lifted for routing/integration. These two files are not yet in the audited commit — they integrate on the next push, and the registry/count regeneration (C2) must run against a HEAD that includes them.

## Status changes to existing items

- **C7 — RESOLVED at source.** `eml-batch-process.txt` was re-encoded to UTF-8 (no BOM) and re-verified; the maintainer holds the canonical copy. The `iconv` fix in the body is done. Standing caution: any editor round-trip can silently restore UTF-16/BOM — re-check with `file` after any future manual edit.
- **M4 — the Electroglottogram row is now actionable, and a fifth row joins it.** M4 listed four missing retrieval rows and flagged the Electroglottogram row "for the EGG thread." That flag is cleared: real trigger text now exists (E1), and the new best-practices file needs its own row (E2). DemoWindow, DEMO_WINDOW best-practices, and CONFIDENCE_FIGURES rows are unchanged from M4.
- **C1 — independently corroborated.** The EGG session, scanning the same retrieval table from a second angle, hit the identical defects: the ghost `EML_DRAWING_PROCEDURES.txt` row and the four rowless files. Two auditors, same holes.
- **Tier 3 #17 (EGG portion) — MOOT.** The stale `.txt`→`.md` demo-window reference at old `COMMANDS_Electroglottogram.txt:328` is gone: the rewritten file contains no demo-window reference at all. The non-EGG occurrence (COMMANDS_DemoWindow.txt:860/984) still stands.
- **Both "EGG-thread flags to carry over" (final line of the body) are now closed:** the retrieval row is E1; the line-328 reference is moot per above.

## New items — EGG integration (retrieval layer)

**E1. Add retrieval row for `COMMANDS_Electroglottogram.txt`.** The file has sat in Project Knowledge with no trigger row, so the protocol could never load it — which is why the EGG session had to find it by name. Add:

| File | Trigger |
|---|---|
| `COMMANDS_Electroglottogram.txt` | Script involves Electroglottogram objects, EGG signals, contact quotient, or a stereo audio+EGG recording. Load before any script that touches an EGG channel — two commands (`To TextGrid (closed glottis)`, `To AmplitudeTier (levels)`) segfault Praat with no catchable error when no cycle falls in [pitch floor, pitch ceiling]; the mandatory cycle guard is in this file. |

**E2. Add retrieval row for `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`** (new file, no row could have existed):

| File | Trigger |
|---|---|
| `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md` | Script computes contact quotient, open quotient, or dEGG landmarks; any decision among dEGG / hybrid / threshold methods; EGG signal-quality (SNR) assessment or de-noising. |

**E3. Add a mandatory EGG co-load step to the loading protocol.** Same clinical mandatory-load logic as APPENDIX_D: an EGG task should auto-pull *both* EGG files, not on a judgement call. EGG is voice analysis, so protocol step 3 already drags in APPENDIX_D — but neither EGG file is reachable without an explicit rule. Add as a sibling to loading-protocol steps 2–4: "If the task involves an EGG signal or contact quotient, ALWAYS load BOTH `COMMANDS_Electroglottogram.txt` AND `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`."

**E4. Amend loading-protocol step 10 — catalogue "not found" is not "does not exist." Not EGG-specific.** Step 10 sends an unfound command to `PRAAT_DEFINITIVE_CATALOGUE.txt` "before concluding it does not exist." For Electroglottogram the catalogue is empty — it carries only the class-hierarchy line `Electroglottogram -> Sound -> Vector -> Matrix` and exposes no commands — so the fallback would *confirm a false negative*. Step 10 needs a carve-out: the catalogue has known gaps; an empty or absent result there is not evidence of absence, and the object-specific COMMANDS file governs. This composes with **M12** (catalogue version drift) and **M13** (catalogue under-specifies query blocks) — the same "the catalogue is not exhaustive" admission, now confirmed by a whole empty object section. If M12 gets a staleness banner, this is the same banner stated at the fallback step.

## New item — registry layer

**E5. Decide the status of the two procedures defined inside the EGG best-practices file.** `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md` defines `emlEggCycleGuard` (§ segfault guard, also printed in the commands file) and `emlEggSpectralThreshold` (§4) as complete, runnable procedures — but they live in a `.md`, not in an `eml-*.txt` source file, and are indexed nowhere in the registry. Two coherent options: (a) promote them to registered library procedures — assign a source file, add registry rows, let the "copy exactly from source" rule (MP:223) apply; or (b) keep them as documentation snippets the model transcribes inline, and state that they are deliberately unregistered. Either is fine; the drift-generating state is the current one (real procedures, no registry entry). Fold into the C2 registry regeneration so the counts reflect whatever is decided.

## Provenance and headers

- **Version stamp is by design — not a reverification trigger.** Both EGG files carry a sandbox-verification stamp in their headers (Praat 6.6.30, 29 July 2026). That stamp *is* the audit trail: any claim verified against the sandbox records the build it was run against, so a later auditor can see exactly what was tested. It does not imply that content is reverified on each Praat release, and none is called for here. Any future sandbox-verified content should carry the same stamp for the same reason.
- License header on the new commands file reads GPL-3.0-or-later — compliant (contrast **M14** in the body, the license-incoherence item, where several eml headers say Creative Commons). The rewritten file also drops the legacy "EML Praat Assistant" branding flagged at **Tier 3 #15**; the batch file's header still carries it.

*End of addendum.*
