clc; clear; close all;

% 1. MODEL CONFIGURATION (Refraction Model)
model.x = 0:4:3000;     % dx = 4m
model.z = 0:4:1500;     % dz = 4m
Nx = numel(model.x);
Nz = numel(model.z);

% 2. TWO-LAYER VELOCITY MODEL
% Layer 1 (Top): 2000 m/s
% Layer 2 (Bottom): 4000 m/s
v_top = 2000;
v_bottom = 4000;
interface_depth = 600; % Boundary at 600m depth

model.vel = v_top * ones(Nz, Nx);
model.vel(model.z > interface_depth, :) = v_bottom;

% 3. SOURCE PARAMETERS
% Single source at the top center
source.x    = 1500; 
source.z    = 50; 
source.f0   = 25;   % Central frequency
source.t0   = 0.05; 
source.type = 1;    % Ricker wavelet
source.amp  = 10;

% 4. RECEIVER CONFIGURATION
% A line of 10 receivers at the bottom to catch the refracted waves
model.recx  = linspace(500, 2500, 10);
model.recz  = ones(1, 10) * 1200; 
model.dtrec = 0.001;
Nr = numel(model.recx);

% 5. SIMULATION PARAMETERS
simul.borderAlg  = 1;    % Absorbing boundaries to avoid reflections from edges
simul.timeMax    = 0.8;  
simul.printRatio = 15;
simul.higVal     = 0.4;
simul.lowVal     = 0.05;
simul.bkgVel     = 1;
simul.cmap       = 'gray'; % Grayscale for professional look

% 6. RUN SIMULATION
disp('Running Refraction Simulation...');
recfield = acu2Dpro(model, source, simul);

% 7. VISUALIZATION - RECEIVER TRACES (Signals)
figure('Name', 'Refraction Seismic Traces', 'Color', 'w');
% Using seisplot2 as per instructions
seisplot2(recfield.data, recfield.time, 1:Nr, 1, 2, 1.5, 'k', []);
title('Seismic Traces: Waves traveling through two layers');
xlabel('Receiver Index');
ylabel('Time (s)');