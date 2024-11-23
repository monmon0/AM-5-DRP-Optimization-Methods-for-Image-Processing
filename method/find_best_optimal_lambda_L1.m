function [psnr_val, mse_val, optim_lambda_val] = find_best_optimal_lambda_L1(u, u_true, lambda_vals, L1_solver)

tolerance = 10^-9;
K = length(lambda_vals); 
psnr_val = NaN(size(lambda_vals)); 
mse_val = NaN(size(lambda_vals)); 

% Loop through each lambda value to compute PSNR and MSE
for i = 1:K
    lambda_val = lambda_vals(i);
    
    % Call the L1 solver with the current lambda value
    [u_denoised, ~] = L1_solver(u_true, u, lambda_val, tolerance);
    
    % Compute PSNR and MSE for the current denoised signal
    psn = psnr(u_denoised, u_true);  % compute psnr. decibel. 
    mse = immse(u_denoised, u_true); % compute mse. 
    
    % Store PSNR and MSE values
    psnr_val(i) = psn; 
    mse_val(i) = mse; 
end 

% Find the optimal lambda value that maximizes PSNR
[max_psnr_val, indx_optim] = max(psnr_val); 
optim_lambda_val = lambda_vals(indx_optim); 

end
