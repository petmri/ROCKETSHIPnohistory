
function Ct = model_vp_cfit(vp, Cp, time)

Cp = Cp(:);
time = time(:);

% Pre-alocate for speed
Ct = zeros(1,numel(time));
for k = 1:numel(time) 
    Ct(k) = vp*Cp(k);
end
    
Ct = Ct';