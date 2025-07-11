% Define the size of the phantom

clear, close all,  clc; 

phantom_size = [272, 272, 136];

% Create the phantom with pixel values ranging from 1 to 10
phantom = randi([1, 10], phantom_size);

load('phantoms\original_phantom\optical_prop_757.mat');
load('phantoms\original_phantom\optical_prop_800.mat');
load('phantoms\original_phantom\optical_prop_850.mat');



% Define the number of shapes to place inside the phantom
num_shapes = 300:100:1000; %randi([100, 250]);
for k = 1 %:size(num_shapes, 2)
    %% 
    load('phantoms\original_phantom\medium_indices_3d_757.mat')
    load('phantoms\original_phantom\medium_indices_3d_800.mat')
    load('phantoms\original_phantom\medium_indices_3d_850.mat')
    %% 
    
    breast_mask = medium_indices_3d_850 > 1; 
    
    medium_indices_3d_757 = medium_indices_3d_757 -1 ; 
    medium_indices_3d_800 = medium_indices_3d_800 -1 ; 
    medium_indices_3d_850 = medium_indices_3d_850 -1; 
    % Loop to generate and place each shape
    for i = 1:num_shapes(k)
        % Define the parameters of the random shape
        shape_value = randi([1, 5]); % Value of the shape
        radius_x = randi([6, 12]); % Radius in x-direction (for oval)
        radius_y = randi([6, 12]); % Radius in y-direction (for oval)
        radius_z = randi([3, 6]); % Radius in z-direction
        center_x = randi([1, phantom_size(1)]); % X-coordinate of the center
        center_y = randi([1, phantom_size(2)]); % Y-coordinate of the center
        center_z = randi([1, phantom_size(3)]); % Z-coordinate of the center
    
        % Create a meshgrid to represent the coordinates of the phantom
        [x, y, z] = meshgrid(1:phantom_size(2), 1:phantom_size(1), 1:phantom_size(3));
    
        % Calculate the distance of each point in the meshgrid from the center of the shape
        distance_from_center = ((x - center_x) / radius_x).^2 + ((y - center_y) / radius_y).^2 + ((z - center_z) / radius_z).^2;
    
        % Create a binary mask where points inside the shape are assigned the shape value
        shape_mask = distance_from_center <= 1;
    
        % Update the phantom with the shape
        phantom(shape_mask) = shape_value;
        medium_indices_3d_757(shape_mask) = shape_value; 
        medium_indices_3d_800(shape_mask) = shape_value; 
        medium_indices_3d_850(shape_mask) = shape_value; 
    end
    medium_indices_3d_757 = medium_indices_3d_757.*breast_mask + 1; 
    medium_indices_3d_800 = medium_indices_3d_800.*breast_mask  + 1; 
    medium_indices_3d_850 = medium_indices_3d_850.*breast_mask + 1; 

    Phantom_Folder = fullfile("Phantoms", sprintf("Phantom_with_Sphere_%s", num2str(num_shapes(k))));

    if ~exist(Phantom_Folder, 'dir')
        mkdir(Phantom_Folder)
    end

    save(fullfile(Phantom_Folder,'medium_indices_3d_757.mat'), 'medium_indices_3d_757'); 
    save(fullfile(Phantom_Folder,'medium_indices_3d_800.mat'), 'medium_indices_3d_800'); 
    save(fullfile(Phantom_Folder,'medium_indices_3d_850.mat'), 'medium_indices_3d_850');

    save(fullfile(Phantom_Folder,'optical_prop_757.mat'), 'optical_prop_757'); 
    save(fullfile(Phantom_Folder,'optical_prop_800.mat'), 'optical_prop_800'); 
    save(fullfile(Phantom_Folder,'optical_prop_850.mat'), 'optical_prop_850');

    figure, imagesc(log(1+medium_indices_3d_757(:,:, 60)));
    figure, imagesc(log(1+medium_indices_3d_800(:,:, 60)));

end 



% Display the phantom
%slice_viewer(phantom);
% figure, imagesc(log(1+medium_indices_3d_757(:,:, 60)));
% figure, imagesc(squeeze(log(1+medium_indices_3d_757(:,130, :))));

% for i=60:10:136
% figure, imagesc(log(1+medium_indices_3d_757(:,:, i)));
% end
