function [u_noising, u_true, noise_lvl] = image_read(noise_level, type)


switch type
    case 1
        u_true = imread('cameraman.tif'); 
        u_true = imresize(u_true, [256 256]); 
        u_noising = imnoise(u_true,'salt & pepper', noise_level);
        noise_lvl = u_true - u_noising; 
        
    case 2 
        u_true = imread('lena.tif'); 
        u_true = imresize(u_true, [512 512]); 
        u_noising = imnoise(u_true,'salt & pepper', noise_level);
        noise_lvl = u_true - u_noising; 
        
    case 3
        u_true = imread('einstein.tif'); 
        u_true = imresize(u_true, [1064 948]); 
        u_noising = imnoise(u_true,'salt & pepper', noise_level);
        noise_lvl = u_true - u_noising; 
        
    case 4
        u_true = imread('eiffiel.tif'); 
        u_true = im2gray(u_true); 
        u_true = imresize(u_true, [474 422]); 
        u_noising = imnoise(u_true,'salt & pepper', noise_level);
        noise_lvl = u_true - u_noising; 
    
end




end 