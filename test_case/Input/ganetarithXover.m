function [parent] = ganetarithXover(parent,Ops)

numXOvers=round(size(parent,1)*size(parent,2)*size(parent,3)*Ops/2);

for i=1:numXOvers
   a1 = round(rand*(size(parent,1)-1)+1); 	%Pick another parent
   a2 = round(rand*(size(parent,1)-1)+1); 	%Pick a parent
   b1 = round(rand*(size(parent,2)-1)+1); 	%Pick another parent
   b2 = round(rand*(size(parent,2)-1)+1); 	%Pick another parent
   c1 = round(rand*(size(parent,3)-1)+1); 	%Pick another parent
   c2 = round(rand*(size(parent,3)-1)+1); 	%Pick another parent
   p1 = parent(a1,b1,c1);
   p2 = parent(a2,b2,c2);
   a = rand;
   parent(a1,b1,c1) = p1*a     + p2*(1-a);
   parent(a2,b2,c2) = p1*(1-a) + p2*a; 
end
