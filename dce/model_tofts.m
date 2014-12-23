%% Helper Function for nonlinear curvefit to FXLAIF model, no vp
function [f, gof, output] = model_tofts(Ct,Cp,timer,prefs)

% Ct = xdata{1}.Ct;
% i  = voxel;
% Ct = Ct(:,i);

% tic

% %configure the optimset for use with lsqcurvefit
% options = optimset('lsqcurvefit');
% 
% %increase the number of function evaluations for more accuracy
% options.MaxFunEvals = 50;
% options.MaxIter     = 50;
% options.TolFun      = 10^(-12);
% options.TolX        = 10^(-6);
% options.Diagnostics = 'off';
% options.Display     = 'off';
% options.Algorithm   = 'levenberg-marquardt';
% 
% % lb = [0 0.03];
% % ub = [Inf 1];
% lb = [0 10^20];
% ub = [Inf Inf];
% 
% [x,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@FXLStep1AIF, ...
%     [0.005 0.01], xdata, ...
%     Ct',lb,ub,options);
% 
% %x(1) =			% ktrans
% %x(2) = 		% ve
% x(3) = 1;		% unused
% x(4) = resnorm;	% residual

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
    'Lower',[prefs.lower_limit_ktrans prefs.lower_limit_ve],...
    'Upper', [prefs.upper_limit_ktrans prefs.upper_limit_ve],...
    'StartPoint', [prefs.initial_value_ktrans prefs.initial_value_ve],...
    'Robust', prefs.Robust);
ft = fittype('model_tofts_cfit( Ktrans, ve, Cp, T1)',...
    'independent', {'T1', 'Cp'},...
    'coefficients',{'Ktrans', 've'});
[f, gof, output] = fit([timer, Cp'],Ct,ft, options);
confidence_interval = confint(f,0.95);
% toc

%Calculate the R2 fit
x(1) = f.Ktrans;			% ktrans
x(2) = f.ve;				% ve
x(3) = gof.sse;				% residual
x(4) = confidence_interval(1,1);% (95 lower CI of ktrans)
x(5) = confidence_interval(2,1);% (95 upper CI of ktrans)
x(6) = confidence_interval(1,2);% (95 lower CI of ve)
x(7) = confidence_interval(2,2);% (95 upper CI of ve)

residuals = output.residuals;
