MATLAB Kernel PCA: PCA with training data , projection of new data 
====

## Overview
KernelPca.m is a MATLAB class file that enables you to do the following three things with a very short code.
1. fitting a kernel pca model with training data with three kernel functions(gaussian, polynomial, linear) (demo.m)  
1. projection of new data with the fitted pca model (demo.m)  
1. confirming the contribution ratio (demo2.m)

Enjoy it!

## Demos
### demo.m

![original data](https://github.com/kitayama1234/MATLAB-Kernel-PCA/blob/master/image1.jpg)

↓

```matlab
kpca = KernelPca(X, 'gaussian', 'gamma', 2.5, 'AutoScale', true);  
projected_X = project(kpca, X, 2);  
projected_Xtest = project(kpca, Xtest, 2);
```

↓  

![gaussian pca](https://github.com/kitayama1234/MATLAB-Kernel-PCA/blob/master/image2.jpg)

### demo2.m

```matlab
load fisheriris
linear_kpca = KernelPca(meas, 'linear');
```
↓

```matlab
plot([1 2 3 4], linear_kpca.contribution_ratio(1:4));
![contribution ratio](https://github.com/kitayama1234/MATLAB-Kernel-PCA/blob/master/image3.jpg)
```

## Description

## Methods

# `kpca = KernelPca(train_data, kernel, Value)`

- **Description**

Making a kernel model using train_data

- Required Input Auguments
 - `train_data`
> low vector dataset (size:N-by-D, where N is the number of vectors and D is the dimention of the vectors).
 - `kernel`
> type of kernel function specified as char.
> ('linear', 'gaussian', or 'polynomial').

- Name-Value Pair Input Auguments [^1]
 - `gamma`
> hyper parameter of gaussian kernel.
> default:2
 - `r`
> hyper parameter of polynomial kernel.
> default:1
 - `d`
> hyper parameter of polynomial kernel.
> default:2
 - `AutoScale`
> flag for auto scaling.
> If this is true, each variable is scaled using its standard deviation.
> default:false

# `projected_data = project(kpca, data, dim)`

- **Description**

Projecting the data to subspace by using kpca that is a fitted kernel pca model.






## Requirement
This code was written in the environment of MATLAB R2017a - academic use

## Author
Masaki Kitayama


