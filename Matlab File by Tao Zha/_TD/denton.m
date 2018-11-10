function res = denton(Y,x,z,ta,sc,d)
% PURPOSE: Multivariate temporal disaggregation with transversal constraint
% -----------------------------------------------------------------------------
% SYNTAX: res = denton(Y,x,z,ta,sc,d)
% -----------------------------------------------------------------------------
% OUTPUT: res: a structure
%         res.meth  = 'Multivariate Denton';
%         res.N     = Number of low frequency data
%         res.n     = Number of high frequency data
%         res.pred  = Number of extrapolations (=0 in this case)
%         res.ta    = Type of disaggregation
%         res.sc     = Frequency conversion
%         res.d     = Degree of differencing 
%         res.y     = High frequency estimate
%         res.z     = High frequency constraint
%         res.et    = Elapsed time
% -----------------------------------------------------------------------
% INPUT: Y: NxM ---> M series of low frequency data with N observations
%        x: nxM ---> M series of high frequency data with n observations
%        z: nx1 ---> high frequency transversal constraint
%        ta: type of disaggregation
%            ta=1 ---> sum (flow)
%            ta=2 ---> average (index)
%            ta=3 ---> last element (stock) ---> interpolation
%            ta=4 ---> first element (stock) ---> interpolation
%        sc: number of high frequency data points for each low frequency data points 
%            sc= 4 ---> annual to quarterly
%            sc=12 ---> annual to monthly
%            sc= 3 ---> quarterly to monthly
%        d: objective function to be minimized: volatility of ...
%            d=0 ---> levels
%            d=1 ---> first differences
%            d=2 ---> second differences
% -----------------------------------------------------------------------
% LIBRARY: aggreg, aggreg_v, dif, vec, desvec
% -----------------------------------------------------------------------
% SEE ALSO: denton_prop, difonzo, mtd_print, mtd_plot
% -----------------------------------------------------------------------
% REFERENCE: Di Fonzo, T. (1994) "Temporal disaggregation of a system of 
% time series when the aggregate is known: optimal vs. adjustment methods",
% INSEE-Eurostat Workshop on Quarterly National Accounts, Paris, december

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Finance
%  Paseo de la Castellana, 162. Office 2.5-1.
%  28046 - Madrid (SPAIN)
%  <enrique.quilis@meh.es>

% Version 2.0 [August 2006]

t0 = clock;

%--------------------------------------------------------
%       Preliminary checking

[N,M] = size(Y);
[n,m] = size(x);
[nz,mz] = size(z);

if ((M ~=  m) |  (nz ~=  n) | (mz ~=  1) )
   error (' *** INCORRECT DIMENSIONS *** ');
else
   clear m nz mz;
end

%--------------------------------------------------------
%       Checking of "ta"

if (ta < 1) | (ta > 4)
    error (' *** INCORRECT TA OPTION *** ');
end

%--------------------------------------------------------
%       Checking of "sc"

if (sc ~= 3) & (sc ~= 4) & (sc ~= 12)
    error (' *** INCORRECT FREQUENCY CONVERSION (sc) *** ');
end

%--------------------------------------------------------
%  **** CONSTRAINT MATRICES ***
%--------------------------------------------------------
% Required:
%              H1 ---> transversal
%              H2 ---> longitudinal
%
%---------------------------------------------------------------
%       Generate H1: n x nM

H1 = kron(ones(1,M),eye(n));

%---------------------------------------------------------------
%       Generate H2: NM x nM.
%
% Generation of aggregation vector c and matrix C

c = aggreg_v(ta,sc);

C = aggreg(ta,N,sc);

% -----------------------------------------------------------
% Expanding the aggregation matrix to perform
% extrapolation if needed.

if (n > sc * N)
   pred = n - sc*N;           % Number of required extrapolations 
   C = [C zeros(N,pred)];
else
   pred = 0;
end

H2 = kron(eye(M),C);

%---------------------------------------------------------------
%       Generate H: n+NM x nM.
%
%       H = [H1
%          H2 ]

H = [H1
   H2];

%--------------------------------------------------------
%  **** PREPARING DATA MATRICES ***
%--------------------------------------------------------
% Required:
%               x_big
%               Y_big, Y_e
%               X_diag, X_e

%--------------------------------------------------------
%       Generate x_big: nM x 1

x_big = vec(x);

%--------------------------------------------------------
%       Generate Y_big: NM x 1

Y_big = vec(Y);

%--------------------------------------------------------
%       Generate Y_e: n+NM x 1
%
%       	It is column vector containing the transversal
%        constraint and all the observations
%       	on the low frequency series
%  		according to: Y_e = [ z Y1 Y2 ... YM]' = [z Y_big]'

Y_e = [ z
      Y_big];

%--------------------------------------------------------
%       Filtering matrices

D1=dif(d,n);
D1=D1(d+1:end,:);  % Difference operator without initial conditions

D=[D1
   zeros(d,n-sc*d)  kron(eye(d),c)];

DD = D' * D;
Wi = kron(eye(M),inv(DD));
Vi = pinv (H * Wi * H');

%--------------------------------------------------------
%       Estimation

U_e = Y_e - H * x_big;

y_big = x_big + Wi * H' * Vi * U_e;

% Series y columnwise y: nxM

y = desvec(y_big,M);

% -----------------------------------------------------------------------
% Loading the structure
% -----------------------------------------------------------------------

% Basic parameters 

res.meth = 'Multivariate Denton';
res.N = N;
res.n = n;
res.pred = pred;
res.ta = ta;
res.sc = sc;
res.d = d;

% -----------------------------------------------------------------------
% Series

res.y = y;
res.z = z;

% -----------------------------------------------------------------------
% Elapsed time

res.et = etime(clock,t0);
