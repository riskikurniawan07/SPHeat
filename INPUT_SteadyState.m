%-------------------------------------------------------------------------%
% INPUT SCRIPT FOR Steady-state heat conduction
% Coded by R.Kurniawan
%-------------------------------------------------------------------------%

clear; close all; clc;
path2add1 = [pwd,'\','_TOOLBOX']; addpath(genpath(path2add1)); 
path2add2 = [pwd,'\','_INPUT']; addpath(genpath(path2add2)); 
outfolder = [pwd,'\OUTPUT\'];  fun_check_n_makefolder(outfolder);   % OUTPUT FOLDER

%% %%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
casename = 'SteadyState';

%% --------- PARAMETERS-----------------------------------------------------%
dt   = 0.02;    % speficied dt
t0    = 0;      % T-start of simulation [s]
T     = 300;    % T-final of simulation [s]
dtOUT = 5;      % dt out (for animation & output)

% Plain carbon steel in dm
particle.rho   = 7.854;       % specific mass       [kg/dm^3]
particle.ka    = 6.05;        % thermal conductivit [W/(dm*K)]
particle.Cp    = 434;         % thermal capacity    [J/(kg*K)]
particle.alpha = particle.ka/(particle.rho*particle.Cp); % thermal difusivity  [dm^2/s]

%% ---------- DOMAIN-------------------------------------------------%
Lx = 1; % Length of plate
Ly = 1; % Width of plate
area = Lx*Ly;  % Area of plate

dx = 0.02; dy = 0.02; % initial particles distance

% Generate vector positions
a = 0:dx:Lx;
b = 0:dy:Ly;
[b1,a1] = ndgrid(a,b);
dom = [a1(:),b1(:)];
x = dom(:,1);
y = dom(:,2);

N = length(x);

%% Define real and ghost particles
% Real particles  pre-allocation:  
  particleReal.x  = zeros(N,1);         % position x-axis          [dm]
  particleReal.y  = zeros(N,1);         % position y-axis          [dm]
  particleReal.T  = zeros(N,1);         % particle temperature     [ºC]
% Ghost particles pre-allocation:  
  particleGhost.x = zeros(N,1);         % position x-axis          [dm]
  particleGhost.y = zeros(N,1);         % position y-axis          [dm]
  particleGhost.T = zeros(N,1);         % particle temperature     [ºC]
% Number of particles:   
  numRealParticles  = 0;                % number of real particles 
  numGhostParticles = 0;                % number of ghost particles

for i = 1:length(x)
    if (x(i) <= 0 || x(i) >= Lx || y(i) <= 0 || y(i) >= Ly) 
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

particle.x = [ particleReal.x( 1:numRealParticles ) ; ...
               particleGhost.x(1:numGhostParticles)]; 
particle.y = [ particleReal.y( 1:numRealParticles ) ; ...
               particleGhost.y(1:numGhostParticles)]; 
particle.T = [ particleReal.T( 1:numRealParticles ) ; ...
               particleGhost.T(1:numGhostParticles)];  

debug = 1;  % plot particles arrangement?

h   = 1.2*dx; % smoothing length
xi  = 1;      % numerical height [dm]       
particle.m  = particle.rho*area*xi/numRealParticles;  % particle mass [kg]

%% --------- INITIAL CONDITIONS---------------------------------------------%
IC_particle.T = zeros(N,1);

%% --------- BOUNDARY CONDITIONS---------------------------------------------%
func_BC = @BC_SteadyState;

%% %%%%%%%%%%%%%%%%%%%%%% OUTPUT : Output setting %%%%%%%%%%%%%%%%%%%%%%%%
postprocessing  = 1;       % do post-processing? 1 for yes, 0 for no.
%--------ANIMATION--------------------------------------------------------%
save_gif     = 1;        % save the animation as gif? 1 for yes 
savename_gif = casename; % save name for the gif file
tstartAnim   = t0;       % starting time of the simulation [s]
tendAnim     = T;        % ending time of the simulation [s]    
delayGif     = 0.1;      % Delay time for the *gif file    
savename     = [outfolder, casename ];% savename for the data

% setting for plot during animation
xlimaxis     = [0, 1];   % xaxis
ylimaxis     = [0, 1];   % yaxis
minmaxTemperature = [0; 127.5];
CRange = (minmaxTemperature(1):5:minmaxTemperature(2));

plotduringsim= 0;       % plot during the simulation? 1 for yes, 0 for no.

%-------SNAPSHOT DATA-------------------------------------------------%
t_snap     = [0 10 T];  % time for snapshot during the simulation


%% %%%%%%%%%%%%%%%%%%%%%%%% CALL MAIN SCRIPT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAIN_SPH_2D;