function[neww1,newb1,neww2,newb2,neww3,newb3,minSSE,meanSSE] = ganetselect(oldw1,oldb1,oldw2,oldb2,oldw3,oldb3,fitness,options)

q=options; 				% Probability of selecting the best
neww1=zeros(size(oldw1,1),size(oldw1,2),size(oldw1,3));
newb1=zeros(size(oldb1,1),size(oldb1,2),size(oldb1,3));
neww2=zeros(size(oldw2,1),size(oldw2,2),size(oldw2,3));
newb2=zeros(size(oldb2,1),size(oldb2,2),size(oldb2,3));
neww3=zeros(size(oldw3,1),size(oldw3,2),size(oldw3,3));
newb3=zeros(size(oldb3,1),size(oldb3,2),size(oldb3,3));
m=size(fitness,1);

fit = zeros(m,1);			% Allocates space for prob of select
x=zeros(m,2); 			        % Sorted list of rank and id
x(:,1) =[m:-1:1]';			% To know what element it was
[y x(:,2)] = sort(fitness);	% Get the index after a sort
minSSE=1000000/y(m);
meanSSE=1000000/(sum(y)/m);
r = q/(1-(1-q)^m); 			% Normalize the distribution, q prime
fit(x(:,2))=r*(1-q).^(x(:,1)-1); 	% Generates Prob of selection 
fit = cumsum(fit); % Calculate the cumulative prob. func

neww1(:,:,1)=oldw1(:,:,x(m,2));
neww2(:,:,1)=oldw2(:,:,x(m,2));
neww3(:,:,1)=oldw3(:,:,x(m,2));
newb1(:,:,1)=oldb1(:,:,x(m,2));
newb2(:,:,1)=oldb2(:,:,x(m,2));
newb3(:,:,1)=oldb3(:,:,x(m,2));

rNums=sort(rand(m,1)); 			% Generate n sorted random numbers
fitIn=1; newIn=2; 			% Initialize loop control
while newIn<=m				% Get n new individuals
  if(rNums(newIn)<fit(fitIn)) 		
   neww1(:,:,newIn)=oldw1(:,:,fitIn);
   newb1(:,:,newIn)=oldb1(:,:,fitIn);
   neww2(:,:,newIn)=oldw2(:,:,fitIn);
   newb2(:,:,newIn)=oldb2(:,:,fitIn);
   neww3(:,:,newIn)=oldw3(:,:,fitIn);
   newb3(:,:,newIn)=oldb3(:,:,fitIn);
    newIn = newIn+1; 			% Looking for next new individual
  else
    fitIn = fitIn + 1; 			% Looking at next potential selection
  end
end
