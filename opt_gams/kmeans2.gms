$ontext

  K-means clustering as optimization model

$offtext

option seed=101;

sets
   k  'clusters' /k1*k3/
   i  'data points' /i1*i20/
   xy 'coordinates of points' /x,y/
;
parameter
   m(k,xy) 'random clusters to generate data points'
   p(i,*)  'data points'
;

*------------------------------------------------
* generate random data
* points are around some clusters
*------------------------------------------------
m(k,xy) = uniform(0,4);
p(i,'cluster') = uniformint(1,card(k));
p(i,xy) = sum(k$(p(i,'cluster')=ord(k)),m(k,xy)) + uniform(0,1);
display m,p;


*------------------------------------------------
* Optimization mdel
*------------------------------------------------

variables
  c(k,xy) 'clusters'
  z       'objective'
  d(i,k)  'distance'
;
binary variables
  x(i,k) 'assign points to clusters'
;

equations
   objective
   distances(i,k)
   assign(i)
;

*------------------------------------------------
* Get some good bounds
*------------------------------------------------

d.lo(i,k) = 0;
alias (i,j);
d.up(i,k) = smax(j, sum(xy, sqr(p(i,xy)-p(j,xy))));
c.lo(k,xy) = smin(i, p(i,xy));
c.up(k,xy) = smax(i, p(i,xy));


objective..       z =e= sum((i,k), d(i,k));
distances(i,k)..  d(i,k) =g= sum(xy, sqr(p(i,xy)-c(k,xy)) ) - d.up(i,k)*(1-x(i,k));
assign(i)..       sum(k, x(i,k)) =e= 1;

model kmeans /all/;
option optcr=0;
solve kmeans minimizing z using miqcp;

option x:0;
display c.l,x.l;
