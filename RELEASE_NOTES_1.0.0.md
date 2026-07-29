# EML PraatGen — Release Notes

**1.0.0** (first stable release; leaves the 0.9.x beta line)
**Release date:** 29 July 2026
**Master Prompt:** 14.1.0 (was 13.9.4)
**PKB snapshot:** 2026-07-29 (was 2026-06-22)
**Sandbox Praat:** 6.6.30 (was 6.4.67)
**License:** GPL-3.0-or-later — Ian Howell, Embodied Music Lab

The first stable release. The EML procedure library is updated and expanded to
match the current plugin — the analysis orchestrators, regression, normality and
the vibrato drawing family; the command reference is verified against Praat
6.6.30; and Phase 3B adapts to the model in use. It folds in two Master Prompt
increments (14.0.0 → 14.1.0) and supersedes 0.9.3-beta.02.1 (22 June 2026).

---

## Highlights

**The EML procedure library is updated and expanded.** Fourteen source files
brought to their current plugin versions. `eml-output` gains the
`@emlWizardExplain*` plain-language helpers and the dialog wrappers;
`eml-vibrato` gains its drawing family including the 8-panel
`@emlVibratoDrawFigure`; `eml-inferential` gains `@emlLinearRegression` and
`@emlTheilSen`; `eml-core-descriptive` gains `@emlShapiroWilk`; `eml-extract`
gains column-role inference; `eml-annotation-procedures` gains its two report
procedures.

**`eml-analysis.txt` — new.** 21 `@emlRun*Analysis` orchestrators covering
regression, normality, RM-ANOVA, Friedman, reliability, and the two-group,
k-group, paired and correlation workflows. This is the layer the plugin's menu
commands call.

**`eml-egg-procedures.txt` — new.** `@emlEggCycleGuard`, mandatory before `To
TextGrid (closed glottis)` and `To AmplitudeTier (levels)` — both segfault
Praat when no cycle falls within the pitch range — and
`@emlEggSpectralThreshold` for low-SNR EGG rescue.

**The procedure registry is updated.** 264 procedures across 15 files,
checked in both directions against the shipped sources. Each library file now
carries its plugin source's version verbatim, so the two can be compared at a
glance.

**Command reference verified against Praat 6.6.30.** Two entries that the
catalogue extraction had under-specified are now complete: `Formant: Formula`
takes a leading time-range pair (5 parameters), and `Table: Bar plot` takes 10
with `vertical columns` and `colours` as string arrays. Both were executed
against 6.4.62 and 6.6.30 and are identical in each — the gap was in the
extraction, not in Praat. String-array fields join paired ranges as a known
catalogue blind spot.

**Self-containment is now an explicit rule.** Generated scripts have always been
standalone; Step 12 states the requirement and both SELF-AUDIT templates check
it. Library procedure bodies are copied into the delivered script, or into a
folder shipped alongside it, transitively, and generated code never `include`s
the plugin.

**Phase 3B is model-conditional.** Extended thinking as a user-facing toggle was
retired in Opus 4.8. The complexity score is unchanged; on toggle models
(4.6/4.7) it recommends thinking on/off and waits on a recommended change, and on
effort models (4.8+) it is advisory and does not gate the turn.

---

## Reference updates (14.1.0)

**`PRAAT_DEFINITIVE_CATALOGUE.txt` — multiple updates.** A header banner states
the catalogue's pin (Praat 6.4.62) and its known gaps; where it and an
object-specific COMMANDS file disagree, the COMMANDS file
governs. Range-taking commands are under-specified by the extraction, so verify
arity before emitting one from the catalogue. Electroglottogram carries a
class-hierarchy line and no commands. §3 function count reconciled with the
file's own header.

**`APPENDIX_D_CLINICAL_DEFAULTS.txt`.** §5B now carries a field-by-field
comparison of the Maryn CPPS parameters against Praat's dialog defaults, with
the sandbox stamp; the values themselves are unchanged. §9's pointer moved to
§10, which supersedes it. `"Parabolic"` normalised to `"parabolic"` to match
`COMMANDS_PowerCepstrogram.txt`.

**`COMMANDS_PowerCepstrogram.txt`.** The peak queries run on a PowerCepstrum;
extract a slice via `To PowerCepstrum (slice):` first. `Get CPPS` is a
Cepstrogram command. Praat's dialog defaults recorded alongside the Maryn set.

**`COMMANDS_TextGrid.txt`.** The `Draw`/`Speckle` block requires a Pitch object
co-selected and the `Extract` commands require a Sound — both now stated.
Bare-TextGrid `Draw:` is a separate 5-parameter command.

**`APPENDIX_C_GUI.txt`.** The form/beginPause default-quoting asymmetry is
one-directional: bare numeric defaults are a parse error in `form:`, while
`beginPause:` accepts either. Rule 19 and the SELF-AUDIT line now say so.

**Vector arguments.** `COMMANDS_Pitch.txt` and `COMMANDS_PitchTier.txt` examples
now use `{0, 0.5, 1}` for REALVECTOR arguments.

**All 23 remaining `COMMANDS_*` files** carry a verification record naming the
Praat build.

---

## Routing and retrieval (14.0.0)

**Drawing route.** The retrieval table now routes drawing to
`BEST_PRACTICES_DRAWING.txt` and the procedure registry.

**Five retrieval rows added:** `COMMANDS_DemoWindow.txt`,
`BEST_PRACTICES_DEMO_WINDOW.md`, `BEST_PRACTICES_CONFIDENCE_FIGURES.txt`,
`COMMANDS_Electroglottogram.txt`, `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`.

**Mandatory EGG co-load.** An EGG task auto-pulls both EGG files, as a sibling to
the APPENDIX_D clinical rule.

**Catalogue fallback.** Retrieval step 10 states the catalogue's known gaps; the
object-specific COMMANDS file governs.

**Step 12 — self-containment (new).** Generated code must never `include` the
plugin. Two accepted delivery shapes; copying is transitive. Enforced in both
SELF-AUDIT templates and the AUTO domain table.

---

## Gates, modes and audit discipline (14.0.0)

**Rule 28 A–L** in the AUTO pre-delivery domain table, matching the 13.9.4
sub-rule set. AUTO also gains a file-output/GUI/UX row (Rules 26/27, 18/19/20,
33/App F) and an EGG row.

**SELF-AUDIT templates.** File-output safety (26/27) added to both, with Rule 4B
and Rule 37; the file-output line also confirms written literals are ASCII.

**STEP 2D — DEBUGGING mode.** The mode now has a defining section: approval
required for every change, no elective refactoring, binding scope declaration,
two-hypothesis circuit breaker, no speculative multi-fix bundles.

**Mode composition.** AUTO combines with SANDBOX; AUTO and DEBUGGING remain
mutually exclusive, and the STEP 1 menu says so.

**VERBOSE** persists across gates — SPARSE is the return keyword.

**HARD GATE and Phase 3B** are reconciled by the model-conditional gate above.

---

## Sandbox (14.0.0–14.1.0)

**PulseAudio startup** restored in the STEP 2B install and the Rule 24C test
template; without it `asynchronous Play` hangs.

**Rule 24C — screenshot capture.** Black frames under Xvfb are a capture artefact
of X11's lack of compositing, not a render failure. `xcompmgr` resolves it;
`Xvfb +bs` does not. `openbox`, `xcompmgr`, `xdotool` and `imagemagick` added to
the install.

**Rule 24C — file encoding.** Written string literals must be ASCII; a single
non-ASCII character makes Praat write the whole file as UTF-16 BE regardless of
`--utf8`.

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

57 of 61 files changed. Replacing the whole `pkb/` folder is the only supported
upgrade path.

**Updated and expanded from plugin source (14 files).** `eml-annotation-procedures`,
`eml-batch-process`, `eml-core-descriptive`, `eml-core-utilities`,
`eml-draw-procedures`, `eml-extract`, `eml-graph-procedures`, `eml-graphs`,
`eml-graphs-form`, `eml-inferential`, `eml-output`, `eml-test-helpers`,
`eml-vibrato-procedures`, `eml-analysis`. Content verbatim from plugin source;
only the License line is normalised, and each carries a provenance block.

**Renamed.** `eml-annotation-procedures` shipped as both
`.praat` and `.praat.txt`; it is now a single `eml-annotation-procedures.txt`,
matching every other library file.

**New:** `eml-analysis.txt`, `eml-egg-procedures.txt`.

**Removed:** `eml-demo-procedures.txt`. `COMMANDS_DemoWindow.txt` and
`BEST_PRACTICES_DEMO_WINDOW.md` are the source of truth for the Demo window.

**`EML_PROCEDURE_REGISTRY.md`** — updated; 264 procedures across 15
files.

**License headers** normalised to GPL-3.0-or-later across the `eml-*` sources.

---

## Version summary

| Component | This release | Previous |
|---|---|---|
| Release | **1.0.0** | 0.9.3-beta.02.1 |
| Master Prompt | **14.1.0** | 13.9.4 |
| PKB snapshot | **2026-07-29** | 2026-06-22 |
| Sandbox Praat | **6.6.30** | 6.4.67 |
| Rules | 37 | 37 |
| EML procedures | **264** across 15 files | 251 |

---

## Upgrade notes

Replace your project's instructions with `MASTER_PROMPT_CORE_v14_1_0.md`. The
filename changed; delete `MASTER_PROMPT_CORE_v13_9_4.md`.

Replace the entire `pkb/` folder. 57 of 61 files changed, `eml-demo-procedures`
is gone, and the `eml-annotation-procedures.praat` / `.praat.txt` pair is now a
single `.txt`. Delete the old folder rather than overwriting into it.

Do not rename files; the Master Prompt references them by exact filename.

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
