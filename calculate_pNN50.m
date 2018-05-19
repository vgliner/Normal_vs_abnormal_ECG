function pNN50=calculate_pNN50(r_vec,Fs)
diff_r_vec=diff(r_vec)/Fs;
diff_diff_r_vec=abs(diff(diff_r_vec));
pNN50=sum(diff_diff_r_vec>0.05)/numel(diff_diff_r_vec);