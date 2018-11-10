% 5/6/97
% Merge the data

%
%===========================================
% Monthly Data
%===========================================
%* The available data considered
%
q_m = 12;   % quarters or months
yrBin=1940;   % beginning of the year
qmBin=1;    % begining of the quarter or month
yrFin=2007;   % <<>>1 final year
qmFin=12;    % <<>>1 final month
nData=(yrFin-yrBin)*q_m - (q_m-qmFin) + (q_m-qmBin+1);
% total number of the available data -- this is all you have


%** Load monthly data and series
%
[xdd,jnk] = xlsread('Datam22Jan08.xls');
    % <<>>2  Note xdd contains only data (including NaN) but NO headings.  Double check datam*.xls to verify, nonetheless.
[nt,ndv]=size(xdd);
if ndv~=61
   warning(sprintf('Error: nvars=%d, not equal to 58, the number of variables in the original Excel monthly data',ndv));
   %disp(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   return
end;%if
if nt~=nData
   warning(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   %disp(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   return
end
%
%1       PCU   CPI-U: All Items (SA, 1982-84=100)
%2       PCUSLFE  CPI-U: All Items Less Food and Energy (SA, 1982-84=100)
%3       FM2   Money Stock: M2 (SA, Bil.$)
%4       FM1   Money Stock: M1 (SA, Bil.$)
%5       CBM   Personal Consumption Expenditures (SAAR, Bil.$)
%6       CBHM  Real Personal Consumption Expenditures (SAAR, Bil.Chn.2000$)
%7       LE Civilian Employment: Sixteen Years & Over: 16 yr + (SA, Thousands)
%8       LANAGRA  All Employees: Total Nonfarm (SA, Thous)
%9       IP Industrial Production Index (SA, 1997=100)
%10      TRST  Retail Sales (SA, Mil.$)
%11      NAPMC ISM Mfg: PMI Composite Index (SA, 50+ = Econ Expand)
%12      SP3000   PPI: Finished Goods (SA, 1982=100)
%13      SP1000   PPI: Crude Materials for Further Processing (SA, 1982=100)
%14      SP1600   PPI: Crude Materials less Energy (SA, 1982=100)
%15      PZALL KR-CRB Spot Commodity Price Index: All Commodities (1967=100)
%16      PZRAW KR-CRB Spot Commodity Price Index: Raw Industrials (1967=100)
%17      PZTEXP   Spot Oil Price: West Texas Intermediate [Prior'82=Posted Price] ($/Barrel)
%18      PZRJOC   FIBER Industrial Materials Index: All Items (1990=100)
%19      SP500 Stock Price Index: Standard & Poor's 500 Composite  (1941-43=10)
%20      SP500E   Stock Price Index: Standard & Poor's 500 Composite (EOM, 1941-43=10)
%21      FARAT Adjusted Reserves of Depository Institutions (SA, Mil.$)
%22      FARAN Adjusted Nonborrowed Reserves of Depository Institutions (SA, Mil.$)
%23      FARAM Adjusted Monetary Base (SA, Mil.$)
%24      FM1   Money Stock: M1 (SA, Bil.$)
%25      FMZM  Money Stock: MZM {Zero Maturity} (SA, Bil.$)
%26      FM3   Money Stock: M3 (SA, Bil.$)
%27      FD Debt of Nonfinancial Sectors: Total Debt (SA, Bil.$)
%28      JCBM  PCE: Chain Price Index (SA, 2000=100)
%29      JCXFEBM  PCE: PCE less Food and Energy: Chain Price Index (SA, 2000=100)
%30      FARANP   Adjusted Nonborrowed Reserves Plus Extended Credit (SA, Mil.$)
%31      FARTN Reserves of Depository Institutions (NSA, Mil.$)
%32      FARNN Nonborrowed Reserves of Depository Institutions (NSA, Mil.$)
%33      FXJAP Foreign Exchange Rate: Japan  (Yen/US$)
%34      FXEURS   Synthetic Euro calculated using 1997 GDP weights (US$/Euro)
%35      FXEUR Foreign Exchange Rate: European Monetary Union (US$/Euro)
%36      FXGER Foreign Exchange Rate: Germany (D. Mark/US$)
%37      LR Civilian Unemployment Rate: 16 yr + (SA, %)
%38      FFED  Federal Funds [effective] Rate (% p.a.)
%39      FTBS3 3-Month Treasury Bills, Secondary Market (% p.a.)
%40      FCM10 10-Year Treasury Note Yield at Constant Maturity (% p.a.)
%41      FCM20 20-Year Treasury Bond Yield at Constant Maturity (% p.a.)
%42      FCM30 30-Year Treasury Bond Yield at Constant Maturity (% p.a.)
%43      FFEDTE   Federal Funds [effective] Rate (EOP, %)
%44      FTB1ME   1-Month Treasury Bill Market Bid Yield at Constant Maturity (EOP, %)
%45      FTB3ME   3-Month Treasury Bill Market Bid Yield at Constant Maturity (EOP, %)
%46      FTB6ME   6-Month Treasury Bill Market Bid Yield at Constant Maturity (EOP, %)
%47      FTB1YE   1-Year Treasury Bill Yield at Constant Maturity (EOP, %)
%48      FTB2YE   2-Year Treasury Note Yield at Constant Maturity (EOP, %)
%49      FTB3YE   3-Year Treasury Note Yield at Constant Maturity (EOP, %)
%50      FTB5YE   5-Year Treasury Note Yield at Constant Maturity (EOP, %)
%51      FTB7YE   7-Year Treasury Note Yield at Constant Maturity (EOP, %)
%52      FTB10YE  10-Year Treasury Bond Yield at Constant Maturity (EOP, %)
%53      FTB20YE  20-Year Treasury Bond Yield at Constant Maturity (EOP, %)
%54      FTB30YE  30-Year Treasury Bond Yield at Constant Maturity (EOP, %)
%55      PCUHSHO  CPI-U: Owners' Equivalent Rent/Primary Residence (SA, Dec-82=100), from Jan 1983 on.
%56      PCUMS  CPI-U: Medical Care Services (SA, 1982-84=100), from Jan 1956 on.
%57      JCSRDM@USNA  PCE: Hous Svcs: Own-Occup Nonfarm Dwell:Space Rent: Chn Price Index(SA,2000=100), from Jan 1959 on.
%58      JCSDM@USNA  PCE: Medical Care Services: Chain Price Index (SA, 2000=100), from Jan 1959 on.
%59      ZZREALPERINC   Calculated Real Personal Income (bil. $)
%60      CHBM@USNA      Personal Consumption Expenditures (SAAR, Bil.Chn.2000$)
%61      ZZHYSPREAD     Merrill Lynch High Yield Corporate Master II: Yield to Maturity Less Moody's Seasoned Aaa Corporate Bond Yield



%* A specific sample is considered for estimation
%*   Sample period 59:1:97:3
%
yrStart=1959;
qmStart=1;
yrEnd=2007;  % <<>>1
qmEnd=12;   % <<>>1 effective month
nSample=(yrEnd-yrStart)*q_m - (q_m-qmEnd) + (q_m-qmStart+1);

if (q_m==12)
   nStart=(yrStart-yrBin)*12+qmStart-qmBin;  % positive number of months at the start
   nEnd=(yrEnd-yrFin)*12+qmEnd-qmFin;     % negative number of months towards end
elseif (q_m==4)
   nStart=(yrStart-yrBin)*4+qmStart-qmBin;  % positive number of months at the start
   nEnd=(yrEnd-yrFin)*4+qmEnd-qmFin;     % negative number of months towards end
else
   warning('This code is only good for monthly/quarterly data!!!')
end
%
if nEnd>0 | nStart<0
   warning('This particular sample considered is out of bounds of the data!!!')
end
%
xdd=xdd(nStart+1:nt+nEnd,:);

%baddata = find(isnan(xdd));
%if ~isempty(baddata)
%   error('Some data are actually unavailable.')
%end

X1=xdd;


%** Load Matlab data for interpolated gdp data
%
load xdgdp;    % variable "rgdpmon", 'rgdpq', 'dpcemon'.
[mT,jnk]=size(rgdpmon);
[qT,jnk]=size(rgdpq);
if mT ~= qT*3
   warning('Qaurterly period does not conform to monthly period!!')
   return
end
%
%****<<>>3  The following should be turned on if quarterly does not match monthly or off if does.
tmp = [rgdpmon dgdpmon];
%X2 = NaN*ones(mT+0,size(tmp,2));
%                 % <<>> +0, because of no more months in other monthly series.
%X2 = NaN*ones(mT+1,size(tmp,2));
%                 % <<>> +1, because of 1 more month in other monthly series.
%X2 = NaN*ones(mT+2,size(tmp,2));
%                 % <<>> +2, because of 2 more months in other monthly series.
X2 = NaN*ones(mT+3,size(tmp,2));
                 % <<>> +3, because of 3 more months in other monthly series.
X2(1:mT,:)=tmp;
%X2 = tmp;
[mT,jnk]=size(X2);        % reset mT
if mT~=nSample
   warning(sprintf('mT=%d, Caution: not equal to the length in the data',mT));
   return
end


%** Load monthly Matlab data for IMF commodity prices
%
%load xdimfcom;    % variables: imfcom
%X3 = [imfcom; NaN; NaN];
%             % <<>> add 2 NaNs, because of 2 more months in other monthly series in 2002.

t=1:size(rgdpmon,1);
figure
plot(t,rgdpmon(:,1))
title('real GDP');
hold on
t=2:3:size(rgdpmon,1);
plot(t,rgdpq(:,1),':')

t=1:size(rgdpmon,1);
figure
plot(t,rgdpmon(:,2))
title('real bus. invest');
hold on
t=2:3:size(rgdpmon,1);
plot(t,rgdpq(:,2),':')

t=1:size(rgdpmon,1);
figure
plot(t,rgdpmon(:,3))
title('real res. invest');
hold on
t=2:3:size(rgdpmon,1);
plot(t,rgdpq(:,3),':')

t=1:size(dgdpmon,1);
figure
plot(t,dgdpmon)
title('Deflator GDP');
hold on
t=2:3:size(dgdpmon,1);
plot(t,dgdpq,':')


% <<>>
%xdd = [X1 X2 X3];
xdd = [X1 X2];
for k=1:size(xdd,2)
   figure
   plot(xdd(:,k))
end

%rgdpmon(:,1) -- real GDP;  rgdpmon(:,2) -- real business investment;  rgdpmon(:,3) -- real residential investment.
save outxdd xdd
