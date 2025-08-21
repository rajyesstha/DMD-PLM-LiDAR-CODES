% Input parameters
lambda = 0.905;          % Wavelength in micrometers
pitch = 13.68 / sqrt(2); % Pitch in micrometers
theta_i_values = [0, 30, 45]; % Incident angles in degrees

% Different order ranges for each angle
orders = {-2:4, -2:4, -2:4}; % Same ranges as specified
line_colors = {'#1f77b4', '#2ca02c', 'red'}; % Blue (0°), Green (30°), Black (45°)
markers = {'s', 'o', 'd'}; % Square, circle, diamond

% Initialize figure with publication quality settings
figure('Position', [100 100 800 600], 'Color', 'white');
hold on;

legend_entries = cell(1, length(theta_i_values));
plot_handles = gobjects(1, length(theta_i_values));

% Loop through incident angles
for i = 1:length(theta_i_values)
    theta_i = theta_i_values(i);
    curr_orders = orders{i};
    
    % Calculate diffraction angles
    theta_d = asind(sind(theta_i) - curr_orders * lambda / pitch);
    
    % Calculate regression slope
    p = polyfit(curr_orders, theta_d, 1); % Linear fit: p(1) is slope, p(2) is intercept
    slope = p(1); % Use regression slope
    
    % Plot with professional styling and store handle
    plot_handles(i) = plot(curr_orders, theta_d, 'Color', line_colors{i}, 'LineWidth', 3, ...
         'LineStyle', '-');
    scatter(curr_orders, theta_d, 100, 'Marker', markers{i}, ...
            'MarkerEdgeColor', 'w', 'MarkerFaceColor', line_colors{i}, ...
            'LineWidth', 3);
    
    % Annotate data points
    for j = 1:length(curr_orders)
        text(curr_orders(j), theta_d(j), sprintf('$%.1f^\\circ$', theta_d(j)), ...
             'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'bottom', ...
             'FontSize', 30, ...
             'Interpreter', 'latex');
    end
    
    % Store LaTeX legend entry with regression slope
    legend_entries{i} = sprintf('$\\theta_i = %d^\\circ$, slope = %.2f', theta_i, slope);
end

% Axis formatting
xlim([-2.5 4.5]);
xlabel('Diffraction Order ($m$)', 'FontSize', 30, 'Interpreter', 'latex');
ylabel('Diffraction Angle ($\theta_r$, degrees)', 'FontSize', 30, 'Interpreter', 'latex');
title('Diffraction Angles vs. Diffraction Orders at multiple angle of incidences on DLP7000, $p = 13.68/\sqrt{2} \, \mu\mathrm{m}, \theta_{\mathrm{inc}} = [0^\circ, 30^\circ, 45^\circ]$', ...
      'FontSize', 30, 'Interpreter', 'latex');

% Grid and tick styling
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.7, ...
    'LineWidth', 1, ...
    'TickDir', 'in', ...
    'TickLength', [0.015 0.025], ...
    'FontSize', 25);

% Legend with proper LaTeX and explicit handles
legend(plot_handles, legend_entries, 'Location', 'best', 'Interpreter', 'latex', ...
       'FontSize', 25, 'Box', 'on', 'EdgeColor', 'k');

% Final adjustments
set(gca, 'Layer', 'top');
box on;
hold off;