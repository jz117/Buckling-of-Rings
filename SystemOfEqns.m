function [F] = SystemOfEqns(u,N,u1,u2,P,dt,ds)

    % Initialize equations
    eq1 = zeros(1,N+1); % dx/ds      
    eq2 = zeros(1,N+1); % dy/ds    
    eq3 = zeros(1,N+1); % dtheta/ds      
    eq4 = zeros(1,N+1); % dkappa/ds    
    eq5 = zeros(1,N+1); % dx/dt      
    eq6 = zeros(1,N+1); % dy/dt      
    eq7 = zeros(1,N+1); % dFx/ds      
    eq8 = zeros(1,N+1); % dFy/ds

    % x = u(i)
    % y = u(i + Nvar)
    % theta = u(i + 2*Nvar)
    % kappa = u(i + 3*Nvar)
    % vx = u(i + 4*Nvar)
    % vy = u(i + 5*Nvar)
    % Fx = u(i + 6*Nvar)
    % Fy = u(i + 7*Nvar)

    for i = 1:N
        ip1 = i+1;
        Nvar = N+1;

        % System of eqns
        eq1(i) = - 1/ds*(u(ip1) - u(i)) + cos((u(i + 2*(Nvar)) + u(ip1 + 2*(Nvar)))/2); 
        eq2(i) = - 1/ds*(u(ip1 + (Nvar)) - u(i + (Nvar))) + sin((u(i + 2*(Nvar)) + u(ip1 + 2*(Nvar)))/2); 
        eq3(i) = - 1/ds*(u(ip1 + 2*(Nvar)) - u(i + 2*(Nvar))) + (u(i + 3*(Nvar)) + u(ip1 + 3*(Nvar)))/2; 
        eq4(i) = - 1/ds*(u(ip1 + 3*(Nvar)) - u(i + 3*(Nvar))) + (u(i + 6*(Nvar)) + u(ip1 + 6*(Nvar)))/2*sin((u(i + 2*(Nvar)) + u(ip1 + 2*(Nvar)))/2) - (u(i + 7*(Nvar)) + u(ip1 + 7*(Nvar)))/2*cos((u(i + 2*(Nvar)) + u(ip1 + 2*(Nvar)))/2); 
        eq5(i) = - u(i + 4*(Nvar)) + 1/dt*(3/2*u(i) - 2*u1(i) + 1/2*u2(i)); 
        eq6(i) = - u(i + 5*(Nvar)) + 1/dt*(3/2*u(i + (Nvar)) - 2*u1(i + (Nvar)) + 1/2*u2(i + (Nvar)));
        eq7(i) = - 1/ds*(u(ip1 + 6*(Nvar)) - u(i + 6*(Nvar))) + P*sin((u(i + 2*(Nvar)) + u(ip1 + 2*(Nvar)))/2) + 1/dt*(3/2*(u(i + 4*(Nvar)) + u(ip1 + 4*(Nvar)))/2 - 2*(u1(i + 4*(Nvar)) + u1(ip1 + 4*(Nvar)))/2 + 1/2*(u2(i + 4*(Nvar)) + u2(ip1 + 4*(Nvar)))/2); 
        eq8(i) = - 1/ds*(u(ip1 + 7*(Nvar)) - u(i + 7*(Nvar))) - P*cos((u(i + 2*(Nvar)) + u(ip1 + 2*(Nvar)))/2) + 1/dt*(3/2*(u(i + 5*(Nvar)) + u(ip1 + 5*(Nvar)))/2 - 2*(u1(i + 5*(Nvar)) + u1(ip1 + 5*(Nvar)))/2 + 1/2*(u2(i + 5*(Nvar)) + u2(ip1 + 5*(Nvar)))/2); 
    end

    % Enforcing the periodic boundary conditions for the last element
    eq1(N+1) = u(N+1) - u(1);  % x(2pi, t) = x(0,t)
    eq2(N+1) = u(2*(N+1)) - u(1 + (N+1));  % y(2pi,t) = y(0,t)
    eq3(N+1) = u(3*(N+1)) - u(1 + 2*(N+1)) - 2*pi;  % theta(2pi,t) = theta(0,t) + 2π
    eq4(N+1) = u(4*(N+1)) - u(1 + 3*(N+1)); % kappa(2pi,t) = kappa(0,t)    
    eq5(N+1) = u(5*(N+1)) - u(1 + 4*(N+1)); % vx(2pi,t) = vx(0,t)
    eq6(N+1) = u(6*(N+1)) - u(1 + 5*(N+1)); % vy(2pi,t) = vy(0,t)  
    eq7(N+1) = u(7*(N+1)) - u(1 + 6*(N+1));  % F_x(2π, t) = F_x(0, t)
    eq8(N+1) = u(8*(N+1)) - u(1 + 7*(N+1));  % F_y(2π, t) = F_y(0, t) 

    

    % Concatenate all equations into a single vector
    F = [eq1,eq2,eq3,eq4,eq5,eq6,eq7,eq8];
end