MATLAB Kernel PCA: PCA with training data , projection of new data 
====

## Overview
KernelPca.m is a MATLAB class file that enables you to do the following two things with a very short code.
1. fitting a kernel pca model with training data with three kernel functions(gaussian, polynomial, linear)
1. projection of new data with the fitted pca model  
1. confirming the contribution ratio

Enjoy it!

## Demo
Run demo.m with KernelPca.m and data.mat.

![original data](https://github.com/kitayama1234/MATLAB-Kernel-PCA/blob/master/image1.jpg)

↓  
kpca = KernelPca(X, 'gaussian', 'gamma', 2.5, 'AutoScale', true);  
projected_X = project(kpca, X, 2);  
projected_Xtest = project(kpca, Xtest, 2);  
↓  

![gaussian pca](https://github.com/kitayama1234/MATLAB-Kernel-PCA/blob/master/image2.jpg)

## Description
See the comment out on the top of KernelPca.m

## Requirement
This code was written in the environment of MATLAB R2017a - academic use

## Author
Masaki Kitayama


