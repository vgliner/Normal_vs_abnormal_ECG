function [polarity]=polarity_determination(input_signal)

[xmax,imax,xmin,imin] = extrema(input_signal);
sorted_max_values=sort(xmax);
sorted_min_values=sort(xmin);

%minimal_number_of_elements=min([numel(xmax) numel(xmin)]);
%minimal_number_of_elements=floor(minimal_number_of_elements/2);% Taking 50% 
%if (sum(xmax(1:minimal_number_of_elements))>sum(xmin(1:minimal_number_of_elements)))
try
        if abs(sum(sorted_max_values(max(1,(end-49)):end)))>abs(sum(sorted_min_values(1:min(50,end))))
            polarity=1;
        else 
            polarity=-1;    
        end
catch
        if abs(sum(sorted_max_values(end-10:end)))>abs(sum(sorted_min_values(1:10)))
            polarity=1;
        else 
            polarity=-1;    
        end    
end