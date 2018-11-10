function fn_foreerr3lines(dates,allseries,nrows,ncols,ylab,forelabel,conlab)
%fn_foreerr3lines(dates,allseries,nrows,ncols,ylab,forelabel,conlab)
%
% Graph forecasts with error bands (3 lines in each graph: lower, hat, and higher).
%
% dates: dates on the horizontal axis.
% allseeries: 3-dimension, row:     the same dimension as dates;
%                          column:  variables;
%                          3rd dim: scenarios (low, high, actual, etc).
% nrows: number of rows in subplot
% ncols: number of columns in subplot
% q_m:  if 4 or 12, quarterly or monthly data.
% ylab:  string array for the length(keyindx)-by-1 variables
% forelabel:  title label for as of time of forecast
% conlab:  x-axis label for what conditions imposed; e.g., conlab = 'All bar MS shocks inspl'
%-------------
% No output argument for this graph file.
%  See fn_forerrgraph.m.
%
% Tao Zha, August 2015
% Copyright (C) 2015 Tao Zha
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

if ((nrows*ncols) < size(allseries,2))
   error('fn_foreerr3lines.m: (nrows*ncols) must be equal to or greater than size(allseries,2)');
end   
keyindx=[1:size(allseries,2)];
%keyindx=[1:(nrows*ncols)];
for (k=keyindx)
   subplot(nrows,ncols,k);
   plot(dates, allseries(:,k,2), ':*m','LineWidth',0.7);
   hold on;
   plot(dates, allseries(:,k,1), '--b','LineWidth',1.0);      
   plot(dates, allseries(:,k,3), '-.k','LineWidth',1.0);            
   hold off;
   grid;
   ylabel(char(ylab(k)));
   if k==keyindx(1)
      title(forelabel)
   elseif k>=length(keyindx)   
      xlabel(conlab)
   end
end
