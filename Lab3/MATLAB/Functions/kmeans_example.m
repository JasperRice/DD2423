K = 8;               % number of clusters used
L = 10;              % number of iterations
seed = 14;           % seed used for random initialization
scale_factor = 1.0;  % image downscale factor
image_sigma = 1.0;   % image preblurring scale

I = imread('orange.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

tic
[ segm, centers ] = kmeans_segm(I, K, L, seed);
toc
Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);
figure; imshow(Inew);
figure; imshow(I);
imwrite(Inew,'result/kmeans1.png')
imwrite(I,'result/kmeans2.png')