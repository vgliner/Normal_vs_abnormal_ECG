function [pLF,pHF,LFHFratio,VLF,LF,HF,f,Y,NFFT] = fft_val_fun(RR,Fs,type)
%fft_val_fun Spectral analysis of a sequence.
%   [pLF,pHF,LFHFratio,VLF,LF,HF,f,Y,NFFT] = fft_val_fun(RR,Fs,type)
%   uses FFT to compute the spectral density function of the interpolated
%   RR tachogram.  The density of very low, low and high frequency parts
%   will be estimated.
%   RR is a vector containing RR intervals in seconds.
%   Fs specifies the sampling frequency.
%   type is the interpolation type. Look up interp1 function of Matlab for
%   accepted types (default: 'spline').
%
%   Example: If RR = repmat([1 .98 .9],1,20),
%      then [pLF,pHF,LFHFratio,VLF,LF,HF] = HRV.fft_val_fun(RR,1000) yields
%      pLF = 5.4297 and pHF = 94.5703 and pHFratio = 0.0574 and
%      VLF = 0.0505 and LF = 0.1749 and HF = 3.0467.
%      [pLF,pHF,LFHFratio] = HRV.fft_val_fun(RR,1000,'linear') yields
%      pLF = 4.0484 and pHF = 95.9516 and LFHFratio = 0.0422.
%
%   See also INTERP1, FFT.

    RR = RR(:);
    if nargin<2 || isempty(Fs)
        error('HRV.fft_val_fun: wrong number or types of arguments');
    end   
    if nargin<3
        type = 'spline';
    end
    
    switch type
        case 'none'
            RR_rsmp = RR;
        otherwise
            if sum(isnan(RR))==0 && length(RR)>1
                ANN = cumsum(RR)-RR(1);
                % use interp1 methods for resampling
                RR_rsmp = interp1(ANN,RR,0:1/Fs:ANN(end),type);
            else
                RR_rsmp = [];
            end
    end
    
    % FFT
    L = length(RR_rsmp); 
    
    if L==0 
        pLF = NaN;
        pHF = NaN;
        LFHFratio = NaN;
        VLF = NaN;
        LF = NaN;
        HF = NaN;
        f = NaN;
        Y = NaN;
        NFFT = NaN;
    else
        NFFT = 2^nextpow2(L);
        Y = fft(detrend(RR_rsmp),NFFT)/L;
        f = Fs/2*linspace(0,1,NFFT/2+1);  

        YY = 2*abs(Y(1:NFFT/2+1));

        VLF = sum(YY(f<=.04));
        LF = sum(YY(f<=.15))-VLF;  
        HF = sum(YY(f<=.4))-VLF-LF;
        TP = sum(YY(f<=.4));

        pLF = LF/(TP-VLF)*100;
        pHF = HF/(TP-VLF)*100;    
        LFHFratio = LF/HF; 
    end
end

