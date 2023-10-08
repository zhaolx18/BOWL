function [fitness] = ganetfitness(p,t,w1,b1,f1,w2,b2,f2,w3,b3,f3)
% fitness -- the fitness of this individual
% wb1,wb2,wb3 -- the individual of generation
% options -- [current_generation]
num=size(w1,3);
fitness=zeros(num,1);
for i=1:num
   a1=feval(f1,w1(:,:,i)*p,b1(:,1,i));
   a2=feval(f2,w2(:,:,i)*a1,b2(:,1,i));
   a3=feval(f3,w3(:,:,i)*a2,b3(:,1,i));
   
   e=t-a3;
 
   SSE=sumsqr(e)/1000000;
   fitness(i,1)=1/SSE;
end
