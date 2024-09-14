% script of reading the ls denoising. 
clc; 
close all; 
clear all; 

addpath('./data/signals'); 

n = 1000;  
mean = 0.0; 
std = 0.4; 
rng('default') % For reproducibility
[u, u_true, noise] = lsdenoising(n, mean, std); 

f1 = figure(1); 
f1.Position = [200 200 800 1000]; 
subplot(2,1,1); 
plot(u_true, 'k-', 'LineWidth', 4.0); 
title('True Signal'); 
hold on; 
plot(u, 'r-.', 'LineWidth', 1.5); 
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


