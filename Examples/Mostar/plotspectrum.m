
% Spectrum estimator for EQ2300 Digital Signal Processing
%  Project 1, 2009
%
% Based on Welch's method with a Blackman Window
%
% Usage: plotspectrum(y)  
%
%        y - input signal (must be longer than 512 samples)
%  
%  Joakim Jalden 091019

%function [Py,f,P] = plotspectrum(y,c)

if(~exist('c')) c = 'k'; end;

% Formatting of input data
%y=y15;
y = y(:); % Column form
N = length(y); % Data length

% Spectrum estimation parameters
M = 2048; % Number of FFT coefficicents (must be even)
L = 512; % Length of window (L < M and L < N)
D = floor(L*0.5); % 50% overlap
w = blackman(L); % Window - sidelobe supression (-58 dB)

% Check that we have enough data
if(L > N)
    error('Lenght of data vector not sufficient for spectrum estimation');
end;

% Compute number of full segments
K = floor((N-L)/D)+1;

% Window
w = w(:); % Column form
U = 1/L*sum(abs(w).^2); % Normalization

% Average of modified periodograms
Py = zeros(M,1);
for n=1:D:(N-L+1)
    x = [y(n:n+L-1).*w; zeros(M-L,1)]; % Segment, windowed and zero padded
    Py = Py + 1/(K*L*U)*abs(fft(x)).^2; % Add contribution
end;

% Plot spectrum over [0,1/2] in dB scale
f = 0:1/M:1/2;
PydB = Py(1:M/2+1);
PydB = 10*log10(max(PydB,eps));
P=plot(f,PydB,c,'LineWidth',1);
xlabel('Frequency (units of 2pi)');
ylabel('Magnitude (dB)');


% Set axes appropriately
Ymax = 10*ceil(max(PydB)/10); % Even multiple of 10
Ymin = Ymax - 100; % 100 dB Y plot range
axis([0 1/2 Ymin Ymax]);

% Cosmetics
set(gca,'YTick',Ymin:20:Ymax);
grid on;
