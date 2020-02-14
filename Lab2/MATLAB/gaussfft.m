function psf = gaussfft(pic, t)
f = pic;
[xsize, ysize] = size(f);
[x, y] = meshgrid(-xsize/2 : xsize/2 - 1, -ysize/2 : ysize/2 - 1);
g = fftshift(exp(-(x.*x+y.*y)/(2*t))/(2*pi*t));

F = fft2(f);
G = fft2(g);
psf = ifft2(F.*G);
end