function [fitting_results, residuals] = parse_cfit(cfit_fit, cfit_gof, cfit_output, cur_dce_model, numparam, quant)

numobjects = numel(cfit_fit);
numresiduals = cfit_output{1}.numobs;

%Preallocate for speed
fitting_results = zeros([numobjects, numparam], 'double');
residuals       = zeros([numobjects, numresiduals], 'double');

parfor i = 1:numobjects
    [fitting_results(i,:), residuals(i,:)] = parse_cfit_helper(cfit_fit{i}, cfit_gof{i}, cfit_output{i}, cur_dce_model, quant, residuals(i,:));
end
    
   