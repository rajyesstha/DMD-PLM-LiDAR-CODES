% Input parameters
orders = -2:4;
theta_i = 45;
lambda = 0.905;
pitch = 13.68 / sqrt(2);
sensor_size = 3.2;
focal_length = 73.6; % New focal length
distance_to_plane = 1000;

% Calculate diffraction angles
theta_d = asind(sind(theta_i) - orders * lambda / pitch);

% Calculate FOV at 0th order (angular) for original and new focal lengths
fov_0_angle_original = 2 * atand(sensor_size / (2 * 24.5)); % Original FOV at f = 24.5 mm
fov_0_angle_new = 2 * atand(sensor_size / (2 * focal_length)); % New FOV at f = 73.6 mm

% Calculate chief ray angles for original FOV (to define grid)
chief_1_original = theta_i - fov_0_angle_original / 2;
chief_2_original = theta_i + fov_0_angle_original / 2;

% Calculate original edges (for grid size)
left_edges_original = asind(sind(chief_1_original) - orders * lambda / pitch);
right_edges_original = asind(sind(chief_2_original) - orders * lambda / pitch);
width_angle_0_original = right_edges_original(orders == 0) - left_edges_original(orders == 0);
height_angle_0_original = width_angle_0_original; % Fixed grid height from original f = 24.5 mm

% Calculate new edges (for shrunk projection)
chief_1_new = theta_i - fov_0_angle_new / 2;
chief_2_new = theta_i + fov_0_angle_new / 2;
left_edges_new = asind(sind(chief_1_new) - orders * lambda / pitch);
right_edges_new = asind(sind(chief_2_new) - orders * lambda / pitch);
width_angle_0_new = right_edges_new(orders == 0) - left_edges_new(orders == 0);
height_angle_0 = width_angle_0_new; % New height tied to zeroth order, scales down

% Colors
color_palette = [
    0.4980    0.4980    1.0000;  % fourth order
    0.0000    1.0000    1.0000;  % third order 
    1.0000    0.0000    1.0000;  % second order
    0.7490    0.7490    0.0000;  % first order 
    1.0000    0.0000    0.0000;  % zeroth order
    0.0000    1.0000    0.0000;  % minus one order 
    0.0000    0.0000    1.0000;  % minus two order
];

% Ensure palette matches orders
if length(orders) > size(color_palette, 1)
    error('Not enough colors in the palette for the number of orders.');
end

% Plotting
figure;
hold on;
for i = 1:length(orders)
    % Grid dimensions (fixed from f = 24.5 mm)
    x_center = theta_d(i);
    width_angle_grid = right_edges_original(i) - left_edges_original(i); % Full grid width
    x_left_grid = x_center - width_angle_grid / 2;
    x_right_grid = x_center + width_angle_grid / 2;
    y_bottom_grid = -height_angle_0_original / 2;
    y_top_grid = height_angle_0_original / 2;
    
    % Shrunk projection (f = 73.6 mm)
    width_angle_projection = right_edges_new(i) - left_edges_new(i); % Shrunk width
    
    % Plot shrunk rectangle centered in grid
    rectangle('Position', [x_center - width_angle_projection / 2, -height_angle_0 / 2, width_angle_projection, height_angle_0], ...
              'EdgeColor', color_palette(i, :), 'FaceColor', color_palette(i, :), 'LineWidth', 2);
    
    % Calculate dimensions in mm
    width_mm_grid = 2 * tand(width_angle_grid / 2) * distance_to_plane; % Full grid width
    height_mm_grid = 2 * tand(height_angle_0_original / 2) * distance_to_plane; % Fixed grid height
    width_mm_projection = 2 * tand(width_angle_projection / 2) * distance_to_plane; % Shrunk projection width
    height_mm_projection = 2 * tand(height_angle_0 / 2) * distance_to_plane; % Shrunk projection height
    
    % Grid cell dimensions (fixed)
    small_width_mm = width_mm_grid / 3;
    small_height_mm = height_mm_grid / 3;

    % Draw complete 3x3 grid with outer borders
    % Horizontal lines (including top and bottom borders)
    for row = 0:3
        y_grid = -height_angle_0_original / 2 + row * (height_angle_0_original / 3);
        plot([x_left_grid, x_right_grid], [y_grid, y_grid], '--k', 'LineWidth', 1.5);
    end
    % Vertical lines (including left and right borders)
    for col = 0:3
        x_grid = x_left_grid + col * (width_angle_grid / 3);
        plot([x_grid, x_grid], [y_bottom_grid, y_top_grid], '--k', 'LineWidth', 1.5);
    end

    % Add text
    text(x_center, height_angle_0_original / 2 + 0.2, sprintf('%.2f$^\\circ$', x_center), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 18, 'Color', 'k', 'Interpreter', 'latex');
    text(x_center, -height_angle_0_original / 2 - 0.2, sprintf('W: %.2f mm', width_mm_projection), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 18, 'Color', 'k', 'Interpreter', 'latex');
    text(x_center, -height_angle_0_original / 2 - 0.2, sprintf('\n\n H: %.2f mm', height_mm_projection), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 18, 'Color', 'k', 'Interpreter', 'latex');
    text(x_center, -height_angle_0_original / 2 - 0.5, ...
         sprintf('\n\n\n Grid: \n%.2f mm\n$\\times$\n%.2f mm', small_height_mm, small_width_mm), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 18, 'Color', 'k', 'Interpreter', 'latex');
end

% Axis limits and labels
xlim([12 73]);
ylim([-height_angle_0_original * 0.8, height_angle_0_original * 1.2]);
xlabel('LiDAR Steering Angle (degrees)', 'fontsize', 25);
title({'\textbf{Sub-Sub-FOVs at each order at distance $d$ from Rx-DMD}', ...
       sprintf('$d = %.2f mm, f = %.2f mm, \\lambda = %.3f \\mu m, \\, \\theta_{inc} = %.1f^\\circ$', distance_to_plane, focal_length, lambda, theta_i)}, ...
       'Interpreter', 'latex', 'fontsize', 25); 
grid off;
axis equal;
set(gca, 'YColor', 'none');
set(gca, 'XDir', 'normal', 'fontsize', 22);

% Legend
legend_objects = gobjects(length(orders), 1);
for i = 1:length(orders)
    legend_objects(i) = plot(nan, nan, 's', 'MarkerSize', 20, ...
                              'MarkerFaceColor', color_palette(i, :), ...
                              'MarkerEdgeColor', 'none');
end
legend(legend_objects, arrayfun(@(x) sprintf('Order %d', x), orders, 'UniformOutput', false), ...
       'Location', 'northeastoutside', 'FontSize', 15);

hold off;