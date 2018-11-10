function [V, D] = fn_ordereig_descend(X)
%function [V, D] = fn_ordereig_descend(X)
%  Produces a diagonal matrix D of eigenvalues and a full matrix V whose columns are the corresponding eigenvectors so
%     that X*V = V*D, where the diagnoal of D is in descending order.
%
% X: a square matrix.
%---
% V: a full matrix of eigenvectors.
% D: a diagonal matrix of eigenvalues.
%
% Tao Zha, Auguest 2014
% Copyright (C) 2014 Tao Zha
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

[eigV,eigD] = eig(X);
[sortD, sortDindx] = sort(abs(diag(eigD)),'descend');
V = eigV(:,sortDindx);
D = eigD(sortDindx,sortDindx);
