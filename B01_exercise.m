% -------------------------------------------------------------------------
%       Acoustic wave equation finite difference simulator
% -------------------------------------------------------------------------

% ----------------------------------------
% Practice with the examples (files named "A**_exercise.m"), 
% by changing source/receiver position, source type, velocity values

clear all; close all; clc;

% 1. MODEL PARAMETERS (Two-Layer Model)
model.x = 0:1:1000;         
model.z = 0:1:500;          
Nx = numel(model.x);
Nz = numel(model.z);

% Define velocity model
z_interface = 250;          
model.vel = zeros(Nz,Nx);   
for kx=1:Nx
  for kz=1:Nz
    if model.z(kz) > z_interface
      model.vel(kz,kx) = 2500; % Lower layer (Fast)
    else
      model.vel(kz,kx) = 1000; % Upper layer (Slow)
    end
  end
end

% 2. SOURCE PARAMETERS
source.x    = 500;          
source.z    = 50;           
source.f0   = 30;           
source.t0   = 0.04;         
source.amp  = 1;            
source.type = 1;            

% 3. RECEIVER PARAMETERS
model.recx  = 100:20:900;   
model.recz  = ones(size(model.recx)) * 5; 
model.dtrec = 0.004;        
Nr = numel(model.recx);

% 4. SIMULATION PARAMETERS
simul.borderAlg  = 1;       
simul.timeMax    = 0.8;     
simul.printRatio = 10;      
simul.higVal     = 0.05;    
simul.lowVal     = 0.01;    
simul.bkgVel     = 1;       
simul.cmap       = 'jet';   

% 5. RUN SIMULATION
recfield = acu2Dpro(model,source,simul);

% =========================================================================
% NEW SECTION: PLOT VELOCITY MODEL + SOURCE + RECEIVERS
% =========================================================================
figure('Name', 'Structural Velocity Model', 'Color', 'w');
imagesc(model.x, model.z, model.vel);
set(gca,'YDir','normal', 'FontSize', 10); 
axis tight;
colormap(parula); % Unique professional colormap
colorbar; 
hold on;


% Draw the Interface line (The boundary between layers)
plot([model.x(1) model.x(end)], [z_interface z_interface], 'k--', 'LineWidth', 1.5);

% Plot the Source (Red Star/Pentagram)
plot(source.x, source.z, 'rp', 'MarkerFaceColor','r', 'MarkerSize', 12);

% Plot the Receivers (White Dots)
plot(model.recx, model.recz, 'w.', 'MarkerSize', 10);

xlabel('Distance (m)');
ylabel('Depth (m)');
title('Velocity Model (Two Layers) with Source and Receivers');
legend({'Interface','Source','Receivers'}, 'Location','northeast');
% =========================================================================

% 6. PLOT SEISMIC TRACES (WIGGLE PLOT)
figure('Name', 'Seismic Traces', 'Color', 'w');
seisplot2(recfield.data, recfield.time, 1:Nr, 2, 0, 1, 'k', []);
title(['Source at Depth: ', num2str(source.z), 'm']);
xlabel('Receiver Number');
ylabel('Time (s)');