%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                   SMOOTHED PARTICLE HYDRODYNAMICS                   %%%
%%%                       HEAT CONDUCTION BALANCE                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name  : Almério José Venâncio Pains Soares Pamplona                     %
% Date  : 29.06.2019                                                      %
% E-mail: almeriopamplona@gmail.com                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION:                                                            %
%                                                                         %
% This code calculates the temperature derivative using the SPH approxi-  %
% mation of the energy balance.                                           %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:                                                                  %
%                                                                         %
% h                : Smoothed lenght                             [double] %
% particle         : Particle position x-axis                    [struct] %
% numRealParticles : Real particles number                       [int]    %
%                                                                         %
% OUTPUT: --------------------------------------------------------------- %
%                                                                         %
% DT        : Lagrangian time derivative                                  %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 function DT = heat(numRealParticles,particle,neighbor,h,...
                   kernelDim,kernelOpt)

DT = zeros(numRealParticles,1);


for i = 1:numRealParticles
    for j = 1:neighbor(i,1) % banyak tetangga partikel-i
        
      % neighbor counter        
        k    = neighbor(i,j+1); 
        
      % distance between particles on x-axis
        xji  = particle.x(k) - particle.x(i);
        
      % distance between particles on y-axis
        yji  = particle.y(k) - particle.y(i);
        
      % distance norm between particles 
        if kernelDim == 2
            rji  = sqrt(xji^2 + yji^2);
        elseif kernelDim == 3
            zji  = particle.z(k) - particle.z(i);
            rji  = sqrt(xji^2 + yji^2 + zji^2);
        end
                
      % Kernel gradient on x-axis
        dwxji = xji*DW(kernelDim,kernelOpt,rji,h)/(rji*h);            
        
      % Kernel gradient on y-axis
        dwyji = yji*DW(kernelDim,kernelOpt,rji,h)/(rji*h);

        if kernelDim == 2
            % Kernel gradient vector
            dw  = [dwxji; dwyji];
            x = [xji; yji];
        elseif kernelDim == 3
            % Kernel gradient on z-axis
            dwzji = zji*DW(kernelDim,kernelOpt,rji,h)/(rji*h);
            dw  = [dwxji; dwyji; dwzji];
            x = [xji; yji; zji]; 
        end
             
      % Corrected gradient kernel
        Fji = dot(x,dw)/(rji^2 + (0.01*h)^2);
        
      % heat conduction balance
        deltaT = particle.T(k) - particle.T(i);
        DT(i) = DT(i) - 2*particle.m*particle.alpha*deltaT*Fji/particle.rho;
             
    end
end

end
