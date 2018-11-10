% Written by Eric Leeper
% Modified by Tao Zha, 5/5/97
% chowlin.m
% Chow-Lin procedure for distributing a quarterly flow variable, yq, to
% an underlying monthly flow variable, ym, using
% several related monthly series, Xm; let Xq denote monthly converted
% to quarterly
% Relationship between monthly variable and the regressors is
%      ym = Xm * b + um, where E(um*um') = Vm     (1)
% Let C be the T x 3*T matrix that converts monthly observations to
% quarterly averages.  Then for quarterly observations (2) is
%     C * ym = C * Xm * b + C * um  or
%     yq = Xq * b + uq         (2)
%  where E(uq*uq') = Vq = E(C*um*um'*C') = C*Vm*C'
%
%
% Xm: 59:1-97:6;
% yq: 59:1-97:2;
% To interpolate monthly real GDP, use monthly data from xdm.mat on
%     IP LE TRST(deflated by CPI) CBHM napmc -- log all but NAPMCOMP by Leeper
%       Take out "log" by Zha, because x1+x1+x3=x_q, not log(x1)+log(x2)+log(x3) = log(x_q)
%
% To interpolate monthly GDP deflator, use monthly data from xdm.mat on
%     M2, PPCE, CPI-U, PPI (Finished Goods)

%===========================================
% Monthly Data
%===========================================
%* The available data considered
%
q_m = 12;   % quarters or months
yrBin=1940;   % beginning of the year
qmBin=1;    % begining of the quarter or month
yrFin=2007;   % <<>>1 final year
qmFin=12;    % <<>>1 final month (Note the last row may be NaN.)
nData=(yrFin-yrBin)*q_m - (q_m-qmFin) + (q_m-qmBin+1);
% total number of the available data -- this is all you have


%** Load monthly data and series
%
[xdd,jnk] = xlsread('Datam22Jan08.xls');
    % <<>>2  Note xdd contains only data (including NaN) but NO headings.  Double check datam*.xls to verify, nonetheless.
[nt,ndv]=size(xdd);
if ndv~=61
   warning(sprintf('Error: nvars=%d, not equal to 61, the number of variables in the original Excel monthly data',ndv));
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








%*** Do not log to ensure that the sum of montly variable = quarterly variabe
%      at the *orignal* level. TZ, 5/7/97
vlist = [9 8 6 11];   % IP, Nonfarm Employment, Real PCE, NAPMC
%vlist = [9 8 11];   % IP, Nonfarm Employment, Real PCE, NAPMC


%* A specific sample is considered for estimation to interpolate quarterly data
%** Thus it ends at the quarterly frequency.
yrStart=1959;
qmStart=1;
yrEnd=2007;    % <<>>
qmEnd=9;    % <<>>  Must end at the quarterly frequency.
nSample=(yrEnd-yrStart)*q_m - (q_m-qmEnd) + (q_m-qmStart+1);

if (q_m==12)
   nStart=(yrStart-yrBin)*12+qmStart-qmBin;  % positive number of months at the start
   nEnd=(yrEnd-yrFin)*12+qmEnd-qmFin;     % negative number of months towards end
elseif (q_m==4)
   nStart=(yrStart-yrBin)*4+qmStart-qmBin;  % positive number of months at the start
   nEnd=(yrEnd-yrFin)*4+qmEnd-qmFin;     % negative number of months towards end
else
   error('This code is only good for monthly/quarterly data!!!')
end
%
if nEnd>0 | nStart<0
   error('This particular sample considered is out of bounds of the data!!!')
end
%

xdd=xdd(nStart+1:nt+nEnd,:);
Xm=xdd(:,vlist);  % monthly data on the right hand side
Xm = [Xm ones(length(Xm(:,1)),1)];

baddata = find(~isfinite(Xm));
%xddebt = xdd;
%xddebt(:,15) = ones(size(xdd,1),1);
%baddata = find(~isfinite(xddebt));
if ~isempty(baddata)
   warning('Some data are actually unavailable.')
   error(' ')
end




%===========================================
% Quarterly Data
%===========================================
%* The available data considered
%
q_m = 4;   % quarters or months
yrBin=1940;   % beginning of the year
qmBin=1;    % begining of the quarter or month
yrFin=2007;   % <<>>1 final year
qmFin=3;    % <<>>1 final quarter
nData=(yrFin-yrBin)*q_m - (q_m-qmFin) + (q_m-qmBin+1);
% total number of the available data -- this is all you have

%** Load quarterly data and series
%
[xdd,jnk] = xlsread('Dataq22Jan08.xls');
    % <<>>2  Note xdd contains only data -- no headings, but check qdata*.xls to verify, nonetheless.
%xdd = xdd(:,2:end);
[nt,ndv]=size(xdd);
if ndv~=42
   warning(sprintf('Error: nvars=%d, not equal to 42, the number of variables in the original Excel quarterly data',ndv));
   %disp(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   return
end;%if
if nt~=nData
   warning(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   %disp(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   return
end
%
%1      GDP   Gross Domestic Product (SAAR, Bil.$)   Q1-1947  Q2-2007  242   BEA
%2      GDPH  Real Gross Domestic Product (SAAR, Bil.Chn.2000$)  Q1-1947  Q2-2007  242   BEA
%3      JGDP  Gross Domestic Product: Chain Price Index (SA, 2000=100)    Q1-1947  Q2-2007  242   BEA
%4      C  Personal Consumption Expenditures (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%5      CH Real Personal Consumption Expenditures (SAAR, Bil.Chn.2000$)   Q1-1947  Q2-2007  242   BEA
%6      JC Personal Consumption Expenditures: Chain Price Index (SA, 2000=100)  Q1-1947  Q2-2007  242   BEA
%7      YCBT  Corporate Profits Before Tax (SAAR, Bil.$)   Q1-1947  Q2-2007  242   BEA
%8      YCAT  Corporate Profits After Tax (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%9      YCP   Corporate Profits with IVA and CCAdj (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%10     SE500 S&P 500 Composite: After-tax Earnings per Share ($/share)   Q1-1935  Q2-2007  290   S&P
%11     IH Real Gross Private Domestic Investment (SAAR, Bil.Chn.2000$)   Q1-1947  Q2-2007  242   BEA
%12     FH Real Private Fixed Investment (SAAR, Bil.Chn.2000$)   Q1-1947  Q2-2007  242   BEA
%13     FNH   Real Private Nonresidential Fixed Investment (SAAR, Bil.Chn.2000$)   Q1-1947  Q2-2007  242   BEA
%14     FNSH  Real Private Nonresidential Investment: Structures (SAAR, Bil.Chn.2000$)   Q1-1947  Q2-2007  242   BEA
%15     FNEH  Real Private Nonresidential Investment: Equipment & Software(SAAR,Bil.Chn.2000$)    Q1-1947  Q2-2007  242   BEA
%16     FRH   Real Private Residential Investment (SAAR, Bil.Chn.2000$)   Q1-1947  Q2-2007  242   BEA
%17     VH Real Change in Private Inventories (SAAR, Bil.Chn.2000$)    Q1-1947  Q2-2007  242   BEA
%18     MEW5@USECON Home Equity Extraction, Net (SAAR, Bil.$)    Q1-1991  Q2-2007  66 FRB
%19     CDH@USNA Real Personal Consumption Expenditures: Durable Goods (SAAR, Bil.Chn.2000$)   Q1-1947  Q2-2007  242   BEA
%20     CNH@USNA Real Personal Consumption Expenditures: Nondurable Goods (SAAR, Bil.Chn.2000$)   Q1-1947  Q2-2007  242   BEA
%21     CSH@USNA Real Personal Consumption Expenditures: Services (SAAR, Bil.Chn.2000$)  Q1-1947  Q2-2007  242   BEA
%22     LE@USECON   Civilian Employment: Sixteen Years & Over (SA, Thousands)   Q4-1947  Q3-2007  240   BLS
%23     LXNFH@USECON   Nonfarm Business Sector: Hours of All Persons (SA, 1992=100)   Q1-1947  Q2-2007  242   BLS
%24     LXNFC@USECON   Nonfarm Business Sector: Compensation Per Hour (SA, 1992=100)  Q1-1947  Q2-2007  242   BLS
%25     LN16N@USECON   Civilian Noninstitutional Population: 16 Years and Over (NSA, Thous)    Q4-1947  Q3-2007  240   BLS
%26     LIPRIVA@USECON Aggregate Weekly Hours Index: Total Private Industries (SA, 2002=100)   Q4-1963  Q3-2007  176   BLS
%27     FFED@USECON Federal Funds [effective] Rate (% p.a.)   Q2-1954  Q3-2007  214   FRB
%28     FFEDTE@USECON  Federal Funds [effective] Rate (EOP, %)   Q4-1961  Q3-2007  184   FRB
%29     JC@USNA  Personal Consumption Expenditures: Chain Price Index (SA, 2000=100)  Q1-1947  Q2-2007  242   BEA
%30     JCXFE@USNA  PCE less Food & Energy: Chain Price Index (SA, 2000=100)    Q1-1959  Q2-2007  194   BEA
%31     UI@CPIDATA  CPI-U: All Items (SA, 1982-84=100)  Q4-1946  Q2-2007  243   BLS
%32     UIXFDG@CPIDATA CPI-U: All Items Less Food & Energy (SA, 1982-84=100)    Q4-1956  Q2-2007  203   BLS
%33     I@USECON Gross Private Domestic Investment (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%34     F@USECON Private Fixed Investment (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%35     FN@USECON   Private Nonresidential Fixed Investment (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%36     FNS@USECON  Private Nonresidential Investment: Structures (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%37     FNE@USECON  Private Nonresidential Investment: Equipment & Software (SAAR, Bil.$)   Q1-1947  Q2-2007  242   BEA
%38     FR@USECON   Private Residential Investment (SAAR,Bil.$)  Q1-1947  Q2-2007  242   BEA
%39     V@USECON Change in Private Inventories (SAAR, Bil.$)  Q1-1947  Q2-2007  242   BEA
%40     CD@USECON   Personal Consumption Expenditures: Durable Goods (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%41     CN@USECON   Personal Consumption Expenditures: Nondurable Goods (SAAR, Bil.$)    Q1-1947  Q2-2007  242   BEA
%42     CS@USECON   Personal Consumption Expenditures: Services (SAAR, Bil.$)   Q1-1947  Q2-2007  242   BEA




%*** Do not log to ensure that the sum of montly variable = quarterly variabe
%      at the *orignal* level. TZ, 5/7/97
vlist = [2 13 16];    % real GDP, real nonresidential fixed invest, real residential invest.


%* A specific sample is considered for estimation to interpolate quarterly data
%** Thus it ends at the available quarter.
yrStart=1959;
qmStart=1;
yrEnd=2007;     % <<>>1 final year
qmEnd=3;        % <<>>1 final quarter
nSample=(yrEnd-yrStart)*q_m - (q_m-qmEnd) + (q_m-qmStart+1);

if (q_m==12)
   nStart=(yrStart-yrBin)*12+qmStart-qmBin;  % positive number of months at the start
   nEnd=(yrEnd-yrFin)*12+qmEnd-qmFin;     % negative number of months towards end
elseif (q_m==4)
   nStart=(yrStart-yrBin)*4+qmStart-qmBin;  % positive number of months at the start
   nEnd=(yrEnd-yrFin)*4+qmEnd-qmFin;     % negative number of months towards end
else
   warning('This code is only good for monthly/quarterly data!!!')
   error(' ')
end
%
if nEnd>0 | nStart<0
   warning('This particular sample considered is out of bounds of the data!!!')
   error(' ')
end
%
xdd=xdd(nStart+1:nt+nEnd,:);
yq=xdd(:,vlist);  % quarterly data on the left hand side

baddata = find(~isfinite(yq));
%xddebt = xdd;
%xddebt(:,15) = ones(size(xdd,1),1);
%baddata = find(~isfinite(xddebt));
if ~isempty(baddata)
   warning('Some data are actually unavailable.')
   error(' ')
end


%===========================================
% Chow-Lin procedure begins
%===========================================
%
%*** specialize for GDP
[qT,jnk]=size(yq);
[mT,p]=size(Xm);
if mT ~= qT*3
   warning('Quarterly period does not conform to monthly period!!')
   disp('Hit any key to continue, or ctrl-c to abort')
   return
end
tscale = 3;  % 3 for quarterly to monthly
%*** create matrix C, which converts 3*qT monthly obs into qT quarterly obs
C = zeros(qT,mT);
i = 1;
tic
while i <= qT
 C(i,tscale*(i-1)+1:tscale*(i-1)+tscale) = (1/3)*[1 1 1];
 i = i+1;
end
%
Xq = C*Xm;  % create quarterly matrices

%
%%%%
%$$$ Chowlin procedure with an iterative loop
%%%%
%
%@@@ Intial q
% ** estimate: B, XTX, residuals **
[u d v]=svd(Xq,0); %trial
%%xtx = Xq'*Xq;      % X'X, k*k (ncoe*ncoe)
%vd=v.*(ones(size(v,2),1)*diag(d)'); %trial
%dinv = 1./diag(d);    % inv(diag(d))
%vdinv=v.*(ones(size(v,2),1)*dinv'); %trial
%xtx=vd*vd';
%xtxinv = vdinv*vdinv';
%xty = phi'*y;        % X'Y
uy = u'*yq; %trial
%xty = vd*uy; %trial
%Bh = xtx\xty;        %inv(X'X)*(X'Y), k*m (ncoe*nvar).
%Bh = xtxinv*xty;
%e = y - phi*Bh;      % from Y = XB + U, e: (T-lags)*nvar
uq = yq - u*uy;
%%
uqlag = zeros(qT-1,1);
uqlag = uq(1:qT-1,1);
uqc = uq(2:qT,1);
[u d v]=svd(uqlag,0); %trial
vd=v.*(ones(size(v,2),1)*diag(d)'); %trial
dinv = 1./diag(d);    % inv(diag(d))
vdinv=v.*(ones(size(v,2),1)*dinv'); %trial
%xtx=vd*vd';
xtxinv = vdinv*vdinv';
%xty = phi'*y;        % X'Y
uy = u'*uqc; %trial
xty = vd*uy; %trial
%Bh = xtx\xty;        %inv(X'X)*(X'Y), k*m (ncoe*nvar).
q = xtxinv*xty      % initial q

%@@@ loop begins
qdiff = 1;
tic
while qdiff > 1.0e-04
   qm = clmonq(q);    % solving for "qm" (a in Chow-Lin, monthly q)
   [bhat,Vq,ACt,uqhat,q2] = clgls(qm,yq,Xq,C,qm,mT,qT);
         % now perform GLS using Chow-Lin procedure
   qdiff = abs(q2-q);
   q = q2;    % updating
end
e_t = toc
q2

%*** generate monthly real gdp, real bus invest, and real res. invest.
rgdpmon = Xm*bhat + ACt*(Vq\uqhat);  %3: real gdp, real bus invest, and real res. invest.
rgdpq = yq;
save outgdp rgdpmon rgdpq
