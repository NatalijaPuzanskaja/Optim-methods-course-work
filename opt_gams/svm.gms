$ontext

  SVM clustering as optimization model
  
$offtext

scalars largeWeightsPenaltyParameter 'penalty parameter' /0.1/
    nPositivePoints 'n points 1 cluster ' /5/
    nNegativePoints 'n points 2 cluster' /5/
;

sets
    dimensions  /d1, d2/
    positivePointNs     /p1*p5/
    negativePointNs     /n1*n5/
;

table positivePoints(positivePointNs, dimensions)
        d1      d2
p1      2       0
p2      0       3
p3      1       3
p4      0       4
p5      1       4
;

table negativePoints(negativePointNs, dimensions)
        d1      d2
n1      1       1
n2      2       1
n3      2       2
n4      3       1
n5      3       2
;

free variables
    m(dimensions)
     b
     z
;

positive variables
     c(positivePointNs)
     d(negativePointNs)
;

equations
     positiveConstraints(positivePointNs)
     negativeConstraints(negativePointNs)
     objective
;

positiveConstraints(positivePointNs) ..
    sum(dimensions, positivePoints(positivePointNs, dimensions) * m(dimensions)) - b + c(positivePointNs) =g= 1;

negativeConstraints(negativePointNs) ..
     - sum(dimensions, negativePoints(negativePointNs, dimensions) * m(dimensions)) + b + d(negativePointNs) =g= 1;

objective ..
    z =e= 1 / nPositivePoints * sum(positivePointNs, c(positivePointNs)) + 1 / nNegativePoints * sum(negativePointNs, d(negativePointNs)) +
    largeWeightsPenaltyParameter / 2 * sum(dimensions, m(dimensions) * m(dimensions))

model svm /all/;

solve svm minimizing z using qcp;
