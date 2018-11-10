function y = minter_xls(Y,x,z,ta,sc,f,type,d,flax1,flax2)
% PURPOSE: Interface via Excel Link for multivariate temporal disaggregation
% -----------------------------------------------------------------------
% SYNTAX: y = minter_xls(Y,x,z,ta,sc,f,type,d,flax1,flax2);
% -----------------------------------------------------------------------
% INPUT
%           SELECTION OF THE METHOD
%
% Common parameters:
%        ta: type of disaggregation
%            ta=1 ---> sum (flow)
%            ta=2 ---> average (index)
%            ta=3 ---> last element (stock) ---> interpolation
%            ta=4 ---> first element (stock) ---> interpolation
%        sc: number of high frequency data points for each low frequency data point
%            sc= 4 ---> annual to quarterly
%            sc=12 ---> annual to monthly
%            sc= 3 ---> quarterly to monthly
%
% Specific parameters:
%
% ==> Rossi:
%        opMethod = type: preliminary univariate disaggregation = 1
%            = 1 ---> Fernandez
%            = 2 ---> Chow-Lin
%            = 3 ---> Litterman
%        In all cases, estimation is performed by Maximum Likelihood
%
% ==> Denton:
%        d: objective function to be minimized: volatility of ...
%            d=0 ---> levels
%            d=1 ---> first differences
%            d=2 ---> second differences
%
% ==> di Fonzo:
%        type: model for the innovations
%            = 0 ---> white noise
%            = 1 ---> random walk
% 
% INPUT DATA:
%         Y : NxM 
%         x : nxMM
%         z : nxnz
%                
% -----------------------------------------------------------------------
% OUTPUT: y: nxi
%       i=M  brief --> only temporally disaggregated series (all procedures)
%       i=2M detailed --> temporally disaggregated series + standard errors of estimates
%                  Available for Di Fonzo.
% -----------------------------------------------------------------------
% LIBRARY: rossi, denton, difonzo

% Ana Abad(*) & Enrique M. Quilis(**)
%   (*)Instituto Nacional de Estadistica
%   (**) Macroeconomic Research Department
%  Ministry of Economy and Finance
%  Paseo de la Castellana, 162. Office 2.5-1.
%  28046 - Madrid (SPAIN)
%  <enrique.quilis@meh.es>

% Version 2.1 (October, 2006)

% -----------------------------------------------------------------------
% SELECTION OF THE METHOD

switch flax1
case 1
   % Rossi
   opMethod = type;
   res = rossi(Y,x,z,ta,sc,opMethod,1);
case 2
   % Denton
   res = denton(Y,x,z,ta,sc,d);
case 3
   % di Fonzo
   res = difonzo(Y,x,z,ta,sc,type,f);
end
  
% -----------------------------------------------------------------------
% SELECTION OF OUTPUT

 switch flax2
     case 0 
         % Brief output
         y = res.y;
     case 1
         % Normal output
         switch res.meth
             case {'Multivariate Denton','Multivariate Rossi'}
                 y = res.y;           
             case {'Multivariate Di Fonzo'}
                  y   = [res.y res.d_y];           
          end
 end
 