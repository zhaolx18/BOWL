function [parent] = ganetnonUnifMutate(parent,bounds,Ops)


cg=Ops(1);% Current Generation
mp=Ops(2);
mg=Ops(3);                              % Maximum Number of Generations
b=Ops(4);                               % Shape parameter
numVar = round(size(parent,1)*size(parent,2)*size(parent,3)*mp); 		% Get the number of variables
for i=1:numVar
   a = round(rand*(size(parent,1)-1)+1); 	%Pick a parent
   b = round(rand*(size(parent,2)-1)+1); 	%Pick another parent
   c = round(rand*(size(parent,3)-1)+1); 	%Pick another parent
   if c==1
      c = round(rand*(size(parent,3)-1)+1); 	%Pick another parent
   end
   
md = round(rand); 			% Choose a direction of mutation
if md 					% Mutate towards upper bound
  parent(a,b,c)=parent(a,b,c)-delta(cg,mg,bounds(1,2)-parent(a,b,c),b);
else 					% Mutate towards lower bound
   parent(a,b,c)=parent(a,b,c)+delta(cg,mg,parent(a,b,c)-bounds(1,1),b);
end

end
