close all
clear all
%%

load dataMeasuredO
time = time;
P = signal(:,1);
Q = signal(:,2);
Efd = signal(:,3);
V = signal(:,4);

load fmincon_results
fmincon_sol = sol;
fmincon_time = simout.time;
fmincon_P = simout.signals.values(:,1);
fmincon_Q = simout.signals.values(:,2);
fmincon_Efd = simout.signals.values(:,3);
fmincon_V = simout.signals.values(:,4);

fmincon_P_err = fmincon_P(1:3752) - P;
fmincon_Q_err = fmincon_Q(1:3752) - Q;
fmincon_Efd_err = fmincon_Efd(1:3752) - Efd;
fmincon_V_err = fmincon_V(1:3752) - V;
delta = [fmincon_P_err,fmincon_Q_err,fmincon_Efd_err,fmincon_V_err];
fitness= sqrt(sum(sum(delta.*delta)))  
load PSO_results
PSO_sol = sol;
PSO_time = simout.time;
PSO_P = simout.signals.values(:,1);
PSO_Q = simout.signals.values(:,2);
PSO_Efd = simout.signals.values(:,3);
PSO_V = simout.signals.values(:,4);

PSO_P_err = PSO_P(1:3752) - P;
PSO_Q_err = PSO_Q(1:3752) - Q;
PSO_Efd_err = PSO_Efd(1:3752) - Efd;
PSO_V_err = PSO_V(1:3752) - V;
delta = [PSO_P_err,PSO_Q_err,PSO_Efd_err,PSO_V_err];
fitness= sqrt(sum(sum(delta.*delta)))  

load multiStart_results
multiStart_sol = sol;
multiStart_time = simout.time;
multiStart_P = simout.signals.values(:,1);
multiStart_Q = simout.signals.values(:,2);
multiStart_Efd = simout.signals.values(:,3);
multiStart_V = simout.signals.values(:,4);


multiStart_P_err = multiStart_P(1:3752) - P;
multiStart_Q_err = multiStart_Q(1:3752) - Q;
multiStart_Efd_err = multiStart_Efd(1:3752) - Efd;
multiStart_V_err = multiStart_V(1:3752) - V;
delta = [multiStart_P_err,multiStart_Q_err];
fitness= sqrt(sum(sum(delta.*delta)))  
%%
tiledlayout(3,1)
nexttile
plot(time, Q,fmincon_time,fmincon_Q,'--',PSO_time,PSO_Q,':',multiStart_time, multiStart_Q,'-.','LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Reactive power, Q (p.u.)','FontSize',12);xlim([0,18]);
legend('Measurements','fmincon','PSO','MultiStart');title('A','FontSize',12)

nexttile
plot(time, Efd,fmincon_time,fmincon_Efd,'--',PSO_time,PSO_Efd,':',multiStart_time, multiStart_Efd,'-.','LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Field voltage, Efd (p.u.)','FontSize',12);xlim([0,18]);title('B','FontSize',12)

nexttile
plot(time, V,fmincon_time,fmincon_V,'--',PSO_time,PSO_V,':',multiStart_time, multiStart_V,'-.','LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Terminal voltage, Vt (p.u.)','FontSize',12);xlim([0,18]);title('C','FontSize',12)

%%
tiledlayout(2,1)
nexttile
plot(time,fmincon_Q_err,'--',time,PSO_Q_err,':',time, multiStart_Q_err,'-.','LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Reactive power, Q (p.u.)','FontSize',12);xlim([0,18]);
legend('fmincon','PSO','MultiStart');title('A','FontSize',12)
% 
% nexttile
% plot(time,fmincon_Efd_err,'--',time,PSO_Efd_err,':',time, multiStart_Efd_err,'-.','LineWidth',2)
% xlabel('Time (s)','FontSize',12); ylabel('Field voltage, Efd (p.u.)','FontSize',12);xlim([0,18]);title('B','FontSize',12)

nexttile
plot(time,fmincon_V_err,'--',time,PSO_V_err,':',time, multiStart_V_err,'-.','LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Terminal voltage, Vt (p.u.)','FontSize',12);xlim([0,18]);title('B','FontSize',12)