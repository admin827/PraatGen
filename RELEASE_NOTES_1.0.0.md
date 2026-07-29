# EML PraatGen — Release Notes

**1.0.0** (first stable release; leaves the 0.9.x beta line)
**Release date:** 29 July 2026
**Master Prompt:** 14.1.0 (was 13.9.4)
**PKB snapshot:** 2026-07-29 (was 2026-06-22)
**Sandbox Praat:** 6.6.30 (was 6.4.67)
**License:** GPL-3.0-or-later — Ian Howell, Embodied Music Lab

A verification release. Where 0.9.3-beta.02 hardened the *rules*, this build
verifies the *reference library those rules depend on* — against the EML plugin
source it was copied from, and against a running Praat install. It supersedes
0.9.3-beta.02.1 (22 June 2026).

The throughline is **a claim nobody checked**. Every defect below shares a
shape: a file asserted something, the assertion was plausible, and no one had
ever executed it. A registry indexed 37 procedures that "existed." A catalogue
documented parameter lists that "came from source." An appendix stated CPPS
differed from Praat's defaults "on three values." A rule said `beginPause:`
numeric defaults "must be bare." A prompt instruction said `--utf8` prevents
UTF-16 output. Each was written in good faith, survived multiple review cycles,
and is wrong — and every one of them was found the same way: by installing
Praat and running it.

That is what earns the 1.0.0. Not new capability; the end of taking the
library's word for itself.

---

## Highlights

**The PKB was shipping truncated copies of the EML library.** Reconciling the
PKB against `plugin_EML_Praat_Tools` source showed seven library files were
short — `eml-output` shipped 21 of 42 procedures, `eml-vibrato` 11 of 16,
`eml-inferential` 25 of 27. This inverts a finding the audit had reached
confidently: the "37 ghost procedures" the registry indexed were not ghosts.
They were real procedures whose source had never been copied over. The 16
`@emlWizardExplain*` helpers were the clearest case — they live in
`eml-output.praat`, a *core* file, and had been read as wizard debris. All
files refreshed to plugin-verbatim content; **registry rebuilt programmatically
from source rather than maintained alongside it**, at 264 procedures across 15
files, verified equal in both directions.

**PKB files now carry the plugin's version verbatim.** A PKB file's version and
its plugin source's version must match; a mismatch means the PKB has drifted.
This is the check that would have caught the truncation years earlier, and its
absence is why the drift went unseen. PKB-only edits (the license header
normalization) are recorded in a provenance block rather than by bumping the
number.

**The catalogue has a systematic arity defect — measured, not suspected.**
542 catalogue command signatures were probed against live Praat 6.6.30: 22
mismatches (4.1%), and they are not random. The extractor drops Praat's paired
range fields — the `left Xxx` / `right Xxx` idiom that renders as two boxes on
one row — so affected commands are documented with 1, 2 or 4 *fewer* parameters
than they take. `Harmonicity Draw` is listed with zero parameters; it takes
four. This generalizes M13 from the audit, which found the same thing on two
Formant and Pitch queries and treated it as local. It is not local. **The 22
object types with a curated `COMMANDS_*.txt` are correct** — those files were
hand-verified and this sweep confirmed them. The remaining 114 types (2,464
commands: KlattGrid, Matrix, TableOfReal, DTW, Discriminant, EEG) have no
curated file, so the catalogue is the sole authority there — precisely the
fallback case it exists to serve. Documented in the catalogue's own banner and
as a hard rule: never emit a catalogue-sourced range command without verifying
its arity first.

**`--utf8` does not guarantee UTF-8 output.** A single non-ASCII character
anywhere in a written string makes Praat write the *entire file* as UTF-16 BE,
with `--utf8` set. Verified triggers: `—` `–` `…` `’` `“` `°` `µ` `±` `Δ` `é`
`≥`. Once flipped, later `appendFileLine:` calls stay UTF-16. This is the actual
cause of the historical UTF-16 `eml-batch-process.txt` incident, and it retires
a standing assumption: the audit had dismissed em-dashes in string literals as
"harmless unless something re-encodes." Writing one to a file **is** the
re-encoding. A generated script that puts an em-dash in a CSV header produces a
file `read.csv` cannot parse, and nothing errors.

**Generated scripts must never `include` the EML plugin.** The user is not
assumed to have it installed, at any path, ever. This became urgent *because* of
the refresh above: the PKB is now byte-faithful to plugin source, so
`eml-graphs.txt` ships nine real `include ../graphs/….praat` lines a model could
copy into delivered code. Two accepted shapes — procedures pasted inline
(default), or a sibling `*_lib/` folder on a script-relative path. Copying is
transitive. Enforced on every surface a model reaches, including a banner
directly above the include block itself.

**Extended thinking was retired in Opus 4.8, so the Phase 3B gate is now
model-conditional.** The complexity score is unchanged; only its vocabulary and
gate behavior differ. Toggle models (4.6/4.7) keep the on/off recommendation and
wait on a recommended *change*; effort models (4.8+) get an advisory line and no
wait. This also resolved a contradiction: HARD GATE and Phase 3B were both
marked hard and gave opposite instructions on the GO-wait.

---

## Audit remediation (14.0.0)

A full-codebase audit ran against the PKB, then every finding was verified
against source. Item IDs are from the audit report.

**Routing integrity.** The retrieval table's only drawing row pointed at
`EML_DRAWING_PROCEDURES.txt`, which does not exist, while
`BEST_PRACTICES_DRAWING.txt` — mandatory co-load per protocol step 2 — had no
row at all (C1). A model scanning the table hit a dead end for all drawing work.
Row replaced, stale name swept from six PKB files. Five files no retrieval row
could reach now have rows: DemoWindow commands and best practices, confidence
figures, and both EGG files (M4/E1/E2) — the Demo deck and EGG analysis are both
scored benchmark tasks that were previously unreachable by the stated trigger
mechanism. `emlReportKWComparison` was missing `.tableId` from its registry
signature, misbinding three arguments (M9).

**Gate logic.** The AUTO domain table still keyed on "Rule 28 A–K" — the
pre-13.9.4 list — so AUTO, the *only* compliance check when gates are
suppressed, would have re-shipped exactly the font-state defect 13.9.4 was
written to close (C3). The STEP 1 menu advertised "AUTO … Combines with SANDBOX
and DEBUGGING" while the mode section declares those mutually exclusive (C5).
DEBUGGING was sold in STEP 1 but had no defining section — added as STEP 2D
(M1). VERBOSE was silently cancelled by GO, the proceed keyword at every gate
(M2). AUTO had no file-output/GUI/UX row at all, leaving Rules 26/27, 18/19/20
and 33 unchecked in the one mode where SELF-AUDIT is suppressed (M5).

**SELF-AUDIT templates.** File-output safety (26/27) is named by the 13.9.4
evidence rule as requiring citation but had no template slot, so the requirement
could never fire (M3). Added to both templates, along with Rule 4B and Rule 37;
verbose template de-duplicated.

**EGG integration.** `emlEggCycleGuard` and `emlEggSpectralThreshold` were
complete runnable procedures living only inside documentation and indexed
nowhere. Promoted to a registered source file (E5). Mandatory EGG co-load added
as loading-protocol step 4a (E3).

**Source-of-truth hygiene.** `BEST_PRACTICES_DRAWING.txt` said "NEVER use
`Marks left:`" and its very next "# CORRECT:" example used it (M7). The Demo
font-state House Rule flagged the mandatory per-frame three-line reset as a
violation (M8). Appendix D's §9 pointed at a handoff document that no longer
exists (M16). The library violated its own prohibition list with 39 `+=` and 2
`elif` (M15) — see *Style exception* below for why those returned.

**License incoherence (M14).** Nine `eml-*` headers declared Creative Commons,
one of them **CC Non-Commercial** — incompatible with GPL and with the other
eight. All normalized to GPL-3.0-or-later.

---

## Sandbox verification (14.1.0)

Praat 6.6.30 was installed and driven. Findings that changed the library:

**Clinical values: verified sound.** All twelve APPENDIX_D canonical calls
executed against a synthetic with known properties. All three pitch algorithms
recovered 150.00 Hz from a 150 Hz signal; HNR 33.1 / 34.9 dB; jitter 0.047%;
shimmer 0.367%; CPPS 10.67 dB. Separately, the catalogue's source-extracted
defaults were diffed against APPENDIX_D for eight commands — exact match on
every parameter. **CPPS was the exception, not the pattern.**

**CPPS differs from Praat's dialog defaults on six fields, not three.** The
appendix said three; a source-extraction reading during the audit said five; the
live dialog shows six. The two missed are the enum fields — Trend type
(*Exponential decay* vs Straight) and Fit method (*Robust slow* vs Robust) —
precisely the fields the catalogue exposes without their default values. §5B is
now a field-by-field table with a sandbox stamp, and the Praat-default call is
recorded in `COMMANDS_PowerCepstrogram.txt` for contrast.

**Rule 19 overclaimed the form/beginPause quoting asymmetry.** 13.9.3 stated
that `beginPause:` numeric defaults "must be bare," with a SELF-AUDIT item
enforcing it. The asymmetry is **one-directional**: bare in `form:` is a hard
parse error, but quoted in `beginPause:` parses, renders and binds correctly.
Bare in beginPause is a house convention, not a requirement. As written, the
audit item would have flagged compliant code — including this library's own
`eml-batch-process.txt`.

**`elif` is accepted.** Both `elif` and `elsif` parse and execute. The
`eml-inferential` normalization is style conformance with the prohibition list,
not a bug fix.

**Three arity defects in the previously unaudited COMMANDS files.** ~630
signatures across 20 files were probed by invoking each with excess arguments —
Praat's "requires only N arguments" reply reports true arity. `Sound Multiply`
was documented with no arguments (takes one; the bare form fails outright).
`TextGrid Scale times` likewise (takes two). And the entire TextGrid
Draw/Speckle block — 15 commands — requires a **Pitch object co-selected**, with
the Extract commands requiring a **Sound**; this was undocumented, and a model
selecting only a TextGrid gets "requires only 5 arguments, not the 9 given"
because bare-TextGrid `Draw:` is a different command. All three corrected and
verified.

**Black screenshots under Xvfb are a capture defect, not a render failure.**
Plain X11 has no compositing, so pixels of an occluded window region are not
stored anywhere and `import -window` reads empty framebuffer. `Xvfb +bs` does
*not* help (the client must request backing store; GTK3 does not). `xcompmgr`
fixes it completely. A 100%-black frame means nothing was mapped — usually a
dead process — and must never be reported as evidence. Full behavior matrix,
fix, and validation check documented in Rule 24C; `openbox`, `xcompmgr`,
`xdotool` and `imagemagick` added to the STEP 2B install.

---

## Effort and model guidance

Deliberately soft, and labelled provisional. **"High" is the *default* effort
setting — the third, balanced step on an escalating scale, not its top.**
Current understanding: no apparent advantage to going *above* default; going
above can derail a project through context exhaustion; some evidence effort may
be set *below* default once the COMMAND PLAN is established. Users are told to
experiment rather than given a rule, and Phase 3B's line is explicitly not to be
presented as settled.

Model recommendations: **Opus 5** preferred; **Opus 4.8** performs well;
**Opus 4.6 + Extended Thinking** remains the original development baseline and
the token-conscious choice; **Opus 4.7** is agentic and superseded. **Sonnet and
Haiku are now explicitly unsupported**, replacing "may work for simple scripts."

---

## PKB updates

This release touches the whole PKB. Replacing the entire `pkb/` folder is the
only supported upgrade path.

**Refreshed from plugin source (14 files).** `eml-annotation-procedures`,
`eml-batch-process`, `eml-core-descriptive`, `eml-core-utilities`,
`eml-draw-procedures`, `eml-extract`, `eml-graph-procedures`, `eml-graphs`,
`eml-graphs-form`, `eml-inferential`, `eml-output`, `eml-test-helpers`,
`eml-vibrato-procedures`, and the new `eml-analysis`. Content is verbatim from
plugin source; only the License line is normalized, and each carries a
provenance block.

**New.** `eml-analysis.txt` — 21 `@emlRun*Analysis` dispatchers, the layer the
plugin's menu wrappers call. Brings regression, normality (Shapiro-Wilk),
RM-ANOVA, Friedman and reliability into reach. `eml-egg-procedures.txt` — the
mandatory EGG cycle guard and spectral-threshold de-noiser.

**Removed.** `eml-demo-procedures.txt` (31 procedures). It was carried on the
assumption that Demo-deck generation depends on it. It does not: the source of
truth for driving the Demo window is `COMMANDS_DemoWindow.txt` (16 sections) and
`BEST_PRACTICES_DEMO_WINDOW.md`, and **neither references it**. It was a
convenience wrapper around already-documented commands, dated April 2026, of
uncertain current quality. Demo window support is unaffected.

**Not shipped, by decision.** `eml-lmm` (linear mixed models — not ready) with
its private numerical dependencies `eml-linalg` and `eml-optimizer` (Cholesky,
BOBYQA; called by nothing else). `@emlRunLMMAnalysis` is consequently the one
dispatcher with unresolvable calls and carries a hard do-not-route warning at
its own definition. `eml-wizard` excluded as vestigial — note that the
`@emlWizardExplain*` helpers **are** shipped; they are core.

**Stamped.** All 23 previously unaudited `COMMANDS_*` files carry an arity-check
record stating how many commands were probed, how many had exact arity
confirmed, and — explicitly — what the check does *not* establish (parameter
order, types, defaults, semantics). Three files that could not be probed
headlessly say so rather than implying coverage.

**Style exception, deliberate.** PKB copies are byte-faithful to plugin source
so that Rule 223 ("copy exactly from source") is satisfiable. That reintroduces
39 `+=` and 2 `elif` the audit had rewritten. Rather than let the PKB diverge
from source again, the fix goes upstream: `plugin_style_fix.sh` at repo root
applies it to the plugin. The Master Prompt names this as a known SOT exception
so a model does not "correct" the library it is copying from.

---

## Version summary

| Component | This release | Previous |
|---|---|---|
| Release | **1.0.0** | 0.9.3-beta.02.1 |
| Master Prompt | **14.1.0** | 13.9.4 |
| PKB snapshot | **2026-07-29** | 2026-06-22 |
| Sandbox Praat | **6.6.30** | 6.4.67 |
| Rules | 37 | 37 |
| EML procedures | **264** across 15 files | 251 claimed / 236 actual |

---

## Upgrade notes

**Replace your project's instructions with `MASTER_PROMPT_CORE_v14_1_0.md`.**
The filename changed; delete `MASTER_PROMPT_CORE_v13_9_4.md`.

**Replace the entire `pkb/` folder.** Every file changed. Piecemeal replacement
is not supported this release. Two files are gone —
`eml-demo-procedures.txt` and the duplicate `eml-annotation-procedures.praat` /
`.praat.txt` pair, now consolidated to `eml-annotation-procedures.txt` — so
delete the old folder rather than overwriting into it.

**Do not rename files;** the Master Prompt references them by exact filename.

**If you generate scripts that write files,** review them for non-ASCII
characters in written string literals. One em-dash makes the output file
UTF-16 BE, and downstream tools will not read it.

**Sandbox Mode users:** the install now also pulls `openbox`, `xcompmgr`,
`xdotool` and `imagemagick`. Still requires `www.fon.hum.uva.nl` in
Settings → Capabilities → Allowed domains, set *before* the conversation starts.

**Two helper scripts ship at repo root.** `praatshot.sh` — reliable X11 window
capture that refuses to return an unvalidated black frame. `plugin_style_fix.sh`
— applies the `+=` / `elif` style fix to the *plugin*, not the PKB.

---

## Known limitations

**Parameter order and types are unverified.** The arity sweep verified parameter
*counts*. A command with the right count and wrong order produces no error and a
wrong number — the exact silent-failure class PraatGen exists to prevent. No
coverage.

**~100 further catalogue defects are projected** in the 114 object types with no
curated `COMMANDS_*.txt`. Those types are harder to instantiate, which is why
they remain unmeasured. A dedicated re-extraction pass is warranted; the fix is
mechanical (handle the `left`/`right` pair) rather than editorial.

**`APPENDIX_B_FUNCTIONS.txt`** (375 entries) was not audited this cycle and is
not reachable by the arity harness, since functions are not commands.

**`COMMANDS_Editor.txt`** carries its own three-phase verification at Praat
6.4.62/6.4.65 and has not been re-confirmed at 6.6.30.

---

## Reporting issues

Report to Ian Howell at the Embodied Music Lab
([www.embodiedmusiclab.com](https://www.embodiedmusiclab.com)). Quote **both**
version numbers — Release and Master Prompt — since they track independently.

- **Script errors:** the task description, the generated script, and the exact
  Praat error message with line number.
- **Reference gaps:** the object type and command name.
- **Suspected arity errors:** if a command fails with "requires only N
  arguments", that message is the ground truth — please include it verbatim.
