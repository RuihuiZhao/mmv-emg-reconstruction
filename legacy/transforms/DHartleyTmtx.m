function [Phi]=DHartleyTmtx(N)
%DHartleyT Summary of this function goes here
% Detailed explanation goes here 
% N is the dimension of WN
% HN is the Discrete Hartley Transform matrix
[k,n]=meshgrid(0:N-1);
Phi=sqrt(1/N)*(cos(2*pi/N*n.*k)+sin(2*pi/N*n.*k));
end
