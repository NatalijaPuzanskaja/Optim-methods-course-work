$ontext 

  K-means clustering heuristic 

$offtext 

option seed=101; 

sets 
   k  'clusters' /k1*k4/ 
   i  'data points' /i1*i100/ 
   ik(i,k) 'assignment of points to clusters' 
   xy 'coordinates of points' /x,y/ 
; 
parameter 
   m(k,xy) 'random clusters to generate data points' 
   p(i,*)  'data points' 
   numk    'number of clusters' 
   cluster(i)    'cluster number' 
; 

numk = card(k); 
alias(ii,i); 

*------------------------------------------------ 
* generate random data 
* points are around some clusters 
*------------------------------------------------ 
m(k,xy) = uniform(0,4); 
cluster(i) = uniformint(1,numk); 
ik(i,k) = cluster(i)=ord(k); 
p(i,xy) = sum(ik(i,k),m(k,xy)) + uniform(0,1); 
display m,p; 

sets 
  ik(i,k) 'assignment of points to clusters' 
  ik_prev(i,k) 'previous assignment of points to clusters' 
  ik_diff 
  trial   'number of trials' /trial1*trial15/ 
  iter    'max number of iterations' /iter1*iter20/ 
; 
parameters 
  n(k)       'number of points assigned to cluster' 
  c(k,xy)    'centroids' 
  notconverged  '0=converged,else not converged' 
  d(i,k)     'squared distance' 
  dclose(i)  'distance closest cluster' 
  trace(trial,iter) 'reporting' 
; 

loop(trial, 

*------------------------------------------------ 
* Step 1 
* Random assignment 
*------------------------------------------------ 

      cluster(i) = uniformint(1,numk); 
      ik(i,k) = cluster(i)=ord(k); 

      notConverged = 1; 
      loop(iter$notConverged, 

*------------------------------------------------ 
* Step 2 
* Calculate centroids 
*------------------------------------------------ 
          n(k) = sum(ik(i,k), 1); 
          c(k,xy)$n(k) = sum(ik(i,k), p(i,xy))/n(k); 

*------------------------------------------------ 
* Step 3 
* Re-assign points 
*------------------------------------------------ 

          ik_prev(i,k) = ik(i,k); 
          d(i,k) = sum(xy, sqr(p(i,xy)-c(k,xy))); 
          dclose(i) = smin(k, d(i,k)); 
          ik(i,k) = yes$(dclose(i) = d(i,k)); 

*------------------------------------------------ 
* Step 4 
* Check convergence 
*------------------------------------------------ 

          ik_diff(i,k) = ik(i,k) xor ik_prev(i,k); 
          notConverged = card(ik_diff); 

          trace(trial,iter) = sum(ik(i,k),d(i,k)); 
      ); 
); 

display trace; 