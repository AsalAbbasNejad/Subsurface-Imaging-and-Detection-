% -------------------------------------------------------------------------
%       Acoustic wave equation finite difference simulator
% -------------------------------------------------------------------------

% --------------------------------------------------
% Create your own model and example....
% --------------------------------------------------
% -------------------------------------------------------------------------
%       Acoustic wave equation finite difference simulator
%       Exercise 5: 2-Layer Model + Dual Rectangular Obstacles
% -------------------------------------------------------------------------
clc; clear; close all;

% --- Grid Definition ---
model.x = 0:2:1000;          
model.z = 0:2:500;           
Nx = numel(model.x);
Nz = numel(model.z);
[X,Z] = meshgrid(model.x, model.z);

% --- 2-Layer Velocity Model Creation ---
model.vel = zeros(Nz, Nx);

% Layer 1: Top Layer (0 to 350m depth) - Very slow: 600 m/s
model.vel(Z < 350) = 600; 

% Layer 2: Bottom Layer (350 to 500m depth) - Bedrock: 4000 m/s
model.vel(Z >= 350) = 4000;

% --- Dual Rectangular Obstacles (Side by Side) ---
% Obstacle 1 (Left Side)
% x: 200-400m, z: 200-240m
model.vel(100:120, 100:200) = 4500; 

% Obstacle 2 (Right Side)
% x: 600-800m, z: 200-240m
model.vel(100:120, 300:400) = 4500; 

% --- Source & Receivers (Positioned at Z=25m) ---
source.x = 500;             % Shot in the center (between the two blocks)
source.z = 25;              
source.f0 = 12;             
source.t0 = 0.08;           
source.amp = 1;
source.type = 1;

model.recx = 50:50:950;     
model.recz = 25 * ones(size(model.recx)); 
model.dtrec = 0.002;

% --- Simulation Parameters ---
simul.borderAlg = 1;
simul.timeMax = 0.9;        
simul.printRatio = 12;      
simul.higVal = 0.25;
simul.lowVal = 0.02;
simul.bkgVel = 1;
simul.cmap = 'gray';

% --- Run Simulation ---
recfield = acu2Dpro(model, source, simul);

% --- Plotting Velocity Model ---
figure('Name', 'Dual Obstacle Model', 'Color', 'w');
imagesc(model.x, model.z, model.vel);
axis tight; colormap(turbo); colorbar;
hold on;
hS = plot(source.x, source.z, 'rp', 'MarkerFaceColor','r', 'MarkerSize', 12);
hR = plot(model.recx, model.recz, 'w.', 'MarkerSize', 10);
set(gca, 'YDir', 'normal'); 
xlabel('Distance (m)'); ylabel('Depth (m)');
title('Exercise 5: 2-Layer Model with Dual Obstacles');
legend([hS hR], {'Source','Receivers'}, 'Location', 'northeast');

% --- Plotting Results ---
figure('Name', 'Shot Gather - Dual Obstacles', 'Color', 'w');
seisplot2(recfield.data, recfield.time, [], 1, 0, 1.8, '', 0.8);
xlabel('Receiver Index'); ylabel('Time (s)');
title('Shot Gather: Interference from Dual Obstacles');