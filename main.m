% script of reading the ls denoising. 
clc; 
close all; 
clear all; 

addpath('./data/signals'); 
addpath('./method'); 


n = 1000;  
mean = 0.1; 
std = 4.8; 
rng('default') % For reproducibility
[u, u_true, noise] = lsdenoising(n, mean, std); 
psn = psnr(u, u_true); 
mse_val = immse(u, u_true); 


f1 = figure(1); 
f1.Position = [200 200 800 1000]; 
subplot(2,1,1); 
plot(u_true, 'k-', 'LineWidth', 4.0); 
hold on; 
plot(u, 'r-.', 'LineWidth', 1.5); 
hold off; 
grid on; 
ylabel('u(x)'); 
xlabel('index'); 
legend('true signal','noising signal'); 
title(['True vs. Noising Signals', ', PSN: ', num2str(psn),' dB' , ', MSE: ', num2str(mse_val)]); 
subplot(2,1,2); 
plot(noise, 'b-.', 'LineWidth', 1.5); 
title(['Gaussian Noise with mean: ', num2str(mean), ', standard deviation: ', num2str(std)  ]);
xlabel('index'); 
ylabel('Gaussian random noise')
grid on; 

lambda = [0.1,0.01, 0.001, 0.0001, 0.00001];
K = length(lambda); 
f2 = figure(2); 
f2.Position = [200 200 600 2000]; 
for j = 1:K
lambda_val = lambda(j); 
[u_denoised, u_true] = solveL2_1Dsignal(u,u_true, lambda_val);

psn = psnr(u_denoised, u_true); 
mse_val = immse(u_denoised, u_true); 

subplot(K,1,j); 
plot(u_true, 'k-', 'LineWidth', 3.0);  
hold on; 
plot(u, 'r-.', 'LineWidth', 0.5); 
plot(u_denoised, 'b-.', 'LineWidth', 2.5); 
hold off; 
grid on; 
ylabel('u(x)'); 
xlabel('index'); 
legend('True signal','Noising signal','Denoised signal'); 
title(['Lambda: ', num2str(lambda_val), ', PSN: ', num2str(psn), ' dB ', ', MSE: ', num2str(mse_val)   ]); 

end 

K = 1e4; 
lambda_vals = linspace(1e-16, 1e-4, K); 
[psnr_val, mse_val, ~] = find_best_optimal_lambda(u,u_true, lambda_vals); 



f3 = figure(3); 
f3.Position = [200 200 700 500]; 
yyaxis left; 
plot(lambda_vals, psnr_val, 'b--', 'LineWidth', 2.0);
ylabel('Peak-to-Noise-Ratio (dB)');
yyaxis right; 
plot(lambda_vals, mse_val, 'r--', 'LineWidth', 2.0); 
ylabel('Mean Squared Error');
xlabel('$\lambda$', 'Interpreter', 'latex'); 
grid on; 
title('Optimal $\lambda$ for $L_{2}-regularization$', 'Interpreter', 'latex');

%--------------------------------------------------------------------------

% L1 penalty solver
% add loop for lambda ?
[x, u_true, noise] = lsdenoising(n, mean, std); 
tolerance = 10^-8;
[u_denoised, residuals] = solve_L1_IRLS(u_true, x, lambda(3), tolerance);

%----------------------------FISTA METHOD----------------------------------
[x, u_true, noise] = lsdenoising(n, mean, std); 
tolerance = 10^-9;
[u_denoised_fista, residuals_fista] = solve_L1_FISTA(u_true, x, 3e-5, tolerance);

% Create a figure with two subplots for FISTA and PGD signal comparison
f_combined1 = figure; 
f_combined1.Position = [200 200 600 2000];

% FISTA subplot 
subplot(2,1,1);
plot(u_true, 'k-', 'LineWidth', 3.0);  
hold on; 
plot(x, 'r-.', 'LineWidth', 0.5);  % Plot the noisy signal (u -> x)
plot(u_denoised_fista, 'b-.', 'LineWidth', 2.5); 
hold off; 
grid on; 
ylabel('u(x)'); 
xlabel('index'); 
legend('True signal','Noisy signal','Denoised signal'); 
title(['FISTA: PSN: ', num2str(psnr(u_denoised_fista, u_true)), ' dB, MSE: ', num2str(immse(u_denoised_fista, u_true))]);

%----------------------------PGD METHOD------------------------------------
[x, u_true, noise] = lsdenoising(n, mean, std); 
tolerance = 10^-9;
[u_denoised_pgd, residuals_pgd] = solve_L1_PGD(u_true, x, 3e-5, tolerance);

% PGD subplot 
subplot(2,1,2);
plot(u_true, 'k-', 'LineWidth', 3.0);  
hold on; 
plot(x, 'r-.', 'LineWidth', 0.5);  % Plot the noisy signal (u -> x)
plot(u_denoised_pgd, 'b-.', 'LineWidth', 2.5); 
hold off; 
grid on; 
ylabel('u(x)'); 
xlabel('index'); 
legend('True signal','Noisy signal','Denoised signal'); 
title(['PGD: PSN: ', num2str(psnr(u_denoised_pgd, u_true)), ' dB, MSE: ', num2str(immse(u_denoised_pgd, u_true))]);

%-------------------- PSNR and MSE Curves (FISTA & PGD) --------------------
% Plot FISTA and PGD PSNR/MSE curves on the same figure

f_combined2 = figure; 
f_combined2.Position = [200 200 700 500];

% FISTA subplot (corresponding to f5)
subplot(2,1,1);
K = 1e4; 
lambda_vals = linspace(1e-16, 1e-4, K); 
[psnr_val_fista, mse_val_fista, ~] = find_best_optimal_lambda_L1(x, u_true, lambda_vals, @solve_L1_FISTA);
yyaxis left; 
plot(lambda_vals, psnr_val_fista, 'b--', 'LineWidth', 2.0);
ylabel('Peak-to-Noise-Ratio (dB)');
yyaxis right; 
plot(lambda_vals, mse_val_fista, 'r--', 'LineWidth', 2.0); 
ylabel('Mean Squared Error');
xlabel('$\lambda$', 'Interpreter', 'latex'); 
grid on; 
title('Optimal $\lambda$ for $L_{1}-regularization$ using FISTA', 'Interpreter', 'latex');

% PGD subplot (corresponding to f7)
subplot(2,1,2);
[psnr_val_pgd, mse_val_pgd, ~] = find_best_optimal_lambda_L1(x, u_true, lambda_vals, @solve_L1_PGD);
yyaxis left; 
plot(lambda_vals, psnr_val_pgd, 'b--', 'LineWidth', 2.0);
ylabel('Peak-to-Noise-Ratio (dB)');
yyaxis right; 
plot(lambda_vals, mse_val_pgd, 'r--', 'LineWidth', 2.0); 
ylabel('Mean Squared Error');
xlabel('$\lambda$', 'Interpreter', 'latex'); 
grid on; 
title('Optimal $\lambda$ for $L_{1}-regularization$ using PGD', 'Interpreter', 'latex');





