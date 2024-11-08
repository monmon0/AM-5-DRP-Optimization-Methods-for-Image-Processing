function [u_denoised, residuals] = solve_L1_PGD(u_true, u_noise, lambda, tolerance)

    % Initialization
    L = 2.0;
    t = 1/L;
    u_curr = u_noise;
    u_prev = u_curr; 
    result_residuals = [];  
    residual_curr = tolerance + 1;
    n = length(u_true);   % Length of signal
   
    
    while residual_curr > tolerance
        u_next = zeros(n, 1);  % Initialize the next iterate
        for i = 1:n
            % Update each element using the given formula
            temp = u_curr(i) - t * (u_curr(i) - u_true(i));
            u_next(i) = sign(temp) * max(abs(temp) - lambda * t, 0);
        end

        % Compute the residual (difference between consecutive iterations)
        residual_curr = norm(u_next - u_curr);
        result_residuals = [result_residuals, residual_curr];

        % Update the current solution and previous solution
        u_prev = u_curr;   % Update u_prev for the next iteration
        u_curr = u_next;   % Update u_curr to the new solution
    end

    u_denoised = transpose(u_curr);  % Return the denoised signal
    residuals = result_residuals;
end
