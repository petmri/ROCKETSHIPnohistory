%% FXLStep1AAIF, vp
function Ct = model_2cxm_cfit(Ktrans, ve, vp, fp, Cp, T1)

Cp = Cp(:);
T1 = T1(:);

if Ktrans>= fp
    PS = 10^8; %large value, prevents Inf and NaN errors
else
    PS = Ktrans*fp/(fp-Ktrans);
end
E = PS/(PS+fp);
e = ve/(vp+ve);
tau_plus  = (E-E*e+e)/(2*E)*(1+sqrt(1-(4*E*e*(1-E)*(1-e))/(E-E*e+e)^2));
tau_minus = (E-E*e+e)/(2*E)*(1-sqrt(1-(4*E*e*(1-E)*(1-e))/(E-E*e+e)^2));
k_plus  = fp/((vp+ve)*tau_minus);
k_minus = fp/((vp+ve)*tau_plus);
F_plus  =  1*fp*(tau_plus-1)/(tau_plus-tau_minus);
F_minus = -1*fp*(tau_minus-1)/(tau_plus-tau_minus);


% Pre-alocate for speed
Ct = zeros(1,numel(T1));
for k = 1:numel(T1)
    
    % The time for T
    T = T1(1:k);
    CP= Cp(1:k);
    
    F = CP.*(F_plus*exp(-k_plus*(T(end)-T)) + F_minus*exp(-k_minus*(T(end)-T)));
    
    if(numel(T) == 1)
        %need this as trapz interprets non array as
        %Y,DIM input instead of X,Y
        Ct(k) = 0;
    else
        Ct(k) = trapz(T,F);
    end
    
    if isnan(Ct(k))
%         disp(['NaN generated ktrans: ' num2str(Ktrans) 've: ' num2str(ve) ...
%              'vp: ' num2str(vp)  'fp: ' num2str(fp)])
        Ct(k) = 0;
    end
end

Ct = Ct';