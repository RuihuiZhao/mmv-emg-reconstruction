# Historical MATLAB experiments

Files are grouped by role, rather than their original working folders:

| Directory | Contents |
| --- | --- |
| `algorithms/` | Historical single-channel and joint OMP implementations |
| `measurement_matrices/` | Binary pair, Bernoulli, circulant, Toeplitz, sparse random and partial Hadamard matrices |
| `transforms/` | DCT, Hartley, wavelet and other sparse-basis helpers |
| `experiments/` | Parameter sweeps, reconstruction drafts, comparison and diagnostic scripts |

Code1_ and Code2_ prefixes have been removed. Remaining Code_ names distinguish alternate implementations from the main historical functions. Identical normalized file contents are stored once, with all original sources mapped in `../docs/legacy_provenance.csv`. The original collection contained 34 MATLAB files in Code, Code1 and Code2. Text encoding and line endings were normalized; local input paths were replaced by LOCAL_INPUT_FILE. Algorithm bodies were otherwise retained. Not every draft is runnable.

Use `../examples/` and `../src/` for the maintained demonstration. See `../docs/REPRODUCIBILITY.md` for historical limitations. Attribution comments remain intact; no general reuse license is assigned pending rights review.

Some alternate historical filenames retain a Code_ prefix to distinguish variants. Before running an archived function, restore its original basename (see the CSV mapping) in a separate local working folder and resolve dependencies there; MATLAB requires the main function and filename to agree. These archival folders are for inspection, not the maintained execution path.
