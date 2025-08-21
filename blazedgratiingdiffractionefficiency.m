% 
% % Plots diffraction efficiency vs diffraction orders for different CGH periodicities
% 
% % Clear previous figures and variables
% clear all;
% close all;
% 
% % Diffraction orders to plot
% orders = -4:4; % Orders from -3 to +3
% 
% % CGH periodicities
% periodicities = 1:5;
% 
% % Diffraction efficiencies for -1st order (from previous calculation)
% efficiency_minus1 = [77, 57.8, 38.5, 19.3, 9.6]; % -1st order efficiencies
% 
% % Initialize efficiency matrix (rows: periodicities, columns: orders)
% efficiencies = zeros(length(periodicities), length(orders));
% 
% % Estimate efficiencies for each order and periodicity
% for p = 1:length(periodicities)
%     % -1st order efficiency
%     idx_minus1 = find(orders == -1);
%     efficiencies(p, idx_minus1) = efficiency_minus1(p);
% 
%     % +1st order (10% of -1st order)
%     idx_plus1 = find(orders == 1);
%     efficiencies(p, idx_plus1) = 0.1 * efficiency_minus1(p);
% 
%     % 0th order (increases as -1st order decreases)
%     idx_0 = find(orders == 0);
%     efficiencies(p, idx_0) = 25 * (1 - (efficiency_minus1(p) / 77)) + 5; % Base 5% plus scaling
% 
%     % Higher orders (-3, -2, +2, +3) share remaining efficiency
%     remaining = 100 - efficiencies(p, idx_minus1) - efficiencies(p, idx_plus1) - efficiencies(p, idx_0);
%     idx_others = [find(orders == -3), find(orders == -2), find(orders == 2), find(orders == 3)];
%     efficiencies(p, idx_others) = remaining / length(idx_others); % Split equally
% end
% 
% % Create the plot
% figure('Name', 'Diffraction Efficiency vs Diffraction Orders', 'NumberTitle', 'off');
% hold on;
% 
% % Plot each periodicity
% colors = lines(length(periodicities)); % Different colors for each periodicity
% for p = 1:length(periodicities)
%     plot(orders, efficiencies(p, :), '-o', 'Color', colors(p, :), ...
%         'LineWidth', 1.5, 'MarkerSize', 6, ...
%         'DisplayName', sprintf('CGH Periodicity %d', periodicities(p)));
% end
% 
% % Customize the plot
% xlabel('Diffraction Order');
% ylabel('Diffraction Efficiency (%)');
% title('Diffraction Efficiency vs Diffraction Orders for Different CGH Periodicities');
% legend('Location', 'best');
% grid on;
% axis([-3.5 3.5 0 100]);
% hold off;


% diffraction_efficiency_plot.m
% Plots diffraction efficiency vs diffraction orders for a binary grating

% Clear previous figures and variables
clear all;
close all;

% Diffraction orders to plot
orders = -4:4; % Orders from -3 to +3

% Calculate diffraction efficiencies for a binary grating (50% duty cycle)
efficiencies = zeros(1, length(orders));
for i = 1:length(orders)
    m = orders(i);
    if m == 0
        efficiencies(i) = 0.25 * 100; % 25% for 0th order
    else
        % Efficiency for non-zero orders
        efficiencies(i) = ((2 / (pi * m))^2) * (sin(pi * m / 2)^2) * 100;
    end
end

% Create the plot
figure('Name', 'Diffraction Efficiency vs Diffraction Orders', 'NumberTitle', 'off');
hold on;

% Plot the efficiencies
plot(orders, efficiencies, '-o', 'LineWidth', 1.5, 'MarkerSize', 6, ...
    'DisplayName', 'Binary Grating (50% Duty Cycle)');

% Customize the plot
xlabel('Diffraction Order');
ylabel('Diffraction Efficiency (%)');
title('Diffraction Efficiency vs Diffraction Orders for Binary Grating');
legend('Location', 'best');
grid on;
axis([-3.5 3.5 0 50]);
hold off;