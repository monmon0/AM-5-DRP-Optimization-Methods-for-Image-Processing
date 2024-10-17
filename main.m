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


% L1 penalty solver
% add loop for lambda ?
[x, u_true, noise] = lsdenoising(n, mean, std); 
tolerance = 10^-8;
[u_denoised, residuals] = solve_L1_IRLS(u_true, x, lambda(3), tolerance);


%FISTA
[x, u_true, noise] = lsdenoising(n, mean, std); 
tolerance = 10^-9;
[u_denoised_fista, residuals_fista] = solve_L1_FISTA(u_true, x, 3e-5, tolerance);
 
f4 = figure(4); 
f4.Position = [200 200 600 2000];
plot(u_true, 'k-', 'LineWidth', 3.0);  
hold on; 
plot(u, 'r-.', 'LineWidth', 0.5); 
plot(u_denoised_fista, 'b-.', 'LineWidth', 2.5); 
hold off; 
grid on; 
ylabel('u(x)'); 
xlabel('index'); 
legend('True signal','Noising signal','Denoised signal'); 
title('Fista'); 
disp(immse(u_denoised_fista, u_true)); 
 

% Plot the PSNR and MSE curves
K = 1e4; 
lambda_vals = linspace(1e-16, 1e-4, K); 
[psnr_val, mse_val, ~] = find_best_optimal_lambda_fista(x, u_true, lambda_vals);

f5 = figure(5); 
f5.Position = [200 200 700 500]; 
yyaxis left; 
plot(lambda_vals, psnr_val, 'b--', 'LineWidth', 2.0);
ylabel('Peak-to-Noise-Ratio (dB)');
yyaxis right; 
plot(lambda_vals, mse_val, 'r--', 'LineWidth', 2.0); 
ylabel('Mean Squared Error');
xlabel('$\lambda$', 'Interpreter', 'latex'); 
grid on; 
title('Optimal $\lambda$ for $L_{1}-regularization$', 'Interpreter', 'latex');
