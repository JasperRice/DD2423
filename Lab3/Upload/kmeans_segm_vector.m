function [segm_vector, centers] = kmeans_segm_vector(Image_mask, K, L, seed)
%% Randomly initialize the K cluster centers
% rng(seed);
centers = randi([0 255], 3, K)';
% centers = rand(3, K)';

%% Compute all distances between pixels and cluster centers
Distances = pdist2(Image_mask, centers, 'euclidean');

%% Iterate L times
segm_vector = zeros(size(Image_mask, 1), 1);
for l = 1 : L
    %% Assign each pixel to the cluster center for which the distance is minimum
    [~, segm_vector] = min(Distances, [], 2);
    
    %% Recompute each cluster center by taking the mean of all pixels assigned to it
    for j = 1 : K
        Pixel_index = find(segm_vector == j);
        centers(j,:) = mean(Image_mask(Pixel_index, :));
    end

    %% Recompute all distances between pixels and cluster centers
    Distances = pdist2(Image_mask, centers, 'euclidean');
end

end