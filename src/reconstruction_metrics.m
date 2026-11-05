function metrics = reconstruction_metrics(reference, reconstructed)
%RECONSTRUCTION_METRICS Per-channel metrics; no silent epsilon regularization.
assert(isequal(size(reference),size(reconstructed)), 'Signal dimensions must agree.');
validateattributes(reference, {'double'}, {'2d','nonempty','finite'});
validateattributes(reconstructed, {'double'}, {'2d','nonempty','finite'});
signalEnergy = sum(abs(reference).^2,1);
errorEnergy = sum(abs(reference-reconstructed).^2,1);
metrics.snr_db = 10*log10(signalEnergy ./ errorEnergy);
metrics.prd_percent = 100*sqrt(errorEnergy ./ signalEnergy);
metrics.nmse_percent = 100*errorEnergy ./ signalEnergy;
metrics.mse = mean(abs(reference-reconstructed).^2,1);
metrics.erp_percent = 100*sum(abs(reconstructed).^2,1) ./ signalEnergy;
% Zero-energy references make normalized metrics undefined.
invalid = signalEnergy == 0;
metrics.snr_db(invalid) = NaN;
metrics.prd_percent(invalid) = NaN;
metrics.nmse_percent(invalid) = NaN;
metrics.erp_percent(invalid) = NaN;
end
