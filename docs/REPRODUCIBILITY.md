# Reproduction guide

## Two distinct code tracks

1. The semantic subfolders of `legacy/` preserve historical experiment scripts. They are UTF-8 normalized with local absolute input filenames replaced by `LOCAL_INPUT_FILE`; they are not byte-identical archival originals. Original SHA-256 digests and redaction counts are in `legacy_provenance.csv`. Original files remain in the owner's local working collection.
2. `src/` and `examples/` were added during repository preparation. They provide a small runnable algorithm illustration. They are not claimed to be the original published implementation.

Do not add every legacy folder recursively to the MATLAB path: duplicate function names can select the wrong implementation.

## Historical paper configuration

The paper describes taking the first 3500 samples, third-order Butterworth band-pass filtering with normalized cutoffs `[0.005,0.45]`, removing the mean, and resampling to 5000 samples. It uses DST and BPBDMtx and studies the sampling ratio `M/N`. Do not interpret these normalized cutoffs as Hz without the sampling frequency. Signal Processing Toolbox is required for `butter`, `filtfilt`, and `resample`; some optional legacy transforms also need Wavelet Toolbox.

The paper and scripts contain varying atom/iteration budgets (including 800 and 1000). `legacy/measurement_matrices/Code2_BPBDMtx.m` uses adjacent-pair binary summation and does not use its local `k=N/M` variable. For `M<N/2`, its loop only covers the first `2*M` input columns; for `M>N/2`, rows are repeated. Do not silently replace this with a random or block-diagonal matrix and call it the same experiment.

## Known obstacles to exact replication

- Input paths were machine-specific and are now explicit placeholders.
- Some scripts call absent functions such as `OMP_MMV1` or `DBBDMtx`.
- Some drafts overwrite the sparse basis multiple times; the last assignment wins.
- One draft assigns lowercase `phi` and then uses uppercase `Phi`.
- Historical OMP uses an explicit inverse of the normal equations and may select an atom repeatedly.
- Metric names and formulas differ among drafts, and some timing calls have no matching active `tic`.
- No complete mapping from every paper figure/table to an input segment, script version, parameters, and random seed has been established.
- Participant data and downloaded datasets are intentionally absent from the release.

Consequently, exact paper tables and timing claims have **not** been independently reproduced.

## Maintained solver changes

The maintained implementation uses MATLAB backslash for least squares, excludes already selected atoms, validates dimensions, and stops when the Frobenius residual is below a relative tolerance. The default correlation aggregation uses `p=1`, following supplied experiment scripts, whereas the paper's pseudocode presents a 2-norm criterion. Pass `p=2` explicitly to investigate that variant. These differences can change support selection, numerical results, and timing.

The maintained synthetic example uses a Gaussian measurement matrix, an orthonormal DST basis, exact shared support, no measurement noise, and a small fixed atom budget. It does not run the acquisition/preprocessing pipeline and does not model clinical recordings.

## Using approved local recordings

Keep approved numeric data in an ignored local directory. Select the signal-only columns and document sampling frequency, units, channel order, segment boundaries, preprocessing, measurement matrix, seed, and stopping settings before adapting the historical script. Do not upload names or patient metadata. For downloaded datasets, obtain data through the original distributor and follow its license.

## Verification

See `../results/validation.txt` for the actual execution status. Generated MAT files are ignored. The solver timing excludes signal generation and matrix construction and must not be described as end-to-end transmission latency.
