% Rectangle dimensions
length = 14.008; % in mm
width = 10.506; % in mm

% Define the corners of the rectangle with the origin at its center
corners = [
    -length/2, -width/2; % Bottom-left corner
    length/2, -width/2;  % Bottom-right corner
    length/2, width/2;   % Top-right corner
    -length/2, width/2;  % Top-left corner
];

% Add the first corner at the end to close the rectangle
corners = [corners; corners(1, :)];

% Define the rotation angle in degrees
rotation_angle = 45;
rotation_angle_rad = deg2rad(rotation_angle);

% Define the rotation matrix
R = [cos(rotation_angle_rad), -sin(rotation_angle_rad);
     sin(rotation_angle_rad),  cos(rotation_angle_rad)];

% Rotate the rectangle corners
rotated_corners = (R * corners')';

% Plot the original rectangle
figure;
plot(corners(:, 1), corners(:, 2), 'b-o', 'LineWidth', 2, 'DisplayName', 'Original Rectangle');
hold on;

% Plot the rotated rectangle
plot(rotated_corners(:, 1), rotated_corners(:, 2), 'r-o', 'LineWidth', 2, 'DisplayName', 'Rotated Rectangle');

% Formatting the plot
grid on;
axis equal;
xlabel('X (mm)');
ylabel('Y (mm)');
title('Rectangle Rotation by 45 Degrees');
legend show;

% Display coordinates before and after rotation
fprintf('Original Coordinates:\n');
for i = 1:size(corners, 1)-1
    fprintf('Corner %d: (%.3f, %.3f)\n', i, corners(i, 1), corners(i, 2));
end

fprintf('\nRotated Coordinates:\n');
for i = 1:size(rotated_corners, 1)-1
    fprintf('Corner %d: (%.3f, %.3f)\n', i, rotated_corners(i, 1), rotated_corners(i, 2));
end
