% -------------------------------------------------------------------------
%       Acoustic wave equation finite difference simulator
% -------------------------------------------------------------------------

% --------------------------------------------------
% In a homogeneous medium, compute the energy of traces at increasing 
% distance from the source
% Plot the resulting energy vs distance
clear all
close all
clc

% -------------------------------------------------------------------------
% PRACTICE EXERCISE 2: Energy vs. Distance in a Homogeneous Medium
% -------------------------------------------------------------------------

% 1. Model Parameters (Homogeneous)
model.x = 0:1:1000;         % Horizontal axis [m]
model.z = 0:1:1000;         % Vertical axis [m]
Nx = numel(model.x);
Nz = numel(model.z);

% Constant velocity model (No layers)
model.vel = zeros(Nz,Nx) + 2000; 

% 2. Source Parameters
source.x    = 100;          % Source placed at the beginning
source.z    = 500;          % Source in the middle of depth
source.f0   = 30;           
source.t0   = 0.05;         
source.amp  = 10;           
source.type = 1;            % Ricker wavelet

% 3. Receiver Parameters (Linear array moving away from source)
model.recx  = 150:50:950;   % Receivers at increasing distances
model.recz  = ones(size(model.recx)) * 500; % Same depth as source
model.dtrec = 0.004;
Nr = numel(model.recx);

% 4. Simulation Parameters
simul.borderAlg  = 1;       
simul.timeMax    = 0.6;     
simul.printRatio = 20;      
simul.higVal     = 0.1;     
simul.lowVal     = 0.01;    
simul.bkgVel     = 0;       
simul.cmap       = 'gray';

% 5. Run Simulator
recfield = acu2Dpro(model,source,simul);

% -------------------------------------------------------------------------
% 6. Energy Calculation
% Energy of a signal is the sum of squared amplitudes: E = sum(A^2)
% -------------------------------------------------------------------------
distances = model.recx - source.x; % Distance from source to each receiver
energy = sum(recfield.data.^2);    % Sum along time axis for each receiver

% 7. Plotting Energy vs. Distance
figure('Color', 'w')
subplot(2,1,1)
% Plotting the traces to see them weakening
seisplot2(recfield.data, recfield.time, distances, 1, 0, 1, 'k', [])
title('Seismic Traces at Increasing Distances');
ylabel('Time (s)');

subplot(2,1,2)
plot(distances, energy, 'ro-', 'LineWidth', 2, 'MarkerFaceColor', 'r');
title('Energy Decay vs. Distance');
xlabel('Distance from Source (m)');
ylabel('Total Energy (Sum of Squares)');
grid on;