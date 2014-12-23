function [f, gof, output] = model_tissue_uptake(Ct,Cp,timer,prefs)

% Use Curvefitting tool box instead of optimization toolbox (lsqcurvefit)
% as curvefitting will easily return confidence intervals on the fit
% performance of the two appears to be the same
options = fitoptions('Method', 'NonlinearLeastSquares',...
    'Algorithm', 'Trust-Region',...
    'MaxIter', prefs.MaxIter,...
    'MaxFunEvals', prefs.MaxFunEvals,...
    'TolFun', prefs.TolFun,...
    'TolX', prefs.TolX,...
    'Display', 'off',...
    'Lower',[prefs.lower_limit_ktrans prefs.lower_limit_fp prefs.lower_limit_tp],...
    'Upper', [prefs.upper_limit_ktrans prefs.upper_limit_fp prefs.upper_limit_tp],...
    'StartPoint', [prefs.initial_value_ktrans prefs.initial_value_fp prefs.initial_value_tp],...
    'Robust', prefs.Robust);
ft = fittype('model_tissue_uptake_cfit( Ktrans, Fp, Tp, Cp, T1)',...
    'independent', {'T1', 'Cp'},...
    'coefficients',{'Ktrans', 'Fp', 'Tp'});
[f, gof, output] = fit([timer, Cp'],Ct,ft, options);
confidence_interval = confint(f,0.95);

% Calulated wanted parameters
PS = f.Ktrans/(1-f.Ktrans/f.Fp);
vp = (f.Fp+PS)*f.Tp;
vp_low_ci = (f.Fp+PS)*confidence_interval(1,3);
vp_high_ci = (f.Fp+PS)*confidence_interval(2,3);

%Calculate the R2 fit
x(1) = f.Ktrans;			% ktrans
x(2) = f.Fp;				% Fp
x(3) = vp;  				% vp
x(4) = gof.sse;				% residual
x(5) = confidence_interval(1,1);% (95 lower CI of ktrans)
x(6) = confidence_interval(2,1);% (95 upper CI of ktrans)
x(7) = confidence_interval(1,2);% (95 lower CI of Fp)
x(8) = confidence_interval(2,2);% (95 upper CI of Fp)
x(9) = vp_low_ci;% (95 lower CI of vp)
x(10) = vp_high_ci;% (95 upper CI of vp)

residuals = output.residuals;