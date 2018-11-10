function [] = tdprint(res,file_sal)
% PURPOSE: Generate output of temporal disaggregation methods
% ------------------------------------------------------------
% SYNTAX: tdprint(res,file_sal) 
% ------------------------------------------------------------
% OUTPUT: file_sal: an ASCII file with detailed output of
% temporal disaggregation methods. Optional.
% ------------------------------------------------------------
% INPUT: res: structure generated by td programs
%        file_sal: name of the ASCII file for output (optional)
%        If file_sal is empty, output is directed to screen
% ------------------------------------------------------------
% LIBRARY: tduni_print, td_print, mtd_print
% ------------------------------------------------------------
% SEE ALSO: 

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Finance
%  Paseo de la Castellana, 162. Office 2.5-1.
%  28046 - Madrid (SPAIN)
%  <enrique.quilis@meh.es>

% Version 1.1 [August 2006]

if (nargin == 1)
   switch res.meth
   case {'Boot-Feibes-Lisman','Denton','Stram-Wei'}
      tduni_print(res);
   case {'Fernandez','Chow-Lin','Litterman','Santos Silva-Cardoso'}
      td_print(res);
   case {'Multivariate Denton','Multivariate Di Fonzo','Multivariate Rossi'}
      mtd_print(res);
   end
else
   switch res.meth
   case {'Boot-Feibes-Lisman','Denton','Stram-Wei'}
      tduni_print(res,file_sal);
   case {'Fernandez','Chow-Lin','Litterman','Santos Silva-Cardoso'}
      td_print(res,file_sal);
   case {'Multivariate Denton','Proportional Multivariate Denton', ...
         'Multivariate Di Fonzo','Multivariate Rossi'}
      mtd_print(res,file_sal);
   end
end

