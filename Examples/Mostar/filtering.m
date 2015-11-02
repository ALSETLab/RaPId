load('dataMeasuredO.mat'); 

simin.time = time; 
simin.signals.values = signal(:,1); 



%%


fs = inv(time(end)-time(end-1)); 


p = signal(:,1); 
p = p-mean(p); 

P = fft(p); 
P_mag = abs(P); 

plot(P_mag)
%%

num_bins = length(P); 
norm_freq = [0:1/(num_bins/2-1):1]; 

plot(norm_freq, P_mag(1:num_bins/2))

[b a] = butter(10,0.04, 'low'); 
[d c] = butter(2,0.005, 'high'); 

%[d c] = butter(2,0.005, 'high'); 
%[b,a] = cheby1(5,0.1,0.05);
H = freqz(b,a,floor(num_bins/2));
D = freqz(d,c,floor(num_bins/2));

plot(norm_freq, abs(H),'r'); 
%%
%p_filt2 = filter(d,c,p); 

[~,state1] = filter(b,a,ones(1000,1)*0.1673);
p_filt = filtfilt(b,a,p);


p_filt2 = filtfilt(d,c,p_filt); 
figure(1); 
plot(time,p);
hold on; 
plot(time,p_filt2,'r')
legend('Original','Filtered'); 
figure(2);
x1 = abs(fft(p))/length(p);
x2 = abs(fft(p_filt2))/length(p_filt2);
plot(norm_freq*fs/2,x1(1:num_bins/2));
hold on;
plot(norm_freq*fs/2,x2(1:num_bins/2),'r');
legend('Original','Filtered'); 
xlim([0 35]);
