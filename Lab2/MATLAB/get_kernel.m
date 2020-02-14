function [deltax, deltay] = get_kernel(i)
switch i
    case 1 % Simple difference operator
        deltax = [-1 0 1];
        deltay = [-1; 0; 1];
    case 2 % Central difference operator
        deltax = [-0.5 0 0.5];
        deltay = [-0.5; 0; 0.5];
    case 3 % Roberts cross edge operator
        deltax = [1 0; 0 -1];
        deltay = [0 1; -1 0];
    case 4 % Sobel operator
        deltax = [-1 0 1; -2 0 2; -1 0 1];
        deltay = [1 2 1; 0 0 0; -1 -2 -1];
    case 5 % Second order central difference operator
        deltax = [1 -2 1];
        deltay = [1; -2; 1];
end
end