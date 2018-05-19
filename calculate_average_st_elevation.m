function st_elevation=calculate_average_st_elevation(cleaned_vec, q_vec,r_vec,s_vec)
try
st_elevation=mean((cleaned_vec(r_vec)-cleaned_vec(q_vec))./(cleaned_vec(r_vec)-cleaned_vec(s_vec)));
catch
st_elevation=1;
end