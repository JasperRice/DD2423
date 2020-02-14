function [segmentation, centers] = kmeans_segm(image, K, L, seed)
%% Get image information
Height = size(image, 1);
Width = size(image, 2);
Image_double = double(image);
Image_vector = reshape(Image_double, Height*Width, 3);

%% Randomly initialize the K cluster centers
rng(seed);
centers = randi([0 255], 3, K)';
% centers = rand(3, K)';
% K = 3; centers = [255 255 255; 255 127 0; 127 127 127];

%% Compute all distances between pixels and cluster centers
Distances = pdist2(Image_vector, centers);

%% Iterate L times
for i = 1 : L
    %% Assign each pixel to the cluster center for which the distance is minimum
    [~, segm_vector] = min(Distances, [], 2);
    
    %% Recompute each cluster center by taking the mean of all pixels assigned to it
    for j = 1 : K
        Pixel_index = find(segm_vector == j);
        centers(j,:) = mean(Image_vector(Pixel_index, :));
    end
        
    %% Recompute all distances between pixels and cluster centers
    Distances = pdist2(Image_vector, centers);
end

% %% Iterate until converge
% centers_copy = zeros(size(centers));
% segmentation = ones(Height*Width, 3);
% segm_copy = zeros(Height*Width, 3);
% iterate = 0;
% while ~(prod(prod(centers==centers_copy))*prod(prod(segmentation==segm_copy)))
%     centers_copy = centers;
%     segm_copy = segmentation;
%     iterate = iterate + 1;
%     [~, segmentation] = min(Distances, [], 2);
%     for j = 1 : K
%         Pixel_index = find(segmentation == j);
%         centers(j,:) = mean(Image_vector(Pixel_index, :));
%     end
%     Distances = pdist2(Image_vector, centers);
% end
% fprintf(sprintf('Iterate times = %0.0f', iterate - 1));

%% Output
segmentation = reshape(segm_vector, Height, Width);
% centers = ceil(centers);
end