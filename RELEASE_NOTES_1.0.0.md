# EML PraatGen — Release Notes

**1.0.0** (first stable release; leaves the 0.9.x beta line)
**Release date:** 30 July 2026
**Master Prompt:** 14.8.1 (was 13.9.4)
**PKB snapshot:** 2026-07-29 (was 2026-06-22)
**Sandbox Praat:** 6.6.30 (was 6.4.67)
**License:** GPL-3.0-or-later — Ian Howell, Embodied Music Lab

The first stable release. The EML procedure library is updated and expanded to
match the current plugin — the analysis orchestrators, regression, normality and
the vibrato drawing family; the command reference is verified against Praat
6.6.30; and Phase 3B adapts to the model in use. It folds in two Master Prompt
increments (14.0.0 → 14.8.1) and supersedes 0.9.3-beta.02.1 (22 June 2026).

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
TextGrid (closed glottis)` and `To AmplitudeTier (levels)` — both segfault Praat
when no cycle falls within the pitch range.

**The procedure registry is updated.** 263 procedures across 15 files,
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

## Generated scripts vectorize by default (14.8.0–14.8.1)

A per-element loop is now a last resort rather than a style preference, backed by
sandbox measurements: scaling 88,200 Sound samples is **146x** faster with
`Formula:` than a Get/Set loop, reading 19,961 Pitch frames is **415x** faster with
`List values in all frames`, and Table column work is 5–10x. The spread is stated
too — sample- and frame-level loops are catastrophic, Table row loops merely
wasteful.

Scaled up, that first figure is 2 seconds of audio: a 60-second recording costs
~11 s per pass and a 100-file batch ~18 minutes, for work `Formula:` finishes in
0.15 s. That is usually misdiagnosed as Praat being slow.

The prompt now carries a task-to-command table for the vectorized forms, names the
loops that are legitimately loops (files, TextGrid intervals, early exit, sequential
algorithms), and requires SELF-AUDIT to justify any loop whose body is arithmetic on
samples, frames or cells.

---

## Quieter output (14.7.2)

Two house rules. **PraatGen does not narrate its own state** — you should never be
told that a capability is withdrawn, parked, untested or absent from this build.
If something is unavailable the consequence is stated in your terms ("this
recording is too noisy to measure reliably") and nothing else. Maintainer notes in
the reference files exist so the tool does not repeat a mistake; they are not
content for a reply.

**PraatGen does not volunteer optional measures.** It computes what the task needs.
An extra descriptor appears only if you asked for it or the task turns on the
question it answers — QDelta on a routine contact-quotient job, for instance, is
noise, and invites reading a noise-sensitive number as a quality check.

---

## VERIFY YOUR STATE covers reloads too (14.7.0–14.7.1)

The command was scoped to compaction. It now covers any event that may have cost
context or continuity — a summary, an error telling you to reload or retry, a
response that failed partway and regenerated, or simply coming back after a gap
unsure what landed. A reload loses as much as a compaction and announces itself
even less.

In Sandbox Mode the check also compares the container's boot ID, because a reload
*may* coincide with a container recycle — often it does not. If the ID changed,
every process is gone and PraatGen rebuilds rather than reattaching. If it is
unchanged, that means the same container, not that the processes survived, so it
confirms by execution before relying on them. The setup block is safe to re-run
either way.

The section is renamed **STATE PERSISTENCE AND RECOVERY**; the old title was
narrower than the rule.

---

## Praat values are not MDVP values (14.6.1)

§3D now carries the cross-program comparison, with the Praat manual's URL so it can
be handed to the user directly. Boersma's case: a constant-period signal plus 1%
additive white noise — **Praat reads 0.02% jitter, MDVP reads 0.6%**, true jitter
zero. Praat locates period boundaries by waveform matching, which averages noise
out; MDVP peak-picks, which follows it. On clean signals both recover 1%, so this is
a noise effect that grows with recording quality problems.

MDVP's pathology thresholds are listed with the manual's own caveat that they came
from noise-influenced measurements and "the correct threshold is probably lower."
The direction is what matters clinically: **applying an MDVP cutoff to a Praat value
under-calls pathology.** Plausible number, in range, wrong for the comparison being
made.

---

## Jitter and shimmer variant selection (14.6.0)

**`APPENDIX_D_CLINICAL_DEFAULTS.txt` §3D — new.** All eleven jitter and shimmer
variants are documented with verified arity; previously only `local` and
`local_dB` appeared anywhere in the PKB. They are not interchangeable, and the
difference can invert a clinical reading.

`local` is a first difference, so it absorbs smooth F0 or amplitude modulation in
proportion to extent x rate — on a sustained tone with vibrato it measures the
vibrato, not phonatory stability. `rap` and `ppq5` reject it: across every
modulation condition tested, `rap` held 0.117–0.128% while `local` varied by 2.9x.

**The local/rap ratio is now emitted by default** with both measures and the cycle
count. It is self-interpreting — ~1.73 clean, >2.2 smooth modulation present,
approaching 1.5 period-alternating structure — and costs one extra query. §3D adds
a task-appropriateness matrix (connected speech is invalid for perturbation
entirely) and a runtime guard needing no extra analysis object. Clarification is
one question, the phonation task, not a variant menu. §7's plausibility band is
annotated as unable to catch a wrong-variant reading: it passed a 0.4431% `local`
that was roughly 60% vibrato.

---

## Master Prompt slimmed (14.5.1)

The prompt carried its own full changelog — nine versions, ~2,950 words, 9.6% of the
file — duplicating `PRAATGEN_CHANGELOG.md`, which already held all of it plus
history back to 12.1. That was being paid on every conversation, in the one file
that is always loaded. The prompt now carries a pointer and a one-line current-version
note. **29,627 → 26,785 words.** No history lost; the changelog file is where it
lives.

---

## Sandbox: container recycle and the display probe (14.5.0)

**Processes die between calls; the filesystem doesn't.** A container recycle can
happen between tool calls — observed coinciding with compaction — killing Xvfb, the
window manager, the compositor and any running Praat while leaving the installed
binary and every file on disk. The environment looks healthy and fails as
`Can't open display: (null)`. Rule 24C now states the fix as a design rule: each GUI
interaction is one self-contained call that raises the stack, drives Praat, captures
to disk and exits, with files as the handoff medium between calls rather than
processes. Recycle detection via `boot_id` is documented as diagnostic.

**The display readiness probe is corrected.** `xdotool getdisplaygeometry` is the
probe. `xdpyinfo` is not installed in the sandbox image, and
`xdotool search --name "."` returns rc=1 on a live display that has no windows yet —
both fail silently as "never ready". The setup snippet now polls rather than
sleeping, and clearing the stale X lock is unconditional in every setup path.

---

## Compaction survival, and two new commands (14.4.2)

**`VERIFY YOUR STATE`.** Say it after a compaction and PraatGen re-reads what is
actually saved in the output folder — current script, notes, open items — and
reports where that disagrees with its own recollection, before touching anything.
**The command is yours to give:** PraatGen does not self-invoke it, because it
cannot reliably tell from the inside that a summary has happened. The file wins —
it reconciles by reading, and never regenerates delivered work from a recollection
of what it should contain.

**A new hard `STATE PERSISTENCE AND RECOVERY` section** requires the current
script, test results and open items to be written to the output folder and kept
current there, as you go — not held in the conversation to be restated later. This
is unconditional: chat, SANDBOX and Cowork all have an output folder, and it
survives both a compaction and a reload. Delivering the `.praat` file is still
required, but delivery is for you; the folder is what PraatGen reads back. (The
section was introduced as `CONTEXT COMPACTION` and renamed at 14.7.0, when the
recovery triggers broadened beyond compaction.)

**`NOINTRO`.** Put it in your first message to skip the opening menu. Straight to
PRE-FLIGHT if you supplied the four items, otherwise PraatGen asks only for what is
missing. It suppresses the greeting and nothing else, and composes with the other
keywords — `SANDBOX NOINTRO`, `AUTO SANDBOX NOINTRO`.

---

## EGG method selection (14.3.1)

**Method selection is a PRE-FLIGHT discussion, not a dialog field.** §5 read as a
behaviour table, which invited both a runtime branch on an SNR threshold and a
`form:` optionmenu offering dEGG / hybrid / threshold as equivalent choices.
Neither is the default. PraatGen now raises it in prose and agrees an approach:
above roughly 20 dB dEGG will most likely be the most accurate measure; as SNR
approaches 10 dB the **opening** landmark specifically decays, because the
derivative's de-contacting trough is broad and shallow next to its contacting
peak, so the GOI degrades well before the GCI; and where that leaves the answer
ambiguous, take both measures on the same cycles and compare means and standard
deviations. The SNR figures are numbers to reason from — 10 dB is Herbst's,
20 dB is lab judgement. §5 also states why the hybrid is the right comparator
rather than an unrelated second opinion: it keeps dEGG's contacting instant
exactly and replaces only the opening, so the two share closure and period. An
optionmenu is correct when you have asked for the choice to be exposed in a
reusable tool.

---

## EGG de-noising parked (14.3.0)

**Spectral thresholding is withdrawn from distribution.**
`@emlEggSpectralThreshold` and §4 of `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md` are
removed: never tested on real material. Every figure behind them came from
synthetic additive white Gaussian noise, which is the easy case and not what EGG
noise is — hum, wandering side tones, electrode drift and movement artefact were
never in the test set. §4 is now a parked notice with a do-not-reconstruct
instruction. Consequence: there is no de-noising path, so §5 refuses sub-10 dB
EGG signals outright rather than offering a rescue. `@emlEggCycleGuard` is
unaffected and remains mandatory. Two Praat traps are kept, being independent of
de-noising: `To Spectrum: "yes"` zero-padding inflates `To Sound` length, and
Ltas dB and raw Spectrum magnitude dB differ by ~91 dB.

---

## Script delivery (14.2.0)

**Generated scripts are delivered as `.praat` files, not code blocks (hard).**
Phase 3C previously specified no format, so on a chat surface it resolved to a
code block. The reason this is a hard rule rather than a preference: copy-paste
out of a rendered code block substitutes curly quotes, en-dashes and
non-breaking spaces into source, which Praat rejects or — per Rule 24C —
converts to UTF-16 BE on output. Delivery shape (b), script plus sibling
`*_lib/` folder, has no code-block form and is now stated as file-only. Code
blocks stay correct for excerpts, single-line debugging fixes, and anything you
ask to see inline. SELF-AUDIT remains inline.

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

**`BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`.** §5 method selection: the
`T1 ≈ 40 dB` upper SNR gate on dEGG is withdrawn. dEGG is the default. Between
10 and 20 dB, dEGG and hybrid-at-0.43 are **both** reported, side by side with
cycle-to-cycle SD and cycle count, rather than one being substituted silently;
§5 explains how to read that comparison and why the two SDs are not directly
comparable. §6 gains a validated single-pass implementation of the dual report.
§3: `Derivative` is the default differentiator with `First central difference`
offered where a protocol calls for it, and the 5000 Hz cutoff is flagged as a
chosen rather than validated value. Detection yield and the plausibility bound
remain the gates.

**`APPENDIX_C_GUI.txt`.** The form/beginPause default-quoting asymmetry is
one-directional: bare numeric defaults are a parse error in `form:`, while
`beginPause:` accepts either. Rule 19 and the SELF-AUDIT line now say so.

**Rule 27 snippet.** The `@emlGenerateUniquePath` pattern read the return value
as `.path$`, which is the procedure's input parameter — the guard would return
the candidate path unchanged. Corrected to `.result$` per the source.
`EML_PROCEDURE_REGISTRY.md` now states that its `Parameters` column lists inputs
only and that return variables must be read from the procedure body. Nineteen
registry rows for zero-argument procedures had a line of body text in the
`Parameters` cell; those now read `(none)`.

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

**`EML_PROCEDURE_REGISTRY.md`** — updated; 263 procedures across 15
files.

**License headers** normalised to GPL-3.0-or-later across the `eml-*` sources.

---

## Version summary

| Component | This release | Previous |
|---|---|---|
| Release | **1.0.0** | 0.9.3-beta.02.1 |
| Master Prompt | **14.8.1** | 13.9.4 |
| PKB snapshot | **2026-07-29** | 2026-06-22 |
| Sandbox Praat | **6.6.30** | 6.4.67 |
| Rules | 37 | 37 |
| EML procedures | **263** across 15 files | 251 |

---

## Upgrade notes

Replace your project's instructions with `MASTER_PROMPT_CORE_v14_8_1.md`. The
filename changed; delete `MASTER_PROMPT_CORE_v13_9_4.md`.

Replace the entire `pkb/` folder. 57 of 61 files changed, `eml-demo-procedures`
is gone, and the `eml-annotation-procedures.praat` / `.praat.txt` pair is now a
single `.txt`. Delete the old folder rather than overwriting into it.

Do not rename files; the Master Prompt references them by exact filename.

Sandbox Mode additionally installs `openbox`, `xcompmgr`, `xdotool` and
`imagemagick`. It still requires `www.fon.hum.uva.nl` in Settings → Capabilities
→ Allowed domains, set *before* the conversation starts.

---

## Known open items

`PARITY_PASS_BACKLOG.md` at the repo root carries the items identified but not
resolved in this release: the catalogue-vs-COMMANDS parity pass and its measured
extraction defect classes, a `Returns` column for the procedure registry, the
EGG parameters that are lab judgement rather than published findings, and the
deliberate `eml-lmm` / `eml-wizard` exclusions.

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
