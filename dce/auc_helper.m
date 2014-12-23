function GG = auc_helper(Sttum,Stlv, Ct_data, Cp_data, timer_data);

% [AUC from conc, AUC from signal, normalized AUC conc, normalized AUC
% signal]

AUCc = trapz(timer_data, Ct_data);
AUCs = trapz(timer_data, Sttum);

AUCcp= trapz(timer_data, Cp_data);
AUCsp= trapz(timer_data, Stlv);



NAUCc= AUCc/AUCcp;
NAUCs= AUCs/AUCsp;

GG(1,1) = AUCc;
GG(1,2) = AUCs;
GG(1,3) = NAUCc;
GG(1,4) = NAUCs;

% figure, % For debugging
% subplot(2,1,1),
% plot(timer_data, Ct_data), hold on, plot(timer_data, Cp_data, 'g')
% subplot(2,1,2),
% plot(timer_data, Sttum), hold on, plot(timer_data, Stlv, 'g')
% title(num2str(GG))
% pause
