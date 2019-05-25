%
% demo2: how to confirm the contribution ratio of a kernel pca model.
%


% load iris dataset
load fisheriris

% make a linear kernel pca model
% (The result is equal to normal pca, but the internal algorithm is 
% different)
linear_model = KernelPca(meas, 'linear');

% plot the contribution ratio
figure
hold on
plot([1 2 3 4], linear_model.contribution_ratio(1:4), '-.<b')
xlabel('dimention')
ylabel('contribution ratio')
title('contribution ratio of the linear kernel pca')

% threshold the max number of subspace dimention
% by the accumulated contribution ratio
th = 0.95;
accumulated = cumsum(linear_model.contribution_ratio(1:4));
for max_dim = 1:4
    if accumulated(max_dim) > th
        break;
    end
end

% make the model compact by releasing some unnecessary properties
set_compact(linear_model, 'MaxDim', max_dim);

% project the data and plot
projected = project(linear_model, meas, max_dim);
figure
gscatter(projected(:, 1), projected(:, 2), species)