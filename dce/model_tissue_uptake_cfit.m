% Formula and form presented in Sourbron et al. NMR Biomed 2013
% also in Sourbron et al. MRM 2009 with different notation
function Ct = model_tissue_uptake_cfit(Ktrans, Fp, Tp, Cp, t)

Cp = Cp(:);
t = t(:);

% Pre-alocate for speed
Ct = zeros(1,numel(t));
for k = 1:numel(t)
    
    % The time for T
    T = t(1:k);
    CP= Cp(1:k);
    
    % Setup for the convolution Cp(t) * I(t-u)
    % Inpulse response function = I(t)
    F = CP.*(Fp.*exp(-(T(end)-T)./Tp) + Ktrans.*(1-exp(-(T(end)-T)./Tp)));

    if(numel(T) == 1)
        %need this as trapz interprets non array as
        %Y,DIM input instead of X,Y
        M = 0;
    else
        % Perform the convolution
        M = trapz(T,F);
    end
    
    Ct(k) = M;
end
Ct = Ct';


% % Create unit impulse (Kroenecker Delta)
% d = zeros(length(t),1);
% d(1) = 1;
% % Setup for the convolution Cp(t) * I(t)
% % Inpulse response function(t)
% % I = Fp.*exp(-t./Tp) + Ktrans.*(1-exp(-t./Tp));
% I = Fp.*d + Ktrans.*(exp(-t.*Ktrans./Tp));
% Ct = conv(Cp,I);
% % truncate to length of acquisition
% Ct = Ct(1:length(t));
