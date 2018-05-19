function most_dominant_freq=calc_most_dominant_freq(cleaned_vector,Fs)
T = 1/Fs;             % Sampling period       
L = numel(cleaned_vector);             % Length of signal
t = (0:L-1)*T;        % Time vector
Y = fft(cleaned_vector);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
[a,b]=max(P1);
most_dominant_freq=f(b);
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')