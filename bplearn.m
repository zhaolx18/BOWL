function [w1,b1,w2,b2,w3,b3]=bplearn(w1,b1,f1,w2,b2,f2,w3,b3,f3,p,t,tp)
%w1
DimOut=size(t,1);
f1  ='logsig';             
f2 ='logsig';            
f3  ='logsig';


%if nargin < 12,error('Not enough arguments.');end

% TRAINING PARAMETERS
%if nargin == 11, tp = []; end
%tp    = nndef(tp,[100 10000 0.002 0.01 0.9 200]);
tp    = [100 100000 0.035 0.01 0.8 200];
df    = tp(1);
me    = tp(2);
eg    = tp(3);
lr    = tp(4);
dm    = tp(5);
more  = tp(6);


df1 = feval(f1,'delta');
df2 = feval(f2,'delta');
df3 = feval(f3,'delta');

dw1 = w1*0;
db1 = b1*0;
dw2 = w2*0;
db2 = b2*0;
dw3 = w3*0;
db3 = b3*0;
MC = 0;

% PRESENTATION PHASE
a1 = feval(f1,w1*p,b1);
a2 = feval(f2,w2*a1,b2);
a3 = feval(f3,w3*a2,b3);
e = t-a3;
olde=e;
SSE = sumsqr(e);
TSSE = sumsqr(olde);
oldSSE=SSE;



message = sprintf('TRAINBPX:%%g/%g,lr=%%g, SSE=%%g.\n',me);
fprintf(message,0,lr,TSSE)


% BACKPROPAGATION PHASE
d3 = feval(df3,a3,e);
d2 = feval(df2,a2,d3,w3);
d1 = feval(df1,a1,d2,w2);

for i=1:me
   
   
 % CHECK PHASE
  if SSE < eg, i=i-1; break, end
  
  
% LEARNING PHASE
  [dw1,db1] = learnbpm(p,d1,lr,MC,dw1,db1);
  [dw2,db2] = learnbpm(a1,d2,lr,MC,dw2,db2);
  [dw3,db3] = learnbpm(a2,d3,lr,MC,dw3,db3);
  MC = dm;
  w1 = w1 + dw1; b1 = b1 + db1;
  w2 = w2 + dw2; b2 = b2 + db2;
  w3 = w3 + dw3; b3 = b3 + db3;
  
      
  % PRESENTATION PHASE
  a1 = feval(f1,w1*p,b1);
  a2 = feval(f2,w2*a1,b2);
  a3 = feval(f3,w3*a2,b3);
  e = t-a3;
  olde=e;
  SSE = sumsqr(e);


  % BACKPROPAGATION PHASE
  d3 = feval(df3,a3,e);
  d2 = feval(df2,a2,d3,w3);
  d1 = feval(df1,a1,d2,w2);

  % PLOTING RECORD
   if rem(i,more)==0
       
fid=fopen('compute.txt','wt');
if fid==-1
error('Error when opening training set file !');
end
 fprintf(fid,'%f\n',TSSE);
 fclose(fid);
 end
    
  if rem(i,df) == 0
  TSSE = sumsqr(olde);
 
    
former_w1=w1;
former_w2=w2;
former_w3=w3;
former_b1=b1;
former_b2=b2;
former_b3=b3;
former_e=e;
former_SSE=SSE;

  if oldSSE<SSE,
     lr=0.8*lr;
     oldSSE=SSE;
     
w1=former_w1;
w2=former_w2;
w3=former_w3;
b1=former_b1;
b2=former_b2;
b3=former_b3;
e=former_e;
SSE=former_SSE;

  end
  
  % TRAINING RECORD
  fprintf(message,i,lr,TSSE)
  
  oldSSE=SSE;
  end
end

% WARNINGS
%if SSE > eg
  %disp(' ')
  %disp('TRAINBPX: Network error did not reach the error goal.')
  %disp(' ')

%end
