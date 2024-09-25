function [psnr_val, mse_val, optim_lambda_val] = find_best_optimal_lambda(u,u_true, lambda_vals)

K = length(lambda_vals); 
psnr_val = NaN(size(lambda_vals)); 
mse_val = NaN(size(lambda_vals)); 

for i = 1:K
    lambda_val = lambda_vals(i);
    [u_denoised, u_true] = solveL2_1Dsignal(u,u_true, lambda_val);
    psn = psnr(u_denoised, u_true);  % compute psnr. decibel. 
    mse = immse(u_denoised, u_true); % compute mse. 
    
    psnr_val(i) = psn; 
    mse_val(i) = mse; 
  
end 

max_psnr_val = max(psnr_val); 
indx_optim = find(psnr_val == max_psnr_val); 
optim_lambda_val = lambda_vals(indx_optim); 


end 


