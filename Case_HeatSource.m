%-------------------------------------------------------------------------%
% INPUT SCRIPT FOR The effect of an internal heat source
% Coded by R.Kurniawan
%-------------------------------------------------------------------------%

clear; close all; clc;
path2add1 = [pwd,'\','_TOOLBOX']; addpath(genpath(path2add1)); 
path2add2 = [pwd,'\','_INPUT']; addpath(genpath(path2add2)); 
outfolder = [pwd,'\OUTPUT\'];  fun_check_n_makefolder(outfolder);   % OUTPUT FOLDER

%% %%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
casename = 'HeatSource';
geometry = input('Input geometry, as Circular or Triangular or Square or Hexagonal or Star or David: ','s');

%% --------- PARAMETERS-----------------------------------------------------%
dt   = 0.02;    % speficied dt
t0    = 0;      % T-start of simulation [s]
T     = 30;     % T-final of simulation [s]
dtOUT = 0.5;    % dt out (for animation & output)

% Plain carbon steel in cm
particle.rho   = 7.854e-3;        % specific mass       [kg/cm^3]
particle.ka    = 0.605;        % thermal conductivit [W/(cm*K)]
particle.Cp    = 434;         % thermal capacity    [J/(kg*K)]
particle.alpha = particle.ka/(particle.rho*particle.Cp); % thermal difusivity  [cm^2/s]

%% ---------- DOMAIN-------------------------------------------------%
Lx = 10; % Length of plate
Ly = 10; % Width of plate
area = Lx*Ly;  % Area of plate

dx = 0.2; dy = 0.2; % initial particles distance [cm]

% Generate vector positions
switch geometry
    case 'Circular'
        g =[2  0.3  9.7  0.3  0.3  1  0   0    0    0
            2  9.7  9.7  0.3  9.7  1  0   0    0    0
            2  9.7  0.3  9.7  9.7  1  0   0    0    0
            2  0.3  0.3  9.7  0.3  1  0   0    0    0
            1  4   5   5   4   1  1   5  5  1
            1  5   6   4   5   1  1   5  5  1
            1  6   5   5   6   1  1   5  5  1
            1  5   4   6   5   1  1   5  5  1]';
    case 'Triangular'
        g =[2  0.3     9.7     0.3     0.3     1  0
            2  9.7     9.7     0.3     9.7     1  0
            2  9.7     0.3     9.7     9.7     1  0
            2  0.3     0.3     9.7     0.3     1  0
            2  3.653   5      4.223   6.555   1  1 %start triangle
            2  5      6.347   6.555   4.223   1  1
            2  6.347   3.653   4.223   4.223   1  1]';
    case 'Square'
        g =[2  0.3     9.7     0.3     0.3     1  0
            2  9.7     9.7     0.3     9.7     1  0
            2  9.7     0.3     9.7     9.7     1  0
            2  0.3     0.3     9.7     0.3     1  0
            2  4.114   5.886   4.114   4.114   1  1
            2  5.886   5.886   4.114   5.886   1  1
            2  5.886   4.114   5.886   5.886   1  1
            2  4.114   4.114   5.886   4.114   1  1]';
    case 'Hexagonal'
        g =[2  0.3     9.7     0.3     0.3     1  0
            2  9.7     9.7     0.3     9.7     1  0
            2  9.7     0.3     9.7     9.7     1  0
            2  0.3     0.3     9.7     0.3     1  0
            2  3.9004   4.4502   5   5.9523   1  1
            2  4.4502   5.5498   5.9523   5.9523   1  1
            2  5.5498   6.0996   5.9523   5   1  1
            2  6.0996   5.5498   5   4.0477   1  1
            2  5.5498   4.4502   4.0477   4.0477   1  1
            2  4.4502   3.9004   4.0477   5   1  1]';
    case 'Star'
        g =[2  0.3     9.7     0.3     0.3     1  0
            2  9.7     9.7     0.3     9.7     1  0
            2  9.7     0.3     9.7     9.7     1  0
            2  0.3     0.3     9.7     0.3     1  0
            2  4.017   4.392   3.647   4.803   1  1 %start star
            2  4.392   3.409   4.803   5.517   1  1
            2  3.409   4.624   5.517   5.517   1  1
            2  4.624   5      5.517   6.673   1  1
            2  5      5.376   6.673   5.517   1  1
            2  5.376   6.591   5.517   5.517   1  1
            2  6.591   5.608   5.517   4.803   1  1
            2  5.608   5.983   4.803   3.647   1  1
            2  5.983   5      3.647   4.361   1  1
            2  5      4.017   4.361   3.647   1  1]';
    case 'David'
        g =[2  0.3     9.7     0.3     0.3     1  0
            2  9.7     9.7     0.3     9.7     1  0
            2  9.7     0.3     9.7     9.7     1  0
            2  0.3     0.3     9.7     0.3     1  0
            2  3.833   4.222   4.326   5      1  1 %start star
            2  4.222   3.833   5      5.674   1  1
            2  3.833   4.611   5.674  5.674   1  1
            2  4.611  5      5.674   6.347   1  1
            2  5      5.389   6.347   5.674   1  1
            2  5.389   6.167   5.674   5.674   1  1
            2  6.167   5.778   5.674   5      1  1
            2  5.778   6.167   5      4.326   1  1
            2  6.167   5.389   4.326  4.326   1  1
            2  5.389  5      4.326   3.653   1  1
            2  5      4.611   3.653   4.326   1  1
            2  4.611   3.833   4.326   4.326   1  1]';
end

a = -1/2*dx:dx:10+1/2*dx;
b = -1/2*dy:dy:10+1/2*dy;
[b1,a1] = ndgrid(a,b);
dom = [a1(:),b1(:)];
Do_x = dom(:,1);
Do_y = dom(:,2);

idx = find(Do_x>=0.3 & Do_x<=9.7 & Do_y>=0.3 & Do_y<=9.7);
Do_x(idx)=[];
Do_y(idx)=[];

[p, e, t]=initmesh(g,'hmax',dx);
Omega_x=p(1,:)';
Omega_y=p(2,:)';
x=[Omega_x;Do_x];
y=[Omega_y;Do_y];

N = length(x);

% Real particles  pre-allocation:  
  particleReal.x  = zeros(N,1);         % position x-axis          [cm]
  particleReal.y  = zeros(N,1);         % position y-axis          [cm]
  particleReal.T  = zeros(N,1);         % particle temperature     [ºC]
% Ghost particles pre-allocation:  
  particleGhost.x = zeros(N,1);         % position x-axis          [cm]
  particleGhost.y = zeros(N,1);         % position y-axis          [cm]
  particleGhost.T = zeros(N,1);         % particle temperature     [ºC]

% Number of particles:   
  numRealParticles  = 0;                % number of real particles 
  numGhostParticles = 0;                % number of ghost particles

switch geometry
    case 'Circular'
        for i = 1:length(x)
            if ((x(i) <= 0 || x(i) >= Lx || y(i) <= 0 || y(i) >= Ly) ||...
                    ((x(i)-5)^2+(y(i)-5)^2 < 1.1))
            % ghost particles
                numGhostParticles = numGhostParticles + 1;
                particleGhost.x(numGhostParticles) = x(i); 
                particleGhost.y(numGhostParticles) = y(i);                
            else
            % real particles
                numRealParticles = numRealParticles + 1;
                particleReal.x(numRealParticles) = x(i); 
                particleReal.y(numRealParticles) = y(i);            
            end
        end
    case 'Triangular'
        for i = 1:length(x)
            if ((x(i) <= 0 || x(i) >= Lx || y(i) <= 0 || y(i) >= Ly) ||...
                    (y(i) <= 1.7312*x(i)-2.10 && y(i) <= -1.7312*x(i)+15.212 && y(i) >= 4.223))
            % ghost particles
                numGhostParticles = numGhostParticles + 1;
                particleGhost.x(numGhostParticles) = x(i); 
                particleGhost.y(numGhostParticles) = y(i);                
            else
            % real particles
                numRealParticles = numRealParticles + 1;
                particleReal.x(numRealParticles) = x(i); 
                particleReal.y(numRealParticles) = y(i);            
            end
        end
    case 'Square'
        for i = 1:length(x)
            if ((x(i) <= 0 || x(i) >= Lx || y(i) <= 0 || y(i) >= Ly) ||...
                    (x(i) >= 4.113 && x(i) <= 5.887 && y(i) >= 4.113 && y(i) <= 5.887))
            % ghost particles
                numGhostParticles = numGhostParticles + 1;
                particleGhost.x(numGhostParticles) = x(i); 
                particleGhost.y(numGhostParticles) = y(i);                
            else
            % real particles
                numRealParticles = numRealParticles + 1;
                particleReal.x(numRealParticles) = x(i); 
                particleReal.y(numRealParticles) = y(i);            
            end
        end
    case 'Hexagonal'
        for i = 1:length(x)
            if ((x(i) <= 0 || x(i) >= Lx || y(i) <= 0 || y(i) >= Ly) ||...
                    (y(i) <= 1.7321*x(i)-1.7558 && y(i) <= 5.9523 && y(i) <= -1.7321*x(i)+15.5652 &&...
                    y(i) >= 1.7321*x(i)-5.5652 && y(i) >= 4.0477 && y(i) >= -1.7321*x(i)+11.7558))
            % ghost particles
                numGhostParticles = numGhostParticles + 1;
                particleGhost.x(numGhostParticles) = x(i); 
                particleGhost.y(numGhostParticles) = y(i);                
            else
            % real particles
                numRealParticles = numRealParticles + 1;
                particleReal.x(numRealParticles) = x(i); 
                particleReal.y(numRealParticles) = y(i);            
            end
        end
    case 'Star'
        for i = 1:length(x)
            if ((x(i) <= 0 || x(i) >= Lx || y(i) <= 0 || y(i) >= Ly) ||...
                    (y(i) <= 3.0783*x(i)-8.717 && y(i) >= 0.7264*x(i)+0.727 && y(i) <= -3.0783*x(i)+22.066) ||...
                    (y(i) <= 3.0783*x(i)-8.717 && y(i) >= 0.7264*x(i)+0.727 && y(i) <= 5.518) ||...
                    (y(i) <= -3.0783*x(i)+22.066 && y(i) >= -0.7264*x(i)+7.992 && y(i) <= 5.518))
            % ghost particles
                numGhostParticles = numGhostParticles + 1;
                particleGhost.x(numGhostParticles) = x(i); 
                particleGhost.y(numGhostParticles) = y(i);                
            else
            % real particles
                numRealParticles = numRealParticles + 1;
                particleReal.x(numRealParticles) = x(i); 
                particleReal.y(numRealParticles) = y(i);            
            end
        end
    case 'David'
        for i = 1:length(x)
            if ((x(i) < 0 || x(i) > Lx || y(i) < 0 || y(i) > Ly) ||...
                    (y(i) <= 1.7318*x(i)-2.311 && y(i) <= -1.7318*x(i)+15.007 && y(i) >= 4.325) ||...
                    (y(i) >= -1.7318*x(i)+12.311 && y(i) >= 1.7318*x(i)-5.007 && y(i) <= 5.675))
            % ghost particles
                numGhostParticles = numGhostParticles + 1;
                particleGhost.x(numGhostParticles) = x(i); 
                particleGhost.y(numGhostParticles) = y(i);                
            else
            % real particles
                numRealParticles = numRealParticles + 1;
                particleReal.x(numRealParticles) = x(i); 
                particleReal.y(numRealParticles) = y(i);            
            end
        end
end

particle.x = [ particleReal.x( 1:numRealParticles ) ; ...
               particleGhost.x(1:numGhostParticles)]; 
particle.y = [ particleReal.y( 1:numRealParticles ) ; ...
               particleGhost.y(1:numGhostParticles)]; 
particle.T = [ particleReal.T( 1:numRealParticles ) ; ...
               particleGhost.T(1:numGhostParticles)];  

debug = 1;  % plot initial condition?

h   = 1.2*dx; % smoothing length
xi  = 1;      % numerical height [dm]       
particle.m  = particle.rho*area*xi/numRealParticles;  % particle mass [kg]

%% --------- INITIAL CONDITIONS---------------------------------------------%
IC_particle.T = 300*ones(N,1);

%% --------- BOUNDARY CONDITIONS---------------------------------------------%
func_BC = @BC_Neumann_HeatSource;

%% %%%%%%%%%%%%%%%%%%%%%% OUTPUT : Output setting %%%%%%%%%%%%%%%%%%%%%%%%
postprocessing  = 1;       % do post-processing? 1 for yes, 0 for no.
%--------ANIMATION--------------------------------------------------------%
save_gif     = 1;        % save the animation as gif? 1 for yes 
savename_gif = geometry; % save name for the gif file
tstartAnim   = t0;   % starting time of the simulation [s]
tendAnim     = T;    % ending time of the simulation [s]    
delayGif     = 0.1;                 % Delay time for the *gif file    
outfolder    = [outfolder, casename,'\'];  fun_check_n_makefolder(outfolder);   % OUTPUT FOLDER
savename     = [outfolder, geometry ];% savename for the data

% setting for plot during animation
xlimaxis     = [0, 10];   % xaxis
ylimaxis     = [0, 10];   % yaxis
minmaxTemperature = [300; 373];
CRange = (minmaxTemperature(1):4:minmaxTemperature(2));

plotduringsim= 0;       % plot during the simulation? 1 for yes, 0 for no.

%-------SNAPSHOT DATA-------------------------------------------------%
t_snap     = [];  % time for snapshot during the simulation


%% %%%%%%%%%%%%%%%%%%%%%%%% CALL MAIN SCRIPT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAIN_SPH_2D;
