function [r2, rmse] = rsquare(y,f,varargin)
r2 = max(0,1 - sum((y(:)-f(:)).^2)/sum((y(:)-mean(y(:))).^2));
rmse = sqrt(mean((y(:) - f(:)).^2));