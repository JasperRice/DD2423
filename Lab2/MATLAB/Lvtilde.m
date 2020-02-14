function pixels = Lvtilde(inpic, kernel_type, shape)
if (nargin < 3)
    shape = 'same';
end
[dxmask, dymask] = get_kernel(kernel_type);
Lx = filter2(dxmask, inpic, shape);
Ly = filter2(dymask, inpic, shape);
pixels = sqrt(Lx.^2 + Ly.^2);
end