# EML PraatGen — Release Notes

**1.0.0** (first stable release; leaves the 0.9.x beta line)
**Release date:** 29 July 2026
**Master Prompt:** 14.1.0 (was 13.9.4)
**PKB snapshot:** 2026-07-29 (was 2026-06-22)
**Sandbox Praat:** 6.6.30 (was 6.4.67)
**License:** GPL-3.0-or-later — Ian Howell, Embodied Music Lab

A verification release. Where 0.9.3-beta.02 hardened the rules the compiler
follows, this build verifies the reference library those rules read from —
against the EML plugin source it was copied from, and against a running Praat
6.6.30. It folds in two Master Prompt increments (14.0.0 → 14.1.0) and
supersedes 0.9.3-beta.02.1 (22 June 2026).

The throughline is empirical verification. Praat 6.6.30 is installed and driven
during the build, so reference content is confirmed by execution rather than by
reading: command arity probed against the live parser, parameter order checked
by type response, pasted example calls run rather than trusted, and the full
clinical battery executed on a signal with known properties. Where the library
and a running Praat disagreed, the library was corrected — twelve command
signatures in all, two of them Praat's own changes since 6.4.x. The reference
files now carry a record of what was verified, by what method, against which
build.

---

## Highlights

**The EML library is reconciled against plugin source.** Seven library files
were incomplete in the PKB; all are refreshed to plugin-verbatim content, and
the procedure registry is now **generated from that source** rather than
maintained beside it — 264 procedures across 15 files, verified equal in both
directions. `eml-output` gains 21 procedures including the `@emlWizardExplain*`
plain-language helpers; `eml-vibrato` gains its five drawing procedures
including the 8-panel `@emlVibratoDrawFigure`; `eml-inferential` gains
`@emlLinearRegression` and `@emlTheilSen`.

**Each PKB library file carries its plugin source's version verbatim**, so a
version mismatch between the two is a drift signal rather than something to
reconcile by hand. PKB-only edits are recorded in a provenance block.

**The fallback catalogue now states its own limits.** Its extraction drops
Praat's paired range fields — the `left Xxx` / `right Xxx` idiom that renders as
two boxes on one row — so affected commands list fewer parameters than they
take. Measured against Praat 6.6.30: 542 signatures probed, 22 affected. The 22
object types with a curated `COMMANDS_*.txt` are unaffected; those files are
hand-written and were confirmed by this sweep. The catalogue carries a banner
naming the pattern, the confirmed cases, and the rule that follows: verify the
arity of a catalogue-sourced range command before emitting it. The Master Prompt
enforces the same at retrieval step 10.

**Two command signatures changed between Praat 6.4.x and 6.6.30.** `Formant
Formula` gained a leading time-range pair (3 documented parameters, 5 actual);
`Table Bar plot` went from 8 parameters to 10, with `Vertical column` and
`Colours` becoming string arrays. The catalogue still shows both old forms. This
is version drift rather than transcription error, and it is the strongest
argument for re-running verification against each new Praat instead of trusting
a once-verified file.

**File output is now guaranteed UTF-8 by rule.** `--utf8` alone does not
achieve it: a single non-ASCII character in a written string makes Praat write
the whole file as UTF-16 BE, and later `appendFileLine:` calls keep it there.
Verified triggers include `—` `–` `…` `’` `“` `°` `µ` `±` `Δ` `é` `≥`. Written
string literals must therefore be ASCII — `->` not `→`, `deg` not `°` — and both
SELF-AUDIT templates now require confirming it on any script that writes a file.
Info-window and Picture-window text are unaffected.

**Generated scripts are self-contained.** Where a script uses an EML library
procedure the body is copied into the delivered script, or into a folder shipped
alongside it, transitively until every `@`-call resolves within the delivery.
Generated code never `include`s the plugin, so a delivered script runs on a bare
Praat installation. Enforced at retrieval step 12, in both SELF-AUDIT templates,
and in the AUTO pre-delivery domain table.

**Extended thinking was retired in Opus 4.8, so Phase 3B is model-conditional.**
The complexity score is unchanged; only its vocabulary and gate behaviour differ.
Toggle models (4.6/4.7) keep the on/off recommendation and wait on a recommended
change; effort models (4.8+) get an advisory line and no wait. This also resolved
a contradiction in which HARD GATE and Phase 3B were both marked hard and gave
opposite instructions on the GO-wait.

---

## Verification (14.1.0)

Praat 6.6.30 is installed during the build and used to confirm reference content
by execution. Four sweeps ran; each is reproducible against a future Praat.

**Command arity — ~630 commands.** Each documented command is invoked with excess
arguments, and Praat's `Command requires only N arguments` reply gives true arity
to compare against the documented count. Three corrections followed: `Sound
Multiply` takes one argument, `TextGrid Scale times` takes two, and the TextGrid
`Draw`/`Speckle` block requires a **Pitch object co-selected** (the `Extract`
commands require a **Sound**) — the co-selection requirement is now documented,
along with the fact that bare-TextGrid `Draw:` is a different, 5-argument command.

**Parameter order — 317 commands.** Each documented parameter list is turned into
a call with type-appropriate values and executed, using Praat's *type* errors as
the discriminator: a type error means the documented sequence disagrees with
Praat's, any other error means only the value was unsuitable. Three corrections
followed, including the two version-drift signatures below.

**Pasted example calls — 111 executed.** The `COMMANDS_*.txt` files carry 169
`# Verified: <exact call>` lines; those the harness could reach were run. Nine
corrections followed — four REALVECTOR arguments needing `{a, b, c}` rather than
bare `a b c`, one arity, and four whose formatting made them unexecutable and so
untestable. All now run, and the files state the convention that keeps them
testable.

**Clinical battery — 12 canonical calls.** Every APPENDIX_D canonical call
executed on a synthetic with known properties: 150.00 Hz recovered from a 150 Hz
signal by all three pitch algorithms, HNR 33.1 / 34.9 dB, jitter 0.047%, shimmer
0.367%, CPPS 10.67 dB. The catalogue's source-extracted defaults were separately
diffed against APPENDIX_D across eight commands — exact match on every parameter.

**Library syntax — all 16 sources parse** in Praat 6.6.30.

## Reference corrections (14.1.0)

**CPPS differs from Praat's dialog defaults on six fields, not three.** The
appendix said three; a source-extraction reading said five; the live dialog shows
six. The two missed are the enum fields — Trend type (*Exponential decay* vs
Straight) and Fit method (*Robust slow* vs Robust) — precisely the fields the
catalogue exposes without their default values. §5B is now a field-by-field table
with a sandbox stamp, and the Praat-default call is recorded in
`COMMANDS_PowerCepstrogram.txt` for contrast.

**The PowerCepstrogram query block runs on a PowerCepstrum.** `Get peak`, `Get
quefrency of peak` and `Get peak prominence` require a slice extracted via `To
PowerCepstrum (slice):` first; calling them on the Cepstrogram fails. `Get CPPS`
genuinely *is* a Cepstrogram command, so the asymmetry is easy to miss. Now
stated.

**Rule 19 overclaimed the form/beginPause quoting asymmetry.** 13.9.3 stated that
`beginPause:` numeric defaults "must be bare", with a SELF-AUDIT item enforcing
it. The asymmetry is one-directional: bare in `form:` is a hard parse error, but
quoted in `beginPause:` parses, renders and binds correctly. As written the audit
item would have flagged compliant code — including this library's own
`eml-batch-process.txt`.

**`elif` is accepted.** Both `elif` and `elsif` parse and execute; the
`eml-inferential` normalization is style conformance with the prohibition list,
not a bug fix.

**Black screenshots under Xvfb are a capture defect, not a render failure.**
Plain X11 has no compositing, so an occluded window region is not stored anywhere
and `import -window` reads empty framebuffer. `Xvfb +bs` does not help — the
client must request backing store and GTK3 does not. `xcompmgr` fixes it. A
100%-black frame means nothing was mapped, usually a dead process, and must never
be reported as evidence. Documented in Rule 24C with the behaviour matrix, fix,
fallbacks and validation check.

---

## Routing and retrieval (14.0.0)

**Ghost drawing route removed (C1).** The retrieval table's only drawing row
pointed at `EML_DRAWING_PROCEDURES.txt`, which does not exist, while
`BEST_PRACTICES_DRAWING.txt` — mandatory co-load per protocol step 2 — had no row
at all. A model scanning the table hit a dead end for all drawing work. Row
replaced; the stale name swept from six PKB files.

**Five unreachable files given retrieval rows (M4, E1, E2).**
`COMMANDS_DemoWindow.txt`, `BEST_PRACTICES_DEMO_WINDOW.md`,
`BEST_PRACTICES_CONFIDENCE_FIGURES.txt`, `COMMANDS_Electroglottogram.txt` and
`BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`. The Demo deck and EGG analysis are both
scored benchmark tasks and were unreachable by the stated trigger mechanism.

**Registry signature drift corrected (M9).** `emlReportKWComparison` was missing
`.tableId` in fourth position, misbinding three arguments for any
registry-faithful call. Verified as the only such drift across the library.

**Catalogue fallback carve-out (E4).** Protocol step 10 sent an unfound command to
the catalogue "before concluding it does not exist" — but the catalogue carries no
Electroglottogram commands at all, so the fallback would confirm a false negative.
Step 10 now states the known gaps; the object-specific COMMANDS file governs.

**Mandatory EGG co-load (E3).** An EGG task now auto-pulls both EGG files rather
than depending on a judgement call, as a sibling to the APPENDIX_D clinical rule.

---

## Gates, modes and audit discipline (14.0.0)

**Rule 28 A–K → A–L in the AUTO domain table (C3).** The whole point of 13.9.4
was promoting the font-state invariant to sub-rule L; the AUTO check — the only
compliance check when gates are suppressed — still keyed on the pre-fix list, so
AUTO would have re-shipped exactly the defect 13.9.4 closed.

**AUTO domain table gained a file-output/GUI/UX row (M5).** With SELF-AUDIT
suppressed in AUTO, Rules 26/27, 18/19/20 and 33/App F had no compliance check at
all — an AUTO batch script could hardcode paths and overwrite files with nothing
firing. An EGG row was added alongside it.

**SELF-AUDIT templates completed (M3).** File-output safety (26/27) is named by
the 13.9.4 evidence rule as requiring citation but had no template slot, so the
requirement could never fire. Added to both templates, with Rule 4B and Rule 37;
verbose template de-duplicated. The file-output line now also requires confirming
every written literal is ASCII.

**STEP 2D — DEBUGGING mode (M1).** STEP 1 sold DEBUGGING, STEP 2A/2B/2C defined
SCAFFOLD/SANDBOX/AUTO, and nothing handled "user replies DEBUGGING". Added with
the five behaviours the STEP 1 text promises.

**AUTO + DEBUGGING menu contradiction (C5).** STEP 1 advertised "AUTO … Combines
with SANDBOX and DEBUGGING" while the mode section declares them mutually
exclusive. Corrected with the reason stated inline.

**VERBOSE no longer cancelled by GO (M2).** GO is the proceed keyword at every
gate, so a VERBOSE user replying GO at the thinking gate silently reverted to
SPARSE. SPARSE is now the sole return keyword.

---

## Model guidance (14.0.0–14.1.0)

**Opus 5 preferred; Opus 4.8 performs well.** Opus 4.6 with Extended Thinking
remains the original development-and-validation baseline and the token-conscious
choice; Opus 4.7 is more agentic and superseded. **Sonnet and Haiku are now
explicitly unsupported**, replacing "may work for simple scripts".

**Reasoning-effort guidance is provisional and labelled as such.** "High" is the
*default* setting — the balanced middle of an escalating scale, not its top. No
apparent advantage to going above default; some risk of derailing a session
through context exhaustion if you do; some evidence a setting below default
serves once the COMMAND PLAN is established. Users are told to experiment, and
Phase 3B's line is explicitly not to be presented as settled.

---

## PKB updates

Every file in the PKB changed this release. Replacing the whole `pkb/` folder is
the only supported upgrade path.

**Refreshed from plugin source (14 files).** `eml-annotation-procedures`,
`eml-batch-process`, `eml-core-descriptive`, `eml-core-utilities`,
`eml-draw-procedures`, `eml-extract`, `eml-graph-procedures`, `eml-graphs`,
`eml-graphs-form`, `eml-inferential`, `eml-output`, `eml-test-helpers`,
`eml-vibrato-procedures`, and the new `eml-analysis`. Content is verbatim from
plugin source; only the License line is normalized, and each carries a provenance
block.

**`eml-analysis.txt` — new.** 21 `@emlRun*Analysis` dispatchers, the layer the
plugin's menu wrappers call. Brings regression, normality (Shapiro-Wilk),
RM-ANOVA, Friedman and reliability into reach.

**`eml-egg-procedures.txt` — new.** The mandatory EGG cycle guard and the
spectral-threshold de-noiser, promoted from documentation where they were
complete runnable procedures indexed nowhere.

**`eml-demo-procedures.txt` — removed.** It was carried on the assumption that
Demo-deck generation depends on it. It does not: `COMMANDS_DemoWindow.txt` (16
sections) and `BEST_PRACTICES_DEMO_WINDOW.md` are the source of truth for the
Demo window, and neither references it. Demo window support is unaffected.

**`EML_PROCEDURE_REGISTRY.md` — regenerated from source.** 264 procedures across
15 files, every row carrying a purpose string, verified equal in both directions
against the shipped sources.

**`PRAAT_DEFINITIVE_CATALOGUE.txt`** — staleness and known-gap banner added, with
the measured arity defect, the confirmed mismatch list, and a verify-before-use
instruction. §3 footer count corrected (369 → 365).

**`APPENDIX_D_CLINICAL_DEFAULTS.txt`** — §5B rewritten as a field-by-field CPPS
comparison with a sandbox stamp; §9's dangling handoff pointer repointed to §10;
`"Parabolic"` normalized to verified `"parabolic"`.

**`APPENDIX_C_GUI.txt`** — form/beginPause quoting asymmetry corrected;
`@emlWrapperCommonFields` example rewritten as an explicit placeholder.

**`APPENDIX_F_UX_STANDARDS.txt`** — file-output encoding rule added; stale
drawing-procedure references repointed.

**All 23 previously unaudited `COMMANDS_*` files** carry an arity-check record
stating how many commands were probed, how many had exact arity confirmed, and
what the check does *not* establish. Three that could not be probed headlessly say
so rather than implying coverage.

**Style exception, deliberate.** PKB copies are byte-faithful to plugin source so
Rule 223 ("copy exactly from source") is satisfiable. That reintroduces 39 `+=`
and 2 `elif` the audit had rewritten. The fix belongs upstream in the plugin; the
Master Prompt names this as a known SOT exception so a model does not "correct"
the library it is copying from.

**License incoherence resolved.** Nine `eml-*` headers declared Creative Commons,
one of them CC Non-Commercial — incompatible with GPL and with the other eight.
All normalized to GPL-3.0-or-later.

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

Replace the entire `pkb/` folder. Every file changed and two are gone —
`eml-demo-procedures.txt`, and the duplicate `eml-annotation-procedures.praat` /
`.praat.txt` pair now consolidated to `eml-annotation-procedures.txt`. Delete the
old folder rather than overwriting into it.

Do not rename files; the Master Prompt references them by exact filename.

If you generate scripts that write files, review them for non-ASCII characters in
written string literals. One em-dash makes the output file UTF-16 BE.

Sandbox Mode additionally installs `openbox`, `xcompmgr`, `xdotool` and
`imagemagick` for GUI verification and screenshot capture. It still requires
`www.fon.hum.uva.nl` in Settings → Capabilities → Allowed domains, set *before*
the conversation starts.

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
