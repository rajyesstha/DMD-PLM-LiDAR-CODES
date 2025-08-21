% Code by Rajesh Shrestha
% July 22, 2025

function plmgratingvisualization()
    % Generate and save CGH bitpattern maps for PLM upload.
    % Visualize the true grating-direction phase ramp with piston index and π-phase values.

    %% Parameters
    grating_period   = 1.5;               % Grating period (pixels)
    theta_degrees    = 45;             % Grating angle (degrees)
    max_x            = 50;             % Number of ramp points to visualize
    pixel_size_nm    = 10800;           % Pixel pitch (nm)
    max_displacement = 296.25;          % Maximum stroke (nm)

    %% Output file
    bit_filename = sprintf('CGH_bits_p%g_theta%g.bmp', grating_period, theta_degrees);

    %% Threshold mapping and displacement data
    thresholds_pct = [1.37420442, 2.140099448, 3.339651934, 4.665104972, ...
                      5.801707182, 7.928027624, 11.68755801, 20.25229282, ...
                      27.6139779, 30.60411602, 35.11205525, 41.69735359, ...
                      48.24418232, 55.61985635, 65.7058895, 100];
    displacements_nm = thresholds_pct / 100 * max_displacement;

    %% Generate pattern
    [pattern_indices, used_patterns, n_values] = CreateCGHPattern(grating_period, theta_degrees, thresholds_pct);

    %% Align phase ramp
    isDesc = mod(theta_degrees, 360) >= 180;
    gp_int = ceil(grating_period);
    if abs(cosd(theta_degrees)) < 1e-6
        col1 = pattern_indices(:,1);
        [~, k] = deal( ...
            ~isDesc * min(col1(1:gp_int)) + isDesc * max(col1(1:gp_int)));
        pattern_indices = circshift(pattern_indices, [-(k-1), 0]);
    else
        row1 = pattern_indices(1,:);
        if ~isDesc
            [~, k] = min(row1(1:gp_int));
        else
            max_val = max(row1(1:gp_int));
            k = find(row1(1:gp_int) == max_val, 1, 'last');
        end
        pattern_indices = circshift(pattern_indices, [0, -(k-1)]);
    end

    %% Define binary tiles for patterns
    bit_tiles = { ...
        [0 1;0 1],[0 1;0 0],[0 0;0 1],[0 1;1 1], ...
        [0 0;0 0],[0 1;1 0],[0 0;1 1],[0 0;1 0], ...
        [1 1;0 1],[1 1;0 0],[1 0;0 1],[1 0;0 0], ...
        [1 1;1 1],[1 1;1 0],[1 0;1 1],[1 0;1 0]};

    %% Build and save bitpattern image
    [rows, cols] = size(pattern_indices);
    bit_map = zeros(rows*2, cols*2);
    for i = 1:rows
        for j = 1:cols
            tile = bit_tiles{pattern_indices(i,j) + 1};
            bit_map(2*i-1:2*i, 2*j-1:2*j) = tile;
        end
    end
    imwrite(uint8(bit_map * 255), bit_filename);
    fprintf('Saved bitpattern map: %s\n', bit_filename);

    %% Blaze diagnostics
    fprintf('\nPatterns used (ceiling-threshold mapping):\n');
    for k = find(used_patterns)'
        phase_val = thresholds_pct(k)/100 * 2*pi;
        disp_nm   = displacements_nm(k);
        fprintf('p%d: phase=%.2f rad (%.2f%%), Δh=%.2f nm\n', ...
            k-1, phase_val, thresholds_pct(k), disp_nm);
    end

    ids = find(used_patterns) - 1;
    delta_h = displacements_nm(max(ids)+1) - displacements_nm(min(ids)+1);
    d_nm = grating_period * pixel_size_nm;
    blaze_deg = rad2deg(atan2(delta_h, d_nm));
    fprintf('\nGrating period: %g px\nSpatial period (d): %.2f nm (%.2f µm)\n', ...
        grating_period, d_nm, d_nm/1000);
    fprintf('Height variation (Δh): %.2f nm\nEstimated blaze angle: %.3f°\n', ...
        delta_h, blaze_deg);

    %% Display pattern info
    fprintf('\ngp = %.1f, theta = %g°, First 15×15 idx pattern:\n', grating_period, theta_degrees);
    disp(pattern_indices(1:15,1:15));

    %% Phase map stats
    unique_n = unique(round(n_values(:),2));
    phase_map = thresholds_pct(pattern_indices + 1) / 100 * 2 * pi;
    unique_p = unique(round(phase_map(:),2));
    fprintf('Unique n-values: %s\n', mat2str(unique_n'));
    fprintf('Unique phase-values: %s\n', mat2str(unique_p'));

    %% Phase Ramp Visualization (True θ Direction)
    figure;
    set(gcf, 'Color', 'white', 'Position', [100, 100, 600, 450], ... % Set figure size for screen display
        'PaperUnits', 'inches', 'PaperSize', [8.5, 11], ... % US Letter size
        'PaperPosition', [0.5, 0.5, 7.5, 10]); % Center figure on page with margins
    hold on;

    t_rad = deg2rad(theta_degrees);
    xc = round(size(pattern_indices, 2) / 2);
    yc = round(size(pattern_indices, 1) / 2);
    dx = cos(t_rad);
    dy = -sin(t_rad);  % image coordinates
    x = 1:max_x;

    xs = round(xc + (x - 1) * dx);
    ys = round(yc + (x - 1) * dy);
    xs = min(max(xs, 1), cols);
    ys = min(max(ys, 1), rows);
    y_indices = arrayfun(@(i) pattern_indices(ys(i), xs(i)), 1:max_x);
    phase_pi_905 = [...
        0.000, 0.014, 0.029, 0.059, ...
        0.078, 0.101, 0.158, 0.242, ...
        0.478, 0.518, 0.590, 0.686, ...
        0.837, 0.932, 1.113, 1.309];
    y = phase_pi_905(y_indices + 1);  % Use phase_pi_905 for phase values in pi units

    plot(x, y, '-', 'LineWidth', 2, 'Color', 'b', ...
        'Marker', 'o', 'MarkerSize', 8, ...
        'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

    for k = 1:max_x
        text(x(k), y(k)+0.05, sprintf('$%.2f\\pi$', y(k)), ...
            'FontSize', 20, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Interpreter', 'latex');
    end

    xlabel('Step (Mirror) Along Grating Vector', 'FontSize', 24, 'Interpreter', 'latex');
    ylabel('Phase (in $\pi$ radians)', 'FontSize', 24, 'Interpreter', 'latex');
    title(sprintf('Phase Ramp: $\\Lambda = %.1f$ px, $\\theta = %g^\\circ$', ...
        grating_period, theta_degrees), ...
        'FontSize', 28, 'Interpreter', 'latex');

    ylim([0 max(phase_pi_905) + 0.1]);
    xlim([1 max_x]);
    set(gca, 'FontSize', 20, 'Box', 'on', 'GridLineStyle', ':', 'LineWidth', 1.5);
    grid on;

    % % Legend: Unique phase values in π
    % used_pistons = unique(y_indices);
    % legend_entries = arrayfun(@(p) ...
    %     sprintf('$%.2f\\pi$', phase_pi_905(p+1)), ...
    %     used_pistons, 'UniformOutput', false);
    % legend_label = sprintf('\\textbf{Phase Values:} %s', strjoin(legend_entries, ', '));
    % legend(legend_label, 'Location', 'best', 'FontSize', 18, 'Interpreter', 'latex');

    set(gcf, 'Renderer', 'painters');

    % Save as vectorized PDF
    pdf_filename = sprintf('Phase_Ramp_p%g_theta%g.pdf', grating_period, theta_degrees);
    print(gcf, pdf_filename, '-dpdf', '-painters', '-bestfit');
    fprintf('Saved vectorized PDF: %s\n', pdf_filename);

    hold off;
end

%% Helper function
function [pattern_indices, used_patterns, n_values] = CreateCGHPattern(grating_period, theta_deg, thresholds_pct)
    rows = 800; cols = 1280;
    pattern_indices = zeros(rows, cols);
    used_patterns   = false(16, 1);
    n_values        = zeros(rows, cols);
    t_rad = deg2rad(theta_deg);

    for i = 0:rows-1
        for j = 0:cols-1
            v = j * cos(t_rad) - i * sin(t_rad) + 1e-5;
            if grating_period < 0, v = -v; end
            n = mod((100 / abs(grating_period)) * v, 100);
            n_values(i+1, j+1) = n;

            k = find(n <= thresholds_pct, 1, 'first');
            if isempty(k), k = 16; end
            pattern_indices(i+1, j+1) = k - 1;
            used_patterns(k) = true;
        end
    end
    fprintf('Grating period: %g, n-range: [%.2f, %.2f]\n', ...
        grating_period, min(n_values(:)), max(n_values(:)));
end