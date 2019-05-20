%
% test code of three kinds of kernel pca using KernelPca class
%


% load sample data and plot------------------------------------------------
load('data.mat')

figure
hold on
gscatter(X(:, 1), X(:, 2), Y)
plot(Xtest(:, 1), Xtest(:, 2), 'LineStyle', 'none', 'Marker', '>')
title('original data')


% make an instance of the KernelPca class----------------------------------
kpca = KernelPca();



% gaussian kernel pca------------------------------------------------------

% set the hyper parameter of gaussian kernel function
kpca.kernel_params.gamma = 0.0001;

% fit pca and get the coefficient for projection with dataset 'X'
fit_pca(kpca, X, "gaussian");

% set the subspace dimention M of projected data (M <= D, where D is the
% dimention of the original data),
% and project the data 'X' into the subspace by using the coefficient
M = 2;
projected_X = project(kpca, X, M);

% project the data 'Xtest' as well
projected_Xtest = project(kpca, Xtest, M);


% plot
figure
hold on
gscatter(projected_X(:, 1), projected_X(:, 2), Y)
plot(projected_Xtest(:, 1), projected_Xtest(:, 2), 'LineStyle', 'none', 'Marker', '>')
title('pca with gaussian kernel')
xlabel('principal dim')
ylabel('second dim')

