%% AIFbiexpconvolve Cp

%% This models the AIF as a biexponential function convolved with a
%% rectangular function to model the injection

function Cp = AIFbiexpcon(x, xdata)%A, B, c, d, T1, step)

A = x(1);
B = x(2);
c = x(3);
d = x(4);
T1 = xdata{1}.timer;
step=xdata{1}.step;
maxer=xdata{1}.maxer;

T1 = T1(:);
OUT = find(step > 0);



%Set as model A, MacGrath, MRM 2009

%B = maxer-A;

if isfield(xdata{1}, 'raw') && xdata{1}.raw == true && isfield(xdata{1}, 'baseline')
    baseline = xdata{1}.baseline;
else
    baseline = 0;
end

for j = 1:numel(T1)
    % Baseline
    if(j< OUT(1))
        Cp(j) = baseline;
    % Linear upslope to max
    elseif(j<OUT(end))
        Cp(j) = baseline + (A-baseline).*((T1(j)-T1(OUT(1)))./(T1(OUT(end))-T1(OUT(1)))) + (B-baseline).*((T1(j)-T1(OUT(1)))./(T1(OUT(end))-T1(OUT(1))));
    % Bi-Exponential Decay    
    else
        Cp(j) = A.*(exp(-c.*(T1(j) - T1(OUT(end))))) + B.*(exp(-d.*(T1(j) - T1(OUT(end)))));
    end
end
