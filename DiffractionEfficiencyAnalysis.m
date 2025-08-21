% % Define phase states (16 levels)
% phi905 = [0.000, 0.014, 0.029, 0.059, 0.078, 0.101, 0.158, 0.242, ...
%          0.478, 0.518, 0.590, 0.686, 0.837, 0.932, 1.113, 1.309] * pi;
% 
% % Parameters
% gratingperiods = [2, 2.5, 3, 5];  % Multiple grating periods
% thetaD = 0;  % degrees Grating Angles
% rows = 800;
% cols = 1280;
% N = 100;  % Finer sampling for phase profile
% orders = -10:10;
% 
% % Colors and markers for plots
% colors = {'#0072BD', '#D95319', '#77AC30', '#7E2F8E'};  % Blue, Orange, Green, Purple
% markers = {'o', 's', 'd', '^'};  % Circle, Square, Diamond, Triangle
% 
% % Store diffraction efficiencies for all periods
% diff_eff_all = zeros(length(orders), length(gratingperiods));
% 
% % Initialize figure with professional settings
% figure('Position', [100, 100, 900, 700], 'Color', 'white');
% hold on;
% grid on;
% 
% % Loop through each grating period
% for p = 1:length(gratingperiods)
%     gratingperiod = gratingperiods(p);
% 
%     % Phase wrapping algorithm (2D grid)
%     phase_states = zeros(rows, cols);
%     phase_values = zeros(rows, cols);
%     for i = 1:rows
%         for j = 1:cols
%             x = j - 1;
%             y = i - 1;
%             rotation_matrix = cosd(thetaD) * x - sind(thetaD) * y + 0.0001;
%             n = (2*pi / gratingperiod) * rotation_matrix;
%             n = mod(n, 2*pi);
%             [~, idx] = min(abs(phi905 - n));
%             phase_states(i,j) = idx - 1;
%             phase_values(i,j) = phi905(idx);
%         end
%     end
% 
%     % Sample one period with higher resolution
%     x = linspace(0, gratingperiod, N);
%     phase_profile = zeros(1, N);
%     for k = 1:N
%         x_pixel = floor(x(k));
%         n = (2*pi / gratingperiod) * x_pixel;
%         n = mod(n, 2*pi);
%         [~, idx] = min(abs(phi905 - n));
%         phase_profile(k) = phi905(idx);
%     end
% 
%     % Diffraction efficiency calculation
%     diff_eff = zeros(size(orders));
%     for m = 1:length(orders)
%         sum_val = 0;
%         for k = 1:N
%             sum_val = sum_val + exp(1i * phase_profile(k)) * ...
%                      exp(-1i * 2 * pi * orders(m) * x(k) / gratingperiod);
%         end
%         diff_eff(m) = abs(sum_val / N)^2;
%     end
%     diff_eff = diff_eff / sum(diff_eff);  % Normalize
%     diff_eff_all(:, p) = diff_eff;  % Store efficiencies
% 
%     % Plotting
%     plot(orders, diff_eff, 'Color', colors{p}, 'LineWidth', 2, ...
%          'DisplayName', sprintf('Period = %.1f', gratingperiod));
%     scatter(orders, diff_eff, 80, 'Marker', markers{p}, 'MarkerEdgeColor', colors{p}, ...
%             'MarkerFaceColor', colors{p}, 'LineWidth', 1.5, 'HandleVisibility', 'off');
% 
%     % Add efficiency percentages on top of points
%     for m = 1:length(orders)
%         if diff_eff(m) > 0.02  % Only label significant efficiencies
%             text(orders(m), diff_eff(m) + 0.04, sprintf('%.1f%%', diff_eff(m)*100), ...
%                  'HorizontalAlignment', 'center', 'FontSize', 9, ...
%                  'Color', colors{p}, 'FontWeight', 'bold');
%         end
%     end
% end
% 
% % Customize plot for publication
% set(gca, 'FontSize', 14, 'FontName', 'Times New Roman', 'LineWidth', 1.2, ...
%     'GridLineStyle', '--', 'GridAlpha', 0.3);
% xlabel('Diffraction Order', 'FontSize', 16, 'FontWeight', 'bold');
% ylabel('Normalized Diffraction Efficiency', 'FontSize', 16, 'FontWeight', 'bold');
% title(sprintf('Diffraction Efficiency vs Order (\\theta_D = %d°)', thetaD), ...
%       'FontSize', 18, 'FontWeight', 'bold');
% xlim([-10 10]);
% ylim([0 1.2]);
% legend('Location', 'northeast', 'FontSize', 12, 'Box', 'off', ...
%        'EdgeColor', 'none', 'Color', 'none');
% box on;
% set(gcf, 'Renderer', 'painters');  % For vector graphics output
% hold off;
% 
% % Display efficiencies for each grating period in a table-like format
% disp('Diffraction Efficiencies (%):');
% fprintf('Order\t');
% for p = 1:length(gratingperiods)
%     fprintf('Period %.1f\t', gratingperiods(p));
% end
% fprintf('\n');
% for m = 1:length(orders)
%     fprintf('%d\t', orders(m));
%     for p = 1:length(gratingperiods)
%         fprintf('%.2f\t\t', diff_eff_all(m, p) * 100);
%     end
%     fprintf('\n');
% end
% % === PHASE MAP VISUALIZATION ===
% for p = 1:length(gratingperiods)
%     gratingperiod = gratingperiods(p);
% 
%     % Recompute for this period
%     % Phase states and values
%     phase_states = zeros(rows, cols);
%     phase_values = zeros(rows, cols);
%     for i = 1:rows
%         for j = 1:cols
%             x = j - 1;
%             y = i - 1;
%             rotation_matrix = cosd(thetaD) * x - sind(thetaD) * y + 0.0001;
%             n = (2*pi / gratingperiod) * rotation_matrix;
%             n = mod(n, 2*pi);
%             [~, idx] = min(abs(phi905 - n));
%             phase_states(i,j) = idx - 1;
%             phase_values(i,j) = phi905(idx);
%         end
%     end
% 
%     % Sample 1D phase profile for one period (N points)
%     x = linspace(0, gratingperiod, N);
%     phase_profile = zeros(1, N);
%     for k = 1:N
%         x_pixel = floor(x(k));
%         n = (2*pi / gratingperiod) * x_pixel;
%         n = mod(n, 2*pi);
%         [~, idx] = min(abs(phi905 - n));
%         phase_profile(k) = phi905(idx);
%     end
% 
%     % Plot all in a single figure
%     figure('Name', sprintf('Phase Maps - Period %.1f', gratingperiod), ...
%            'Color', 'white', 'Position', [200 200 1000 800]);
% 
%     % Subplot 1: Phase states
%     subplot(2,2,1);
%     imagesc(phase_states);
%     colormap(parula(16)); % Distinct colors for 16 phase states
%     colorbar('Ticks', 0:1:15, 'TickLabels', string(0:1:15)); % Explicitly label states
%     title(sprintf('Phase States (0–15) [Period = %.1f]', gratingperiod), 'FontWeight', 'bold');
%     xlabel('X Pixels');
%     ylabel('Y Pixels');
%     axis image;
% 
%     % Subplot 2: Phase values (quantized)
%     subplot(2,2,2);
%     imagesc(phase_values);
%     colormap('turbo');
%     colorbar;
%     title('Quantized Phase Values (radians)', 'FontWeight', 'bold');
%     xlabel('X Pixels');
%     ylabel('Y Pixels');
%     axis image;
% 
%     % Subplot 3: 1D Quantized Phase Profile with Chosen Phase Levels
%     subplot(2,2,3);
%     plot(x, phase_profile, 'b.-', 'LineWidth', 1.5, 'MarkerSize', 12);
%     hold on;
% 
%     % Get unique phase levels used
%     used_levels = unique(phase_profile);
%     used_colors = turbo(length(used_levels));
% 
%     % Plot horizontal lines to indicate which levels were chosen
%     for l = 1:length(used_levels)
%         y = used_levels(l);
%         yline(y, '--', 'Color', used_colors(l,:), ...
%               'LineWidth', 1.5, 'Label', ...
%               sprintf('%.2f\\pi', y/pi), 'LabelHorizontalAlignment', 'right', ...
%               'LabelVerticalAlignment', 'middle', 'FontSize', 9, ...
%               'FontWeight', 'bold');
%     end
% 
%     grid on;
%     title('1D Phase Profile (Quantized)', 'FontWeight', 'bold');
%     xlabel('x (μm or pixel unit)');
%     ylabel('Phase (radians)');
%     ylim([0 2*pi]);
%     yticks(0:pi/2:2*pi);
%     yticklabels({'0','\pi/2','\pi','3\pi/2','2\pi'});
% 
%     % Subplot 4: Wrapped Phase Map (0 to 2π)
%     subplot(2,2,4);
%     imagesc(mod(phase_values, 2*pi));  % Wrapped phase
%     colormap('hsv');
%     colorbar;
%     title('Wrapped Phase Map (0 to 2\pi)', 'FontWeight', 'bold');
%     xlabel('X Pixels');
%     ylabel('Y Pixels');
%     axis image;
% end

% Full code for Phase Map Visualization with Diffraction Efficiencies
% Generates four subplots for each grating period, showing phase states, phase profiles, and diffraction efficiencies

% % Define phase states (16 levels)
% phi905 = [0.000, 0.014, 0.029, 0.059, 0.078, 0.101, 0.158, 0.242, ...
%           0.478, 0.518, 0.590, 0.686, 0.837, 0.932, 1.113, 1.309] * pi;
% 
% % Parameters
% gratingperiods = [1.5, 1.9, 2.1, 4];  % Multiple grating periods
% thetaD = 0;  % degrees Grating Angles
% rows = 800;
% cols = 1280;
% N = 100;  % Finer sampling for phase profile
% orders = -10:10;
% 
% % Colors and markers for plots
% colors = {'#0072BD', '#D95319', '#77AC30', '#7E2F8E'};  % Blue, Orange, Green, Purple
% markers = {'o', 's', 'd', '^'};  % Circle, Square, Diamond, Triangle
% 
% % Store diffraction efficiencies for all periods
% diff_eff_all = zeros(length(orders), length(gratingperiods));
% phase_states_all = cell(length(gratingperiods), 1);  % Store phase states chosen for each grating period
% 
% % Initialize figure with professional settings
% figure('Position', [100, 100, 900, 700], 'Color', 'white');
% 
% % Loop through each grating period and plot separately
% for p = 1:length(gratingperiods)
%     gratingperiod = gratingperiods(p);
% 
%     % Phase wrapping algorithm (2D grid)
%     phase_states = zeros(rows, cols);
%     phase_values = zeros(rows, cols);
%     for i = 1:rows
%         for j = 1:cols
%             x = j - 1;
%             y = i - 1;
%             rotation_matrix = cosd(thetaD) * x - sind(thetaD) * y + 0.0001;
%             n = (2*pi / gratingperiod) * rotation_matrix;
%             n = mod(n, 2*pi);
%             [~, idx] = min(abs(phi905 - n));
%             phase_states(i,j) = idx - 1;
%             phase_values(i,j) = phi905(idx);
%         end
%     end
% 
%     % Store the chosen phase states for the current grating period
%     phase_states_all{p} = phase_states;
% 
%     % Sample one period with higher resolution
%     x = linspace(0, gratingperiod, N);
%     phase_profile = zeros(1, N);
%     phase_states_profile = zeros(1, N);  % Store selected phase states for phase profile
% 
%     for k = 1:N
%         x_pixel = floor(x(k));
%         n = (2*pi / gratingperiod) * x_pixel;
%         n = mod(n, 2*pi);
%         [~, idx] = min(abs(phi905 - n));
%         phase_profile(k) = phi905(idx);
%         phase_states_profile(k) = idx - 1;
%     end
% 
%     % Diffraction efficiency calculation
%     diff_eff = zeros(size(orders));
%     for m = 1:length(orders)
%         sum_val = 0;
%         for k = 1:N
%             sum_val = sum_val + exp(1i * phase_profile(k)) * ...
%                      exp(-1i * 2 * pi * orders(m) * x(k) / gratingperiod);
%         end
%         diff_eff(m) = abs(sum_val / N)^2;
%     end
%     diff_eff = diff_eff / sum(diff_eff);  % Normalize
%     diff_eff_all(:, p) = diff_eff;  % Store efficiencies
% 
%     % Plotting the phase map visualization (subplot 1)
%     subplot(4, 3, (p-1)*3 + 1);
%     imagesc(phase_states);  % Show the phase map for each grating period
%     colormap(hsv);
%     colorbar;
%     title(sprintf('Phase Map (Period = %.1f)', gratingperiod));
%     axis off;
% 
%     % Plotting diffraction efficiencies (subplot 2)
%     subplot(4, 3, (p-1)*3 + 2);
%     plot(orders, diff_eff, 'Color', 'blue', 'LineWidth', 1);
%     hold on;
%     scatter(orders, diff_eff, 50, 'Marker', 'o', 'MarkerEdgeColor', 'r', ...
%             'MarkerFaceColor', 'r', 'LineWidth', 1);  % Red data points
%     % Display diffraction efficiency values on top of data points
%     for i = 1:length(orders)
%         text(orders(i), diff_eff(i), sprintf('%.2f', diff_eff(i)*100), ...
%              'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 5);
%     end
%     xlabel('Diffraction Order');
%     ylabel('Normalized Diffraction Efficiency');
%     title('Diffraction Efficiencies');
%     grid on;
%     hold off;
% 
%     % Extract unique phase states for this grating period
%     unique_phase_states = unique(phase_states_profile);
% 
%     % Plotting the chosen phase states profile (subplot 3)
%     subplot(4, 3, (p-1)*3 + 3);
%     scatter(1:N, phase_states_profile, 10, 'r', 'filled');  % Red dots
%     hold on;
%     plot(1:N, phase_states_profile, 'b-', 'LineWidth', .5);  % Blue connecting line
%     for k = 1:N
%         text(k, phase_states_profile(k) + 0.3, sprintf('%d', phase_states_profile(k)), ...
%             'HorizontalAlignment', 'center', 'FontSize', 2);
%     end
%     xlabel('Mirror Number (Pixel Index)');
%     ylabel('Phase State Index');
%     title(sprintf('Phase States Used (Period = %.1f)', gratingperiod));
%     ylim([min(unique_phase_states)-1, max(unique_phase_states)+1]); % Adjust Y-limits
%     yticks(unique_phase_states); % Show only selected phase states
%     grid on;
%     hold off;
% end
% 
% % Customize plot for publication
% set(gcf, 'Renderer', 'painters');  % For vector graphics output
% 
% % Display diffraction efficiencies and phase states for each grating period
% disp('Diffraction Efficiencies (%) and Phase States:');
% fprintf('Order\t');
% for p = 1:length(gratingperiods)
%     fprintf('Period %.1f\t', gratingperiods(p));
% end
% fprintf('\n');
% for m = 1:length(orders)
%     fprintf('%d\t', orders(m));
%     for p = 1:length(gratingperiods)
%         fprintf('%.2f\t\t', diff_eff_all(m, p) * 100);
%     end
%     fprintf('\n');
% end
% 
% % Display the phase states chosen for each grating period
% disp('Phase States Chosen for Each Grating Period:');
% for p = 1:length(gratingperiods)
%     fprintf('\nGrating Period = %.1f\n', gratingperiods(p));
%     unique_phase_states = unique(phase_states_all{p});
%     fprintf('Phase States Chosen: ');
%     fprintf('%d ', unique_phase_states);
%     fprintf('\n');
% end

% Define phase states (16 levels)
phi905 = [0.000, 0.014, 0.029, 0.059, 0.078, 0.101, 0.158, 0.242, ...
           0.478, 0.518, 0.590, 0.686, 0.837, 0.932, 1.113, 1.309] * pi;
% phi905 = [0.00       , 0.01035484, 0.02119355, 0.04354839, 0.05787097, 0.075     , 0.11670968, 0.17903226, 0.35370968, 0.38274194, 0.43645161, 0.50748387, 0.61867742, 0.68864516, 0.82277419,0.96774194] * pi;

% Parameters
gratingperiods = [2.5, 2.7, 4, 6];  % Multiple grating periods
thetaD = 0;  % degrees Grating Angles
rows = 800;
cols = 1280;
N = 100;  % Finer sampling for phase profile
orders = -3:3;

% Colors and markers for plots
colors = {'#0072BD', '#D95319', '#77AC30', '#7E2F8E'};  % Blue, Orange, Green, Purple
markers = {'o', 's', 'd', '^'};  % Circle, Square, Diamond, Triangle

% Store diffraction efficiencies for all periods
diff_eff_all = zeros(length(orders), length(gratingperiods));
phase_states_all = cell(length(gratingperiods), 1);  % Store phase states chosen for each grating period

% Initialize figure with professional settings
figure('Position', [100, 100, 900, 700], 'Color', 'white');

% Loop through each grating period and plot separately
for p = 1:length(gratingperiods)
    gratingperiod = gratingperiods(p);

    % Phase wrapping algorithm (2D grid)
    phase_states = zeros(rows, cols);
    phase_values = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            x = j - 1;
            y = i - 1;
            rotation_matrix = cosd(thetaD) * x - sind(thetaD) * y + 0.0001;
            n = (2*pi / gratingperiod) * rotation_matrix;
            n = mod(n, 2*pi);
            [~, idx] = min(abs(phi905 - n));
            phase_states(i,j) = idx - 1;
            phase_values(i,j) = phi905(idx);
        end
    end

    % Store the chosen phase states for the current grating period
    phase_states_all{p} = phase_states;

    % Sample one period with higher resolution for diffraction efficiency
    x = linspace(0, gratingperiod, N);
    phase_profile = zeros(1, N);
    for k = 1:N
        x_pixel = floor(x(k));
        n = (2*pi / gratingperiod) * x_pixel;
        n = mod(n, 2*pi);
        [~, idx] = min(abs(phi905 - n));
        phase_profile(k) = phi905(idx);
    end

    % Diffraction efficiency calculation
    diff_eff = zeros(size(orders));
    for m = 1:length(orders)
        sum_val = 0;
        for k = 1:N
            sum_val = sum_val + exp(1i * phase_profile(k)) * ...
                     exp(-1i * 2 * pi * orders(m) * x(k) / gratingperiod);
        end
        diff_eff(m) = abs(sum_val / N)^2;
    end
    diff_eff = diff_eff / sum(diff_eff);  % Normalize
    diff_eff_all(:, p) = diff_eff;  % Store efficiencies

    % Sample phase states for plotting (subplot 3)
    phase_states_profile = zeros(1, N);
    for k = 1:N
        % Map x(k) to a position within one period in the phase_states array
        % x(k) ranges from 0 to gratingperiod, so we scale it to the column index
        pos = x(k) / gratingperiod;  % Fraction of the period
        col_idx = mod(floor(pos * cols), cols) + 1;  % Map to column index
        phase_states_profile(k) = phase_states(1, col_idx);
    end

    % Plotting the phase map visualization (subplot 1)
    subplot(4, 3, (p-1)*3 + 1);
    imagesc(phase_states);  % Show the phase map for each grating period
    colormap(hsv);
    colorbar;
    title(sprintf('Phase Map (Period = %.1f)', gratingperiod));
    axis off;

    % Plotting diffraction efficiencies (subplot 2)
    subplot(4, 3, (p-1)*3 + 2);
    plot(orders, diff_eff, 'Color', 'blue', 'LineWidth', 1);
    hold on;
    scatter(orders, diff_eff, 10, 'Marker', 'o', 'MarkerEdgeColor', 'r', ...
            'MarkerFaceColor', 'r', 'LineWidth', 1);  % Red data points
    for i = 1:length(orders)
        text(orders(i), diff_eff(i), sprintf('%.2f', diff_eff(i)), ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
    end
    xlabel('Diffraction Order');
    ylabel('Normalized Diffraction Efficiency');
    title('Diffraction Efficiencies');
    grid on;
    hold off;

    % Calculate unique phase states for this grating period from the 2D phase map
    unique_phase_states = unique(phase_states(:));  % Use the full phase map for accuracy
    num_phase_states = length(unique_phase_states);

    % Plotting the phase states vs mirror number (subplot 3)
    subplot(4, 3, (p-1)*3 + 3);
    scatter(1:N, phase_states_profile, 10, 'r', 'filled');  % Red dots for phase states
    hold on;
    plot(1:N, phase_states_profile, 'b-', 'LineWidth', 0.5);  % Blue connecting line
    xlabel('Mirror Number (Pixel Index)');
    ylabel('Phase State Index');
    title(sprintf('Phase States (Period = %.1f, %d States)', gratingperiod, num_phase_states));
    ylim([min(unique_phase_states)-1, max(unique_phase_states)+1]); % Adjust Y-limits
    yticks(unique_phase_states); % Show only selected phase states
    grid on;
    hold off;
end

% Customize plot for publication
set(gcf, 'Renderer', 'painters');  % For vector graphics output

% Display diffraction efficiencies and phase states for each grating period
disp('Diffraction Efficiencies (%) and Phase States:');
fprintf('Order\t');
for p = 1:length(gratingperiods)
    fprintf('Period %.1f\t', gratingperiods(p));
end
fprintf('\n');
for m = 1:length(orders)
    fprintf('%d\t', orders(m));
    for p = 1:length(gratingperiods)
        fprintf('%.2f\t\t', diff_eff_all(m, p) * 100);
    end
    fprintf('\n');
end

% Display the phase states chosen for each grating period
disp('Phase States Chosen for Each Grating Period:');
for p = 1:length(gratingperiods)
    fprintf('\nGrating Period = %.1f\n', gratingperiods(p));
    unique_phase_states = unique(phase_states_all{p});
    fprintf('Phase States Chosen: ');
    fprintf('%d ', unique_phase_states);
    fprintf('\n');
end