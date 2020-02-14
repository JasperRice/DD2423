function [linepar, acc] = houghline(curves, magnitude, nrho, ntheta, threshold, nlines, verbose)
%% Check if input appear to be valid
if nargin < 6
    error('Wrong # of arguments.')
    return
elseif nargin == 6
    verbose = 2;
end

%% Allocate accumulator space
acc = zeros(nrho, ntheta);

%% Define a coordinate system in the accumulator space
% rho: from -sqrt(2) * D to + sqrt(2) * D.
% D is the diagonal distance of the image. D = sqrt(2 * N^2) = N * sqrt(2)
rho_max = nrho / 2;
rho_coord_sys = linspace(-rho_max, rho_max, nrho);

theta_max = pi / 2;
theta_coord_sys = linspace(-theta_max, theta_max, ntheta);

%% Loop over all the input curves (cf. pixelplotcurves)
curve_size = size(curves, 2);
flag = 1;
num_curves = 0;
while flag <= curve_size
    curve_length = curves(2, flag);
    num_curves = num_curves + 1;
    flag = flag + 1;
    % For each point on each curve
    for curve_i = 1:curve_length
        x = curves(2, flag);
        y = curves(1, flag);
        magxy = magnitude(round(x), round(y));
        flag = flag + 1;
        % Check if valid point with respect to threshold
        if magxy < threshold
            continue;
        end
        % Loop over a set of theta values
        for theta_i = 1 : ntheta
            theta = theta_coord_sys(theta_i);
            rho = x * cos(theta) + y * sin(theta);
            % Find the accumulator cell rho must be in
            rho_placed = find(rho_coord_sys < rho, 1, 'last');
            acc(rho_placed, theta_i) = acc(rho_placed, theta_i) + 1; % Add 1 in accumulator
            % acc(rho_placed, theta_i) = acc(rho_placed, theta_i) + magxy; % Question 10
            % acc(rho_placed, theta_i) = acc(rho_placed, theta_i) + log(magxy); % Question 10
        end
    end
end

%% Extract local maxima from the accumulator
[pos, value, anms] = locmax8(acc);
[~, indexvector] = sort(value);
nmaxima = size(value, 1);
linepar = zeros(2, nlines);

%% Delimit the number of responses if necessary

%% Compute a line for each one of the strongest responses in the accumulator
for idx = 1 : nlines
    rhoidxacc = pos(indexvector(nmaxima - idx + 1), 1);
    thetaidxacc = pos(indexvector(nmaxima - idx + 1), 2);
    rho = rho_coord_sys(rhoidxacc);
    theta = theta_coord_sys(thetaidxacc);
    % Avoid infinity
    if theta == 0
        theta = 1e-6;
    end
    linepar(:, idx) = [rho; theta];
end

%% Overlay these curves on the gradient magnitude image
if verbose > 0
    figure; showgrey(anms); axis('square');
end
if verbose > 1
    figure; showgrey(binsepsmoothiter(acc, 0.5, 1)); axis('square');
end
%% Return the output data
end