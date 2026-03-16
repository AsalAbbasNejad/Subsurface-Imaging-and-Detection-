% -------------------------------------------------------------------------
%       Acoustic wave equation finite difference simulator
% -------------------------------------------------------------------------

% ----------------------------------------
% Build a model that "focuses" the wavefield in one direction and/or
% against one target.
% You can use array of sources  properly delayed (beam-forming), 
% and/or obstacles (reflectors) properly shaped (acoustic lens/horn)
%
% https://en.wikipedia.org/wiki/Architectural_acoustics

clc; clear; close all;

% 1. MODEL CONFIGURATION
model.x = 0:2:2400;     
model.z = 0:2:1200;     
Nx = numel(model.x);
Nz = numel(model.z);
[X,Z] = meshgrid(model.x, model.z);

% 2. VELOCITY FIELD & LENS
v0 = 3000; 
model.vel = v0 * ones(Nz, Nx);

% Elliptical Lens Geometry
target_x = 1200; 
target_z = 1000; 
lens_center_x = 1200;
lens_center_z = 600; 
lens_a = 400; 
lens_b = 180; 
lens_mask = ((X - lens_center_x).^2)/(lens_a^2) + ...
            ((Z - lens_center_z).^2)/(lens_b^2) <= 1;

v_lens = 1700; 
model.vel(lens_mask) = v_lens;

% 3. SOURCE ARRAY & BEAMFORMING
source.x = linspace(700, 1700, 30); 
Ns = numel(source.x);
source.z = 60 * ones(1, Ns);
source.f0 = 22 * ones(1, Ns);
source.type = ones(1, Ns);
source.amp = tukeywin(Ns, 0.5)';

% Delay calculation for focusing
v_ref = 3000;
t0_raw = zeros(1, Ns);
for i = 1:Ns
    dist = sqrt((source.x(i) - target_x)^2 + (source.z(i) - target_z)^2);
    t0_raw(i) = dist / v_ref;
end
source.t0 = -(t0_raw) + max(t0_raw);

% 4. RECEIVER CONFIGURATION
model.recx = [target_x-500, target_x-250, target_x, target_x+250, target_x+500];
model.recz = ones(1, 5) * target_z;
model.dtrec = 0.001;
Nr = numel(model.recx);

% 5. SIMULATION PARAMETERS
simul.borderAlg  = 1;
simul.timeMax    = 1; 
simul.printRatio = 15;
simul.higVal     = 0.5;
simul.lowVal     = 0.05;
simul.bkgVel     = 1;
simul.cmap       = 'gray'; 

% 6. EXECUTION
disp('Running simulation...');
recfield = acu2Dpro(model, source, simul);

% 7. VISUALIZATION - ONLY SIGNAL TRACES
figure('Name', 'Receiver Signal Analysis', 'Color', 'w');
t = recfield.time;
tr = recfield.data;
for i = 1:Nr
    subplot(Nr, 1, i);
    plot(t, tr(:, i), 'LineWidth', 1.2, 'Color', [0.4 0.4 0.4]); 
    grid on; axis tight;
    ylabel(['Rec ', num2str(i)]);
end
xlabel('Time (s)');