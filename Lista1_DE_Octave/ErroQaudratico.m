## Copyright (C) 2017 Eduardo Rodrigues  D Neto
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} ErroQaudratico (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Eduardo Rodrigues  D Neto <eduardo@Eduardos-MacBook-Pro.local>
## Created: 2017-07-11

function result = ErroQaudratico (x)
  X = dlmread('aerogerador.dat');
  v = X(:,1);
  p = X(:,2);
  
  ypred = polyval(x,v);
  erro = p-ypred;
  %result = sum(erro.^2);  
  result =sum(erro.^2)+0.1*norm(x);
endfunction
