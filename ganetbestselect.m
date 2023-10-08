function[ww1,bb1,ww2,bb2,ww3,bb3,minSSE] = ganetbestselect(w1,b1,w2,b2,w3,b3,fitness)

m=size(fitness,1);
fit = zeros(m,1);% Allocates space for prob of select

x=zeros(m,2); 			        
% Sorted list of rank and id

x(:,1) =[m:-1:1]';			
% To know what element it was

[y x(:,2)] = sort(fitness);	
% Get the index after a sort

ww1=w1(:,:,x(m,2));
bb1=b1(:,:,x(m,2));
ww2=w2(:,:,x(m,2));
bb2=b2(:,:,x(m,2));
ww3=w3(:,:,x(m,2));
bb3=b3(:,:,x(m,2));
minSSE=1000000*1/y(m,1);
