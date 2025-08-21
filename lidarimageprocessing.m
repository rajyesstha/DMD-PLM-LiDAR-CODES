% Load image
img = imread('letterrplusfour.png');
img_d = im2double(img);

% Convert to HSV
hsv_img = rgb2hsv(img_d);
H = hsv_img(:,:,1);
S = hsv_img(:,:,2);
V = hsv_img(:,:,3);

% Relaxed thresholds for better feature coverage
hue_range     = (H > 0.1) & (H < 0.35);   % yellow to green
saturation_ok = (S > 0.6);
value_ok      = (V > 0.4);

% Combined mask
target_mask = hue_range & saturation_ok & value_ok;
target_mask = bwareaopen(target_mask, 1);  % Remove tiny specks

% ==== CUSTOM BACKGROUND COLOR ====
% [R, G, B] values in range [0, 1]
custom_bg = [1,1,1];  % Example: dark gray background

% Create a background canvas with the chosen color
output_img = cat(3, ...
    custom_bg(1) * ones(size(img_d,1), size(img_d,2)), ...
    custom_bg(2) * ones(size(img_d,1), size(img_d,2)), ...
    custom_bg(3) * ones(size(img_d,1), size(img_d,2)));

% Apply mask to blend target on background
for c = 1:3
    temp = img_d(:,:,c);
    output_channel = output_img(:,:,c);
    output_channel(target_mask) = temp(target_mask);  % overwrite only target
    output_img(:,:,c) = output_channel;
end

% Display and save result
imshow(output_img);
title('Target with Custom Background');
imwrite(output_img, 'letterr-fourthorder.png');
