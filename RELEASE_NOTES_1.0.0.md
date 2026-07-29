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

**Command references.** 24 `COMMANDS_*.txt` files covering the object types used
in voice and speech work — Sound, Pitch, Formant, Intensity, Harmonicity,
PointProcess, PowerCepstrogram, Spectrum, Spectrogram, Ltas, TextGrid, Table,
Strings, the tier types, Electroglottogram, the Picture and Demo windows, and
editor scripting. Each documents verified syntax, parameter order, arity and
known failure modes.

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
made to CPPS parameter documentation, three command arities, the
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

**Parameter order and types are unverified.** Verification covered command
existence and parameter counts. A command with the correct count and wrong order
returns a wrong value without error.

**The fallback catalogue under-specifies range-taking commands.** Its extraction
drops Praat's paired range fields, so affected commands list fewer parameters
than they take. The 22 object types with a curated `COMMANDS_*.txt` are
unaffected — those files are correct. For the remaining 114 types the catalogue
is the only source; verify the arity of any range-taking command before use.
Roughly 100 commands are expected to be affected.

**Reference coverage is not exhaustive.** The `COMMANDS_*.txt` files cover
commonly used object types thoroughly. Gaps are filled as they are found —
report them.

**`APPENDIX_B_FUNCTIONS.txt`** was not re-verified this cycle.
**`COMMANDS_Editor.txt`** carries its own verification at Praat 6.4.62/6.4.65
and has not been re-confirmed at 6.6.30.

**File-output encoding.** A single non-ASCII character in a written string
causes Praat to write the entire file as UTF-16 BE, regardless of the `--utf8`
flag. Keep written literals ASCII; downstream tools will not read UTF-16 CSV.

**No access to your environment.** Outside Sandbox Mode PraatGen does not
execute scripts; in Sandbox Mode it runs Praat only in its own environment and
never touches your files or installation. Test generated scripts on
representative data before using them in research.

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
