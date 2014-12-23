% FWR
function R1t = model_fxr_cfit(Ktrans, ve, tau, Cp, T1, R1o, R1i, r1, fw)

% Calculate Ct first
Cp = Cp(:);
T1 = T1(:);
po = ve/fw;

% Pre-alocate for speed
Ct = zeros(1,numel(T1));
for k = 1:numel(T1)    
    % The time for T
    T = T1(1:k);
    CP= Cp(1:k);
    
    F = CP.*exp((-Ktrans./ve).*(T(end)-T));
    
%     M = sampleintegration(T,F);
    if(numel(T) == 1)
        %need this as trapz interprets non array as
        %Y,DIM input instead of X,Y
        M = 0;
    else
        % 54 times faster than sampleintegration
        M = trapz(T,F);
    end
    
    Ct(k) = Ktrans.*M;
end

Ct = Ct';

% tau = 10^-20;
% Now incorporate into FXR 2SX Equation
XX = (R1o-R1i+1/tau)/po;
YY = ((2/tau -r1.*Ct-XX).^2)+4*(1-po)/(tau*tau*po);

ind = find(YY < 0);

if(~isempty(ind))
    YY(ind) = 0;
end
R1t = double((1/2).*(2.*R1i+r1.*Ct+XX-sqrt(YY)));
% R1t = Ct;