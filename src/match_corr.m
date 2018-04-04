function [ corr_coef ] = match_corr( data, reference )
% return similarity coefficient

norm_data = sqrt(sum(sum( data&data )));
norm_ref = sqrt(sum(sum( reference&reference )));

product = max(max(xcorr2(double(data),double(reference))));

corr_coef = product / (norm_data*norm_ref);

end

