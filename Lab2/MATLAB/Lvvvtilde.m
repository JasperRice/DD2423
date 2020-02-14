function pixels = Lvvvtilde(inpic, shape)
if (nargin < 2)
    shape = 'same';
end
%% Lx, Ly
% Get first order derivative
[dxmask, dymask] = get_kernel(2);

% Include masks into 5x5 matrix
dxmask_5 = zeros(5,5);
dxmask_5(3, 2:4) = dxmask;
dymask_5 = zeros(5,5);
dymask_5(2:4, 3) = dymask;

% Convolution
Lx = filter2(dxmask_5, inpic, shape);
Ly = filter2(dymask_5, inpic, shape);

%% Lxx, Lyy
% Get the second order derivative kernel
[dxxmask, dyymask] = get_kernel(5);

% Include masks into 5x5 matrix
dxxmask_5 = zeros(5,5);
dxxmask_5(3, 2:4) = dxxmask;
dyymask_5 = zeros(5,5);
dyymask_5(2:4, 3) = dyymask;

% Convolution
Lxx = filter2(dxxmask_5, inpic, shape);
Lyy = filter2(dyymask_5, inpic, shape);

%% Lxxx
dxxxmask_5 = conv2(dxmask_5, dxxmask_5, 'same');
Lxxx = filter2(dxxxmask_5, inpic, shape);

%% Lxxy
dxxymask_5 = conv2(dxxmask_5, dymask_5, 'same');
Lxxy = filter2(dxxymask_5, inpic, shape);

%% Lxyy
dxyymask_5 = conv2(dxmask_5, dyymask_5, 'same');
Lxyy = filter2(dxyymask_5, inpic, shape);

%% Lxxx
dyyymask_5 = conv2(dymask_5, dyymask_5, 'same');
Lyyy = filter2(dyyymask_5, inpic, shape);

%% Output
pixels = Lx.^3 .* Lxxx + 3 * Lx.^2 .* Ly .* Lxxy + 3 * Lx .* Ly.^2 .* Lxyy + Ly.^3 .* Lyyy;

end