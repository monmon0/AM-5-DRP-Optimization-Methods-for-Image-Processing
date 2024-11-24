% script of reading the ls denoising. 
% v1: run simulation 1D case for all algorithms. 

clc; 
close all; 
clear all; 

addpath('./data/signals'); 
addpath('./method'); 
n_vals = 8000;  
iters_IRLS = zeros(size(n_vals)); 
iters_FISTA = zeros(size(n_vals)); 
iters_PGD = zeros(size(n_vals)); 

n = n_vals;  
mean = 0.1; 
std = 4.8; 
%rng('default') % For reproducibility
[u, u_true, noise] = lsdenoising(n, mean, std);

%----------------------------IRLS--------------------------------------------
                        
% L1 penalty solver
% add loop for lambda ?
%[x, u_true, noise] = lsdenoising(n, mean, std);
tolerance = 10^-8;
[u_denoised_irls, residuals_irls] = solve_L1_IRLS(u_true, u, 1e3, tolerance);

% lambda = difference than other algorithms. 


%----------------------------FISTA METHOD----------------------------------
 
%[x, u_true, noise] = lsdenoising(n, mean, std); 
tolerance = 10^-8;
[u_denoised_fista, residuals_fista] = solve_L1_FISTA(u_true, u, 1e-3, tolerance);

%----------------------------PGD METHOD------------------------------------

%[x, u_true, noise] = lsdenoising(n, mean, std); 
tolerance = 10^-8;
[u_denoised_pgd, residuals_pgd] = solve_L1_PGD(u_true, u, 1e-5, tolerance);

% -------------------------- Print out Result -----------------------------

fprintf('Total Grid-Size N: %i \n', n); 

%fprintf('Result for IRLS, MSE: %.3e, PSNR: %.5f \n', immse(u_denoised_irls, u_true'), psnr(u_denoised_irls, u_true')); 
fprintf('Number of converging iteration(s) IRLS: %i \n', length(residuals_irls)); 
iters_IRLS = length(residuals_irls); 

%fprintf('Result for FISTA, MSE: %.3e, PSNR: %.5f \n', immse(u_denoised_fista, u_true), psnr(u_denoised_fista, u_true)); 
fprintf('Number of converging iteration(s) FISTA: %i \n', length(residuals_fista)); 
iters_FISTA = length(residuals_fista); 

%fprintf('Result for PGD, MSE: %.3e, PSNR: %.5f \n', immse(u_denoised_pgd, u_true), psnr(u_denoised_pgd, u_true)); 
fprintf('Number of converging iteration(s) PGD: %i \n', length(residuals_pgd)); 
iters_PGD = length(residuals_pgd); 

fprintf('-----------------------------------------------------------------'); 



figure(1); 
plot(1:length(residuals_irls), residuals_irls, 'k-', 'LineWidth', 3); 
hold on; 
plot(1:length(residuals_fista), residuals_fista, 'r-', 'LineWidth', 3); 
plot(1:length(residuals_pgd), residuals_pgd, 'b-', 'LineWidth', 3); 
hold off; 
legend('IRLS', 'FISTA', 'PGD'); 
xlabel('# of Iteration(s)'); 
ylabel('L2 error norm'); 
set(gca, 'yScale', 'log'); 
xlim([0,1e3]); 




