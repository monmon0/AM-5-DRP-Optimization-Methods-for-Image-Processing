% script of reading the ls denoising. 
clc; 
close all; 
clear all; 

addpath('./data/image'); 
addpath('./method'); 
type = 4;
noise_level = 0.2; 

rng('default') % For reproducibility
 
[u, u_true, noise_lvl ] = image_read(noise_level, type); 
psn = psnr(u, u_true); 
mse_val = immse(u, u_true); 



f1 = figure(1); 
f1.Position = [100 100 1200 600]; 
subplot(1,2,1); 

imshow(u_true); 
title('True Image'); 
subplot(1,2,2); 

imshow(u); 
%title('Noising Image'); 
title(sprintf('Noising Image, PSNR = %.5f, MSE = %.5f', psn, mse_val), 'Color', 'black');