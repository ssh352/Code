function [Pi,H0multi,Hpmulti,H0invmulti,Hpinvmulti,sgh] ...
                      = fn_rnrprior_covres_dobs_v2(nvar,q_m,lags,xdgel,mu,indxDummy,nexo)             
% No linear restrictions (Ui and Vi) have applied yet to this function.
% Only works for the nexo=1 (constant term) case.  To extend this to other exogenous variables, see fn_dataxy.m.  01/14/03.
% Differs from fn_rnrprior_covres.m in that dummy observations are included as part of the explicit prior.  See Zha's Forcast II notes, pp.68-69b.
% More general than fn_rnrprior.m because when hpmsmd=0, fn_rnrprior_covres() is the same as fn_rnrprior().
%    Allows for prior covariances for the MS and MD equations to achieve liquidity effects.
%    Exports random Bayesian prior of Sims and Zha with asymmetric rior (but no linear restrictions yet)
%    See Waggoner and Zha's Gibbs sampling paper and TVBVAR NOTES p. 71k.0.
%
% nvar:  number of endogenous variables
% q_m:  quarter or month
% lags: the maximum length of lag
% xdgel: T*nvar endogenous-variable matrix of raw or original data (no manipulation involved) with sample size including lags.
%       Order of columns: (1) nvar endogenous variables; (2) constants will be automatically put in the last column.
%       Used only to get variances of residuals for mu(1)-mu(5) and for dummy observations mu(5) and mu(6).
% mu: 6-by-1 vector of hyperparameters (the following numbers for Atlanta Fed's forecast), where
%          mu(5) and mu(6) are NOT used here.  See fn_dataxy.m for using mu(5) and mu(6).
%       mu(1): overall tightness and also for A0;  (0.57)
%       mu(2): relative tightness for A+;  (0.13)
%       mu(3): relative tightness for the constant term;  (0.1).  NOTE: for other
%               exogenous terms, the variance of each exogenous term must be taken into
%               acount to eliminate the scaling factor.
%       mu(4): tightness on lag decay;  (1)
%       mu(5): weight on nvar sums of coeffs dummy observations (unit roots);  (5)
%       mu(6): weight on single dummy initial observation including constant
%               (cointegration, unit roots, and stationarity);  (5)
% indxDummy:  1: uses dummy observations to form part of an explicit prior; 0: no dummy observations as part of the prior.
% nexo:  number of exogenous variables (if not specified, nexo=1 (constant) by default).
%         The constant term is always put to the last of all endogenous and exogenous variables.
% --------------------
% Pi: ncoef-by-nvar matrix for the ith equation under random walk.  Same for all equations
% H0multi: nvar-by-nvar-by-nvar; H0 for different equations under asymmetric prior
% Hpmulti: ncoef-by-ncoef-by-nvar; H+ for different equations under asymmetric prior
% H0invmulti: nvar-by-nvar-by-nvar; inv(H0) for different equations under asymmetric prior
% Hpinvmulti: ncoef-by-ncoef-by-nvar; inv(H+) for different equations under asymmetric prior
% sgh: nvar-by-1 standard deviations of residuals for each equation.
%
% Tao Zha, February 2000.  Revised, September 2000, February, May 2003.

% Copyright (C) 1997-2012 Tao Zha
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

% Modified by Tong XU; 2015-02-24
%       Remove "hpmsmd,indxmsmdeqn" and "asym0,asymp"


if (nargin<=6), nexo=1; end
ncoef = nvar*lags+nexo;  % number of coefficients in *each* equation, RHS coefficients only.

H0multi=zeros(nvar,nvar,nvar);  % H0 for different equations under asymmetric prior
Hpmulti=zeros(ncoef,ncoef,nvar);  % H+ for different equations under asymmetric prior
H0invmulti=zeros(nvar,nvar,nvar);  % inv(H0) for different equations under asymmetric prior
Hpinvmulti=zeros(ncoef,ncoef,nvar);  % inv(H+) for different equations under asymmetric prior

%*** Constructing Pi for the ith equation under the random walk assumption
Pi = zeros(ncoef,nvar);   % same for all equations
Pi(1:nvar,1:nvar) = eye(nvar);   % random walk

%
%@@@ Prepared for Bayesian prior
%
%
% ** monthly lag decay in order to match quarterly decay: a*exp(bl) where
% **  l is the monthly lag.  Suppose quarterly decay is 1/x where x=1,2,3,4.
% **  Let the decay of l1 (a*exp(b*l1)) match that of x1 (say, beginning: 1/1)
% **  and the decay of l2 (a*exp(b*l2)) match that of x2 (say, end: 1/5),
% **  we can solve for a and b which are
% **      b = (log_x1-log_x2)/(l1-l2), and a = x1*exp(-b*l1).
if q_m==12
   l1 = 1;   % 1st month == 1st quarter
   xx1 = 1;   % 1st quarter
   l2 = lags;   % last month
   xx2 = 1/((ceil(lags/3))^mu(4));   % last quarter
   %xx2 = 1/6;   % last quarter
   % 3rd quarter:  i.e., we intend to let decay of the 6th month match
   %    that of the 3rd quarter, so that the 6th month decays a little
   %    faster than the second quarter which is 1/2.
   if lags==1
      b = 0;
   else
      b = (log(xx1)-log(xx2))/(l1-l2);
   end
   a = xx1*exp(-b*l1);
end



%
% *** specify the prior for each equation separately, SZ method,
% ** get the residuals from univariate regressions.
%
sgh = zeros(nvar,1);        % square root
sgsh = sgh;              % square
nSample=size(xdgel,1);  % sample size-lags
yu = xdgel;
C = ones(nSample,1);
for k=1:nvar
   [~,ek,~,~,~,~] = sye([yu(:,k) C],lags);
   sgsh(k) = ek'*ek/(nSample-lags);
   sgh(k) = sqrt(sgsh(k));
end
% ** prior variance for A0(:,1), same for all equations!!!
sg0bid = zeros(nvar,1);  % Sigma0_bar diagonal only for the ith equation
for j=1:nvar
   sg0bid(j) = 1/sgsh(j);    % sgsh = sigmai^2
end
% ** prior variance for lagged and exogeous variables, same for all equations
sgpbid = zeros(ncoef,1);     % Sigma_plus_bar, diagonal, for the ith equation
for i = 1:lags
   if (q_m==12)
      lagdecay = a*exp(b*i*mu(4));
   end
   %
   for j = 1:nvar
      if (q_m==12)
         % exponential decay to match quarterly decay
         sgpbid((i-1)*nvar+j) = lagdecay^2/sgsh(j);  % ith equation
      elseif (q_m==4)
         sgpbid((i-1)*nvar+j) = (1/i^mu(4))^2/sgsh(j);  % ith equation
      else
			error('Incompatibility with lags, check the possible errors!!!')
      end
   end
end
%

if indxDummy   % Dummy observations as part of the explicit prior.
   ndobs=nvar+1;         % Number of dummy observations: nvar unit roots and 1 cointegration prior.
   phibar = zeros(ndobs,ncoef);
   %* constant term
   const = ones(nvar+1,1);
   const(1:nvar) = 0.0;
   phibar(:,ncoef) = const;      % the first nvar periods: no or zero constant!

   xdgelint = mean(xdgel(1:lags,:),1); % mean of the first lags initial conditions
   %* Dummies
   for k=1:nvar
      for m=1:lags
         phibar(ndobs,nvar*(m-1)+k) = xdgelint(k);
         phibar(k,nvar*(m-1)+k) = xdgelint(k);
         % <<>> multiply hyperparameter later
      end
   end
   phibar(1:nvar,:) = mu(5)*phibar(1:nvar,:);    % standard Sims and Zha prior
   phibar(ndobs,:) = mu(6)*phibar(ndobs,:);
   [phiq,phir]=qr(phibar,0);
   xtxbar=phir'*phir;   % phibar'*phibar.   ncoef-by-ncoef.  Reduced (not full) rank.  See Forcast II, pp.69-69b.
end

%=================================================
%   Computing the (prior) covariance matrix for A0, no data yet.
%   As proved in pp.69a-69b, Forecast II, the following prior covariance of A0
%     will remain the same after the dummy observations prior is incorporated.
%   The dummy observation prior only affects the prior covariance of A+|A0.
%   See pp.69a-69b for the proof.
%=================================================
%
%
% ** set up the conditional prior variance sg0bi and sgpbi.
sg0bida = mu(1)^2*sg0bid;   % ith equation
sgpbida = mu(1)^2*mu(2)^2*sgpbid;
sgpbida(ncoef-nexo+1:ncoef) = mu(1)^2*mu(3)^2;
          %<<>> No scaling adjustment has been made for exogenous terms other than constant
sgppbd = sgpbida(nvar+1:ncoef);    % corresponding to A++, in a Sims-Zha paper

Hptd = zeros(ncoef);
Hptdi=Hptd;
Hptd(ncoef,ncoef)=sgppbd(ncoef-nvar);
Hptdinv(ncoef,ncoef)=1./sgppbd(ncoef-nvar);
             % condtional on A0i, H_plus_tilde

%=================================================
%   Computing the final covariance matrix (S1,...,Sm) for the prior of A0,
%      and final Gb=(G1,...,Gm) for A+ if asymmetric prior or for
%      B if symmetric prior for A+
%=================================================
%
for i = 1:nvar
   %------------------------------
   % Introduce prior information on which variables "belong" in various equations.
   % In this first trial, we just introduce this information here, in a model-specific way.
   % Eventually this info has to be passed parametricly.  In our first shot, we just damp down
   % all coefficients except those on the diagonal.

   %*** For A0
    sg0bd = sg0bida; %  Note, this only works for the prior variance Sg(i)
                      % of a0(i) being diagonal.  If the prior variance Sg(i) is not
                      % diagonal, we have to the inverse to get inv(Sg(i)).
   %sg0bdinv = 1./sg0bd;
   % *    unconditional variance on A0+
   H0td = diag(sg0bd);    % unconditional
   H0tdinv = inv(H0td);
   %
   H0multi(:,:,i)=H0td;
   H0invmulti(:,:,i)=H0tdinv;


   %*** For A+
   if ~(lags==0)  % For A1 to remain random walk properties
      sg1bd = sgpbida(1:nvar);
      sg1bdinv = 1./sg1bd;
      %
      Hptd(1:nvar,1:nvar)=diag(sg1bd);
      Hptdinv(1:nvar,1:nvar)=diag(sg1bdinv);
      if lags>1
         sgpp_cbd = sgppbd(1:ncoef-nvar-1);
         sgpp_cbdinv = 1./sgpp_cbd;
         Hptd(nvar+1:ncoef-1,nvar+1:ncoef-1)=diag(sgpp_cbd);
         Hptdinv(nvar+1:ncoef-1,nvar+1:ncoef-1)=diag(sgpp_cbdinv);
               % condtional on A0i, H_plus_tilde
      end
   end
   %---------------
   % The dummy observation prior affects only the prior covariance of A+|A0,
   %    but not the covariance of A0.  See pp.69a-69b for the proof.
   %---------------
   if indxDummy   % Dummy observations as part of the explicit prior.
      Hpinvmulti(:,:,i)=Hptdinv + xtxbar;
      Hpmulti(:,:,i) = inv(Hpinvmulti(:,:,i));
   else
      Hpmulti(:,:,i)=Hptd;
      Hpinvmulti(:,:,i)=Hptdinv;
   end
end


