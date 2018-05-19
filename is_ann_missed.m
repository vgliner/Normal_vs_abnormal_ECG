function is_missing=is_ann_missed(ann_vec,max_samples_between_ann)
is_missing=0;
for counter=2:numel(ann_vec)
    if (ann_vec(counter)-ann_vec(counter-1))>max_samples_between_ann
       is_missing=counter-1;
       return 
    end
end