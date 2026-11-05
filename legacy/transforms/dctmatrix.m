function [ c ] = dctmatrix( N )
N=100;
[cc,rr] = meshgrid(0:N-1);
c = sqrt(2 / N) * cos(pi *(2*cc + 1) .* rr / (2 * N));
c(1,:) = c(1,:) / sqrt(2);