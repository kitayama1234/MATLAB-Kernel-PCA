MATLAB Kernel PCA: PCA with training data , projection of new data 
====

# Overview
KernelPca.m is a MATLAB class file that enables you to do the following three things with a very short code.
1. fitting a kernel pca model with training data with three kernel functions(gaussian, polynomial, linear) (demo.m)  
1. projection of new data with the fitted pca model (demo.m)  
1. confirming the contribution ratio (demo2.m)

# Demos
## demo.m

![original data](https://github.com/kitayama1234/MATLAB-Kernel-PCA/blob/master/image1.jpg)

↓

```matlab
kpca = KernelPca(X, 'gaussian', 'gamma', 2.5, 'AutoScale', true);  
projected_X = project(kpca, X, 2);  
projected_Xtest = project(kpca, Xtest, 2);
```

↓  

![gaussian pca](https://github.com/kitayama1234/MATLAB-Kernel-PCA/blob/master/image2.jpg)

## demo2.m

```matlab
load fisheriris
linear_kpca = KernelPca(meas, 'linear');
```
↓

```matlab
plot([1 2 3 4], linear_kpca.contribution_ratio(1:4));
```
![contribution ratio](https://github.com/kitayama1234/MATLAB-Kernel-PCA/blob/master/image3.jpg)



# Description

* Kernel pca with three types of kernel function: linear\[^1], gaussian, and polynomial.
  * linear kernel function : <img src="https://latex.codecogs.com/gif.latex?K_l(\vec{x}_1,\vec{x}_2)=\vec{x}_1\cdot\vec{x}_2">
  * gaussian kernel function : <img src="https://latex.codecogs.com/gif.latex?K_{g}(\vec{x}_1,\vec{x}_2)=\exp(-\gamma|\vec{x}_1-\vec{x}_2|^{2})">
  * polynomial kernel function : <img src="https://latex.codecogs.com/gif.latex?K_{p}(\vec{x}_1,\vec{x}_2)=(\vec{x}_1\cdot\vec{x}_2&plus;r)^d">
* Optional pre-processing.
* New data projection without re-training the model.

## Methods

***

### `kpca = KernelPca(train_data, kernel, Value)`
> Making a kernel pca model (an instance of `KernelPca` class) using `train_data`

#### Required Input Arguments

>- `train_data`
>> row vector dataset (size:N-by-D, where N is the number of vectors and D is the dimention of the vectors).
>
>- `kernel`
>> type of the kernel function specified as char.
>> ('linear', 'gaussian', or 'polynomial').

#### Name-Value Pair Input Arguments\[^2]

>- `gamma`
>> hyper parameter of gaussian kernel.
>> default:2
>
>- `r`
>> hyper parameter of polynomial kernel.
>> default:1
>
>- `d`
>> hyper parameter of polynomial kernel.
>> default:2
>
>- `AutoScale`
>> flag for auto scaling.
>> If this is true, each variable is scaled using its standard deviation.
>> default:false

#### Output Arguments

>- `kpca`
>> trained kernel pca model as a KernelPca class. New data can be projected by this.

***

### `projected_data = project(kpca, data, dim)`
> Projecting the data to subspace by using kpca that is a fitted kernel pca model.

#### Required Input Arguments

>- `kpca`
>> trained kernel pca model as a KernelPca class.
>
>- `data`
>> row vector dataset.
>
>- `dim`
>> subspace dimention number of the projected data (dim<D, where D is the original dimention number of input data)

#### Output Arguments

>- `projected_data`
>> projected row vector dataset.

***

### `set_compact(kpca, Value)`
> Setting a fitted instance compact by releasing some properties not used for projection.

#### Required Input Arguments

>- `kpca`
>> trained kernel pca model as a KernelPca class.

#### Name-Value Pair Input Arguments\[^2]

>- `MaxDim`
>> max number of the subspace dimention specified as an integer.
>> If you specify this, unnecessary part of the coefficient is released.

***



\[^1]: Note that linear kernel is corresponding to the normal pca, but the internal algorithm is different from it.

\[^2]: Specify optional comma-separated pairs of Name,Value arguments. Name is the argument name and Value is the corresponding value. Name must appear inside quotes. You can specify several name and value pair arguments in any order as Name1,Value1,...,NameN,ValueN.


# Requirement
This code was written in the environment of MATLAB R2017a - academic use

# Author
Masaki Kitayama


