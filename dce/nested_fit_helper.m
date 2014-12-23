%wrapper function for nested fitting

function [cfit_fit, cfit_gof, cfit_output] = nested_fit_helper(Ct_data, Cp_data, timer_data, prefs);

%Fit 0 order model

[cfit_fit_zero, cfit_gof_zero, cfit_output_zero] = model_0(Ct_data);

fp_lower = 0;
% Fit 1st order model
[cfit_fit_one, cfit_gof_one, cfit_output_one] = model_vp(Ct_data,Cp_data,timer_data,prefs);
fp_higher = 1;

% Compare
n = numel(timer_data);

GG_zero = cfit_gof_zero.sse;
GG_one  = cfit_gof_one.sse;
p_value = ftest(n,fp_lower,fp_higher,GG_zero,GG_one);

if p_value>=0.05
    % Use 0 order
    cfit_fit                = cfit_fit_zero;
    cfit_gof                = cfit_gof_zero;
    cfit_output             = cfit_output_zero;
    cfit_output.nestedmodel = 0;
else
    % Use 1st order
    cfit_fit                = cfit_fit_one;
    cfit_gof                = cfit_gof_one;
    cfit_output             = cfit_output_one;
    cfit_output.nestedmodel = 1;
    fp_lower = 1;
    
    
    % Continue, Fit 2nd order model
    [cfit_fit_two, cfit_gof_two, cfit_output_two] = model_patlak(Ct_data,Cp_data,timer_data,prefs);
    
    fp_higher = 2;
    % Compare
    
    GG_one = cfit_gof_one.sse;
    GG_two = cfit_gof_two.sse;
    
    p_value = ftest(n,fp_lower,fp_higher,GG_one,GG_two);
    
    if p_value<0.05
        % Use 2nd order
        cfit_fit                = cfit_fit_two;
        cfit_gof                = cfit_gof_two;
        cfit_output             = cfit_output_two;
        cfit_output.nestedmodel = 2;
        fp_lower = 2;
        
        % Continue, Fit 3rd order model
        [cfit_fit_three, cfit_gof_three, cfit_output_three] = model_extended_tofts(Ct_data,Cp_data,timer_data,prefs);
        fp_higher = 3;
        
        % Compare
        GG_two     = cfit_gof_two.sse;
        GG_three   = cfit_gof_three.sse;
        
        p_value = ftest(n,fp_lower,fp_higher,GG_two,GG_three);
        
        if p_value<0.05
            % Use 3rd order
            cfit_fit                = cfit_fit_three;
            cfit_gof                = cfit_gof_three;
            cfit_output             = cfit_output_three;
            cfit_output.nestedmodel = 3;
            fp_lower = 3;
        end
    end
end









