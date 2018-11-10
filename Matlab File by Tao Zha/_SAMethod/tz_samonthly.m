% ** ONLY UNDER UNIX SYSTEM
%path(path,'/usr2/f1taz14/mymatlab')

if (1)  
  close all
  clear all
  clc
end


%===========================================
% Exordium I
%===========================================
format short g     % format
%
q_m = 12;   % quarters or months
yrBin=1997;   % beginning of the year
qmBin=1;    % begining of the quarter or month
yrFin=2015;   % final year
qmFin=2;    % final month or quarter
nData=(yrFin-yrBin)*q_m + (qmFin-qmBin+1);
       % total number of the available data -- this is all you have
mdates = [(yrBin+(qmBin-1)/q_m):(1/q_m):(yrFin+(qmFin-1)/q_m)]';
%******* Load data and series
[xdd0,jnk] = xlsread('forecasting data_for PBC_201503.xlsx','Sheet1');
    %  Note xdd0 contains only data (including blank and comment columns) -- no headings, but check qdata*.xls to verify, nonetheless.
nvars = 8;    
xdd0(:,[1]) = [];  %1: dates;
xdd = xdd0;  %Because the data contains future GDP potenital (beyond the end of the sample).
clear xdd0;
[nt,ndv]=size(xdd);
if ndv~=nvars
   warning(sprintf('Error: nvars=%d, not equal to 140, the number of variables in the original Excel quarterly data',ndv));
   %disp(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   return
end;%if
if nt~=(nData)
   warning(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   %disp(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   return
end
%1 M2	
%2 repo7D	
%3 RealVAI	
%4 CPI	
%5 export	
%6 import	
%7 retailSale	
%8 investment


%=================================================
%========== Seasonally adjusted series ===========
%=================================================
xdd2 = xdd;
for (ki=[1 3:nvars])
   logtobesa = log(xdd(:,ki));
   %---$$## Setup 
   nobs = size(logtobesa,1);
   timetrend = [1:nobs]';
   constterm = ones(nobs,1);
   nyears_max = ceil(nobs/q_m);
   SeasDumMat = kron(ones(nyears_max,1),eye(q_m));
   SeasDumMat = SeasDumMat(1:(size(SeasDumMat,1)-10),:);  %$$##
   SeasDumMatTrunc = SeasDumMat(:,1:(q_m-1));
   %--- Seasonally adjusting
   Xright = [constterm timetrend SeasDumMatTrunc];
   yleft = logtobesa(:,1);
   BetaOLS = regress(yleft,Xright);
   BetaSeas = [BetaOLS(3:end) ; 0] - sum(BetaOLS(3:end))/q_m;
   yleftSA = yleft - SeasDumMat*BetaSeas;
   xdd2(:,ki) = exp(yleftSA);   
end   

ki=8;
logtobesa = log(xdd(1:(end-2),ki));
%---$$## Setup 
nobs = size(logtobesa,1);
timetrend = [1:nobs]';
constterm = ones(nobs,1);
nyears_max = ceil(nobs/q_m);
SeasDumMat = kron(ones(nyears_max,1),eye(q_m));
SeasDumMat = SeasDumMat(1:(size(SeasDumMat,1)-0),:);  %$$##
SeasDumMatTrunc = SeasDumMat(:,1:(q_m-1));
%--- Seasonally adjusting
Xright = [constterm timetrend SeasDumMatTrunc];
yleft = logtobesa(:,1);
BetaOLS = regress(yleft,Xright);
BetaSeas = [BetaOLS(3:end) ; 0] - sum(BetaOLS(3:end))/q_m;
yleftSA = yleft - SeasDumMat*BetaSeas;
xdd2(1:(end-2),ki) = exp(yleftSA);   
figure;
plot(mdates, [log(xdd2(:,ki)), log(xdd(:,ki))]);
legend('SA','NA');
title('Higgin''s method I');

X = [constterm SeasDumMatTrunc];
BetaOLS2 = regress(diff(yleft),X(2:end,:));
BetaSeas2 = [BetaOLS2(2:q_m) ; 0] - sum(BetaOLS2(2:q_m))/q_m;
ySA2 = NaN(length(yleft),1);
ySA2(1) = yleft(1);
for ttt=2:length(yleft)
ySA2(ttt) = ySA2(ttt-1) + (yleft(ttt)-yleft(ttt-1)) - SeasDumMat(ttt,:)*BetaSeas2;
end
ySA2 = ySA2 - mean(ySA2) + mean(yleft);
xdd2(1:(end-2),ki) = exp(ySA2);   
figure;
plot(mdates, [log(xdd2(:,ki)), log(xdd(:,ki))]);
legend('SA','NA');
title('Higgin''s method II');

X = [constterm timetrend SeasDumMat];
R = [0 0 ones(1,12)];
r = 0;
XX = X'*X;
XXtilda = [[XX R']; [ R 0]];
bstarlambda = XXtilda\[X'*yleft ; r];
BetaRLS = bstarlambda(1:end-1);
BetaSeas3 = BetaRLS(3:end);
ySA3 = yleft - SeasDumMat*BetaSeas3;
xdd2(1:(end-2),ki) = exp(ySA3);   
figure;
plot(mdates, [log(xdd2(:,ki)), log(xdd(:,ki))]);
legend('SA','NA');
title('Higgin''s method III');

if (0)
   figure;
   for (ki=1:nvars)   
      plot(mdates, [log(xdd2(:,ki)), log(xdd(:,ki))]);
      %plot(mdates, [(xdd2(:,ki)), (xdd(:,ki))]);
      legend('SA','NA');
      ki
      pause;
   end
end


return;

nvars_rawdata = 2;
load datauinfsq.prn      % the default name for the variable is "xdd".
%xdd = dlmread('dataraw_logMPKR_logsigma.prn', '', 0,0);  %base0 data file. 
xdd = datauinfsq;
clear datauinfsq;
if (size(xdd,2) ~= nvars_rawdata)
   error(sprintf('The number of variables is %d, not equal to 13',size(xdd,2)));   
end   
if (size(xdd,1) ~= nData)
   error(sprintf('The number of periods is %d, not equal to the data length',size(xdd,1)));      
end  
%--------
%1    U
%2    PCE


%******* Identificaiton and variables.
vlist = [1 2];    % 1: U; 2: PCE inflation.
varlist={'U', 'Inflation'};
xlab = {'Shock to U','Shock to PCE'};
rnum = 2;      % number of rows in the graph
cnum = 1;      % number of columns in the graph
vlistlog = [ ];   % subset of "vlist.  Variables in log level so that differences are in **monthly** growth, unlike R and U which are in annual percent (divided by 100 already).
vlistper = [1 2];           % subset of "vlist"
idfile_const = 'fn_iden_upperchol';   %The function is in '/Users/tzha/ZhaGit/TZcode/MatlabFiles/A_Identification'
ylab = varlist;
%---
nvar = length(vlist);   % number of endogenous variables
nlogeno = length(vlistlog)  % number of endogenous variables in vlistlog
npereno = length(vlistper)  % number of endogenous variables in vlistper
if (nvar~=(nlogeno+npereno))
   disp(' ')
   warning('Check xlab, nlogeno or npereno to make sure of endogenous variables in vlist')
   disp('Press ctrl-c to abort')
   return
elseif (nvar==length(vlist))
   nexo=1;    % only constants as an exogenous variable.  The default setting.
elseif (nvar<length(vlist))
   nexo=length(vlist)-nvar+1;
else
   disp(' ')
   warning('Make sure there are only nvar endogenous variables in vlist')
   disp('Press ctrl-c to abort')
   return
end


%******* Lag and sample range
yrStart=1960;
qmStart=1;
yrEnd=2003;
qmEnd=4;
nfyr = 6;   % number of years for forecasting
qm_dates_all_sample = ((yrStart+(qmStart-1)/4):1/4:(yrEnd+(qmEnd-1)/4))';
if nfyr<1
   error('To be safe, the number of forecast years should be at least 1')
end
ystr=num2str(yrEnd);
forelabel = [ ystr(3:4) ':' num2str(qmEnd) ' Forecast'];

nSample=(yrEnd-yrStart)*q_m + (qmEnd-qmStart+1);
if qmEnd==q_m
   E1yrqm = [yrEnd+1 1];  % first year and quarter (month) after the sample
else
   E1yrqm = [yrEnd qmEnd+1];  % first year and quarter (month) after the sample
end
E2yrqm = [yrEnd+nfyr qmEnd];   % end at the last month (quarter) of a calendar year after the sample
[fdates,nfqm]=fn_calyrqm(q_m,E1yrqm,E2yrqm);   % forecast dates and number of forecast dates
[sdates,nsqm] = fn_calyrqm(q_m,[yrStart qmStart],[yrEnd qmEnd]);
   % sdates: dates for the whole sample (including lags)
if nSample~=nsqm
   warning('Make sure that nSample is consistent with the size of sdates')
   disp('Hit any key to continue, or ctrl-c to abort')
   pause
end
imstp = 4*q_m;    % <<>>  impulse responses (4 years)
nayr = 4; %nfyr;  % number of years before forecasting for plotting.


%------- Prior, etc. -------
lags = 4        % number of lags
qm_dates_ess = qm_dates_all_sample(lags+1:end);
indxC0Pres = 0;   % 1: cross-A0-and-A+ restrictions; 0: idfile_const is all we have
            % Example for indxOres==1: restrictions of the form P(t) = P(t-1).
Rform = 0;  % 1: contemporaneous recursive reduced form; 0: restricted (non-recursive) form
Pseudo = 0;  % 1: Pseudo forecasts; 0: real time forecasts
indxPrior = 1;  % 1: Bayesian prior; 0: no prior
indxDummy = indxPrior;  % 1: add dummy observations to the data; 0: no dummy added.
ndobs = 0;  % No dummy observations for xtx, phi, fss, xdatae, etc.  Dummy observations are used as an explicit prior in fn_rnrprior_covres_dobs.m.
%if indxDummy
%   ndobs=nvar+1;         % number of dummy observations
%else
%   ndobs=0;    % no dummy observations
%end
%=== The following mu is effective only if indxPrior==1.
mu = zeros(6,1);   % hyperparameters
mu(1) = 1;
mu(2) = 1.0;
mu(3) = 0.1;
mu(4) = 1.2;
mu(5) = 1.0;
mu(6) = 1.0;
%   mu(1): overall tightness and also for A0;
%   mu(2): relative tightness for A+;
%   mu(3): relative tightness for the constant term;
%   mu(4): tightness on lag decay;  (1)
%   mu(5): weight on nvar sums of coeffs dummy observations (unit roots);
%   mu(6): weight on single dummy initial observation including constant
%           (cointegration, unit roots, and stationarity);
%
%
hpmsmd = [0.0; 0.0];
indxmsmdeqn = [1; 2; 1; 2];


tdf = 3;          % degrees of freedom for t-dist for initial draw of the MC loop
nbuffer = 100;        % a block or buffer of draws (buffer) that is saved to the disk (not memory)
ndraws1=1*nbuffer;         % 1st part of Monte Carlo draws
ndraws2=10*ndraws1         % 2nd part of Monte Carlo draws
seednumber = 0; %7910;    %472534;   % if 0, fn_reset_ini_seed(0) (random state at clock time) is called at the start with startup.m.
           % good one 420 for [29 45], [29 54]
if seednumber
   fn_reset_ini_seed(seednumber);
end
%  nstarts=1         % number of starting points
%  imndraws = nstarts*ndraws2;   % total draws for impulse responses or forecasts
%<<<<<<<<<<<<<<<<<<<





