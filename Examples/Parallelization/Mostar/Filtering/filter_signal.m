function [sig_filt, H, D, norm_freq,num_bins] = filter (time, signal, f1, f2, fs,type)

S = fft(signal); 
num_bins = length(S); 
norm_freq = [0:1/(num_bins/2-1):1]; 

%Design the filter with cheby 
 [d c] = cheby1(5,0.1,f1*2/fs);
 [b,a] = cheby1(5,0.1,f2*2/fs,'high');

%Design the filter with butterworth
%[d c] = butter(6,f1*2/fs);
%[b,a] = butter(6,f2*2/fs,'high');

%Create the filter
H = freqz(b,a,floor(num_bins/2));
D = freqz(d,c,floor(num_bins/2));

if strcmp(type,'low');
sig_filt = filtfilt(d,c,signal);
elseif strcmp(type,'high')
sig_filt = filtfilt(b,a,signal);
else
sig_filt_temp = filtfilt(b,a,signal);
sig_filt = filtfilt(d,c,sig_filt_temp);   
end
end