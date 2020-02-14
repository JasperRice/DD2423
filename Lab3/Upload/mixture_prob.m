function prob = mixture_prob(image, K, L, mask)
%% Store all pixels for which mask=1 in a Nx3 matrix
[Height, Width, Color] = size(image);
Image_double = double(image);
Image_vector = reshape(Image_double, Height*Width, Color);
Mask_vector = reshape(mask, Height*Width, 1);
Image_mask = Image_vector(find(Mask_vector == 1), :);
N = size(Image_mask, 1);

%% Randomly initialize the K components using masked pixels
[segm_vector, centers] = kmeans_segm_vector(Image_mask, K, 5*L, 1234);
cov = cell(K, 1);
% cov(:) = {rand * eye(Color)};
cov(:) = {0.05 * rand * eye(Color)};
w = zeros(K ,1);
for k = 1 : K
    w(k) = sum(segm_vector(:, 1) == k) / N;
end

%% Iterate L times
g = zeros(N, K);
g_ = zeros(Height*Width, K);
for l = 1 : L
    %% Expectation: Compute probabilities P_ik using masked pixels
    for k = 1 : K
        mean = centers(k, :);
        diff = bsxfun(@minus, Image_mask, mean(k, :));
        g(:, k) = 1/sqrt(det(cov{k})*(2*pi)^3)*exp(-0.5*sum((diff/cov{k}.* diff), 2));
    end
    p = bsxfun(@times, g, w);
    p = bsxfun(@rdivide, p, sum(p, 2));
    
    %% Maximization: Update weights, means and covariances using masked pixels
    w = sum(p, 1) / size(p, 1);
    for k = 1 : K
        centers(k, :) = p(:, k)' * Image_mask / sum(p(:, k), 1);
        diff = bsxfun(@minus, Image_mask, centers(k, :));
        cov{k} = (diff' * bsxfun(@times, diff, p(:, k))) / sum(p(:, k), 1);
    end

end

%% Compute probabilities p(c_i) in Eq.(3) for all pixels I.
for k = 1 : K
    diff = bsxfun(@minus, Image_vector, centers(k, :));
    g_(:, k) = 1 / sqrt(det(cov{k}) * (2 * pi)^3) * exp(-0.5 * sum((diff / cov{k} .* diff), 2));
end
prob = sum(bsxfun(@times, g_, w), 2);
prob = reshape(prob, Height, Width, 1);

end