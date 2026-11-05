function [X, support] = joint_omp(Y, A, maxAtoms, p, tolerance)
%JOINT_OMP Joint sparse recovery with a shared support across channels.
% Y: measurements x channels; A: measurements x atoms.
% Maintained adaptation of the archived OMP_MMV algorithm. Backslash replaces
% explicit normal-equation inversion; selected atoms cannot be chosen twice.
if nargin < 4, p = 1; end
if nargin < 5, tolerance = 1e-10; end
validateattributes(A, {'double'}, {'2d','nonempty','finite'});
validateattributes(Y, {'double'}, {'2d','nonempty','finite'});
assert(size(Y,1) == size(A,1), 'Measurement dimensions must agree.');
validateattributes(maxAtoms, {'numeric'}, {'scalar','integer','positive','<=',min(size(A))});
validateattributes(p, {'numeric'}, {'scalar','real','finite','>=',1});
validateattributes(tolerance, {'numeric'}, {'scalar','real','finite','nonnegative'});
X = zeros(size(A,2), size(Y,2));
support = [];
R = Y;
referenceNorm = norm(Y,'fro');
if referenceNorm == 0, return; end
for iteration = 1:maxAtoms
    correlations = A' * R;
    scores = sum(abs(correlations).^p,2).^(1/p);
    scores(support) = -Inf;
    [~, index] = max(scores);
    support(end+1) = index; %#ok<AGROW>
    coefficients = A(:,support) \ Y;
    R = Y - A(:,support) * coefficients;
    if norm(R,'fro') <= tolerance * referenceNorm, break; end
end
X(support,:) = coefficients;
end
