function [w,b] = initializeganet(num,bounds,dimin,dimout,evalOps,options)
% function [pop]=initializega(populationSize, variableBounds,evalFN,
%                           evalOps,options)
%    initializega creates a matrix of random numbers with 
%    a number of rows equal to the populationSize and a number
%    columns equal to the number of rows in bounds plus 1 for
%    the f(x) value which is found by applying the evalFN.
%    This is used by the ga to create the population if it
%    is not supplied.
%
% pop            - the initial, evaluated, random population 
% sol            - the soultion of the population
% evalFN         - the evaluation fn, usually the name of the .m file for 
%                  evaluation
% evalOps        - any options to be passed to the eval function defaults []
% options        - options to the initialize function, ie. 
%                  [type prec] where eps is the epsilon value 
%                  and the second option is 1 for float and 0 for binary, 
%                  prec is the precision of the variables defaults [1e-6 1]


if nargin<6  options=[1e-6 1];
end
if nargin<5  evalOps=[];
end

rng         = (bounds(1,2)-bounds(1,1))*0.5;     %The variable ranges

if options(2)==1 %Float GA
   
pop=zeros(dimout,dimin+1,num);
w=zeros(dimout,dimin,num);
b=zeros(dimout,1,num);

for i=1:num
   pop(:,:,i)= (2*rand(dimout,dimin+1)-1)*rng;
   w(:,1:dimin,i)=pop(:,1:dimin,i);
   b(:,1,i)=pop(:,dimin+1,i);
end

else %Binary GA
  bits=calcbits(bounds,options(1));
  xZomeLength = sum(bits)+1; 		%Length of string is numVar + fit
  pop = round(rand(num,sum(bits)+1));
end
