function [u_denoised, residuals] = solve_L1_PGD_2D(u_true, u_noise, lambda, tolerance)
    % Convert inputs to double precision if they aren't already
    u_true = double(u_true);
    u_noise = double(u_noise);

    % Initialization
    L = 2.0;
    t = 1 / L;
    u_curr = u_noise;
    result_residuals = [];  
    residual_curr = tolerance + 1;
   
    while residual_curr > tolerance
        % Vectorized update using the formula for each element
        temp = u_curr - t * (u_curr - u_true);  % Gradient step
        u_next = double(sign(temp) .* max(abs(temp) - lambda * t, 0));  % Soft thresholding
        
        % Compute the residual (difference between consecutive iterations)
        residual_curr = norm(u_next - u_curr, 'fro');
        result_residuals = [result_residuals, residual_curr];

        % Update the current solution and previous solution
        u_curr = u_next; 
    end

    u_denoised = u_curr;  % Final denoised signal
    residuals = result_residuals;
end

