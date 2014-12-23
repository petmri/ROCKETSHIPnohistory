%% FXLStep1AAIF, no vp
function Ct = model_tofts_cfit(Ktrans, ve, Cp, T1)

Cp = Cp(:);
T1 = T1(:);

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