function [u_denoised, residuals] = solve_L1_IRLS_2D(u_true, u_noise, lambda, tolerance)
    
% convert to double precision
    u_true = double(u_true);
    u_noise = double(u_noise);

    [m, n] = size(u_noise); 
    
    u_curr = u_noise;
    u_prev = zeros(m, n);
    epsilon = 1e-4; % Small constant to avoid division by zero
    
    % Create difference operators for horizontal and vertical directions
    Dx = spdiags([-ones(n,1), ones(n,1)], [0, 1], n, n);
    Dx(n,n) = 0; % Ensure no wrapping
    Dx = kron(speye(m), Dx); % Expand to handle 2D
    
    Dy = spdiags([-ones(m,1), ones(m,1)], [0, 1], m, m);
    Dy(m,m) = 0; % Ensure no wrapping
    Dy = kron(Dy, speye(n)); % Expand to handle 2D

    residual = [];
    
    while norm(u_curr(:) - u_prev(:), 2) > tolerance
        % Compute differences in both directions
        Dxu = Dx * u_curr(:);
        Dyu = Dy * u_curr(:);
        
        % Compute weights for the IRLS process
        Wx = spdiags(1 ./ sqrt(Dxu.^2 + epsilon), 0, numel(Dxu), numel(Dxu));
        Wy = spdiags(1 ./ sqrt(Dyu.^2 + epsilon), 0, numel(Dyu), numel(Dyu));
        
        % Construct the weighted regularization matrix
        L = lambda * (Dx' * Wx * Dx + Dy' * Wy * Dy);
        
        % Solve the linear system
        u_prev = u_curr;
        A = speye(m * n) + 2 * L; % Regularized system matrix
        u_curr = reshape(A \ u_true(:), m, n); % Solve and reshape to 2D
        
        % Calculate residual
        residual = [residual, norm(u_curr(:) - u_prev(:), 2)];
        % disp(norm(u_curr(:) - u_prev(:), 2)); 
    end
    
    u_denoised = u_curr;
    residuals = residual;
end

