function [f, gof, output] = model_extended_tofts(Ct,Cp,timer,prefs)

%[x, residuals] = model_extended_tofts(Ct,Cp,timer,prefs)

% Ct = xdata{1}.Ct;
% i  = voxel;
% Ct = Ct(:,i);

% 	tic

% %configure the optimset for use with lsqcurvefit
% options = optimset('lsqcurvefit');
% 
% %increase the number of function evaluations for more accuracy
% options.MaxFunEvals = 50;
% options.MaxIter     = 50;
% options.TolFun      = 1e-8; %could use -8
% options.TolX        = 1e-4; %could use -4
% options.Diagnostics = 'off';
% options.Display     = 'off';
% options.Algorithm   = 'levenberg-marquardt';
% 
% lb = [0 0 0];
% ub = [5 1 1];
% 
% [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@FXLStep1AIF_vp, ...
% 	[0.005 0.05 0.05], xdata, ...
% 	Ct',lb,ub,options);
% % 	r2 = 1 - resnorm / norm(Ct-mean(Ct))^2;
% r2 = resnorm;
% 
% %	x(1) =			% ktrans
% %	x(2) = 			% ve
% % 	x(3) = 			% vp
% x(4) = resnorm;	% residual
% % 	toc

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
    'Lower',[prefs.lower_limit_ktrans prefs.lower_limit_ve prefs.lower_limit_vp],...
    'Upper', [prefs.upper_limit_ktrans prefs.upper_limit_ve prefs.upper_limit_vp],...
    'StartPoint', [prefs.initial_value_ktrans prefs.initial_value_ve prefs.initial_value_vp],...
    'Robust', prefs.Robust);
ft = fittype('model_extended_tofts_cfit( Ktrans, ve, vp, Cp, T1)',...
    'independent', {'T1', 'Cp'},...
    'coefficients',{'Ktrans', 've', 'vp'});
[f, gof, output] = fit([timer, Cp'],Ct,ft, options);
confidence_interval = confint(f,0.95);

if output.exitflag<=0
    % Change start point to try for better fit
    new_options = fitoptions(options,...
        'StartPoint', [prefs.initial_value_ktrans*10 prefs.initial_value_ve prefs.initial_value_vp]);
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
            'StartPoint', [prefs.initial_value_ktrans*100 prefs.initial_value_ve prefs.initial_value_vp]);
        [new_f, new_gof, new_output] = fit([timer, Cp'],Ct,ft, new_options);

        if new_gof.sse < gof.sse
            f = new_f;
            gof = new_gof;
            output = new_output;
            confidence_interval = confint(f,0.95);
        end
    end
end

% toc

%Calculate the R2 fit
x(1) = f.Ktrans;			% ktrans
x(2) = f.ve;				% ve
x(3) = f.vp;				% vp
x(4) = gof.sse;				% residual
x(5) = confidence_interval(1,1);% (95 lower CI of ktrans)
x(6) = confidence_interval(2,1);% (95 upper CI of ktrans)
x(7) = confidence_interval(1,2);% (95 lower CI of ve)
x(8) = confidence_interval(2,2);% (95 upper CI of ve)
x(9) = confidence_interval(1,3);% (95 lower CI of vp)
x(10) = confidence_interval(2,3);% (95 upper CI of vp)

residuals = output.residuals;