% Constants
wavelength_nm = 905 ; % Laser wavelength in nm
piston_displacements = [1.07, 2.19, 4.5, 5.98, 7.75, 12.06, 18.50, 36.55, 39.55, 45.10, 52.44, 63.93, 71.16, 85.02, 100]; % Piston displacements in percentage
max_displacement_nm = 296.7; % Maximum displacement at 100% (p15) in nm
% Calculate phase displacements for each phase level
phase_displacements = piston_displacements / 100 * max_displacement_nm;
% Initialize variables
closest_npi_phase_level = -1;
closest_npi_difference = Inf;
exact_phase_difference = 0;
fraction = 2/5;

requiredphase = fraction * pi;
% Loop through phase levels
for i = 1:length(phase_displacements)
    % Calculate the phase displacement for the current level
    current_displacement = phase_displacements(i);
    
    % Calculate the phase difference (in radians) for the given wavelength
    phase_difference = 2 * current_displacement * 2 * pi / wavelength_nm;
    
    % Check if the phase difference exceeds π
    if phase_difference >= requiredphase
        % Use the previous phase level
        closest_npi_phase_level = i - 1;
        exact_phase_difference = 2 * phase_displacements(closest_npi_phase_level) * 2 * pi / wavelength_nm;
        break; % Exit the loop
    end
    
    % Update the closest phase level if this is closer to π
    difference_from_npi = abs(phase_difference - requiredphase);
    if difference_from_npi < closest_npi_difference
        closest_npi_difference = difference_from_npi;
        closest_npi_phase_level = i;
        exact_phase_difference = phase_difference;
    end
end
% Display the result
format rat % Set the display format to fractions
fprintf('The phase level closest to %.6f π phase (without exceeding π) is p%d.\n', fraction, closest_npi_phase_level);
fprintf('Exact phase difference: %.4f π radians\n', exact_phase_difference / pi);

