clear;
triangle = triangle128;
tools = few256;
house = godthem256;
houghtest = houghtest256;

inpic = triangle;
N = size(inpic, 2);

% theta: from -90 to +90 (plus 0)
ntheta = 180 + 1;

% rho: from -sqrt(2) * D to + sqrt(2) * D (plus 0). D is the diagonal distance
% of the image.
nrho = 2 * 2 * (N-1);

[lines, acc] = houghedgeline(inpic, 4, 8, nrho, ntheta, 3, 2);
lines_N = size(lines, 1);
lines_M = size(lines, 2);
outcurves = zeros(lines_N, lines_M);

for i = 1 : lines_M
    x0 = 0;
    y0 = (lines(1,i) - x0 * cos(lines(2,i))) / sin(lines(2,i));
    dx = N^2;
    dy = (lines(1,i) - dx * cos(lines(2,i))) / sin(lines(2,i));
    outcurves(1, 4 * (i-1) + 1) = 0;
    outcurves(2, 4 * (i-1) + 1) = 3;
    outcurves(2, 4 * (i-1) + 2) = x0 - dx;
    outcurves(1, 4 * (i-1) + 2) = y0 - dy;
    outcurves(2, 4 * (i-1) + 3) = x0;
    outcurves(1, 4 * (i-1) + 3) = y0;
    outcurves(2, 4 * (i-1) + 4) = x0 + dx;
    outcurves(1, 4 * (i-1) + 4) = y0 + dy;
end
figure; overlaycurves(inpic, outcurves);