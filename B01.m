clear all
close all
clc

% -------------------------------------------------------------------------
% PRACTICE EXERCISE: Analyzing Source and Receiver Positioning
% -------------------------------------------------------------------------

% 1. Model Parameters (Two-Layer Model)
model.x = 0:1:1000;         % Horizontal axis sampling [m]
model.z = 0:1:500;          % Vertical axis sampling [m]
Nx = numel(model.x);
Nz = numel(model.z);

% Define the interface depth and velocity values
z_interface = 250;          % Interface depth at 250 meters
model.vel = zeros(Nz,Nx);   % Initialize velocity matrix

for kx=1:Nx
  for kz=1:Nz
    if model.z(kz) > z_interface
      model.vel(kz,kx) = 2500; % Fast lower layer [m/s]
    else
      model.vel(kz,kx) = 1000; % Slow upper layer [m/s]
    end
  end
end

% ----------------------------------------
% 2. Source Parameters
% You can modify 'source.z' to analyze the effect of source depth
source.x    = 500;          % Horizontal position at the center
source.z    = 50;           % Shallow source depth (Try changing to 240m)
source.f0   = 30;           % Central frequency [Hz]
source.t0   = 0.04;         % Time delay [s]
source.amp  = 1;            % Source amplitude multiplier
source.type = 1;            % 1: Ricker wavelet (Impulsive source)

% ----------------------------------------
% 3. Receiver Parameters
% Receivers placed near the surface to record the waves
model.recx  = 100:20:900;   % Horizontal positions of receivers
model.recz  = ones(size(model.recx)) * 5; % Receivers at 5m depth
model.dtrec = 0.004;        % Recording time sampling [s]
Nr = numel(model.recx);

% ----------------------------------------
% 4. Simulation & Graphic Parameters
simul.borderAlg  = 1;       % 1: Absorbing boundaries enabled
simul.timeMax    = 0.8;     % Total simulation time [s]
simul.printRatio = 10;      % Update snapshot every 10 steps
simul.higVal     = 0.05;    % Colormap upper limit
simul.lowVal     = 0.01;    % Values near zero are hidden
simul.bkgVel     = 1;       % Display velocity model in background
simul.cmap       = 'jet';   % Colormap style

% ----------------------------------------
% 5. Call the Acoustic Simulator
recfield = acu2Dpro(model,source,simul);

% ----------------------------------------
% 6. Plotting Seismic Traces
figure
scal   = 2;                 % 2 for trace normalization
pltflg = 0;                 % 0 for wiggle traces with filled peaks
scfact = 1;                 % Scaling factor
colour = '';                % Default trace color (black)
clip   = [];                % No clipping

seisplot2(recfield.data, recfield.time, 1:Nr, scal, pltflg, scfact, colour, clip)

title(['Effect of Source Positioning (Source Depth: ', num2str(source.z), 'm)']);
xlabel('Receiver Number');
ylabel('Time (seconds)');