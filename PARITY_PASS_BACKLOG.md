# PraatGen — Open Items for the Catalogue Parity Pass

**Opened:** 29 July 2026, at the close of Release 1.0.0 / Master Prompt 14.6.1
**Purpose:** carry forward the items that were identified but deliberately not
resolved in this release, so the next dedicated session starts from a written
scope rather than a rediscovery.

Nothing in this file is a defect in 1.0.0. These are known-unknowns, chosen
parameters awaiting validation, and structural work too large for the release
that surfaced it.

---

## 1. The parity pass proper — catalogue vs. COMMANDS files

**State.** `PRAAT_DEFINITIVE_CATALOGUE.txt` is machine-extracted from
`praat_addAction` / `praat_addMenuCommand` registrations joined to FORM blocks by
callback name, pinned to Praat 6.4.62, extracted 8 April 2026. Its header banner
now states the pin and the known gaps.

**The structural problem.** The extractor cannot see how Praat *renders* a
dialog, so any field type that occupies a shared row or a repeated widget is
miscounted. Two classes are confirmed by execution:

| class | mechanism | confirmed case |
|---|---|---|
| paired ranges | `left X` / `right X` on one dialog row counted as one field or none | 22 defects in 542 commands probed (4.1%) |
| string arrays (`…$#`) | dropped entirely | `Table: Bar plot` — catalogue 8 params, actual 10 |

Both confirmed cases were executed against **6.4.62 and 6.6.30** and are
identical in each. **This is an extraction gap, not Praat changing signatures.**
Assume the extraction before assuming a signature change.

**Suspected further classes, unmeasured:**

- `optionmenu` / `choice` blocks — enum *defaults* are known absent (documented);
  whether the fields themselves are ever miscounted is untested.
- numeric vector fields (`…#`) — same widget family as string arrays, so the same
  failure is plausible. Untested.

**Proposed method — stop treating the extraction as the measurement.**

1. **Probe every command for arity** across all 136 object types — of which the
   114 uncurated types alone account for 2,464 commands. Invoke each with excess
   arguments; Praat's `Command requires only N arguments` is ground truth. The
   22-defect figure came from 542 probes across 8 types in one afternoon; the
   full sweep is the same harness with a wider object-construction table.
   (First job of the pass: establish the true total. The catalogue does not state
   one consistently — MP 13.9.4 claimed 2,089 commands, a figure that appears
   nowhere in the file. Do not carry any of these numbers forward unverified.)
   **The bulk of the work is the constructor**: ~40 of
   the 136 types need a fixture recipe (KlattGrid, Discriminant, OTGrammar, DTW,
   FormantModeler, EEG, TableOfReal, …). Output: a live arity column beside the
   catalogue's, and a defect list that is counted rather than the current
   projected ~100.
2. **Then order, not just count.** Arity catches dropped fields; it does not
   catch permuted ones. The type-discrimination probe built for this release
   (`should be a number` vs `should be a string` vs `should be a numeric vector`
   vs `should be a string array`) recovers the type signature position by
   position, which pins order for any command with mixed types.
   **Known limit:** homogeneous all-numeric commands are not resolvable this way
   and need dialog inspection.
3. **Regenerate against the live probe, not the source scrape.**

**Decision required before starting — this is Ian's call.** Two shapes:

- **(a)** Correct `PRAAT_DEFINITIVE_CATALOGUE.txt` in place at 6.6.30.
- **(b)** Ship a machine-generated arity table *alongside* the existing
  catalogue, leaving its prose untouched.

Recommendation is **(b)**: the catalogue's non-parameter content (class
hierarchy, function lists, §3) has value the probe cannot reproduce, and a
generated companion keeps the provenance of each claim legible.

**Scope note.** 22 of 136 object types have a curated `COMMANDS_*.txt` carrying
hand-verified arity. The remaining 114 types (2,464 commands) have the catalogue
as sole authority — exactly the fallback case it exists to serve, and exactly
where the defect rate is unmeasured.

---

## 2. Registry — add a `Returns` column

**Why.** `EML_PROCEDURE_REGISTRY.md` has a `Parameters` column and no `Returns`
column. For a procedure whose entire purpose is returning a value, the registry
documents the input and omits the output, so any consumer must go to source or
guess. That gap produced a real defect in 14.0.0: the Rule 27 snippet read
`emlGenerateUniquePath.path$` — the *input parameter* — which compiles, returns
the candidate path unchanged, and silently defeats the collision guard. The
correct name is `.result$`.

1.0.0 patched the snippet and added a header warning. **The structural fix is a
fourth column**, which is generatable: return variables are recoverable from each
procedure's `Outputs:` header comment and cross-checkable against the locals
actually assigned in its body.

**Also carry forward:** the return-variable scanner written for this release
(parses every `procedure … endproc` in the 15 sources, collects assigned locals,
checks every `emlXxx.yyy` reference in the Master Prompt and all non-`eml-` PKB
files against that set). It found 32 references, 1 defect. Cheap enough to be a
standing check rather than an audit activity. Note when reusing it: the matrix
suffix is `##`, and a regex that stops at one `#` produces false positives on
`@emlOneWayAnova.dMatrix##` and `@emlDunnTest.rMatrix##`, both of which are
correct (re-exported from `@emlTukeyHSD` and `@emlRankBiserialR`).

---

## 3. EGG — chosen parameters awaiting validation

All three items are lab judgement recorded as such in
`BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`, not published findings.

**3a. The `Derivative: 5000, 100, 0` low-pass cutoff.** 5000 Hz is a *chosen*
value, and it is doing the work that produces `Derivative`'s advantage over
`First central difference` in the §3 yield table (FCD collapses to zero GCIs at
SNR 20; `Derivative` holds 297). The right cutoff depends on sampling rate, F0
and closure-peak sharpness: too low smears the GCI and biases CQ, too high
forfeits the noise rejection. Measured at one cutoff, one synthetic waveform
shape. **Sweep it, and validate against peak timing on real material.**

**3b. The 10–20 dB dual-report band.** §5 now reports dEGG and hybrid-at-0.43
side by side between 10 and 20 dB rather than substituting one silently. The
20 dB boundary is judgement. Validate against real graded material, not
synthetic white noise — which is the flaw that produced the withdrawn
`T1 ≈ 40 dB` gate.

Carry forward the reasoning that killed T1, because it will recur: **cycle-to-
cycle SD is dispersion, not error.** A fixed-threshold criterion is insensitive
by construction to the peak structure dEGG depends on, so the hybrid reads
smoother even where it is no more accurate. Any rule of the form "lower SD wins"
reintroduces the 40 dB gate through the back door.

**3c. Herbst et al. (2017) SNR computation — unconfirmed.** How they computed EGG
SNR is not stated in any abstract or metadata accessible without the PDF. Boersma
(1993) in their reference list suggests Praat harmonicity, and harmonicity is
validated here as an accurate estimator, but the identification is an
**inference**. Confirm against the paper before citing 10 dB as directly
comparable to a harmonicity reading. (Also recorded as §9 "Open item" in the EGG
file.)

**3d. Qci (Ternström 2019).** Normalised contact quotient, area under the
normalised pulse, 0.5 for a sine; comparatively insensitive to SNR. Not
implemented, not validated.

---

## 4. Single commands not sandbox-verified

**`Formant: Down to Table (optimal interval)`** — 14-parameter field order is
from the catalogue registration layer only, carrying an explicit
`⚠️ NOT SANDBOX-VERIFIED` warning in `COMMANDS_Formant.txt`. Verify against the
dialog (Paste history) and stamp it.

---

## 5. Excluded by decision — revisit when ready

**`eml-lmm`** and its private numerical dependencies (`eml-linalg`,
`eml-optimizer`, no other consumer) are excluded pending validation.
`@emlRunLMMAnalysis` ships in `eml-analysis.txt` and is **not routable** — it
carries a do-not-route warning at its own definition. Include when the plugin's
LMM implementation is validated.

**`eml-wizard`** — vestigial, excluded. Note the `@emlWizardExplain*` helpers are
*not* part of this exclusion; they live in `eml-output.txt`, a core file, and
ship.

---

## 6. Upstream style fix

PKB `eml-*.txt` copies are byte-faithful to plugin source so that "copy exactly
from source" (Rule 223) is satisfiable. That faithfulness carries 39 `+=`
compound assignments and 2 `elif` into the PKB. Praat accepts both (verified
6.6.30), and the Master Prompt names them a known SOT exception so a model does
not "correct" the library it is copying from.

**The fix belongs upstream, in the plugin.** Not a PKB edit — editing the copies
would break the byte-faithfulness that makes Rule 223 work.

A mechanical rewriter (`plugin_style_fix.sh`: `+=` → `x = x + n`, `elif` →
`elsif`, verified behaviour-preserving against 6.6.30) was written during this
release and deliberately **not** shipped in the PraatGen repo, because it
maintains the plugin, not the compiler. It belongs in
`plugin_EML_Praat_Tools`. If it is wanted and no longer to hand, it is 39 lines
and faster to rewrite than to find.

---

## 7. Open question — is the post-COMMAND-PLAN gate still wanted on effort models?

**Current behaviour (14.1.0 onward, working as specified).** The Phase 3B gate
table says *no wait, ever* on effort models (Opus 4.8+). On Opus 5, Turn 2 runs
COMMAND PLAN → FUNCTION PLAN → advisory line → script → SELF-AUDIT in a single
turn. Turn 1 remains PRE-FLIGHT-only and still requires EXECUTE/GO.

**The assumption worth testing.** Both the HARD GATE section and the Phase 3B
table justify this by asserting the Turn-2/Turn-3 split existed *only* to let the
user act on a thinking-toggle recommendation, so with no toggle there is nothing
to wait for. That is a design decision, not a fact. Historically the same gate
also gave the user a chance to inspect the plan and correct a command choice
*before* a few hundred lines were built on it. On an effort model that
opportunity is now structurally absent — the plan and the code arrive together,
so review is after the fact.

**Counterweight.** The plan is still emitted in full immediately above the code,
so nothing is hidden, and PRE-FLIGHT — where scope and approach are actually
contested — still gates. If plan-stage interventions were rare, the gate was
friction and removing it was right.

**Resolve empirically, not by argument.** Run several real tasks on Opus 5 and
note whether the missing pause ever costs something. If it does, the fix is one
row in the Phase 3B table: effort models stop after the plans when the
complexity score is ≥ 3, or unconditionally. That decouples "review the plan"
from "change a setting" — two purposes that are currently conflated because they
historically shared one gate.

Whatever is decided, the Cowork build (`SKILL.md` §3) must match; it currently
makes the post-plan gate conditional on the same criterion and would otherwise
diverge.

---

## 8. Parked — EGG spectral thresholding (withdrawn 14.3.0)

`@emlEggSpectralThreshold` and §4 of `BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`
briefly shipped and are now withdrawn. **Not ready for distribution.** Do not
reinstate either without the validation below, and do not reconstruct the
procedure from documentation or memory in the meantime.

**Why it was pulled.** Never tested on real material. Every supporting figure
came from synthetic signals with additive white Gaussian noise:

- clean-signal penalty (CQ error 0.00002 raw vs 0.00015 de-noised)
- zero-to-297 GCI recovery at SNR 20 / 15 / 10, CQ within 0.001 of truth
- the 30–60 dB CQ stability plateau and QΔ's instability across it
- the self-calibrating sweep (longest run where CQ is stable within 0.005, take
  its centre) and the "no plateau → refuse" criterion

White Gaussian noise is the easy case, and it is not what an EGG recording is
noisy *like*. Absent from the test set entirely: mains hum and its harmonics,
wandering side tones, electrode drift, movement artefact, and the low-frequency
baseline shift that EGG hardware actually produces. A method that keys off a
spectral peak and expands everything below a fixed offset behaves very
differently when the noise is tonal and non-stationary rather than flat.

The risk is not that it fails loudly. It is that it returns a plausible CQ from
altered data — the same silent-failure class the plausibility bound exists to
catch, except here the tool itself introduced the alteration.

**What validation would require, at minimum:**

1. Real EGG recordings across a graded quality range, not synthetic noise — with
   an independent CQ reference on the same material (videokymography, or at
   minimum a high-SNR recording of the same phonation).
2. Tonal and non-stationary noise in the test set: 50/60 Hz hum with harmonics,
   drifting side tones, movement artefact.
3. Whether the plateau criterion survives contact with those. It was explicitly
   validated only on white noise, and the file said so — "hum and wandering side
   tones will narrow or fragment the plateau" was a prediction, never a
   measurement.
4. A decision on whether de-noising belongs in the tool at all, versus being
   named as something the user does upstream with their own judgement. Altering
   someone's data inside an analysis pipeline is a design question, not only a
   validation question.

**Where the withdrawn material lives.** Git history, at the commits preceding the
14.3.0 withdrawal — not reprinted in the PKB, because a reader who finds a
runnable listing will run it. `git log -- pkb/eml-egg-procedures.txt` and the §4
history of `pkb/BEST_PRACTICES_EGG_CONTACT_QUOTIENT.md`.

**Kept, being independent of de-noising** and true of any spectral work on an EGG
signal: `To Spectrum: "yes"` zero-pads to the next power of two and `To Sound`
returns the padded length (88200 → 131072), silently computing every per-cycle
measure over a signal 49% too long; and Ltas dB versus raw Spectrum magnitude dB
differ by ~91 dB, so anchoring any threshold to an Ltas peak strips every harmonic
while appearing to do nothing.

`@emlEggCycleGuard` is **not** affected. It is validated against all five
segfault conditions, passes valid signals down to 10 dB SNR, and remains
mandatory.
