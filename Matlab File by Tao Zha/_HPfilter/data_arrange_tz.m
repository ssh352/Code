%=== Writtien by Jake Smith.
close all
clear all
clc

% load and transform data
load raw_data.mat  %Gives data and names in the order of
% 1: Date
% 2: FFR
% 3: Unemployment
% 4: RGDP
% 5: CorePCE
% 6: PCE
% 7: CoreCPI
% 8: CPI
% 9: GDPDeflator
% 10: RGDPPotentialCBO
% 11: RGDPotentialFRBUS
% 12: RGDPTrendPotential
% 13: NAIRUCBO
% 14: NAIRUMA
% 15: NAIRUFRBUS
% 16: Michigan1YearAheadInflationExpectations
% 17: Michigan5-10YearAheadInflationExpectations

% want to plot?
to_plot = 1;


% need to do some conversions
interpolated_data = data;
interpolated_data(:,[10 11]) = 1000*interpolated_data(:,[10 11]);  %Converting to $Billion.


% hpfilter rgdp for another trend measurement of poptential
names{length(names)+1} = 'RGDP Potential HPFilter';  %18
interpolated_data(1:end-1,end+1) = hpfilter(data(1:end-1,4),1600);
interpolated_data(end,end) = NaN;

hpunemployment = hpfilter(data(1:end-1,3),1600);
names{length(names)+1} = 'Unemployment HPFilter';  %19
interpolated_data(1:end-1,end+1) = hpunemployment;
interpolated_data(end,end) = NaN;



%--- Linear Trend.  Redo the series 12.
y = log(data(1:end-1,4));
x = ones(length(y),1);
x(:,2) = [0:length(y)-1];
b = regress(y,x);
for i=1:length(y)
    trgdp(i) = b(1) + b(2)*i;
end
interpolated_data(1:end-1,12) = trgdp;



% Calculate the different gaps
names{length(names)+1} = 'OutputGap(CBO)';
interpolated_data(:,end+1) = log(interpolated_data(:,4)) - log(interpolated_data(:,10));

names{length(names)+1} = 'OutputGap(FRB/US)';
interpolated_data(:,end+1) = log(interpolated_data(:,4)) - log(interpolated_data(:,11));

names{length(names)+1} = 'OutputGap(Trend)';
interpolated_data(:,end+1) = log(interpolated_data(:,4)) - log(interpolated_data(:,12));

names{length(names)+1} = 'OutputGap(HPFilter)';
interpolated_data(:,end+1) = log(interpolated_data(:,4)) - log(interpolated_data(:,18));

% calculate the different unemployment gaps
names{length(names)+1} = 'UnemploymentGap(CBO)';
interpolated_data(:,end+1) = interpolated_data(:,13) - interpolated_data(:,3);
                                                      
names{length(names)+1} = 'UnemploymentGap(MA)';       
interpolated_data(:,end+1) = interpolated_data(:,14) - interpolated_data(:,3);
                                                      
names{length(names)+1} = 'UnemploymentGap(FRB/US)';   
interpolated_data(:,end+1) = interpolated_data(:,15) - interpolated_data(:,3);
                                                      
names{length(names)+1} = 'UnemploymentGap(HPFilter)'; 
interpolated_data(:,end+1) = interpolated_data(:,19) - interpolated_data(:,3);


for i=1:length(names), fprintf('%d: %s\n',i,names{i}); end
% 1: Date
% 2: FFR
% 3: Unemployment
% 4: RGDP
% 5: CorePCE
% 6: PCE
% 7: CoreCPI
% 8: CPI
% 9: GDPDeflator
% 10: RGDPPotentialCBO
% 11: RGDPotentialFRBUS
% 12: RGDPTrendPotential
% 13: NAIRUCBO
% 14: NAIRUMA
% 15: NAIRUFRBUS
% 16: Michigan1YearAheadInflationExpectations
% 17: Michigan5-10YearAheadInflationExpectations
% 18: RGDP Potential HPFilter
% 19: Unemployment HPFilter
% 20: OutputGap(CBO)
% 21: OutputGap(FRB/US)
% 22: OutputGap(Trend)
% 23: OutputGap(HPFilter)
% 24: UnemploymentGap(CBO)
% 25: UnemploymentGap(MA)
% 26: UnemploymentGap(FRB/US)
% 27: UnemploymentGap(HPFilter)


%--- swich rates to decimal (ffr, unemployment, nairu's, inflation
%---  expectations) quarterly rates (except unemployment rate).
interpolated_data(:,[2]) = interpolated_data(:,[2])./400;  %FRR
interpolated_data(:,[3 13 14 15 19 24:27]) = interpolated_data(:,[3 13 14 15 19 24:27])./100;  %Unemployment
interpolated_data(:,[16 17]) = interpolated_data(:,[16 17])./400;  %Inflation expectations.

%--- log difference -- quarterly changes (pce's,cpi's, deflator).
to_difference = [5 6 7 8 9];
for i=to_difference
   interpolated_data(2:end,i) = ( log(interpolated_data(2:end,i)) - log(interpolated_data(1:end-1,i)) );
end


% log-level (rgdp,potentialgdp's)
to_log = [4 10 11 18];
for i=to_log
    interpolated_data(:,i) = log(interpolated_data(:,i));
end


% plotting
if to_plot
    dates = interpolated_data(:,1);
    figure('PaperPosition',[0.25 1 8 9]); %[left bottom witdh height]  Tip: bottom + height = 10.0
    %figure;
    % plot all of the different measures of potential gdp
    plot(dates, interpolated_data(:,4), dates, interpolated_data(:,10), dates, interpolated_data(:,11), dates, interpolated_data(:,12),dates, interpolated_data(:,18));
    legend({names{4},names{10},names{11},names{12},names{18}});
    print -depsc2 fig_outputgaps.eps
    print -dpdf fig_outputgaps.pdf
    
    figure('PaperPosition',[0.25 1 8 9]); %[left bottom witdh height]  Tip: bottom + height = 10.0
    %figure
    u_plot = [3, 13, 14, 15, 19];
    hold all
    for i=u_plot
        plot(dates,interpolated_data(:,i));
    end
    hold off
    legend({names{u_plot}});
    print -depsc2 fig_unemploygaps.eps
    print -dpdf fig_unemploygaps.pdf
end

%--- Exporting the data to an ascii file for a review.
interpolated_data4C = interpolated_data(1:end,:);  %Note that there is not much data for the last row.
locs_nan = find(isnan(interpolated_data4C)); %Locations for NaN.
interpolated_data4C(locs_nan) = -1.0E+301; 
save outdata_dif_logData_all.prn interpolated_data4C -ascii
%--- Exporting the data to an ascii file for C programming.
interpolated_data4C = interpolated_data(38:end-1,[1 2 5 20]);  %FFR, Core PCE inflation, OutputGap(CBO). There is not much data for the last row, so we simply get rid of it.
if (~isempty(find(isnan(interpolated_data4C))))
   disp('  ');
   disp('************ Fatal error: cannot contain any NaNs **************')
   [[1:length(interpolated_data4C)]' interpolated_data4C]
   disp('************ Fatal error: cannot contain any NaNs **************')
end   
save outdata_dif_logData_moda1_3v_const.prn interpolated_data4C -ascii  



if (0)  %Exporting the data for dynare used by Jake.
   %---- Exporting ---%
   txt_data = interpolated_data(1:end-1,:);  
   j = [];
   for i=1:size(txt_data,2)
   	if ~isempty(max(find(isnan(txt_data(:,i)))))
   		j(i) = max(find(isnan(txt_data(:,i))));
   	else
   		j(i) = 1;
   	end
   end
   %---- FFR, Core PCE, CBO OutputGap  ----% 
   base_vars = [2 5 20];
   start_indx = max(j(base_vars));
   if start_indx ~= 1
   	start_indx = start_indx + 1;
   end	         
   base_data = txt_data(start_indx:end, base_vars);
   save base_nk_vars.txt base_data -ascii
end