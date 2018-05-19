function [mean_qrs_width,std_qrs_width,mean_st_width,std_st_width,mean_pr_width,std_pr_width,entropyNoise]=  beats_morphology_analyzer_satistics(q_vec,r_vec,s_vec,t_vec,p_vec,Fs)
while numel(s_vec)>numel(q_vec)
    if abs(s_vec(1)-q_vec(1))>abs(s_vec(end)-q_vec(end))
        s_vec(1)=[];
    else
        s_vec(end)=[];        
    end        
end
while numel(q_vec)>numel(s_vec)
    if abs(s_vec(1)-q_vec(1))>abs(s_vec(end)-q_vec(end))
        q_vec(1)=[];
    else
        q_vec(end)=[];        
    end        
end

while numel(t_vec)>numel(s_vec)
    if abs(s_vec(1)-t_vec(1))>abs(s_vec(end)-t_vec(end))
        t_vec(1)=[];
    else
        t_vec(end)=[];        
    end        
end

while numel(p_vec)>numel(s_vec)
    if abs(s_vec(1)-p_vec(1))>abs(s_vec(end)-p_vec(end))
        p_vec(1)=[];
    else
        p_vec(end)=[];        
    end        
end

mean_qrs_width=mean(s_vec-q_vec)/Fs;
std_qrs_width=std(s_vec-q_vec)/Fs;

if numel(t_vec)<numel(s_vec)
    if s_vec(1)>t_vec(1)    
            s_vec(1)=[];
    else
            s_vec(end)=[];        
    end
end
mean_st_width=mean(t_vec-s_vec)/Fs;
std_st_width=std(t_vec-s_vec)/Fs;

while numel(p_vec)>numel(r_vec)
    if abs(r_vec(1)-p_vec(1))>abs(r_vec(end)-p_vec(end))
        p_vec(1)=[];
    else
        p_vec(end)=[];        
    end        
end



while numel(r_vec)>numel(p_vec)
    if abs(p_vec(1)-r_vec(1))>abs(r_vec(end)-p_vec(end))
        r_vec(1)=[];
    else
        r_vec(end)=[];        
    end        
end
mean_pr_width=mean(r_vec-p_vec)/Fs;
std_pr_width=std(r_vec-p_vec)/Fs;


%%  Tachograph entropy
    maxScale=6;
         %vec_to_entropy=ECG_vec;
         vec_to_entropy=diff(r_vec);
         if isrow(vec_to_entropy)
             vec_to_entropy=vec_to_entropy';
         end
         try
        [entropyNoise,scale1]=msentropy(vec_to_entropy,[],[],[],[],[],[],[],1);
         catch
         entropyNoise=7.13;    
         end
