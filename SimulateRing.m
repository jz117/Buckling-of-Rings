clc
close all
clear variables


P = 8; % Uniformly Applied External Pressure


t0 = 0; % Arbitrary unitless initial time
tf = 10; % Arbitrary unitless final time
M = 1000; % Number of equally sized intervals between t0 and tf
dt = (tf-t0)/M; % Step size


r = 1;
N = 256; % # of grid points
epsilon = 5 * 10^(-3); % Perturbation Bounds
R_i = epsilon * (2*rand() - 1); % Uniformly distributed random number between [-epsilon, epsilon]
fprintf('R_i = %.3f\n', R_i);

ds = 2*pi/N;  
theta = (0:N) * ds;
kappa = ones(1, N+1); 
x = r*sin(theta);
y = -r*cos(theta);
vx = zeros(1, N+1);
vy = zeros(1, N+1); 
Fx = zeros(1, N+1); 
Fy = zeros(1, N+1);  



u0 = [x, y, theta, kappa, vx, vy, Fx, Fy]; % j initial guess 
u1 = u0; % j-1 initial guess
u2 = u0; % j-2 initial guess



sol = zeros(M,8*(N+1)); % matrix of M rows by 8*(N+1) columns


i = 1;

% Define key colors for the colormap
keyColors = [0, 0, 1;  % Blue
             0, 0.5, 0;  % Green
             1, 0.5, 0;  % Orange
             1, 0.75, 0]; % Yellow

% Interpolate between key colors to create the colormap
cm = interp1(linspace(0, 1, size(keyColors, 1)), keyColors, linspace(0, 1, M));


% Setting radius around each grid point to check for intersections
radius = 0.01; 

intersectionDetected = false; % Initialize flag


figure
hold on
while i < M
    fprintf('Iteration %d out of %d total iterations unless special conditions cause the program to break early\n', i, M);
    [sol(i,:), ~, exitflag, output] = fsolve(@(u) SystemOfEqns(u,N,u1,u2,P,dt,ds), u0);
    x1 = sol(i,1:N+1); 
    y1 = sol(i,N+2:2*(N+1));
    

    % Check for intersection based on the radius
    for j = 1:N
        for offset = 10:(N-10) % Check points 10 away up to N-10 away, wrapping around
            % Calculate the index of the point to check against
            k = mod(j + offset - 1, N) + 1; % Use modular arithmetic for circular indexing
        
            dx = x1(j) - x1(k);
            dy = y1(j) - y1(k);
            distance = sqrt(dx^2 + dy^2);
        
            if distance <= 2*radius
                fprintf('Intersection detected based on radius. Stopping on iteration %d.', i);
                intersectionDetected = true;
                break; % Exit the inner loop
            end
        end
        if intersectionDetected
            break; % Exit the outer loop if an intersection is detected
        end
    end

    if intersectionDetected
        % If intersection detected, break before updating state and plotting
        break;
    end



    if i == 1
        u2 = u0;
        u1 = sol(i,:);
        u0 = u1;
        R_i = epsilon * (2*rand() - 1); % Uniformly distributed random number between [-epsilon, epsilon]
        u0(1:N+1) = (1 + R_i)*u0(1:N+1);
        u0(N+2:2*(N+1)) = (1 + R_i)*u0(N+2:2*(N+1));
    else
        u2 = sol(i-1,:);
        u1 = sol(i,:);
        u0 = u1;
        R_i = epsilon * (2*rand() - 1); % Uniformly distributed random number between [-epsilon, epsilon]
        u0(1:N+1) = (1 + R_i)*u0(1:N+1);
        u0(N+2:2*(N+1)) = u0(N+2:2*(N+1));
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
    titleStr = sprintf('M = %d, tf = %.2f, dt = %.4f, P = %.2f, current t = %.4f', M, tf, dt, P, current_t);
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