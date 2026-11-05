% Deterministic joint-sparse synthetic example (NOT a paper replication).
root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root,'src'));
rng(42,'twister');
N = 256; M = 128; channels = 4; K = 8;
[row,col] = ndgrid(1:N,1:N);
Psi = sqrt(2/(N+1))*sin(pi*row.*col/(N+1));
Phi = randn(M,N)/sqrt(M);
A = Phi*Psi;
coefficients = zeros(N,channels);
trueSupport = randperm(N,K);
coefficients(trueSupport,:) = randn(K,channels);
reference = Psi*coefficients;
Y = Phi*reference;
tic;
[estimate,support] = joint_omp(Y,A,K,1);
elapsedSeconds = toc;
reconstructed = Psi*estimate;
metrics = reconstruction_metrics(reference,reconstructed);
assert(isequal(sort(support),sort(trueSupport)), 'Shared support recovery failed.');
assert(norm(reference-reconstructed,'fro')/norm(reference,'fro') < 1e-8);
% Independent OMP baseline using the identical measurements and atom budget.
independent = zeros(N,channels);
tic;
for channel = 1:channels
    independent(:,channel) = joint_omp(Y(:,channel),A,K,1);
end
independentSeconds = toc;
independentMetrics = reconstruction_metrics(reference,Psi*independent);
output = fullfile(root,'results');
if ~exist(output,'dir'), mkdir(output); end
save(fullfile(output,'demo_results.mat'),'metrics','independentMetrics', ...
    'elapsedSeconds','independentSeconds','N','M','K','channels','support');
f = figure('Visible','off');
plot(reference(:,1),'LineWidth',1); hold on;
plot(reconstructed(:,1),'--','LineWidth',1);
xlabel('Sample'); ylabel('Amplitude (arbitrary units)');
title('Synthetic shared-support example: channel 1');
legend('Reference','MMV reconstruction');
exportgraphics(f,fullfile(output,'demo_reconstruction.png'),'Resolution',160);
close(f);
fprintf('Synthetic demo passed. Mean PRD: %.3g%%; MMV solver: %.4fs\n', ...
    mean(metrics.prd_percent),elapsedSeconds);
