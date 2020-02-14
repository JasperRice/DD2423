function [linepar, acc] = houghedgeline(pic, scale, gradmagnthreshold, nrho, ntheta, nlines, verbose)
curves = extractedge(pic, scale, gradmagnthreshold, 'same', verbose);
Lv = Lvtilde(pic, 2);

if verbose > 0
    figure; overlaycurves(pic, curves);
    figure; showgrey(Lv);
end

[linepar, acc] = houghline(curves, Lv, nrho, ntheta, gradmagnthreshold, nlines, verbose);
end