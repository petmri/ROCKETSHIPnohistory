%% Helper Function for nonlinear curvefit to FXLAIF model, vp
function [f, gof, output] = model_2cxm(Ct,Cp,timer,prefs)

% warning off

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
    'Lower',[prefs.lower_limit_ktrans prefs.lower_limit_ve prefs.lower_limit_vp prefs.lower_limit_fp],...
    'Upper', [prefs.upper_limit_ktrans prefs.upper_limit_ve prefs.upper_limit_vp prefs.upper_limit_fp],...
    'StartPoint', [prefs.initial_value_ktrans prefs.initial_value_ve prefs.initial_value_vp prefs.initial_value_fp],...
    'Robust', prefs.Robust);
ft = fittype('model_2cxm_cfit( Ktrans, ve, vp, fp, Cp, T1)',...
    'independent', {'T1', 'Cp'},...
    'coefficients',{'Ktrans', 've', 'vp', 'fp'});
[f, gof, output] = fit([timer, Cp'],Ct,ft, options);
confidence_interval = confint(f,0.95);
if output.exitflag<=0
    % Change start point to try for better fit
    new_options = fitoptions(options,...
        'StartPoint', [prefs.initial_value_ktrans*10 prefs.initial_value_ve prefs.initial_value_vp prefs.initial_value_fp]);
    [new_f, new_gof, new_output] = fit([timer, Cp'],Ct,ft, new_options);
    
    if new_gof.sse < gof.sse
        f = new_f;
        gof = new_gof;
        output = new_output;
        confidence_interval = confint(f,0.95);
    end
    
    if output.exitflag<=0
        % Change start point to try for better fit
        new_options = fitoptions(options,...
            'StartPoint', [prefs.initial_value_ktrans*100 prefs.initial_value_ve prefs.initial_value_vp prefs.initial_value_fp]);
        [new_f, new_gof, new_output] = fit([timer, Cp'],Ct,ft, new_options);

        if new_gof.sse < gof.sse
            f = new_f;
            gof = new_gof;
            output = new_output;
            confidence_interval = confint(f,0.95);
        end
    end
end


x(1) = f.Ktrans;			% ktrans
x(2) = f.ve;				% ve
x(3) = f.vp;				% vp
x(4) = f.fp;				% fp
x(5) = gof.sse;				% residual
x(6) = confidence_interval(1,1);% (95 lower CI of ktrans)
x(7) = confidence_interval(2,1);% (95 upper CI of ktrans)
x(8) = confidence_interval(1,2);% (95 lower CI of ve)
x(9) = confidence_interval(2,2);% (95 upper CI of ve)
x(10) = confidence_interval(1,3);% (95 lower CI of vp)
x(11) = confidence_interval(2,3);% (95 upper CI of vp)
x(12) = confidence_interval(1,4);% (95 lower CI of Fp)
x(13) = confidence_interval(2,4);% (95 upper CI of Fp)

residuals = output.residuals;