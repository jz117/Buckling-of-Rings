P_neg = -P; % Uniformly Applied Internal Pressure

% Reinitializing the forces and velocities experienced by the deformed configuration
vx = zeros(1, N+1);
vy = zeros(1, N+1); 
Fx = zeros(1, N+1); 
Fy = zeros(1, N+1);

% Replace the corresponding entries in the finalState array
finalState(4*(N+1)+1:5*(N+1)) = vx; % Update vx
finalState(5*(N+1)+1:6*(N+1)) = vy; % Update vy
finalState(6*(N+1)+1:7*(N+1)) = Fx; % Update Fx
finalState(7*(N+1)+1:8*(N+1)) = Fy; % Update Fy


% Re-run the simulation with the final state as the initial condition
sol_negative_pressure = zeros(M, 8*(N+1));  % Initialize the solution matrix for the new simulation

% Fill the first row of sol_negative_pressure with finalState
sol_negative_pressure(1,:) = finalState;



u0 = finalState;  % Set the initial state to the final state of the previous simulation
u1 = u0; % j-1 initial guess
u2 = u0; % j-2 initial guess


i = 1;


% For example, if radius is the average radius of an irregular shape
initialDiameter = 2 * r; % Update this based on how you define initial diameter



% Define key colors for the colormap
keyColors = [0, 0, 1;  % Blue
             0, 0.5, 0;  % Green
             1, 0.5, 0;  % Orange
             1, 0.75, 0]; % Yellow

% Interpolate between key colors to create the colormap
cm = interp1(linspace(0, 1, size(keyColors, 1)), keyColors, linspace(0, 1, M));




% Track changes in shape
shapeReturnedToInitial = false;

tolerance = 0.05 * initialDiameter; % Define a tolerance, e.g., 10% of the initial diameter


figure
hold on
while i < M
    fprintf('Iteration %d out of %d total iterations unless special conditions cause the program to break early\n', i, M);
    [sol_negative_pressure(i,:), ~, exitflag, output] = fsolve(@(u) SystemOfEqns(u,N,u1,u2,P_neg,dt,ds), u0);
    x1 = sol_negative_pressure(i,1:N+1); 
    y1 = sol_negative_pressure(i,N+2:2*(N+1));



    % Calculate 'effective diameter' at this iteration
    effectiveDiameter = CalculateEffectiveDiameter(x1, y1, N);

    % Check if the effective diameter approximates the initial diameter
    if abs(effectiveDiameter - initialDiameter) <= tolerance
        % If within tolerance, assume the ring has returned to initial shape
        shapeReturnedToInitial = true;
        fprintf('Ring has returned to its initial shape. Stopping simulation on iteration %d.', i);
        break; % Exit the loop
    end


    

    if i == 1
        u2 = u0;
        u1 = sol_negative_pressure(i,:);
        u0 = u1;
    else
        u2 = sol_negative_pressure(i-1,:);
        u1 = sol_negative_pressure(i,:);
        u0 = u1;
    end
    % Check exit flag to determine if fsolve stopped prematurely
    if exitflag ~= 1  % fsolve did not converge to a solution
        disp('Solver stopped prematurely:');
        disp(output.message);
        break;  % Break out of the while loop
    end

    i = i+1;


    % Plot in 3D space
    plot3(x1, i * dt * ones(1, N+1), y1, 'Color', cm(i, :));

    % Dynamically update the title with each iteration
    current_t = (i-1) * dt; % Calculate the current time based on iteration
    titleStr = sprintf('M = %d, tf = %.2f, dt = %.4f, P = %.2f, current t = %.4f', M, tf, dt, P_neg, current_t);
    title(titleStr);
end

hold off;
xlabel('x');
ylabel('t');
zlabel('y');
view(150, 30); % Set view for 3D plotting

% Adjust the number of tick marks along the t axis
ax = gca;
ax.YTick = linspace(t0, tf, 5); % Adjust to have 5 ticks (including start and end)