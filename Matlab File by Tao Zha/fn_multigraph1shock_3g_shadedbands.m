function fn_multigraph1shock_3g_shadedbands(imfn,xlab,ylab,tstring,XTick,nrowg,ncolg)
%Searching <<>> for ad hoc and specific changes.
%
%Stacking n sets of impulse responses in one graph.  See fn_multigraph2_ver2.m.
%   imfn: 1st D: "nstp" time horizon (in each graph),
%         2nd D: variables or number of graphs.
%         3rd D: low band, estimate, high band (in each graph).
%   xlab:   x-axis labels on the top
%   ylab:   y-axis labels on the left
%   tstring:  string for time (e.g., month or quarter) -- x-axis labels at the bottom
%   nrowg: number of rows in the graph
%   ncolg: number of columns in the graph
%
%  See imrgraph, imcerrgraph, imrerrgraph
% Copyright (C) 2016 Tao Zha
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

nstp = size(imfn,1);
ngraphs = size(imfn,2);

t = 1:nstp;
treverse = fliplr(t);

if (nrowg*ncolg < ngraphs)
   nrowg
   ncolg
   error('fn_multigraph1shock_3g_shadedbands: nrowg*ncolg must be greater than size(imfn,2)')
end


for (gk = 1:ngraphs)     
      subplot(nrowg,ncolg,gk)

      %set(0,'DefaultAxesColorOrder',[1 0 0;0 1 0;0 0 1],...
      %   'DefaultAxesLineStyleOrder','-|--|:')
      %set(0,'DefaultAxesLineStyleOrder','-|--|:|-.')
      %---<<>>
      %set(0,'DefaultAxesColorOrder',[0 0 0],...
      %   'DefaultAxesLineStyleOrder','-.|-.|-|--|-.|-*|--o|:d')

      %---<<>> 
      fill([t treverse],[imfn(:,gk,[3])' fliplr(imfn(:,gk,[1])')],[0.8,0.8,0.8],'EdgeColor','none');
      %plot(t,nseries(:,[1 3]), '-.k','LineWidth',1.0); %,'Color','k');
      hold on
      plot(t,imfn(:,gk,[2]), '-k','LineWidth',1.5);
      %plot(t,nseries(:,[4]), '--k','LineWidth',1.6);
      hold off
      grid;      
      %set(gca,'LineStyleOrder','-|--|:|-.')
      %set(gca,'LineStyleOrder',{'-*',':','o'})

      %set(gca,'YLim',[minval(i) maxval(i)])
      %
		set(gca,'XTick',XTick)

      if (~isempty(xlab)), title(char(xlab(gk))), end
		if (~isempty(ylab)), ylabel(char(ylab(gk))), end
      if (gk==ngraphs)
         xlabel(tstring)
      end
end


%Order of line styles and markers used in a plot.
%This property specifies which line styles and markers to use and in what order
%when creating multiple-line plots. For example,set(gca,'LineStyleOrder', '-*|:|o')sets LineStyleOrder to solid line with asterisk
%marker, dotted line, and hollow circle marker. The default is (-), which specifies
%a solid line for all data plotted. Alternatively, you can create a cell array
%of character strings to define the line styles:set(gca,'LineStyleOrder',{'-*',':','o'})MATLAB supports four line styles, which you can specify any number of
%times in any order. MATLAB cycles through the line styles only after using
%all colors defined by the ColorOrder property. For example,
%the first eight lines plotted use the different colors defined by ColorOrder with
%the first line style. MATLAB then cycles through the colors again, using the
%second line style specified, and so on.You can also specify line style and color directly with the plot and plot3 functions
%or by altering the properties of theline or
%lineseries objects after creating the graph. High-Level Functions and LineStyleOrderNote that, if the axes NextPlot property is set
%to replace (the default), high-level functions like plot reset
%the LineStyleOrder property before determining the line
%style to use. If you want MATLAB to use a LineStyleOrder that
%is different from the default, set NextPlot to replacechildren. Specifying a Default LineStyleOrderYou can also specify your own default LineStyleOrder.
%For example, this statementset(0,'DefaultAxesLineStyleOrder',{'-*',':','o'})
%creates a default value for
