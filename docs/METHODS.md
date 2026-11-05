# Model and metric definitions

Let `X` have shape samples × channels, `Psi` be a synthesis basis, and `S` be the coefficient matrix with shared sparse row support. Then `X = Psi*S`, `Y = Phi*X`, and `A = Phi*Psi`, so reconstruction solves `Y = A*S` approximately.

Joint OMP chooses the dictionary atom with the largest p-norm of correlations across channel residuals, adds it to a common support, fits all channels by least squares, and updates the residual. Independent OMP instead fits each channel separately. Shared support is a modeling assumption; real sEMG need not obey it exactly.

The maintained implementation reports the following per-channel metrics, where `e = x - xhat`:

| Metric | Definition |
| --- | --- |
| SNR (dB) | `10*log10(sum(abs(x).^2)/sum(abs(e).^2))` |
| PRD (%) | `100*norm(e)/norm(x)` |
| NMSE (%) | `100*sum(abs(e).^2)/sum(abs(x).^2)` |
| MSE | `mean(abs(e).^2)` |
| ERP (%) | `100*sum(abs(xhat).^2)/sum(abs(x).^2)` |
| Sampling ratio | `M/N`, retained measurements per input sample |

PRD squared divided by 100 equals NMSE (%). A label of MSE alone does not establish which of these formulas an archived script used. For zero-energy reference channels, normalized metrics return NaN. Exact nonzero recovery gives infinite SNR. ERP can exceed 100% and is not an accuracy score by itself.

Do not equate `M/N` with a measured reduction in bytes or power: metadata, measurement-matrix representation, quantization, and communication overhead are not included.
