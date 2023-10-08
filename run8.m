close all 
clear all 
clc 

config_file = 'config-BP.txt';
fid = fopen(config_file, 'r');

data_range_A2E50 = fgetl(fid);
data_range_F2F50 = fgetl(fid);

fclose(fid);

x = xlsread('BP.xls',data_range_A2E50);
y = xlsread('BP.xls',data_range_F2F50);

[m,n]=size(x);
[c,d]=size(y);
for i=1:n
    for j=1:m-1
        
        X(j,i)=x(j+1,i)-x(j,i);
    end
end
for s=1:m-1
    if y(s,1) ~= 0
        Y(s)=(y(s+1,1)-y(s,1))/y(s,1);
    else
        Y(s) = 0; 
    end
end


for r=1:m-1
    P1(r,:)=[x(r,:) X(r,:)];
end


DimIn  =2*n;     
DimOut =d; 
Q  =m-1;  
p  =zeros(DimIn,Q); 
t =zeros(DimOut,Q);     


p = P1'; 
t = Y;
 
maxp=max(p')';        minp=min(p')';
maxt=max(t')';        mint=min(t')';

tmax  =0.9;      tmin  =0.1;
pmax  =0.9;      pmin  =0.1;
[rows, cols] = size(p);
if size(minp, 1) < rows
    error('minp');
end

for i=1:m-1
   for j=1:DimOut,
t(j,i)=tmin+(t(j,i)-mint(j,1))*(tmax-tmin)/(maxt(j,1)-mint(j,1));
end
end
for i=1:m-1
   for j=1:DimIn, 
p(j,i)=pmin+(p(j,i)-minp(j,1))*(pmax-pmin)/(maxp(j,1)-minp(j,1));
end
end
nntwarn OFF
S1=30;    
S2=20;
f1='logsig';   
f2='logsig';    
f3='logsig';
%nntwarn OFF
PopSize=10000;
xOpts = 0.1;
eOpts = 0.05;
selectOps =0.05;
termOps =30;
tr =zeros(termOps,3);
bounds =zeros(1,2);
bounds(1,1) = 0;   
bounds(1,2) = 1;   
[w1,b1]=initializeganet(PopSize,bounds,DimIn,S1);
[w2,b2]=initializeganet(PopSize,bounds,S1,S2);
[w3,b3]=initializeganet(PopSize,bounds,S2,DimOut);
net0pt=0;


if net0pt==1
   load net;
   w1(:,:,1)=ww1;
   w2(:,:,1)=ww2;
   w3(:,:,1)=ww3;
   b1(:,:,1)=bb1;
   b2(:,:,1)=bb2;
   b3(:,:,1)=bb3;
end
   
   

disp('The minimum SSE of the generation:');
for gen=1:termOps   
     
   message = sprintf('generation:%%g/%g, minSSE=%%g, meanSSE=%%g.\n',termOps);
   [fitness]=ganetfitness(p,t,w1,b1,f1,w2,b2,f2,w3,b3,f3); 
   [w1,b1,w2,b2,w3,b3,minSSE,meanSSE] =ganetselect(w1,b1,w2,b2,w3,b3,fitness,selectOps);
   fprintf(message,gen,minSSE,meanSSE);
   tr(gen,:)=[gen minSSE meanSSE];
   
 
 
   
   [w1] = ganetarithXover(w1,xOpts);
   [w2] = ganetarithXover(w2,xOpts);
   [w3] = ganetarithXover(w3,xOpts);
   [b1] = ganetarithXover(b1,xOpts);
   [b2] = ganetarithXover(b2,xOpts);
   [b3] = ganetarithXover(b3,xOpts);

   [w1] = ganetnonUnifMutate(w1,bounds,[gen eOpts termOps 3]);
   [w2] = ganetnonUnifMutate(w2,bounds,[gen eOpts termOps 3]);
   [w3] = ganetnonUnifMutate(w3,bounds,[gen eOpts termOps 3]);
   [b1] = ganetnonUnifMutate(b1,bounds,[gen eOpts termOps 3]);
   [b2] = ganetnonUnifMutate(b2,bounds,[gen eOpts termOps 3]);
   [b3] = ganetnonUnifMutate(b3,bounds,[gen eOpts termOps 3]);
   
end

[w1,b1,w2,b2,w3,b3,SSE] = ganetbestselect(w1,b1,w2,b2,w3,b3,fitness);
save ganet w1 w2 w3 b1 b2 b3;

w1=zeros(DimIn,S1);    
w2=zeros(S1,S2);    
w3=zeros(S2,DimOut);
b1=zeros(1,S1);        
b2=zeros(1,S2);     
b3=zeros(1,DimOut);
  netsel=1;
if netsel==1
 load ganet;

else
  w1=rands(S1,DimIn); 
  w2=rands(S2,S1);
  w3=rands(DimOut,S2);
  b1=rands(S1,1);
  b2=rands(S2,1);
  b3=rands(DimOut,1);
end
df    = 10000;  
me    = 10000; 
eg    =0.002; 
lr    = 0.01; 
mc    = 0.8;
more  = 100;
tp=[df me eg lr mc more];

[w1,b1,w2,b2,w3,b3]=bplearn(w1,b1,f1,w2,b2,f2,w3,b3,f3,p,t,tp);

save net w1 w2 w3 b1 b2 b3;

QTEST=m-1;     
PTEST  =zeros(DimIn,QTEST);  
TTEST =zeros(DimOut,QTEST);

p = P1'; 
t = Y;

for k=DimIn/2+1:DimIn
  P2=p;
  P2(k,:)=0;

  P_test = P2; 

QTEST =m-1;
f1  ='logsig'; 
f2  ='logsig';   
f3  ='logsig';
nntwarn OFF

for i=1:QTEST
   for j=1:DimIn, 
P_test(j,i)=pmin+(P_test(j,i)-minp(j,1))*(pmax-pmin)/(maxp(j,1)-minp(j,1));
   end
end


load net;


a=simuff(P_test,w1,b1,f1,w2,b2,f2,w3,b3,f3);
 for i=1:QTEST
   for j=1:DimOut,
a(j,i)=mint(j,1)+(a(j,i)-tmin)*(maxt(j,1)-mint(j,1))/(tmax-tmin);
   end
 end
for d=1:QTEST
     e1(d)=abs(t(1,d)-a(1,d));
     end
     Z(k-DimIn/2)=sum(e1)/QTEST;
end


[num, txt, raw] = xlsread('BP.xls', 'A1:Z1');  % Assuming the data is in the first row and doesn't exceed column Z

parameter_names = txt(1:end-1);

figure;
plot(Z, 1:length(parameter_names), 'o-');
set(gca, 'YTick', 1:length(parameter_names), 'YTickLabel', parameter_names);
xlabel('Sensitivity Value');
title('Sensitivity Analysis');
grid on;
saveas(gcf, 'Sensitivity_Results.png');






