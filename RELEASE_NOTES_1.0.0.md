# EML PraatGen — Release Notes

**1.0.0** (first stable release; leaves the 0.9.x beta line)
**Release date:** 29 July 2026
**Master Prompt:** 14.1.0 (was 13.9.4)
**PKB snapshot:** 2026-07-29 (was 2026-06-22)
**Sandbox Praat:** 6.6.30 (was 6.4.67)
**License:** GPL-3.0-or-later — Ian Howell, Embodied Music Lab

A reference-library release. Where 0.9.3-beta.02 hardened the rules the compiler
follows, this build reconciles the reference files those rules read from —
against the EML plugin source they were copied from, and against Praat 6.6.30.
It folds in two Master Prompt increments (14.0.0 → 14.1.0) and supersedes
0.9.3-beta.02.1 (22 June 2026).

The throughline is the stale copy. A library file copied once and left behind as
its source grew; a registry maintained by hand beside the code it describes; a
catalogue extracted from one Praat version and read against another; a command
whose signature Praat changed underneath the documentation. None of these
announce themselves — the file still looks right, and the drift only surfaces
when something is run. This build closes the loop: reference content is now
verified by execution against a live Praat, and the version stamps that make
drift visible are in place.

---

## Highlights

**The EML library is reconciled against plugin source.** Seven library files
were incomplete; all are refreshed to plugin-verbatim content. `eml-output`
gains 21 procedures including the `@emlWizardExplain*` plain-language helpers;
`eml-vibrato` gains its five drawing procedures including the 8-panel
`@emlVibratoDrawFigure`; `eml-inferential` gains `@emlLinearRegression` and
`@emlTheilSen`; `eml-core-descriptive` gains `@emlShapiroWilk`.

**The procedure registry is generated from source.** 264 procedures across 15
files, verified equal in both directions — no registry row without source, no
source procedure unlisted. Each library file carries its plugin source's version
verbatim, so a version mismatch is a drift signal.

**Twelve command signatures corrected against Praat 6.6.30**, including two that
Praat itself changed since 6.4.x: `Formant Formula` takes a leading time-range
pair (5 parameters, not 3), and `Table Bar plot` takes 10 parameters with
`Vertical column` and `Colours` as string arrays.

**Generated scripts are self-contained.** Library procedure bodies are copied
into the delivered script, or into a folder shipped alongside it, transitively.
Generated code never `include`s the plugin; a delivered script runs on a bare
Praat installation.

**File output is ASCII-constrained.** `--utf8` does not guarantee UTF-8: one
non-ASCII character in a written string makes Praat write the whole file as
UTF-16 BE. Written literals must be ASCII, and both SELF-AUDIT templates now
check it.

**Phase 3B is model-conditional.** Extended thinking as a user-facing toggle was
retired in Opus 4.8. The complexity score is unchanged; on toggle models
(4.6/4.7) it recommends thinking on/off and waits on a recommended change, on
effort models (4.8+) it is advisory and does not gate the turn.

---

## Reference corrections (14.1.0)

**`APPENDIX_D` §5B — CPPS.** The Maryn set differs from Praat's dialog defaults
on six fields, not three. The two previously unlisted are the enum fields: trend
type (*Exponential decay* vs Straight) and fit method (*Robust slow* vs Robust).
Now a field-by-field table; the Praat-default call is recorded in
`COMMANDS_PowerCepstrogram.txt` for contrast.

**`COMMANDS_PowerCepstrogram.txt` — query scope.** `Get peak`, `Get quefrency of
peak` and `Get peak prominence` run on a PowerCepstrum; extract a slice via `To
PowerCepstrum (slice):` first. `Get CPPS` is a Cepstrogram command — the
asymmetry is now stated.

**`COMMANDS_TextGrid.txt` — co-selection.** The `Draw`/`Speckle` block requires a
Pitch object co-selected; the `Extract` commands require a Sound. Bare-TextGrid
`Draw:` is a different, 5-parameter command. `Scale times` takes two arguments.

**`COMMANDS_Sound.txt` — `Multiply`** takes one argument (multiplication
factor); a duplicate corrupted entry removed.

**`COMMANDS_Formant.txt` / `COMMANDS_Table.txt`** — the two version-drift
signatures above.

**`COMMANDS_Pitch.txt` / `COMMANDS_PitchTier.txt`** — REALVECTOR arguments take
`{0, 0.5, 1}` or `"0 0.5 1"`, not bare `0 0.5 1`.

**`APPENDIX_C_GUI.txt` — form/beginPause quoting.** The asymmetry is
one-directional: bare numeric defaults are a parse error in `form:`, but
`beginPause:` accepts both forms. Rule 19 and the SELF-AUDIT item corrected
accordingly.

**`PRAAT_DEFINITIVE_CATALOGUE.txt` — staleness banner.** The extraction drops
paired range fields (`left Xxx` / `right Xxx`), so affected commands list fewer
parameters than they take; 22 confirmed cases listed. The 22 object types with a
curated `COMMANDS_*.txt` are unaffected. Verify the arity of a catalogue-sourced
range command before use. §3 function count corrected (369 → 365).

---

## Routing and retrieval (14.0.0)

**C1 — ghost drawing route.** The retrieval table's only drawing row pointed at
`EML_DRAWING_PROCEDURES.txt`, which does not exist, while
`BEST_PRACTICES_DRAWING.txt` had no row at all. Row replaced; the stale name
swept from six PKB files.

**M4 / E1 / E2 — five retrieval rows added:** `COMMANDS_DemoWindow.txt`,
`BEST_PRACTICES_DEMO_WINDOW.md`, `BEST_PRACTICES_CONFIDENCE_FIGURES.txt`,
`COMMANDS_Electroglottogram.txt`, `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`.

**M9 — registry signature drift.** `emlReportKWComparison` was missing
`.tableId` in fourth position; verified as the only such drift in the library.

**E3 — mandatory EGG co-load.** An EGG task auto-pulls both EGG files, as a
sibling to the APPENDIX_D clinical rule.

**E4 — catalogue fallback carve-out.** Retrieval step 10 now states the
catalogue's known gaps; the object-specific COMMANDS file governs.

**Step 12 — self-containment (new).** Generated code must never `include` the
plugin. Two accepted delivery shapes; copying is transitive. Enforced in both
SELF-AUDIT templates and the AUTO domain table.

---

## Gates, modes and audit discipline (14.0.0)

**C3 — Rule 28 A–K → A–L** in the AUTO pre-delivery domain table, which keyed on
the pre-13.9.4 list and is the only compliance check when gates are suppressed.

**M5 — AUTO domain table** gained a file-output/GUI/UX row (Rules 26/27,
18/19/20, 33/App F had no check in AUTO) and an EGG row.

**M3 — SELF-AUDIT templates.** File-output safety (26/27) had no line item, so
the 13.9.4 evidence rule could never fire on it. Added to both templates, with
Rule 4B and Rule 37; verbose template de-duplicated.

**M1 — STEP 2D, DEBUGGING mode.** STEP 1 advertised the mode; no section defined
it. Added with the five behaviours the STEP 1 text promises.

**C5 — mode composition.** STEP 1 offered "AUTO … Combines with SANDBOX and
DEBUGGING" against a mutual-exclusion rule. Corrected.

**M2 — VERBOSE.** GO is the proceed keyword at every gate and was silently
reverting VERBOSE to SPARSE. SPARSE is now the sole return keyword.

**C4 — HARD GATE / Phase 3B.** Both were marked hard and gave opposite
instructions on the GO-wait. Resolved by the model-conditional gate above.

---

## Sandbox (14.0.0–14.1.0)

**C6 — PulseAudio startup** was commented out in both the STEP 2B install step
and the Rule 24C test template. Uncommented; without it `asynchronous Play`
hangs.

**Rule 24C — screenshot capture.** Black frames under Xvfb are a capture defect,
not a render failure: X11 has no compositing, so an occluded window region reads
as empty framebuffer. `xcompmgr` fixes it; `Xvfb +bs` does not. A 100%-black
frame means nothing was mapped. Behaviour matrix, fix and validation check
documented; `openbox`, `xcompmgr`, `xdotool` and `imagemagick` added to the
install.

**Rule 24C — file encoding.** Written string literals must be ASCII; `--utf8`
does not prevent UTF-16 output when one is not.

---

## Model guidance (14.0.0–14.1.0)

**Opus 5 preferred; Opus 4.8 performs well.** Opus 4.6 with Extended Thinking
remains the original development baseline and the token-conscious choice; Opus
4.7 is more agentic and superseded. **Sonnet and Haiku are not supported.**

**Reasoning effort.** "High" is the default — the balanced middle of an
escalating scale, not its top. Guidance is provisional: no apparent advantage
above default, some risk of context exhaustion if you go there, some evidence a
lower setting serves once the COMMAND PLAN exists. Experiment.

---

## PKB updates

Every file changed. Replacing the whole `pkb/` folder is the only supported
upgrade path.

**Refreshed from plugin source (14 files).** `eml-annotation-procedures`,
`eml-batch-process`, `eml-core-descriptive`, `eml-core-utilities`,
`eml-draw-procedures`, `eml-extract`, `eml-graph-procedures`, `eml-graphs`,
`eml-graphs-form`, `eml-inferential`, `eml-output`, `eml-test-helpers`,
`eml-vibrato-procedures`, `eml-analysis`. Content verbatim; only the License
line is normalized, and each carries a provenance block.

**`eml-analysis.txt` — new.** 21 `@emlRun*Analysis` dispatchers: regression,
normality, RM-ANOVA, Friedman, reliability, and the two-group / k-group /
paired / correlation orchestrators.

**`eml-egg-procedures.txt` — new.** `@emlEggCycleGuard` (mandatory before `To
TextGrid (closed glottis)` and `To AmplitudeTier (levels)`, which segfault when
no cycle falls in range) and `@emlEggSpectralThreshold`.

**`eml-demo-procedures.txt` — removed.** `COMMANDS_DemoWindow.txt` and
`BEST_PRACTICES_DEMO_WINDOW.md` are the source of truth for the Demo window;
neither depends on it.

**`EML_PROCEDURE_REGISTRY.md`** — regenerated from source; 264 procedures across
15 files.

**All 23 previously unaudited `COMMANDS_*` files** carry an arity-check record
naming the Praat build and what the check does and does not establish.

**License headers** — nine `eml-*` files declared Creative Commons, one of them
CC Non-Commercial. All normalized to GPL-3.0-or-later.

**Style note.** PKB copies are byte-faithful to plugin source so "copy exactly
from source" is satisfiable; the `+=` and `elif` instances that remain are
therefore expected, and the Master Prompt names them as a known SOT exception.

---

## Version summary

| Component | This release | Previous |
|---|---|---|
| Release | **1.0.0** | 0.9.3-beta.02.1 |
| Master Prompt | **14.1.0** | 13.9.4 |
| PKB snapshot | **2026-07-29** | 2026-06-22 |
| Sandbox Praat | **6.6.30** | 6.4.67 |
| Rules | 37 | 37 |
| EML procedures | **264** across 15 files | 251 indexed |

---

## Upgrade notes

Replace your project's instructions with `MASTER_PROMPT_CORE_v14_1_0.md`. The
filename changed; delete `MASTER_PROMPT_CORE_v13_9_4.md`.

Replace the entire `pkb/` folder. Every file changed and two are gone
(`eml-demo-procedures.txt`, and the duplicate `eml-annotation-procedures.praat` /
`.praat.txt` pair, now consolidated to `.txt`). Delete the old folder rather than
overwriting into it.

Do not rename files; the Master Prompt references them by exact filename.

Scripts using `Table Bar plot` or `Formant Formula` need updating — both
signatures changed in Praat 6.6.30.

Sandbox Mode additionally installs `openbox`, `xcompmgr`, `xdotool` and
`imagemagick`. It still requires `www.fon.hum.uva.nl` in Settings → Capabilities
→ Allowed domains, set *before* the conversation starts.

---

## Reporting issues

Report to Ian Howell at the Embodied Music Lab
([www.embodiedmusiclab.com](https://www.embodiedmusiclab.com)). Quote both the
Release and Master Prompt versions; they track independently.

- **Script errors:** the task description, the generated script, and the exact
  Praat error message with line number.
- **Reference gaps:** the object type and command name.
- **Arity errors:** Praat's "requires only N arguments" message is ground truth —
  include it verbatim.
