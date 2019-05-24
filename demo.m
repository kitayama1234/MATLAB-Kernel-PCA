%
% test code of a gaussian kernel pca using KernelPca.m
%


% load sample data and plot------------------------------------------------
load('data.mat')

figure
hold on
gscatter(X(:, 1), X(:, 2), Y)
plot(Xtest(:, 1), Xtest(:, 2), 'LineStyle', 'none', 'Marker', '>')
legend(["X (class1)", "X (class2)", "X (class3)", "X (class4)", "Xtest"])
title('original data')


% gaussian kernel pca------------------------------------------------------

% fit pca model and get the coefficient for projection with dataset 'X'
% setting 'AutoScale' true is highly reccomended (default:false)
kpca = KernelPca(X, 'gaussian', 'gamma', 2.5, 'AutoScale', true);

% set the subspace dimention number M of projected data
% (M <= D, where D is the dimention of the original data)
M = 2;

% project the train data 'X' into the subspace by using the coefficient
projected_X = project(kpca, X, M);

% project the test data 'Xtest' as well
projected_Xtest = project(kpca, Xtest, M);


% plot
figure
hold on
gscatter(projected_X(:, 1), projected_X(:, 2), Y)
plot(projected_Xtest(:, 1), projected_Xtest(:, 2), 'LineStyle', 'none', 'Marker', '>')
title('pca with gaussian kernel')
xlabel('principal dim')
ylabel('second dim')
legend(["X (class1)", "X (class2)", "X (class3)", "X (class4)", "Xtest"])

