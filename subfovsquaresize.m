% Input parameters
orders = -2:4;
theta_i = 45;
lambda = 0.905;
pitch = 13.68 / sqrt(2);
sensor_size = 3.2;
focal_length = 24.13 ;
distance_to_plane = 575; % from rx dmd to image plane

% Calculate diffraction angles
theta_d = asind(sind(theta_i) - orders * lambda / pitch);

% Calculate FOV at 0th order (angular)
fov_0_angle = 2 * atand(sensor_size / (2 * focal_length)); % FOV angle in degrees

% Calculate chief ray angles
chief_1 = theta_i - fov_0_angle / 2;
chief_2 = theta_i + fov_0_angle / 2;

% Calculate sub-FOVs (in degrees)
sub_fov = asind(sind(chief_2) - orders * lambda / pitch) - asind(sind(chief_1) - orders * lambda / pitch);

% Calculate the angular positions of the rectangle edges
left_edges = asind(sind(chief_1) - orders * lambda / pitch);
right_edges = asind(sind(chief_2) - orders * lambda / pitch);

% Calculate HEIGHT (angular) of the zeroth order
width_angle_0 = right_edges(orders == 0) - left_edges(orders == 0);
height_angle_0 = width_angle_0; % Angular height is equal to angular width for 0th order

% Colors extracted from the image (normalized RGB for MATLAB)
color_palette = [
    0.4980    0.4980    1.0000;  % fourth order
    0.0000    1.0000    1.0000;  % third order 
    1.0000    0.0000    1.0000;  % second order
    0.7490    0.7490    0.0000;  % first order 
    1.0000    0.0000    0.0000;  % zeroth order
    0.0000    1.0000    0.0000;  % minus one order 
    0.0000    0.0000    1.0000;  % minus two order
];

% Ensure the palette matches the number of orders
if length(orders) > size(color_palette, 1)
    error('Not enough colors in the palette for the number of orders.');
end

% Plotting
figure;
hold on;
for i = 1:length(orders)
    % Calculate x-positions (diffraction angles)
    x_center = theta_d(i);
    width_angle = right_edges(i) - left_edges(i); % Width in angles

    % Plot rectangle using angular width and the zeroth-order angular height
    rectangle('Position', [x_center - width_angle / 2, -height_angle_0 / 2, width_angle, height_angle_0], ...
              'EdgeColor', color_palette(i, :), 'FaceColor', color_palette(i, :), 'LineWidth', 2);

    % Calculate dimensions in mm
    width_mm = 2 * tand(width_angle / 2) * distance_to_plane; % Width in mm
    height_mm = 2 * tand(height_angle_0 / 2) * distance_to_plane; % Height in mm

    % Calculate dimensions of each smaller grid
    small_width_mm = width_mm / 3;
    small_height_mm = height_mm / 3;

    % % Add 3x3 grid within the rectangle (black dashed lines), including borders
    % for row = 0:3
    %     % Horizontal grid lines (including top and bottom edges)
    %     y_grid = -height_angle_0 / 2 + row * (height_angle_0 / 3);
    %     plot([x_center - width_angle / 2, x_center + width_angle / 2], [y_grid, y_grid], '--k', 'LineWidth', 1.5);
    % end
    % for col = 0:3
    %     % Vertical grid lines (including left and right edges)
    %     x_grid = x_center - width_angle / 2 + col * (width_angle / 3);
    %     plot([x_grid, x_grid], [-height_angle_0 / 2, height_angle_0 / 2], '--k', 'LineWidth', 1.5);
    % end

    % Add text for LiDAR steering angle (top of the rectangle) with LaTeX formatting
    text(x_center, height_angle_0 / 2 + 0.2, ...
         sprintf('%.2f$^\\circ$', x_center), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
         'FontSize', 18, 'Color', 'k', 'Interpreter', 'latex');

    % Add text for width info (center of the rectangle)
    text(x_center, -height_angle_0 / 2 - 0.2, sprintf('W: %.2f mm', width_mm), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 18, 'Color', 'k', 'Interpreter', 'latex');

    % Add text for height info (below width)
    text(x_center, -height_angle_0 / 2 - 0.2, sprintf('\n\n H: %.2f mm', height_mm), ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 18, 'Color', 'k', 'Interpreter', 'latex');

    % % Add small grid dimensions below each box
    % text(x_center, -height_angle_0 / 2 - 0.5, ...
    %      sprintf('\n\n\n Grid: \n%.2f mm\n$\\times$\n%.2f mm', small_height_mm, small_width_mm), ...
    %      'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 18, 'Color', 'k', 'Interpreter', 'latex');
end

% Set axis limits (adjust if needed)
xlim([12 73]); % Adjusted x limits for better visualization
ylim([-height_angle_0 * 0.8, height_angle_0 * 1.2]);

xlabel('LiDAR Steering Angle (degrees)', 'fontsize', 25);

title({'\textbf{Continuous SubFOVs formed at each LiDAR steering angle at distance $D$ from Rx-DMD}', ...
       sprintf('$D = %.2f mm, f = %.2f mm, \\lambda = %.3f \\mu m, \\, \\theta_i = %.1f^\\circ$', distance_to_plane, focal_length, lambda, theta_i)}, ...
       'Interpreter', 'latex', 'fontsize', 25); 

grid off;
axis equal; % Very important to maintain aspect ratio

% Remove y-axis
set(gca, 'YColor', 'none');
set(gca, 'XDir', 'normal', 'fontsize', 22); % Ensure normal x-axis orientation

% Add legend
legend_objects = gobjects(length(orders), 1); % Initialize empty array for legend objects
for i = 1:length(orders)
    % Create dummy objects for legend (small colored markers)
    legend_objects(i) = plot(nan, nan, 's', 'MarkerSize', 20, ...
                              'MarkerFaceColor', color_palette(i, :), ...
                              'MarkerEdgeColor', 'none');
end

% Create the legend and set the font size
lgd = legend(legend_objects, arrayfun(@(x) sprintf('Order %d', x), orders, 'UniformOutput', false), ...
             'Location', 'northeastoutside');
lgd.FontSize = 20; % Adjust the font size to make it slightly bigger

hold off;
