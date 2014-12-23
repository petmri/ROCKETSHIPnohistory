
function Ct = model_patlak_cfit(Ktrans, vp, Cp, time)

Cp = Cp(:);
time = time(:);

% Pre-alocate for speed
Ct = zeros(1,numel(time));
for k = 1:numel(time)
    
    % The time for T
    T = time(1:k);
    CP= Cp(1:k);
    
    F = CP;
    
    if(numel(T) == 1)
        %need this as trapz interprets non array as
        %Y,DIM input instead of X,Y
        M = 0;
    else
        M = trapz(T,F);
    end
    
    Ct(k) = Ktrans.*M+vp*Cp(k);
end
    
Ct = Ct';