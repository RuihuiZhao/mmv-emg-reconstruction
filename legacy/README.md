# Historical MATLAB experiments

Files are grouped by role, rather than their original working folders:

| Directory | Contents |
| --- | --- |
| `algorithms/` | Historical single-channel and joint OMP implementations |
| `measurement_matrices/` | Binary pair, Bernoulli, circulant, Toeplitz, sparse random and partial Hadamard matrices |
| `transforms/` | DCT, Hartley, wavelet and other sparse-basis helpers |
| `experiments/` | Reconstruction drafts and comparison scripts |

Working-folder prefixes have been removed. Distinct variants with colliding names use an _alternate suffix. Identical normalized file contents are stored once, with all original sources mapped in `../docs/legacy_provenance.csv`. The original collection contained 34 MATLAB files in Code, Code1 and Code2. Text encoding and line endings were normalized; local input paths were replaced by LOCAL_INPUT_FILE. Algorithm bodies were otherwise retained. Not every draft is runnable.

Use `../examples/` and `../src/` for the maintained demonstration. See `../docs/REPRODUCIBILITY.md` for historical limitations. Attribution comments remain intact; no general reuse license is assigned pending rights review.

Alternate historical filenames use an _alternate suffix where needed. Before running an archived function, restore its original basename (see the CSV mapping) in a separate local working folder and resolve dependencies there; MATLAB requires the main function and filename to agree. These archival folders are for inspection, not the maintained execution path.

The original Code1/CS_OMP.m variant and the OMP_MMV0.m draft were removed from the distributed file set at the maintainer's request. CS_OMP.m now refers to the retained implementation originally stored in Code/CS_OMP.m. Original files remain in the local source collection and earlier Git commits. The provenance CSV lists the currently distributed variants.

The maintainer also removed the historical K/M parameter-sweep scripts, reconstruction test draft, Channel_error.m, and Diaoyong.m from the experiments folder. Earlier Git commits retain their history.

MMV.m, MMVtest.m, and MMVtestnewmat1.m were subsequently removed at the maintainer's request. The experiments folder retains MMVnew.m, MMVtest1.m, OMPtest.m, SMV.m, and run_CS_OMP.m.
