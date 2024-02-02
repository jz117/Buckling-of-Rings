% The purpose of this script is to generate a 2D plot of the selected ring
% configuratrion and displays the prior configurations too

i = 1;
final = 793; % Adjust this value such that it's <= final iteration value

figure;
hold on; % Hold on to plot multiple frames

% Define key colors for the colormap: blue, green, orange, yellow
keyColors = [0, 0, 1;  % Blue
             0, 0.5, 0;  % Green
             1, 0.5, 0;  % Orange
             1, 0.75, 0]; % Yellow

% Interpolate between key colors to create the colormap
cm = interp1(linspace(0, 1, size(keyColors, 1)), keyColors, linspace(0, 1, final));

while i < M
    if i <= final
        x1 = sol(i, 1:N+1); 
        y1 = sol(i, N+2:2*(N+1));

        % Select color based on the iteration number
        plotColor = cm(i, :);

        plot(x1, y1, 'Color', plotColor);

        % Update the title with each iteration
        current_t = (i-1) * dt; % Calculate the current time based on iteration
        titleStr = sprintf('M = %d, tf = %.2f, dt = %.4f, P = %.2f, Plot number = %d, , current t = %.4f', M, tf, dt, P, final, current_t);
        title(titleStr);

        i = i + 1;
    else
        break;
    end
end

hold off; % Release the plot hold

% Labeling the axes
xlabel('x');
ylabel('y');


finalState = sol(final,:);