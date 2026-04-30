%-------------------------------------------------------------------------%
% MAIN SCRIPT for pre-processing, main-processing, and postprocessing of SPH for Heat Conduction Simulation
% Coded by R.Kurniawan
%-------------------------------------------------------------------------%
% VER 20251017

%% 1. PREPARATION; DOMAIN, TIME, and INITIAL CONDITION

% Create regular grid across data space
[X,Y] = meshgrid(linspace(min(particle.x),max(particle.x)), linspace(min(particle.y),max(particle.y)));

% --------- TIME ---------------------------------------------------------%
t     = (t0 : dt : T)';    % time domain
Nt    = length(t);         % # discretization in time
tOUT  = (t0 : dtOUT : T)'; % OUTPUT time domain
NtOUT = length(tOUT);      % # discretization in OUTPUT time

% OUTPUT Variable
uOUT = zeros(N,NtOUT);

% Plot particles arrangement
if debug == 1
    f100=figure; set(f100,'color',[1 1 1],'Position',[100 100 580 500]);
    scatter(particle.x(1:numRealParticles),particle.y(1:numRealParticles),'filled')
    hold on
    scatter(particle.x(numRealParticles+1:N),particle.y(numRealParticles+1:N),'filled')
    legend('Real Particles','Ghost Particles')
    xlim([min(x),max(x)])
    ylim([min(y),max(y)])
    axis equal
    xlabel('$x$','interpreter','latex')
    ylabel('$y$','interpreter','latex')
    set(gca,'fontsize',14)
end

%% --------- INITIAL CONDITIONS--------------------------------------------%

particle.T = IC_particle.T;
uOUT(:,1) = particle.T;

%% Neighborhood and Kernel
neighbor = neighborhood(particle, h, numRealParticles, N);

kernelOpt = 1;
kernelDim = 2;

%% TIME INTEGRATION
err   = 10;   
DT2   = zeros(N,1);
DT1   = zeros(N,1);
auxParticle = particle;

%% MAIN CALCULATION; TIME STEPPING
% 0. Preparation
if plotduringsim==0
    progressbar('Time Stepping of SPH');
end % initiate progress
counter = 2;

tic
for k=2:Nt
  
    oldParticle = particle;
    
    % 1. LAGRANGIAN TIME DERIVATE
    DT = heat(numRealParticles,particle,neighbor,h,...
              kernelDim,kernelOpt);       

    % 2. EULERIAN TIME INTEGRATION
    particle.T(1:numRealParticles) = integration(particle,...
                                              numRealParticles,DT,dt);

    err = norm(particle.T(1:N) - oldParticle.T(1:N));

    % 3. BC
    particle = func_BC(particle,numRealParticles,N,Lx,Ly,dx,dy,t(k));

    %% 4. PLOTTING & saving u
    if mod(t(k),dtOUT) == 0
        
        uOUT(:,counter) = particle.T;
        counter = counter + 1;

        if plotduringsim==1
            contourf(X,Y,griddata(particle.x,particle.y,particle.T,X,Y),CRange, 'EdgeColor','none')
            colormap jet
            clim(minmaxTemperature)
            colorbar
            title(['t = ', num2str(t(k)), ' s'])
            xlabel('$x$','interpreter','latex');
            ylabel('$y$','interpreter','latex');
            xlim([min(x),max(x)])
            ylim([min(y),max(y)])
            axis equal
            set(gca,'FontSize',14)
            pause(0.01);
        
            % save as gif
            saveas_gif_with_itstart(save_gif, [outfolder, savename_gif], k, NtOUT, 1, delayGif);
        else
            progressbar(k/Nt) % Update progress bar
        end
    end
end
if plotduringsim==0
    progressbar(1);
end %closing progressbar

Ttoc = toc;
disp(['CPU time for time-stepping : ',num2str(Ttoc/60),' min']);

%% 3. SAVING THE DATA 
save(savename);
disp(['Save all data as ..  ', savename]);

if postprocessing==1
%% 4. POSTPROCESSING  

% --------- PLOTTING ANIMATION -------------------------------------------%
f100=figure; set(f100,'color',[1 1 1],'Position',[100 80 650 600]);

for ii = 1:NtOUT
    contourf(X,Y,griddata(particle.x,particle.y,uOUT(:,ii),X,Y),CRange, 'EdgeColor','none')
    colormap jet
    clim(minmaxTemperature)
    colorbar
    title(['t = ', num2str(tOUT(ii)), ' s'])
    xlabel('$x$','interpreter','latex');
    ylabel('$y$','interpreter','latex');
    xlim([min(x),max(x)])
    ylim([min(y),max(y)])
    axis equal
    set(gca,'FontSize',14)
    pause(0.01);

    % save as gif
    saveas_gif_with_itstart(save_gif, [outfolder, savename_gif], ii, NtOUT, 1, delayGif);
end

%%
% SNAP SHOT OF SIMULATION
if ~isempty(t_snap)
    Ns = length(t_snap);
    ft = figure;
    set(ft,'Position',[51   175   1200   400]); set(gca,'Position',[0.0665    0.1641    0.9146    0.7375], 'FontSize',14);
    tiledlayout(1,Ns,'TileSpacing','compact');
    for ii = 1:Ns

        tS   = t_snap(ii);
        uS = interp1(tOUT, permute(uOUT, [2 1]), tS, 'linear');
    
        ax = nexttile;
        contourf(X,Y,griddata(particle.x,particle.y,uS',X,Y),CRange, 'EdgeColor','none')
        colormap jet
        clim(minmaxTemperature)
        % colorbar
        title(['t = ',num2str(tS),' s']);
        xlabel('$x$','interpreter','latex');
        xlim([min(x),max(x)])
        ylim([min(y),max(y)])
        set(gca,'FontSize',14)
        % --- hanya subplot paling bawah yang punya xtick ---
        if ii > 1
            ax.YTickLabel = [];
        else
            ylabel('$y$','interpreter','latex')
        end
    
        % SAVING
        % saveas(ft,[casename,'.fig'],'fig');
        % saveas(ft,[casename,'.png'],'png');
    end
end % end of t_snap

end % end of postprocessing