% function trial12
% % Model DLP 3000 with 905 nm light for use in Lidar system
% % Modified to simulate phase patterns at three time samples
% % Braden Smith, Updated 2025
% 
% %% Define input variables
% % CCW positive for angles
% Inc_ang = 45;         % Degrees
% MirX = 3;             % Num mirrors in x direction
% MirY = 3;             % Num mirrors in y direction
% wave = 0.905;         % um (905 nm)
% Mir_width = 13.68/sqrt(2);     % um
% Mir_spls = 100;        % Samples per mirror width (diagonal of mirror)
%                       % Must be even
% Fill_factor = 0.925;  % Pixel fill factor for the DLP3000 is 0.925
% theta_max = 12;       % Maximum mirror tilt angle (degrees)
% T_act = 2.4;          % Actuation period (µs)
% 
% % Sample times (in µs)
% times = [0, 1.2, 4]; % t1, t2, t3
% labels = {'t_1', 't_2', 't_3'};
% 
% %% Create one DMD mirror pattern
% xv = linspace(-1,1,Mir_spls);
% yv = linspace(1,-1,Mir_spls);
% [X,Y] = meshgrid(xv,yv);
% % Create dimensionally correct mirror
% f = 1;
% Mir_lay = double(abs(X)/f + abs(Y)/f <= 1);
% 
% %% Plot phase for each time sample
% figure('Position', [100, 100, 1200, 400]);
% for t_idx = 1:length(times)
%     t_delay = times(t_idx); % Current time delay (µs)
% 
%     % Compute micromirror angle
%     DMD_ang = -theta_max + 2 * theta_max * (t_delay / T_act);
% 
%     %% Create Phase to overlay on one DMD mirror pattern
%     phase_vec = linspace(0, 2 * Mir_width * sin((Inc_ang - DMD_ang) * pi/180) * 2 * pi / wave, Mir_spls);
%     phase_mir = repmat(phase_vec, Mir_spls, 1);
%     phase_mir = exp(1i * phase_mir);
% 
%     %% Combine Mirror and Phase Profile
%     Single_mir = phase_mir .* Mir_lay;
% 
%     %% Create 2D layout of mirrors
%     % Create single mirror
%     Cell = zeros(Mir_spls);
%     Cell(1,1) = 1;
%     Cell(Mir_spls/2+1, Mir_spls/2+1) = 1;
%     % Create mirror matrix
%     Mir = repmat(Cell, MirY+1, MirX+1);
%     % Convolve mirrors with layout
%     Mir = conv2(Single_mir, Mir);
%     % Trim off extra
%     [SizeX, SizeY] = size(Mir);
%     Mir = Mir(Mir_spls+1:SizeY-Mir_spls+1, Mir_spls+1:SizeX-Mir_spls+1);
% 
%     %% Plot the phase
%     subplot(1, length(times), t_idx);
%     phase = angle(Mir); % Extract phase angle
%     phase = mod(phase + 2 * pi, 2 * pi); % Shift to [0, 2pi]
%     imagesc(phase);
%     colormap(jet);
%     colorbar;
%     title(sprintf('Phase at %s (t = %.1f \\mus)', labels{t_idx}, t_delay));
%     xlabel('X (pixels)');
%     ylabel('Y (pixels)');
%     axis equal tight;
%     clim([0, 2 * pi]);
% end
% 
% % Customize the colorbar for the last subplot
% h = colorbar;
% h.Label.String = 'Phase (rad)';
% h.Label.FontSize = 12;
% h.Ticks = [0, pi, 2 * pi]; % Set ticks at 0, pi, 2pi
% h.TickLabels = {'0', '\pi', '2\pi'}; % Label ticks in terms of pi
% end

% function dmdphasemap
% % Model DLP 3000 with 905 nm light for use in Lidar system
% % Simulate phase patterns at three time samples
% % Braden Smith, Updated 2025
% 
% %% Define input variables
% Inc_ang = 45;         % Degrees
% MirX = 3;             % Num mirrors in x direction
% MirY = 3;             % Num mirrors in y direction
% wave = 0.905;         % um
% Mir_width = 13.68 / sqrt(2);  % um
% Mir_spls = 20;        % Samples per mirror (must be even)
% Fill_factor = 0.925;  % Pixel fill factor for the DLP3000
% theta_max = 12;       % Max mirror tilt angle (degrees)
% T_act = 4;          % Actuation period (µs)
% 
% % Sample times (µs)
% times = [0, 2, 4];
% labels = {'t_1: -12°', 't_2: 0°', 't_3: +12°'};
% 
% %% Create one DMD mirror pattern
% xv = linspace(-1, 1, Mir_spls);
% yv = linspace(1, -1, Mir_spls);
% [X, Y] = meshgrid(xv, yv);
% f = 1;
% Mir_lay = double(abs(X)/f + abs(Y)/f <= 1);
% 
% %% Plot phase for each time sample
% figure('Position', [100, 100, 1200, 400]);
% for t_idx = 1:length(times)
%     t_delay = times(t_idx);
% 
%     % Calculate current mirror angle (from -12 to +12 degrees)
%     DMD_ang = -theta_max + 2 * theta_max * (t_delay / T_act);
% 
%     % Phase gradient due to mirror tilt and incident angle
%     delta_phase = 2 * Mir_width * sin((Inc_ang + DMD_ang) * pi/180) * 2 * pi / wave;
%     phase_vec = linspace(0, delta_phase, Mir_spls);
%     phase_mir = repmat(phase_vec, Mir_spls, 1);
%     phase_mir = exp(1i * phase_mir);
% 
%     % Combine with mirror mask
%     Single_mir = phase_mir .* Mir_lay;
% 
%     % Mirror layout across array
%     Cell = zeros(Mir_spls);
%     Cell(1,1) = 1;
%     Cell(Mir_spls/2+1, Mir_spls/2+1) = 1;
%     Mir = repmat(Cell, MirY+1, MirX+1);
%     Mir = conv2(Single_mir, Mir);
%     [SizeX, SizeY] = size(Mir);
%     Mir = Mir(Mir_spls+1:SizeY-Mir_spls+1, Mir_spls+1:SizeX-Mir_spls+1);
% 
%     % Plot phase
%     subplot(1, length(times), t_idx);
%     phase = angle(Mir);
%     phase = mod(phase + 2*pi, 2*pi);  % Ensure phase is within [0, 2π]
%     imagesc(phase);
%     colormap(jet);
%     title(sprintf('Phase @ %s (%.1f µs)', labels{t_idx}, t_delay));
%     xlabel('X (pixels)');
%     ylabel('Y (pixels)');
%     axis equal tight;
%     caxis([0 2*pi]);
% 
%     % Set consistent colorbar ticks
%     cb = colorbar;
%     cb.Ticks = [0, pi, 2*pi];
%     cb.TickLabels = {'0', '\pi', '2\pi'};
%     if t_idx == length(times)
%         cb.Label.String = 'Phase (rad)';
%         cb.Label.FontSize = 12;
%     end
% end
% 
% %% Plot OPD for each time sample
% figure('Position', [100, 550, 1200, 400]);
% for t_idx = 1:length(times)
%     t_delay = times(t_idx);
% 
%     % Calculate current mirror angle (same as above)
%     DMD_ang = -theta_max + 2 * theta_max * (t_delay / T_act);
% 
%     % Phase gradient due to mirror tilt and incident angle
%     delta_phase = 2 * Mir_width * sin((Inc_ang + DMD_ang) * pi/180) * 2 * pi / wave;
%     phase_vec = linspace(0, delta_phase, Mir_spls);
%     phase_mir = repmat(phase_vec, Mir_spls, 1);
%     phase_mir = exp(1i * phase_mir);
% 
%     % Combine with mirror layout
%     Single_mir = phase_mir .* Mir_lay;
%     Cell = zeros(Mir_spls);
%     Cell(1,1) = 1;
%     Cell(Mir_spls/2+1, Mir_spls/2+1) = 1;
%     Mir = repmat(Cell, MirY+1, MirX+1);
%     Mir = conv2(Single_mir, Mir);
%     [SizeX, SizeY] = size(Mir);
%     Mir = Mir(Mir_spls+1:SizeY-Mir_spls+1, Mir_spls+1:SizeX-Mir_spls+1);
% 
%     % Phase → OPD (ensure no sign flip issue)
%     phase = angle(Mir);
%     phase = mod(phase + 2*pi, 2*pi);  % Ensure phase is within [0, 2π]
%     opd = (phase * wave) / (2*pi);  % Convert to OPD in microns
% 
%     % Plot OPD
%     subplot(1, length(times), t_idx);
%     imagesc(opd);
%     colormap(jet);
%     title(sprintf('OPD @ %s (%.1f µs)', labels{t_idx}, t_delay));
%     xlabel('X (pixels)');
%     ylabel('Y (pixels)');
%     axis equal tight;
%     caxis([0, wave]);  % OPD range: 0 to λ
% 
%     % Colorbar
%     cb = colorbar;
%     cb.Ticks = [0, wave/2, wave];
%     cb.TickLabels = {'0', sprintf('%.3f', wave/2), sprintf('%.3f', wave)};
%     if t_idx == length(times)
%         cb.Label.String = 'OPD (µm)';
%         cb.Label.FontSize = 12;
%     end
% end


% Model DLP 3000 with 905 nm light for use in Lidar system
% Simulate phase patterns at three time samples
% Braden Smith, Updated 2025

% %% Define input variables
% Inc_ang = 45;         % Degrees
% MirX = 3;            % Num mirrors in x direction (to match the example: 300 pixels / 20 samples per mirror = 15 mirrors)
% MirY = 3;            % Num mirrors in y direction
% wave = 0.905;         % um (905 nm)
% Mir_width = 13.68 / sqrt(2);  % um
% Mir_spls = 22;        % Samples per mirror (adjusted to match the example)
% Fill_factor = 0.925;  % Pixel fill factor for the DLP3000
% theta_max = 12;       % Max mirror tilt angle (degrees)
% T_act = 4;            % Actuation period (µs)
% 
% % Sample times (µs)
% times = [0, 1, 2, 3, 4];
% labels = {'t_1: -12°', 't_2: -6°°', 't_3: 0°', 't_4: +6°' 't_5: +12°'};
% 
% %% Create one DMD mirror pattern
% xv = linspace(-1, 1, Mir_spls);
% yv = linspace(1, -1, Mir_spls);
% [X, Y] = meshgrid(xv, yv);
% f = 1;
% Mir_lay = double(abs(X)/f + abs(Y)/f <= 1);  % Diamond shape for mirror
% 
% %% Plot phase and OPD for each time sample in a single figure
% figure('Position', [100, 100, 1200, 800]);
% for t_idx = 1:length(times)
%     t_delay = times(t_idx);
% 
%     % Calculate current mirror angle: -12° at t=0, 0° at t=2, +12° at t=4
%     DMD_ang = -theta_max + (2 * theta_max * t_delay / T_act);
% 
%     % Create phase to overlay on one DMD mirror pattern
%     % Phase gradient across a single mirror, but we'll scale it for the entire grid
%     phase_vec = linspace(0, 2 * (MirX * Mir_width) * sin((Inc_ang + DMD_ang) * pi/180) * 2 * pi / wave, MirX * Mir_spls);
%     phase_vec = phase_vec(1:Mir_spls);  % Take the portion for a single mirror
%     phase_mir = repmat(phase_vec, Mir_spls, 1);
%     phase_mir = exp(1i * phase_mir);
% 
%     % Combine mirror and phase profile
%     Single_mir = phase_mir .* Mir_lay;
% 
%     % Create 2D layout of mirrors with gaps
%     Cell = zeros(Mir_spls);
%     Cell(1,1) = 1;
%     Cell(Mir_spls/2+1, Mir_spls/2+1) = 1;
%     Mir = repmat(Cell, MirY+1, MirX+1);
%     Mir = conv2(Single_mir, Mir, 'full');  % Convolve to create the grid
%     [SizeX, SizeY] = size(Mir);
%     Mir = Mir(Mir_spls+1:SizeY-Mir_spls+1, Mir_spls+1:SizeX-Mir_spls+1);  % Trim edges
% 
%     % Extract phase
%     phase = angle(Mir);
%     phase = mod(phase + 2*pi, 2*pi);  % Ensure phase is within [0, 2π]
% 
%     % Plot phase (top row)
%     subplot(1, length(times), t_idx);
%     imagesc(phase);
%     colormap(jet);  % Jet colormap for phase
%     title(sprintf('Phase @ %s (%.1f µs)', labels{t_idx}, t_delay));
%     % xlabel('X (pixels)');
%     % ylabel('Y (pixels)');
%     axis equal tight;
%     caxis([0 2*pi]);
%      % ❌ Hide axis tick numbers
%     set(gca, 'XTick', [], 'YTick', []);
% 
%     % Set consistent colorbar ticks
%     cb = colorbar;
%     cb.Ticks = [0, pi, 2*pi];
%     cb.TickLabels = {'0', '\pi', '2\pi'};
%     if t_idx == length(times)
%         cb.Label.String = 'Phase (rad)';
%         cb.Label.FontSize = 12;
%     end
% 
%     % Convert phase to OPD
%     % opd = (phase * wave) / (2*pi);  % Convert to OPD in microns
%     % opd = opd - wave/2;  % Center OPD around 0 (range: -λ/2 to λ/2)
% 
%     % % Plot OPD (bottom row)
%     % subplot(2, length(times), t_idx + length(times));
%     % imagesc(opd);
%     % colormap(jet);  % Jet colormap for OPD
%     % title(sprintf('OPD @ %s (%.1f µs)', labels{t_idx}, t_delay));
%     % xlabel('X (pixels)');
%     % ylabel('Y (pixels)');
%     % axis equal tight;
%     % caxis([-wave/2, wave/2]);  % OPD range: -λ/2 to λ/2
%     % 
%     % % Colorbar for OPD
%     % cb = colorbar;
%     % cb.Ticks = [-wave/2, 0, wave/2];
%     % cb.TickLabels = {sprintf('%.2f', -wave/2), '0', sprintf('%.2f', wave/2)};
%     % if t_idx == length(times)
%     %     cb.Label.String = 'OPD (µm)';
%     %     cb.Label.FontSize = 12;
%     % end
% end


%% Define input variables
Inc_ang = 45;         % Degrees
MirX = 3;             % Num mirrors in x direction
MirY = 3;             % Num mirrors in y direction
wave = 0.905;         % um (905 nm)
Mir_width = 13.68 / sqrt(2);  % um
Mir_spls = 22;        % Samples per mirror
Fill_factor = 0.925;  % Pixel fill factor
theta_max = 12;       % Max mirror tilt angle (degrees)
T_act = 4;            % Actuation period (µs)

% Sample times (µs)
times = [0, 1, 2, 3, 4];
labels = {'t_0: -12°', 't_1: -6°', 't_2: 0°', 't_3: +6°', 't_4: +12°'};

%% Create one DMD mirror pattern
xv = linspace(-1, 1, Mir_spls);
yv = linspace(1, -1, Mir_spls);
[X, Y] = meshgrid(xv, yv);
f = 1;
Mir_lay = double(abs(X)/f + abs(Y)/f <= 1);  % Diamond shape for mirror

%% Create tiled layout
figure('Position', [100, 100, 1600, 300]);  % Adjusted for horizontal layout
tiledlayout(1, length(times), 'TileSpacing', 'compact', 'Padding', 'compact');  % Minimal spacing

for t_idx = 1:length(times)
    t_delay = times(t_idx);
    
    % Calculate mirror angle
    DMD_ang = -theta_max + (2 * theta_max * t_delay / T_act);
    
    % Phase gradient across mirror
    phase_vec = linspace(0, 2 * (MirX * Mir_width) * sin((Inc_ang + DMD_ang) * pi/180) * 2 * pi / wave, MirX * Mir_spls);
    phase_vec = phase_vec(1:Mir_spls);  % For one mirror
    phase_mir = repmat(phase_vec, Mir_spls, 1);
    phase_mir = exp(1i * phase_mir);
    
    % Mirror + phase profile
    Single_mir = phase_mir .* Mir_lay;
    
    % Mirror grid layout
    Cell = zeros(Mir_spls);
    Cell(1,1) = 1;
    Cell(Mir_spls/2+1, Mir_spls/2+1) = 1;
    Mir = repmat(Cell, MirY+1, MirX+1);
    Mir = conv2(Single_mir, Mir, 'full');
    [SizeX, SizeY] = size(Mir);
    Mir = Mir(Mir_spls+1:SizeY-Mir_spls+1, Mir_spls+1:SizeX-Mir_spls+1);  % Trim
    
    % Phase
    phase = angle(Mir);
    phase = mod(phase + 2*pi, 2*pi);
    
    % Plot in tiled layout
    ax = nexttile;
    imagesc(phase);
    colormap(jet);
    title(sprintf('Phase at %s (%.1f µs)', labels{t_idx}, t_delay), 'FontSize', 20);
    axis equal tight;
    set(gca, 'XTick', [], 'YTick', []);
    caxis([0 2*pi]);
end

% Add shared colorbar
cb = colorbar(ax, 'Location', 'eastoutside');
cb.Ticks = [0, pi, 2*pi];
cb.TickLabels = {'0', '\pi', '2\pi'};
cb.Label.String = 'Phase';
cb.Label.FontSize = 25;
cb.FontSize = 20;
