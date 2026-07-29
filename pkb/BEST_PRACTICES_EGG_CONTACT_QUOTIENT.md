# Best Practices: EGG Contact Quotient Measurement

**Author:** Ian Howell, Embodied Music Lab (embodiedmusiclab.com)
**Compiled from:** EML PraatGen sandbox verification session, 29 July 2026
**Praat version:** 6.6.30
**Status:** Empirically validated against synthetic signals with analytically known crossings, graded-SNR variants, and a real stereo audio+EGG recording.

For command syntax, arity, return types, and failure modes: see `COMMANDS_Electroglottogram.txt`.

---

## 0. Provenance — read before citing

Sections 1–4 are literature-sourced and cited. **Section 5 is a lab recommendation and carries no external authority.** Do not attribute it to the cited authors.

The published sources describe algorithms and study exclusion criteria. They do not specify a runtime decision procedure for a software tool. Where this document turns a study design decision into tool behaviour, it says so.

---

## 1. The three CQ methods

### (a) dEGG

- Contacting instant = positive peak of the EGG derivative
- De-contacting instant = negative peak of the derivative
- Period = GCI[i+1] − GCI[i]; CQ = (GOI − GCI) / period

Herbst et al. (2017) found that, disregarding low-quality signals, the best agreement between CQegg and the videokymographic closed quotient came from an algorithm operating on the first derivative. **This is the default method for adequate signals.**

### (b) Hybrid (Howard's method)

- Contacting instant = positive peak of the EGG **derivative**
- De-contacting instant = descending crossing of a fixed threshold on the EGG **waveform**
- Threshold: 3/7 = 0.4286, conventionally written 0.43
- Origin: Davies et al. (1986); Howard (1995)

Rationale: the derivative's de-contacting trough is broad and shallow compared with its contacting peak, so the GOI degrades first as noise rises. The waveform crossing is more stable.

**The two landmarks come from different signals.** Derivative for closing, undifferentiated waveform for opening. Implementing both on one signal is wrong.

Praat cannot do this natively. `To TextGrid (closed glottis)` applies its threshold to *both* crossings, so it cannot produce a dEGG closure with a threshold opening. The hybrid must be hand-rolled — see §6.

### (c) Threshold-only (criterion level)

Both instants from waveform threshold crossings — what `To TextGrid (closed glottis)` implements natively. Common criteria: 0.20, 0.25, 0.35. Herbst & Ternström (2006) found 0.20 or 0.25 gave the best match to videokymography.

### CQ values are not comparable across methods or criteria

Always report the method and the threshold. Measured on one real recording (F0 244 Hz, SNR 27.1 dB, 1874 cycles):

| method | CQ |
|---|---|
| dEGG | 0.4280 |
| hybrid at 0.43 | 0.4559 |
| threshold at 0.25 | 0.5524 |

A spread of 0.124 on identical data.

---

## 2. EGG signal-to-noise ratio

Herbst et al. (2017) report that phonations with an EGG SNR below 10 dB are not suited to CQegg analysis. That criterion is actionable, and the measurement is three lines using canonical Appendix D parameters:

```praat
selectObject: eggSoundId
h = noprogress To Harmonicity (cc): 0.01, 75, 0.1, 1.0
selectObject: h
snr = Get mean: 0, 0
```

**Validated** against signals with known added noise:

| true SNR | measured |
|---|---|
| 40 | 39.7 |
| 30 | 29.9 |
| 20 | 20.1 |
| 15 | 15.3 |
| 10 | 10.5 |
| noise only | −7.6 |

Accurate within 0.5 dB across the usable range.

### Glide robustness

Praat's harmonicity window is six periods of the pitch floor — 80 ms at floor 75 — which raises a legitimate concern that F0 movement inside the window would smear the autocorrelation and depress the reading. Tested:

| condition | true SNR | measured | error |
|---|---|---|---|
| static 200 Hz | 30 | 30.02 | +0.02 |
| static 200 Hz | 20 | 20.14 | +0.14 |
| static 200 Hz | 10 | 10.44 | +0.44 |
| octave glide 176–350 | 30 | 29.64 | −0.36 |
| octave glide 176–350 | 20 | 20.07 | +0.07 |
| octave glide 176–350 | 10 | 10.40 | +0.40 |

**An octave glide costs under 0.4 dB at realistic noise levels.** The glide penalty and the noise do not add; the larger dominates, and at 10–30 dB the noise is far larger. HNR is therefore valid on gliding and non-sustained material, and Herbst's 10 dB criterion transfers.

**Caveat:** on a *noiseless* signal the glide is the only thing left to measure and dominates completely — a noiseless octave glide reads 41.8 dB against 133.6 dB static. HNR therefore saturates around 40–50 dB on gliding material and cannot distinguish "very clean" from "extremely clean." Nothing downstream depends on that distinction.

**No quiescent segment is required.** Do not impose one as a protocol burden.

---

## 3. Which derivative

`First central difference` is the literature-standard differentiator and the correct choice when replicating published dEGG values. It applies **no band limiting** — the single argument is a rescale factor. `Derivative` applies a low-pass.

Measured consequence on synthetic signals at graded SNR — GCI detection yield:

| SNR | First central difference | Derivative: 5000, 100, 0 |
|---|---|---|
| clean | 297 | 297 |
| 40 | 297 | 297 |
| 30 | 297 | 297 |
| 20 | **0** | 297 |
| 15 | **0** | 268 |
| 10 | 0 | 0 |

`Derivative` extends usable GCI detection two SNR steps further. Prefer it for detection on anything not pristine; use `First central difference` when replicating a protocol that specifies it.

### The derivative is the binding constraint

Measured on a real recording:

- EGG waveform HNR: 22.1 dB
- dEGG HNR: 14.0 dB

Differentiation cost 8 dB. Ternström (2024) makes the same point — that no current EGG hardware has sufficient SNR *of the derivative*. **A waveform SNR comfortably above 10 dB does not guarantee a usable derivative.**

---

## 4. De-noising — when, and only when

Ternström (2024) describes spectral thresholding plus static notch filtering as a **pragmatic** toolkit for signals with identifiable problems. It is applied to problematic signals. It is not a stage every recording passes through.

### Do not de-noise clean signals

Measured on a clean synthetic:

| | CQ error |
|---|---|
| raw | 0.00002 |
| de-noised | 0.00015 (8× worse) |

### Where it earns its place

At SNR 20, 15, and 10 the raw signal yielded **zero** GCIs. After spectral thresholding all 297 cycles were recovered with CQ within 0.001 of truth. De-noising can move a signal up a tier. Offer it as a rescue for a recording that is otherwise unusable, and **tell the user**, because it changes their data.

### Praat implementation

4:1 downward dB expansion below threshold, phase preserved. Expansion rather than zeroing avoids transients as components cross the threshold.

```praat
procedure emlEggSpectralThreshold: .soundId, .thresholdBelowPeak, .lowPassHz
    selectObject: .soundId
    .spec = To Spectrum: "no"
    selectObject: .spec
    .magCopy = Copy: "mag"
    selectObject: .magCopy
    Formula: ~ sqrt (self [1, col] ^ 2 + self [2, col] ^ 2)
    .magMat = To Matrix
    selectObject: .magMat
    .rawPeak = Get maximum
    removeObject: .magCopy, .magMat
    .thrLin = .rawPeak * 10 ^ (- .thresholdBelowPeak / 20)
    selectObject: .spec
    Formula: ~ self * (if sqrt (self [1, col] ^ 2 + self [2, col] ^ 2)
        ... < .thrLin then ((sqrt (self [1, col] ^ 2 + self [2, col] ^ 2)
        ... + 1e-30) / .thrLin) ^ 3 else 1 fi)
    selectObject: .spec
    .denoised = To Sound
    removeObject: .spec
    if .lowPassHz > 0
        selectObject: .denoised
        .resultId = Filter (pass Hann band): 0, .lowPassHz, 100
        removeObject: .denoised
    else
        .resultId = .denoised
    endif
endproc
```

**Two traps, both authoritative in `COMMANDS_Spectrum.txt`, repeated here because this is where they bite:**

- `To Spectrum: "yes"` zero-pads to the next power of two and `To Sound` returns the padded length (88200 → 131072 samples). Every per-cycle measurement is then computed over a signal 49% too long, with no warning. Use `"no"`.
- Ltas dB and raw Spectrum magnitude dB differ by ~91 dB. Anchoring the threshold to an Ltas peak expands away every harmonic and leaves a sinusoid. Because the mismatch exceeds any plausible sweep range, the symptom is that the threshold appears to have no effect at all.

### Threshold selection

The threshold has a real operating window and the wrong value fails silently. Measured (truth: QΔ 4.16, CQ 0.4798):

| threshold | QΔ | CQ | verdict |
|---|---|---|---|
| 20 dB | 2.22 | 0.5035 | over-aggressive, harmonics stripped |
| 30 dB | 3.38 | 0.4798 | usable |
| 40 dB | 4.07 | 0.4801 | optimum |
| 50 dB | 4.23 | 0.4802 | usable |
| 50 dB @ SNR 10 | **5.61** | 0.4819 | QΔ inflated 35%, looks plausible |
| 60 dB @ SNR 15 | — | — | noise back in, detection collapses |

CQ is stable across 30–60 dB; QΔ is not. A self-calibrating selection is available: sweep the threshold, find the longest run over which CQ is stable within 0.005, take its centre. Validated:

| signal | plateau | centre | CQ |
|---|---|---|---|
| clean | 30–60 dB | 45 | 0.4800 |
| SNR 20 | 30–60 dB | 45 | 0.4803 |
| SNR 10 | 30–50 dB | 40 | 0.4814 |
| no phonation | **none** | — | refuse |

Plateau width tracks accuracy monotonically and its absence is a refusal criterion. Validated on white Gaussian noise — the easy case. Hum and wandering side tones will narrow or fragment the plateau.

---

## 5. Method selection — LAB RECOMMENDATION, not literature

Herbst et al. (2017) excluded sub-10 dB signals from **their analysis**. Whether a tool should refuse or flag is a design decision, not a published finding. Current EML position: refuse, on the grounds that a flagged number gets used anyway.

| EGG SNR | method |
|---|---|
| ≥ T1 | dEGG |
| 10 dB ≤ SNR < T1 | hybrid at 0.43 |
| < 10 dB | offer de-noising; refuse if it does not lift the signal above 10 dB |

**T1 is unresolved.** There is no published upper cutoff. Synthetic testing found the hybrid more stable than dEGG from SNR 40 downward — cycle-to-cycle SD 0.0029 vs 0.0104 at SNR 40; 0.0158 vs 0.0916 at SNR 15, where the dEGG mean also biased +0.011. That suggests T1 near 40 dB, but it rests on synthetic white noise and a single waveform shape. Pending a ruling, report the method used and do not treat T1 as settled.

**In all cases, apply the plausibility bound to the output** (`COMMANDS_Electroglottogram.txt`, final section) regardless of which method ran. It is the only check that caught a differentiated signal presented as an EGG.

---

## 6. Hybrid CQ — reference implementation

Validated to 2.0e-05 against an analytic reference at threshold 0.43.

```praat
# GCI and period from the derivative
selectObject: eggId
degg = Derivative: 5000, 100, 0
selectObject: degg
pp = noprogress To PointProcess (periodic, peaks): floor, ceiling, "yes", "no"
selectObject: pp
nGci = Get number of points

for i from 1 to nGci - 1
    selectObject: pp
    tGci = Get time from index: i
    tNext = Get time from index: i + 1
    period = tNext - tGci
    # ... plausibility checks on period ...
    # GOI from the WAVEFORM, descending crossing at 0.43
    selectObject: eggSoundId
    peakVal = Get maximum: tGci, tNext, "Sinc70"
    tPeak = Get time of maximum: tGci, tNext, "Sinc70"
    valleyVal = Get minimum: tGci, tNext, "Sinc70"
    tValley = Get time of minimum: tGci, tNext, "Sinc70"
    thr = valleyVal + 0.43 * (peakVal - valleyVal)
    # bisect the monotonic falling limb [tPeak, tValley]
    lo = tPeak
    hi = tValley
    for iter from 1 to 40
        mid = (lo + hi) / 2
        selectObject: eggSoundId
        v = Get value at time: 1, mid, "Sinc70"
        if v > thr
            lo = mid
        else
            hi = mid
        endif
    endfor
    cq = ((lo + hi) / 2 - tGci) / period
endfor
```

**Bisect on [tPeak, tValley], not [tPeak, tNext].** The signal crosses the threshold twice per cycle — once descending (wanted) and once ascending before the next closure. Only [tPeak, tValley] brackets exactly one.

---

## 7. QΔ — optional descriptor, not a gate

Ternström (2019) defines a normalised peak derivative requiring no threshold and no contacting event:

```
QΔ = 2 · δmax / (App · sin(2π / T))
```

where App is peak-to-peak EGG amplitude over the cycle, T is the period in sample intervals, and δmax is the largest sample-to-sample differential in the cycle. A sinusoid gives 1. Contacting is indicated above about 2, well established above about 4.

Use it as a descriptor when the question is whether the folds are contacting — breathy onsets, voice mapping.

**Do not use it as a gate on CQ measurement.** It is the most noise-sensitive quantity in the pipeline (it read 5.61 against a truth of 4.16 at SNR 10) and it passed a signal that produced a CQ of 0.049. The plausibility bound is the gate.

Companion measure: Ternström (2019) also defines a normalised contact quotient (Qci — area under the normalised pulse, 0.5 for a sine) which is comparatively insensitive to SNR. Not yet implemented or validated here.

---

## 8. Canonical workflow

1. Read the file. Confirm channel count and sampling frequency.
2. Identify the EGG channel if not specified. Derivative HNR is a usable discriminator — on a real stereo file ch2 (EGG) gave 21.5 dB against ch1 (audio) 17.7 dB, with waveform HNR 27.1 vs 22.1.
3. `Extract Electroglottogram: channel, invert?`
4. `To Sound` — keep this; it is the working object for every query.
5. Measure EGG SNR (§2) on the Sound.
6. Guard (`COMMANDS_Electroglottogram.txt`) before any call to `To TextGrid (closed glottis)` or `To AmplitudeTier (levels)`.
7. Select method (§5). Compute CQ.
8. Plausibility-bound the **output**. Refuse rather than report an impossible value.
9. Report, in every output row: method, threshold criterion, EGG SNR, cycles used, and any de-noising applied.

Object hygiene: `High-pass filter`, `Derivative`, and `First central difference` each create a new object. `To AmplitudeTier (levels)` creates up to three. Track every ID and remove only what the script created (Rule 4B).

---

## 9. References

**Davies, P., McGowan, R., & Rosenberg, A.** (1986). Variation in glottal open and closed phases for speakers of English. *Proceedings of the Institute of Acoustics*, 8, 539.
— Origin of the hybrid method.

**Herbst, C. T.** (2020). Electroglottography — An Update. *Journal of Voice*, 34(4), 503–526. doi:10.1016/j.jvoice.2018.12.014
— Published online 2019; issue 2020. `praatgen_references_complete.md` dates this to 2019 — correct to 2020 or cite both.

**Herbst, C. T., Schutte, H. K., Bowling, D. L., & Švec, J. G.** (2017). Comparing Chalk With Cheese — The EGG Contact Quotient Is Only a Limited Surrogate of the Closed Quotient. *Journal of Voice*, 31(4), 401–409. doi:10.1016/j.jvoice.2016.11.007
— 10 dB SNR criterion; dEGG best agreement with CQvkg; five-algorithm comparison; hybrid threshold given as ca. 0.43 (three-sevenths).

**Herbst, C. T., & Ternström, S.** (2006). A comparison of different methods to measure the EGG contact quotient. *Logopedics Phoniatrics Vocology*, 31(3), 126–138. doi:10.1080/14015430500376580
— Criterion levels 0.20 / 0.25 best matched videokymography.

**Howard, D. M.** (1995). Variation of electrolaryngographically derived closed quotient for trained and untrained adult female singers. *Journal of Voice*, 9(2), 163–172. doi:10.1016/S0892-1997(05)80250-4
— Hybrid / Howard's method.

**Kankare, E., Laukkanen, A.-M., Ilomäki, I., et al.** (2012). Electroglottographic contact quotient in different phonation types using different amplitude threshold levels. *Logopedics Phoniatrics Vocology*, 37(3), 127–132. doi:10.3109/14015439.2012.664656

**Ternström, S.** (2019). Normalized time-domain parameters for electroglottographic waveforms. *JASA*, 146(1), EL65–EL70. doi:10.1121/1.5117174
— QΔ and Qci; threshold-free and contacting-event-free parameters.

**Ternström, S.** (2024). Pragmatic De-Noising of Electroglottographic Signals. *Bioengineering*, 11(5), 479. doi:10.3390/bioengineering11050479
— Spectral thresholding with 4:1 dB expansion; notch filtering; the observation that derivative SNR is the binding hardware constraint.

**Ternström, S., Johansson, D., & Selamtzis, A.** (2018). FonaDyn — A system for real-time analysis of the electroglottogram, over the voice range. *SoftwareX*, 7, 74–80.
— Author list not independently verified against the published paper.

**Boersma, P.** (1993). Accurate short-term analysis of the fundamental frequency and the harmonics-to-noise ratio of a sampled sound. *Proceedings of the Institute of Phonetic Sciences*, 17, 97–110.
— Basis of Praat's harmonicity. See open item below.

### Open item

Herbst et al. (2017) do not state, in any abstract or metadata accessible without the PDF, how they computed EGG SNR. The presence of Boersma (1993) in their reference list suggests Praat harmonicity, and harmonicity is validated here as an accurate SNR estimator (§2), but the identification is an **inference**. Confirm against the paper before citing the 10 dB figure as directly comparable to a harmonicity reading.
