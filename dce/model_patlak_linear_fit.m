function [cfun, gof, output] = model_patlak_linear_fit(Ct,Cp,timer)
%Same as model_patlak_linear, grouped to conform to cfit object
Cp = Cp';
y_value = Ct./Cp;
x_value = zeros(numel(timer),1);
% Integrate the tissue curve
for t = 1:numel(timer)
    % The time for tau from zero to t
    tau = timer(1:t);
    cp_t= Cp(1:t);
    if(numel(tau) == 1)
        %need this as trapz interprets non array as
        %Y,DIM input instead of X,Y
        M = 0;
    else
        M = trapz(tau,cp_t);
    end
	x_value(t) = M/Cp(t);
end

%Trim to after injection
x_value = x_value(2:end);
y_value = y_value(2:end);

% Fit the model
Ybar = mean(y_value);
Xbar = mean(x_value);

y = y_value-Ybar;
x = x_value-Xbar;
slope =sum(x.*y)/sum(x.^2);
intercept = Ybar-slope.*Xbar; 
r_squared = (sum(x.*y)/sqrt(sum(x.^2)*sum(y.^2)))^2;
sum_squared_error = (1-r_squared)*sum(y.^2);
if ~isfinite(r_squared) || ~isreal(r_squared)
	r_squared = 0;
end
% Save Results
result(1) = slope;				% ktrans
result(2) = intercept;			% vp
result(3) = sum_squared_error;	% residual
% Confidence intervals not calculated
result(4) = -1;					% (95 lower CI of ktrans)
result(5) = -1;					% (95 upper CI of ktrans)
result(6) = -1;					% (95 lower CI of vp)
result(7) = -1;					% (95 upper CI of vp)

residuals = zeros([1 numel(timer)],'double');

f = fittype('a*x+b');

cfun = cfit(f, slope, intercept);
gof.sse = sum_squared_error;
output.residuals = residuals;
