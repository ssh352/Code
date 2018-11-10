function [x, y] = fn_AdaptiveBinPDF(draws,bins)
% function [x, y] = fn_AdaptiveBinPDF(draws,bins)
% x: x-axis values.
% y: probability density function (pdf).
%
% Daniel Waggoner, June 2015
% Copyright (C) 2015 Daniel Waggoner
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

z=sort(draws,'ascend');
inc=numel(z)/bins;
x=zeros(bins,1);
y=zeros(bins,1);
for i=1:bins
    x0=z(floor((i-1)*inc)+1);
    x1=z(floor(i*inc));
    x(i)=(x0+x1)/2;
    y(i)=(1/bins)/(x1-x0);
end