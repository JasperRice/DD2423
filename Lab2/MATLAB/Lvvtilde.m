function pixels = Lvvtilde(inpic, shape)
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

%% Lxy
dxymask_5 = conv2(dxmask_5, dymask_5, 'same');
Lxy = filter2(dxymask_5, inpic, shape);

%% Output
pixels = Lx .^2 .* Lxx + 2 .* Lx .* Ly .* Lxy + Ly .^2 .* Lyy;

end