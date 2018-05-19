function [stdevs_vec]=wavelets_analysis(ECG_sig,Fs)
% Sampling frequency
s=ECG_sig;
N=length(s);
 

waveletFunction = 'db8';
                [C,L] = wavedec(s,8,waveletFunction);
       
                cD1 = detcoef(C,L,1);
                cD2 = detcoef(C,L,2);
                cD3 = detcoef(C,L,3);
                cD4 = detcoef(C,L,4);
                cD5 = detcoef(C,L,5); %GAMA
                cD6 = detcoef(C,L,6); %BETA
                cD7 = detcoef(C,L,7); %ALPHA
                cD8 = detcoef(C,L,8); %THETA
                cA8 = appcoef(C,L,waveletFunction,8); %DELTA
                D1 = wrcoef('d',C,L,waveletFunction,1);
                D1=D1/(max(D1)-min(D1));
                D2 = wrcoef('d',C,L,waveletFunction,2);
                D2=D2/(max(D2)-min(D2));                
                D3 = wrcoef('d',C,L,waveletFunction,3);
                D3=D3/(max(D3)-min(D3));                
                D4 = wrcoef('d',C,L,waveletFunction,4);
                D4=D4/(max(D4)-min(D4));                
                D5 = wrcoef('d',C,L,waveletFunction,5); %GAMMA
                D5=D5/(max(D5)-min(D5));                
                D6 = wrcoef('d',C,L,waveletFunction,6); %BETA
                D6=D6/(max(D6)-min(D6));                
                D7 = wrcoef('d',C,L,waveletFunction,7); %ALPHA
                D7=D7/(max(D7)-min(D7));                
                D8 = wrcoef('d',C,L,waveletFunction,8); %THETA
                D8=D8/(max(D8)-min(D8));
                A8 = wrcoef('a',C,L,waveletFunction,8); %DELTA
stdevs_vec=[std(D1) std(D2) std(D3) std(D4) std(D5) std(D6) std(D7) std(D8) ];