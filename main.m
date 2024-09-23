% script of reading the ls denoising. 
clc; 
close all; 
clear all; 

addpath('./data/signals'); 
addpath('./method'); 


n = 1000;  
mean = 0.0; 
std = 0.4; 
rng('default') % For reproducibility
[x, u_true, noise] = lsdenoising(n, mean, std); 

f1 = figure(1); 
f1.Position = [200 200 800 1000]; 
subplot(2,1,1); 
plot(u_true, 'k-', 'LineWidth', 4.0); 
title('True Signal'); 
hold on; 
plot(x, 'r-.', 'LineWidth', 1.5); 
hold off; 
grid on; 
ylabel('u(x)'); 
xlabel('index'); 
legend('true signal','noising signal'); 
subplot(2,1,2); 
plot(noise, 'b-.', 'LineWidth', 1.5); 
title(['Gaussian Noise with mean: ', num2str(mean), ', standard deviation: ', num2str(std)]);
xlabel('index'); 
ylabel('Gaussian random noise')
grid on; 

lambda = [0.001, 0.01, 0.1, 1, 100, 1000];
K = length(lambda); 

for j = 1:K
lambda_val = lambda(j); 
[u_denoised, u_true] = solveL2_1Dsignal(x,u_true, lambda_val);
psn = psnr(u_denoised, u_true); 


f2 = figure(2); 
f2.Position = [200 200 1000 1500]; 
subplot(K,1,j); 
plot(u_true, 'k-', 'LineWidth', 5.0);  
hold on; 
plot(x, 'r-.', 'LineWidth', 2.5); 
plot(u_denoised, 'b-.', 'LineWidth', 2.5); 
hold off; 
grid on; 
ylabel('u(x)'); 
xlabel('index'); 
legend('True signal','Noising signal','Denoised signal'); 
title(['Lambda: ', num2str(lambda_val), ', PSN: ', num2str(psn), ' dB'   ]); 

end 