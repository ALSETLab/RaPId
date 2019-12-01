load('dataMeasuredO.mat'); 

%%


fs = inv(time(end)-time(end-1)); 


%Active power
p = signal(:,1); 

P = fft(p); 
P_mag = abs(P); 

%Reactive power

q = signal(:,2);
m_q = mean(q); 
q = q-m_q; 

%Excitation field voltage 

efd = signal(:,3);

%Terminal voltage

v = signal(:,4);
%%
f1 = 1;
f2 = 2; 


[p_filt, H, D, norm_freq, num_bins] = filter_signal(time,p,f2,f1,fs,'band'); 
fig1 = figure(1); 
clf; 
set(fig1,'Position',[0 500 500 800])

subplot(3,2,1);
title('Filter bandwidth'); 
hold on;
grid;
plot(norm_freq*fs/2, abs(H)); 
plot(norm_freq*fs/2, abs(D)); 
xlim([0 f2+2])
xlabel('Frequency (Hz)');


[v_filt, H, D, norm_freq, num_bins] = filter_signal(time,v,f2+20,f1,fs,'low'); 
subplot(3,2,2);
V_mag = abs(fft(v));
V_mag_filt = abs(fft(v_filt));
hold on;
grid;
plot(norm_freq*fs/2,V_mag(1:end/2)/length(V_mag)*2);
plot(norm_freq*fs/2,V_mag_filt(1:end/2)/length(V_mag_filt)*2); 
xlim([0 f2+2])
ylim([0 0.002]);
title('Terminal voltage spectrum');
xlabel('Frequency (Hz)'); 
ylabel('Magnitude (pu)');
legend('Original signal','Filtered signal'); 


[p_filt, H, D, norm_freq, num_bins] = filter_signal(time,p,f2,f1,fs,'band'); 
subplot(3,1,3);
P_mag = abs(fft(p));
P_mag_filt = abs(fft(p_filt));
hold on;
grid;
plot(norm_freq*fs/2,P_mag(1:end/2)/length(P_mag)*2);
plot(norm_freq*fs/2,P_mag_filt(1:end/2)/length(P_mag_filt)*2); 
xlim([0 f2+2])
ylim([0 0.002])
title('Active power spectrum');
xlabel('Frequency (Hz)'); 
ylabel('Magnitude (pu)');
legend('Original signal','Filtered signal'); 

[q_filt, H, D, norm_freq, num_bins] = filter_signal(time,q,f2+20,f1,fs,'low'); 
subplot(3,2,3);
Q_mag = abs(fft(q));
Q_mag_filt = abs(fft(q_filt));
hold on;
grid;
plot(norm_freq*fs/2,Q_mag(1:end/2)/length(Q_mag)*2);
plot(norm_freq*fs/2,Q_mag_filt(1:end/2)/length(Q_mag_filt)*2); 
xlim([0 f2+2])
ylim([0 0.1]);
title('Reactive power spectrum');
xlabel('Frequency (Hz)'); 
ylabel('Magnitude (pu)');
legend('Original signal','Filtered signal');

[efd_filt, H, D, norm_freq, num_bins] = filter_signal(time,efd,f2+20,f1,fs,'low'); 
subplot(3,2,4);
EFD_mag = abs(fft(efd));
EFD_mag_filt = abs(fft(efd_filt));
hold on;
grid;
plot(norm_freq*fs/2,EFD_mag(1:end/2)/length(EFD_mag)*2);
plot(norm_freq*fs/2,EFD_mag_filt(1:end/2)/length(EFD_mag_filt)*2); 
xlim([0 f2+2])
ylim([0 0.5]);
title('Field voltage spectrum');
xlabel('Frequency (Hz)'); 
ylabel('Magnitude (pu)');
legend('Original signal','Filtered signal');
%%
fig2 = figure(2); 
clf; 
set(fig2,'Position',[500 500 500 800])

subplot(4,1,1);
hold on;
grid;
plot(time,p); 
plot(time,p_filt+mean(p)); 
title('Active power'); 
xlabel('Time (s)'); 
ylabel('Magnitude (pu)'); 

subplot(4,1,2);
hold on;
grid;
plot(time,q); 
plot(time,q_filt+m_q); 
title('Reactive power'); 
xlabel('Time (s)'); 
ylabel('Magnitude (pu)'); 

subplot(4,1,3);
hold on;
grid;
plot(time,efd); 
plot(time,efd_filt); 
title('Field voltage'); 
xlabel('Time (s)'); 
ylabel('Magnitude (pu)'); 

subplot(4,1,4);
hold on;
grid;
plot(time,v); 
plot(time,v_filt); 
title('Terminal voltage'); 
xlabel('Time (s)'); 
ylabel('Magnitude (pu)'); 

%%

%Saving filtered data

signal = [p_filt+mean(p) q_filt+m_q efd_filt v_filt];

save('dataMeasuredO_filtered.mat','time','signal');
