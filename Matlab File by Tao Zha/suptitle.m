function hout=suptitle(str)
%SUPTITLE Puts a title above all subplots.
%	SUPTITLE('text') adds text to the top of the figure
%	above all subplots (a "super title"). Use this function
%	after all subplot commands.

% Drea Thomas 6/15/95 drea@mathworks.com
% Copyright (C) 1997-2012 Drea Thomas
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


% Warning: If the figure or axis units are non-default, this
% will break.

% Parameters used to position the supertitle.

% Amount of the figure window devoted to subplots
plotregion = .92;

% Y position of title in normalized coordinates
titleypos  = .95;

% Fontsize for supertitle
fs = get(gcf,'defaultaxesfontsize')+4;

% Fudge factor to adjust y spacing between subplots
fudge=1;

haold = gca;
figunits = get(gcf,'units');

% Get the (approximate) difference between full height (plot + title
% + xlabel) and bounding rectangle.

	if (~strcmp(figunits,'pixels')),
		set(gcf,'units','pixels');
		pos = get(gcf,'position');
		set(gcf,'units',figunits);
	else,
		pos = get(gcf,'position');
	end
	ff = (fs-4)*1.27*5/pos(4)*fudge;

        % The 5 here reflects about 3 characters of height below
        % an axis and 2 above. 1.27 is pixels per point.

% Determine the bounding rectange for all the plots

% h = findobj('Type','axes');

% findobj is a 4.2 thing.. if you don't have 4.2 comment out
% the next line and uncomment the following block.

h = findobj(gcf,'Type','axes');  % Change suggested by Stacy J. Hills

% If you don't have 4.2, use this code instead
%ch = get(gcf,'children');
%h=[];
%for i=1:length(ch),
%  if strcmp(get(ch(i),'type'),'axes'),
%    h=[h,ch(i)];
%  end
%end




max_y=0;
min_y=1;

oldtitle =0;
for i=1:length(h),
	if (~strcmp(get(h(i),'Tag'),'suptitle')),
		pos=get(h(i),'pos');
		if (pos(2) < min_y), min_y=pos(2)-ff/5*3;end;
		if (pos(4)+pos(2) > max_y), max_y=pos(4)+pos(2)+ff/5*2;end;
	else,
		oldtitle = h(i);
	end
end

if max_y > plotregion,
	scale = (plotregion-min_y)/(max_y-min_y);
	for i=1:length(h),
		pos = get(h(i),'position');
		pos(2) = (pos(2)-min_y)*scale+min_y;
		pos(4) = pos(4)*scale-(1-scale)*ff/5*3;
		set(h(i),'position',pos);
	end
end

np = get(gcf,'nextplot');
set(gcf,'nextplot','add');
if (oldtitle),
	delete(oldtitle);
end
ha=axes('pos',[0 1 1 1],'visible','off','Tag','suptitle');
ht=text(.5,titleypos-1,str);set(ht,'horizontalalignment','center','fontsize',fs);
set(gcf,'nextplot',np);
axes(haold);
if nargout,
	hout=ht;
end



