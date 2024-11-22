% script of reading the ls denoising. 
clc; 
close all; 
clear all; 

addpath('./data/image'); 
addpath('./method'); 
type = 4;
noise_level = 0.5; 

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


%----------------------------FISTA METHOD----------------------------------
% Load or create a noisy 2D image 
[x, u_true] = image_read(noise_level, type); 
tolerance = 1e-9;
lambda = 3e-5;

% Apply the FISTA method for 2D image denoising
[u_denoised_fista, residuals_fista] = solve_L1_FISTA_2D(u_true, x, lambda, tolerance);

% Convert the denoised image to original type
u_denoised_fista = cast(u_denoised_fista, class(u_true));

% Plot the results
f_combined1 = figure; 
f_combined1.Position = [200 200 800 600];

% Plot true, noisy, and denoised images
subplot(1,3,1);
imshow(u_true, []);  
title('True Image');

subplot(1,3,2);
imshow(x, []);  
title('Noisy Image');

subplot(1,3,3);
imshow(u_denoised_fista, []);  
title(['Denoised Image (FISTA), PSNR: ', ...
    num2str(psnr(u_denoised_fista, u_true)), ...
    ' dB, MSE: ', num2str(immse(u_denoised_fista, u_true))]);

%----------------------------PGD METHOD------------------------------------
% Load or create a noisy 2D image 
[x, u_true] = image_read(noise_level, type); 
tolerance = 1e-8;
lambda = 3e-5;

% Apply the FISTA method for 2D image denoising
[u_denoised_pgd, residuals_pgd] = solve_L1_PGD_2D(u_true, x, lambda, tolerance);

% Convert the denoised image to original type
u_denoised_pgd = cast(u_denoised_pgd, class(u_true));

% Plot the results
f_combined1 = figure; 
f_combined1.Position = [200 200 800 600];

% Plot true, noisy, and denoised images
subplot(1,3,1);
imshow(u_true, []);  
title('True Image');

subplot(1,3,2);
imshow(x, []);  
title('Noisy Image');

subplot(1,3,3);
imshow(u_denoised_pgd, []);  
title(['Denoised Image (PGD), PSNR: ', ...
    num2str(psnr(u_denoised_pgd, u_true)), ...
    ' dB, MSE: ', num2str(immse(u_denoised_pgd, u_true))]);



