
%function [x, residuals] = model_0(Ct)
function [cfun, gof, output] = model_0(Ct)
% mean_ct = mean(Ct);

residuals = Ct - 0;
sse = sum(residuals.^2);

x(1) = sse;                 % residual

output.residuals    = residuals;

gof.sse             = sse;

f = fittype('a*x+b');

cfun = cfit(f, 0, 1);

