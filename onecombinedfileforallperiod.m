%CGH GENERATION FOR 905nm ALL AT ONCE.
%RAJESH SHRESTHA
%JULY 15, 2025


rows = 800;     % Number of rows in the CGH pattern
cols = 1280;    % Number of columns in the CGH pattern
%theta_deg_values = [0, 45, 90, 135, 180, 225, 270, 315]; % Angles to process
theta_deg_values = 0;
% Loop over theta_deg values
for theta_deg = theta_deg_values
    % Loop over gp values from 1 to 3 with a step of 1
    for gp = 2:1:2
        onecombinedcghfileforallperiod(gp, theta_deg, rows, cols);
    end
end

function onecombinedcghfileforallperiod(gp, theta_deg, rows, cols)

% Build a full-frame CGH bit-pattern BMP for a given grating period gp and angle theta_deg.
% Works for any positive gp (integer or non-integer).

% Validate gp
if gp <= 0
    error('Grating period gp must be positive.');
end

% Threshold percentages for mapping
thr_pct = [1.37420442,2.140099448,3.339651934,4.665104972, ...
           5.801707182,7.928027624,11.68755801,20.25229282, ...
           27.6139779,30.60411602,35.11205525,41.69735359, ...
           48.24418232,55.61985635,65.7058895,100];

%% Generate raw index map at the requested angle
[idx,~,~] = CreateCGH(gp, theta_deg, thr_pct, rows, cols);

%% Determine ascending / descending criterion
isDesc = mod(theta_deg,360) >= 180;

%% Shift so first cycle is ascending (for <180°) or descending (for ≥180°)
if abs(cosd(theta_deg)) < 1e-6 % Vertical grating (theta ≈ 90, 270)
    % Shift vertically
    col1 = idx(:,1);
    gp_int = ceil(gp);
    if ~isDesc
        [~, k] = min(col1(1:gp_int));
    else
        [~, k] = max(col1(1:gp_int));
    end
    sh = -(k-1);
    idx = circshift(idx, [sh, 0]);
else
    % Shift horizontally
    row1 = idx(1,:);
    gp_int = ceil(gp);
    if ~isDesc
        [~, k] = min(row1(1:gp_int));
    else
        % Find the index that starts a descending cycle
        max_val = max(row1(1:gp_int));
        k = find(row1(1:gp_int) == max_val, 1, 'last');
    end
    sh = -(k-1);
    idx = circshift(idx, [0, sh]);
end

%% Build 2×2-pixel bit-pattern BMP
tiles = { [0 1;0 1],[0 1;0 0],[0 0;0 1],[0 1;1 1], ...
          [0 0;0 0],[0 1;1 0],[0 0;1 1],[0 0;1 0], ...
          [1 1;0 1],[1 1;0 0],[1 0;0 1],[1 0;0 0], ...
          [1 1;1 1],[1 1;1 0],[1 0;1 1],[1 0;1 0] };
BMP = zeros(rows*2, cols*2);
for i = 1:rows
    for j = 1:cols
        BMP(2*i-1:2*i, 2*j-1:2*j) = tiles{ idx(i,j)+1 };
    end
end
fname = sprintf('CGH_gp_%.1f_theta%g_bits.bmp', gp, theta_deg);
imwrite(uint8(BMP*255), fname);
fprintf('Saved %s\n', fname);

%% Output the first 10x10 pattern of the index map
fprintf('gp = %.1f, theta = %g, First 10x10 idx pattern:\n', gp, theta_deg);
disp(idx(1:15,1:15));
end

function [idx,used,n] = CreateCGH(gp, theta_deg, thr_pct, rows, cols)
% Create index (0-15) map for a tilted blazed grating using first-threshold mapping
idx = zeros(rows,cols); used = false(16,1); n = zeros(rows,cols);
t = deg2rad(theta_deg);
if abs(cos(t)) < 1e-6 % theta ≈ 90, 270 (vertical grating)
    isDesc = mod(theta_deg,360) >= 180;
    for i = 1:rows
        y = i-1;
        % Adjust phase for ascending/descending
        if isDesc
            val = mod((1 - (y/gp)) * 100, 100); % Reverse phase for descending
        else
            val = mod((y/gp) * 100, 100);
        end
        for j = 1:cols
            n(i,j) = val;
            k = find(val <= thr_pct, 1, 'first');
            if isempty(k), k = 16; end
            idx(i,j) = k-1;
            used(k) = true;
        end
    end
else
    % General case: tilted grating
    for i = 1:rows
        y = i-1;
        for j = 1:cols
            x = j-1;
            % Normalize by gp to enforce periodicity
            phase = (x*cos(t) - y*sin(t)+0.00001)/gp;
            isDesc = mod(theta_deg,360) >= 180;
            if isDesc
                val = mod((1 - phase) * 100, 100); % Reverse phase for descending
            else
                val = mod(phase * 100, 100);
            end
            n(i,j) = val;
            k = find(val <= thr_pct, 1, 'first');
            if isempty(k), k = 16; end
            idx(i,j) = k-1;
            used(k) = true;
        end
    end
end
end
 
