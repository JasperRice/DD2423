function edgecurves = extractedge(inpic, scale, threshold, shape, show_overlay)
inpic_smoothed = discgaussfft(inpic, scale);
%% Lv
Lv = Lvtilde(inpic_smoothed, 2);
Lv_mask = ((Lv > threshold) - 0.5) * 2; % Match 0 to -1 and 1 still 1.
% figure; showgrey(Lv_mask); title("Lv mask");
%% Lvv
Lvv = Lvvtilde(inpic_smoothed, shape);
% figure; contour(Lvv, [0 0]); axis('image'); axis('ij'); title("Lvv = 0");
%% Lvvv
Lvvv = Lvvvtilde(inpic_smoothed, shape);
Lvvv_mask = ((Lvvv < 0) - 0.5) * 2;
% figure; showgrey(Lvvv_mask); title("Lvvv mask");
%% Edges
zerocross = zerocrosscurves(Lvv, Lvvv_mask);
edgecurves = thresholdcurves(zerocross, Lv_mask);
% figure; contour(edgecurves); title("Edges")
%% Verbose
if show_overlay
    figure; overlaycurves(inpic, edgecurves); % title("Over lay")
end

end