# EML PraatGen — Release Notes

**1.0.0** — first stable release
**Release date:** 29 July 2026
**Master Prompt:** 14.1.0
**PKB snapshot:** 2026-07-29
**Sandbox Praat:** 6.6.30
**License:** GPL-3.0-or-later — Ian Howell, Embodied Music Lab

PraatGen is a Claude Project that writes syntactically correct, scientifically
defensible Praat scripts from plain-language descriptions. It consists of a
Master Prompt — 37 rules governing syntax validation, command verification,
clinical defaults, drawing discipline and debugging protocol — and a Project
Knowledge Base of 61 verified reference files that serve as its source of truth
in place of model recall.

1.0.0 is the first release whose reference library has been verified against a
running Praat installation rather than assembled from documentation.

---

## What's in it

**Command references.** 27 `COMMANDS_*.txt` files — 22 object types used
in voice and speech work (Sound, Pitch, Formant, Intensity, Harmonicity,
PointProcess, PowerCepstrogram, Spectrum, Spectrogram, Ltas, TextGrid, Table,
Strings, the tier types, Electroglottogram and others), plus the Picture window,
the Demo window, editor scripting, and universal commands. Each documents
verified syntax, parameter order, arity and known failure modes; 207 entries
carry a pasted working example call.

**Clinical defaults.** `APPENDIX_D_CLINICAL_DEFAULTS.txt` carries canonical
parameter sets for pitch extraction (three algorithms), jitter, shimmer,
harmonicity, CPPS, formants and intensity, each traceable to a Praat GUI default
or a named citation. Deviation requires signal-loss evidence, not preference.

**Function and syntax references.** `APPENDIX_B_FUNCTIONS.txt` (375 entries),
`APPENDIX_C_GUI.txt` (form and beginPause mechanics, variable derivation),
`APPENDIX_E_SPECIAL_CHARACTERS.txt`, `APPENDIX_F_UX_STANDARDS.txt` (dialog
conventions, file-output safety, batch patterns).

**Best-practice guides.** Drawing, confidence figures, Demo window, automatic
TextGrid annotation, EGG contact quotient, plugin architecture.

**The EML procedure library.** 264 procedures across 15 source files —
descriptive and inferential statistics, extraction, formatted reporting, the
`@emlRun*Analysis` dispatchers, drawing and annotation, vibrato analysis, batch
infrastructure, EGG support, and a test harness. Indexed by
`EML_PROCEDURE_REGISTRY.md`, which is generated from the sources themselves.

**Fallback catalogue.** `PRAAT_DEFINITIVE_CATALOGUE.txt` — 136 object types,
3,414 commands, 365 Formula engine functions, extracted from Praat source.

---

## What it does

**Validates every command against the library, not from memory.** Praat's
parameter lists change between versions, several commands have parameters that
look optional and are not, and clinical parameter sets differ from Praat's
dialog defaults in ways that produce plausible wrong numbers rather than errors.
PraatGen looks commands up.

**Runs a structured workflow.** PRE-FLIGHT verification, a COMMAND PLAN and
FUNCTION PLAN, then code and a SELF-AUDIT. For the silent-failure items —
drawing, clinical defaults, viewport reset, file output — the audit requires a
cited PKB source or a pasted script line rather than an attestation.

**Generates self-contained scripts.** Where a script uses an EML library
procedure, the procedure body is copied into the delivered script, or into a
folder shipped alongside it. Generated code never `include`s the plugin; you are
never assumed to have it installed.

**Verifies itself empirically.** In Sandbox Mode, PraatGen installs Praat in its
own environment and runs generated scripts before delivery, including GUI and
Picture-window output.

**Composable modes.** SCAFFOLD (collaborative design), SANDBOX (empirical
verification), DEBUGGING (approval required for every change, no elective
refactoring), AUTO (gates suppressed for batch work). SANDBOX composes with any;
AUTO and DEBUGGING are mutually exclusive.

---

## Working with it

**Models.** Opus 5 preferred; Opus 4.8 performs well; Opus 4.6 with Extended
Thinking remains the original development baseline and the token-conscious
choice; Opus 4.7 is agentic and superseded. Sonnet and Haiku are not supported —
command-verification reliability degrades with complexity and silent failures
are possible.

**Reasoning effort.** "High" is the default setting — the balanced middle of an
escalating scale, not its top. Current guidance is provisional: no apparent
advantage to going above default, some risk of derailing a session through
context exhaustion if you do, and some evidence that a setting below default
serves once the COMMAND PLAN is established. Experiment and find what works for
your workflows.

**Thinking.** Extended thinking as a user-facing toggle was retired in Opus 4.8.
On 4.6/4.7 PraatGen still tells you at PRE-FLIGHT when you can safely turn it
off. On 4.8 and later the same assessment reads as effort guidance and does not
gate the turn.

**Versioning.** Release and Master Prompt track independently. Quote both when
reporting an issue. Each PKB library file carries its plugin source's version
verbatim; a mismatch means the PKB has drifted and should be re-synced.

---

## What changed since 0.9.3-beta.02.1

The reference library was reconciled against the EML plugin source and verified
against Praat 6.6.30. Seven library files were incomplete and have been
refreshed; the procedure registry is now generated from source rather than
maintained alongside it. Retrieval-table gaps that made five reference files
unreachable are closed. Contradictions between the HARD GATE and the Phase 3B
thinking gate, and between the STEP 1 mode menu and the mode definitions, are
resolved. DEBUGGING mode gained the defining section it lacked. Corrections were
made to CPPS parameter documentation, eight command signatures, the
form/beginPause quoting rule, and file-output encoding guidance. Nine source
headers carried incompatible licenses and are now uniformly GPL-3.0-or-later.

**New:** `eml-analysis.txt` (21 analysis dispatchers — regression, normality,
RM-ANOVA, Friedman, reliability), `eml-egg-procedures.txt` (mandatory EGG cycle
guard, spectral-threshold de-noiser), and a self-containment rule for
generated scripts.

**Removed:** `eml-demo-procedures.txt`. Demo window support is unaffected —
`COMMANDS_DemoWindow.txt` and `BEST_PRACTICES_DEMO_WINDOW.md` are its source of
truth.

**Not shipped by decision:** the linear-mixed-model layer (`eml-lmm` with its
`eml-linalg` and `eml-optimizer` dependencies), pending validation.
`@emlRunLMMAnalysis` is documented as not routable. The vestigial `eml-wizard`
is also excluded; its `@emlWizardExplain*` helpers are core and remain.

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

**Replace your project's instructions with `MASTER_PROMPT_CORE_v14_1_0.md`.**
The filename changed; delete `MASTER_PROMPT_CORE_v13_9_4.md`.

**Replace the entire `pkb/` folder.** Every file changed, and two are gone.
Delete the old folder rather than overwriting into it.

**Do not rename files;** the Master Prompt references them by exact filename.

**Sandbox Mode** additionally installs `openbox`, `xcompmgr`, `xdotool` and
`imagemagick` for GUI verification and screenshot capture. It still requires
`www.fon.hum.uva.nl` in Settings → Capabilities → Allowed domains, set *before*
the conversation starts.

---

## Known limitations

Each is stated with the evidence behind it.

**Parameter order is verified, with a bounded gap.** Coverage comes from three
layers:

- **Executed end-to-end.** All twelve APPENDIX_D canonical clinical calls ran
  against Praat 6.6.30 on a synthetic with known properties and returned correct
  values — 150.00 Hz recovered from a 150 Hz signal by all three pitch
  algorithms, HNR 33.1/34.9 dB, jitter 0.047%, shimmer 0.367%, CPPS 10.67 dB. A
  call returning the right answer has the right parameter order.
- **Executed from pasted examples.** The `COMMANDS_*.txt` files carry 169
  `# Verified: <exact call>` lines. **111 (66%) were executed against Praat
  6.6.30** this release rather than trusted; all 111 now run clean. Nine were
  wrong and are corrected: five command defects — four REALVECTOR arguments
  written as bare whitespace-separated numbers (`0 0.5 1`), which Praat rejects,
  and one command given four arguments where it takes five — plus four examples
  whose call was split across lines or carried trailing prose, which made them
  unexecutable and so untestable.

  The 58 not executed are not unverified in principle, only outside this
  harness: 47 are commands documented in a target object's file but run on a
  different type (FormantPath queries inside `COMMANDS_Formant.txt`, creation
  commands that run on Sound), and 5 need a real audio or text file on disk.
  Extending the harness to those is the obvious next increment.
- **Arity-checked.** ~630 commands were probed for existence and parameter count
  by invoking each with excess arguments; three further defects were found and
  corrected (`Sound Multiply`, `TextGrid Scale times`, and an undocumented
  co-selection requirement across the TextGrid Draw/Speckle block).

**On what the absence of a pasted example means.** 169 examples cover roughly
800 documented commands, but the other commands are not therefore unverified.
The `COMMANDS_*.txt` files were built from Praat's C API (`praatlib.h`), the
official manual, Praat source files, and **Paste Commands sessions — where the
syntax string is emitted by Praat itself**, not typed by hand. That is machine
ground truth for parameter order, captured at the time.

The measured evidence supports it. The arity sweep this release probed ~630
commands independently of any example and found **three** defects (0.5%). The
pasted-example execution found five in 111 (4.5%) — but examples get pasted
precisely when a command is awkward, so that rate comes from the hardest cases,
not the typical one.

What is genuinely missing is a *standing automated check* on parameter order for
commands without an example — not evidence that they are wrong. Extending
pasted-example coverage, and the harness that executes it, is the way to convert
that from sound-by-sourcing to checked-every-release.

**The fallback catalogue under-specifies range-taking commands.** Praat renders
a range as two boxes on one row using the `left Xxx` / `right Xxx` label idiom.
The catalogue's extraction counted each such pair as one field or as none, so
affected commands list 1, 2 or 4 fewer parameters than they take —
`Harmonicity Draw` is listed with zero parameters and takes four.

Measured: 542 catalogue signatures probed against Praat 6.6.30 across 8 object
types, 22 mismatches (4.1%), every one a dropped range pair. 22 of the
catalogue's 136 object types have a curated `COMMANDS_*.txt`; those files are
hand-written rather than extracted, so they do not inherit this defect, and all
of them were arity-checked and corrected this release. The remaining 114 types
carry 2,464 commands for which the catalogue is the only source — which is
exactly the fallback case it exists to serve. At the measured rate, **roughly
100 further commands are expected to be affected**. Verify the arity of any
catalogue-sourced range-taking command before use.

**Reference coverage is not exhaustive.** The `COMMANDS_*.txt` files cover 22 of
the 136 object types Praat exposes — those used in voice and speech work — and
cover them thoroughly. The rest fall back to the catalogue, with the
caveat above. Gaps are filled as they are found — report them.

**Two reference files carry older verification.**
`APPENDIX_B_FUNCTIONS.txt` (375 entries) sources from the official Praat
Functions manual and was not re-verified this cycle; the arity harness cannot
reach it, since functions are not commands and produce no arity error.
`COMMANDS_Editor.txt` carries its own three-phase empirical verification at
Praat 6.4.62 desktop and 6.4.65 xvfb — more thorough than this release's arity
sweep — but has not been re-confirmed at 6.6.30, because its 58 commands require
an open editor window that the headless harness could not drive.

**File-output encoding.** A single non-ASCII character anywhere in a written
string causes Praat to write the entire file as UTF-16 BE, regardless of the
`--utf8` flag, and subsequent `appendFileLine:` calls keep it UTF-16. Verified
triggers include `—` `–` `…` `’` `“` `°` `µ` `±` `Δ` `é` `≥` — every character
tested flipped the file. Keep written literals ASCII; `read.csv`, pandas, Excel
import and `grep` will not read a UTF-16 CSV. Non-ASCII in Info-window output
and in Picture-window text is unaffected.

**No access to your environment.** Outside Sandbox Mode PraatGen does not
execute scripts. In Sandbox Mode it installs and runs Praat only in its own
environment and never touches your files or your installation. This is
architectural, not a gap to be closed: verification happens on synthetic or
supplied data, so generated scripts should still be tested on representative
data before use in research.

---

## Reporting issues

Report to Ian Howell at the Embodied Music Lab
([www.embodiedmusiclab.com](https://www.embodiedmusiclab.com)). Quote both the
Release and Master Prompt versions.

- **Script errors:** the task description, the generated script, and the exact
  Praat error message with line number.
- **Reference gaps:** the object type and command name.
- **Arity errors:** Praat's "requires only N arguments" message is ground truth
  — include it verbatim.
