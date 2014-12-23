
function [x, residuals] = parse_cfit_helper(f, gof, output, cur_dce_model, quant, residuals)

if strcmp(cur_dce_model, 'tofts')
    %         headings = {'ROI path', 'ROI', 'Ktrans', 'Ve','Residual', 'Ktrans 95% low', ...
    %             'Ktrans 95% high', 'Ve 95% low', 'Ve 95% high'};
    %         paramname = {'Ktrans'; 've'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'};
    
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
    
elseif strcmp(cur_dce_model, 'ex_tofts')
    %         headings = {'ROI path', 'ROI', 'Ktrans', 'Ve','Vp','Residual', 'Ktrans 95% low', ...
    %             'Ktrans 95% high', 'Ve 95% low', 'Ve 95% high','Vp 95% low','Vp 95% high'};
    %         paramname = {'Ktrans'; 've'; 'vp'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'; 'vp_ci_low'; 'vp_ci_high'};
    confidence_interval = confint(f,0.95);
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
elseif  strcmp(cur_dce_model, 'nested')
    %         headings = {'ROI path', 'ROI', 'Ktrans', 'Ve','Vp','Residual', 'Ktrans 95% low', ...
    %             'Ktrans 95% high', 'Ve 95% low', 'Ve 95% high','Vp 95% low','Vp 95% high', 'Model'};
    %         paramname = {'Ktrans'; 've'; 'vp'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'; 'vp_ci_low'; 'vp_ci_high', 'model'};
    x = zeros([1 11], 'double');
    
    if output.nestedmodel == 0
        % 0th order model
        x(4) = gof.sse;
        residuals = output.residuals;
    elseif output.nestedmodel == 1
        % 1st order model
        confidence_interval = confint(f,0.95);
        
        x(3) = f.vp;                % vp
        x(4) = gof.sse;				% residual
        x(9) = confidence_interval(1,1);% (95 lower CI of vp)
        x(10) = confidence_interval(2,1);% (95 upper CI of vp)
        x(11) = output.nestedmodel;
        residuals = output.residuals;
    elseif output.nestedmodel == 2
        % 2nd order (Patlak)
        
        confidence_interval = confint(f,0.95);
        
        x(1) = f.Ktrans;			% ktrans
        x(3) = f.vp;				% vp
        x(4) = gof.sse;				% residual
        x(5) = confidence_interval(1,1);% (95 lower CI of ktrans)
        x(6) = confidence_interval(2,1);% (95 upper CI of ktrans)
        x(9) = confidence_interval(1,2);% (95 lower CI of vp)
        x(10) = confidence_interval(2,2);% (95 upper CI of vp)
        x(11) = output.nestedmodel;
        residuals = output.residuals;
    elseif output.nestedmodel == 3
        % 3rd order model (Ex-tofts)
        confidence_interval = confint(f,0.95);
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
        x(11) = output.nestedmodel;
        residuals = output.residuals;
    else
        error('No nested model match');
    end
    
    
elseif strcmp(cur_dce_model, '2cxm')
    %         headings = {'ROI path', 'ROI', 'Ktrans', 'Ve','Vp','Fp','Residual', 'Ktrans 95% low', ...
    %             'Ktrans 95% high', 'Ve 95% low', 'Ve 95% high','Vp 95% low','Vp 95% high','Fp 95% low','Fp 95% high'};
    %         paramname = {'Ktrans'; 've'; 'vp';'fp'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'; 'vp_ci_low'; 'vp_ci_high'; 'fp_ci_low'; 'fp_ci_high'};
    confidence_interval = confint(f,0.95);
    
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
    
    
elseif strcmp(cur_dce_model, 'tissue_uptake')
    %         headings = {'ROI path', 'ROI', 'Ktrans', 'Fp','Vp','Residual', 'Ktrans 95% low', ...
    %             'Ktrans 95% high', 'Fp 95% low', 'Fp 95% high','Vp 95% low','Vp 95% high'};
    %         paramname = {'Ktrans'; 'fp'; 'vp'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'; 'vp_ci_low'; 'vp_ci_high'};
    
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
    
elseif strcmp(cur_dce_model, 'patlak')
    %         headings = {'ROI path', 'ROI', 'Ktrans','Vp','Residual', 'Ktrans 95% low', ...
    %             'Ktrans 95% high','Vp 95% low','Vp 95% high'};
    %         paramname = {'Ktrans'; 'vp'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 'vp_ci_low'; 'vp_ci_high'};
    
    confidence_interval = confint(f,0.95);
    
    
    x(1) = f.Ktrans;			% ktrans
    x(2) = f.vp;				% vp
    x(3) = gof.sse;				% residual
    x(4) = confidence_interval(1,1);% (95 lower CI of ktrans)
    x(5) = confidence_interval(2,1);% (95 upper CI of ktrans)
    x(6) = confidence_interval(1,2);% (95 lower CI of vp)
    x(7) = confidence_interval(2,2);% (95 upper CI of vp)
    residuals = output.residuals;
    
elseif strcmp(cur_dce_model, 'fxr')
    %         headings = {'ROI path', 'ROI', 'Ktrans', 'Ve','Tau','Residual', 'Ktrans 95% low', ...
    %             'Ktrans 95% high', 'Ve 95% low', 'Ve 95% high','Tau 95% low','Tau 95% high'};
    %         paramname = {'Ktrans'; 've'; 'tau'; 'residual'; 'ktrans_ci_low'; 'ktrans_ci_high'; 've_ci_low';'ve_ci_high'; 'tau_ci_low'; 'tau_ci_high'};
    confidence_interval = confint(f,0.95);
    % toc
    
    %Calculate the R2 fit
    x(1) = f.Ktrans;			% ktrans
    x(2) = f.ve;				% ve
    x(3) = f.tau;				% tau
    x(4) = gof.sse;				% residual
    x(5) = confidence_interval(1,1);% (95 lower CI of ktrans)
    x(6) = confidence_interval(2,1);% (95 upper CI of ktrans)
    x(7) = confidence_interval(1,2);% (95 lower CI of ve)
    x(8) = confidence_interval(2,2);% (95 upper CI of ve)
    x(9) = confidence_interval(1,3);% (95 lower CI of tau)
    x(10) = confidence_interval(2,3);% (95 upper CI of tau)
    residuals = output.residuals;
    
elseif strcmp(cur_dce_model, 'auc')
    
    x = f;
    if quant
%         headings = {'ROI path', 'ROI', 'AUC conc', 'AUC sig','NAUC conc', 'NAUC sig'};
%         paramname = {'AUCc'; 'AUCs'; 'NAUCc'; 'NAUCs'};
    else
        x(:,3) = [];
        x(:,1) = [];
        
%         headings = {'ROI path', 'ROI', 'AUC sig', 'NAUC sig'};
%         paramname = {'AUCs'; 'NAUCs'};
    end
    
else
    % Error
    error('Model not supported');
end

end