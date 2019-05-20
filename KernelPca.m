classdef KernelPca < handle
    % kernel pca with three types of kernel function: linear, gaussian,
    % and polynomial.
    % * Note that linear kernel is corresponding to the normal pca, but
    %   the internal algorithm is different from it.
    % 
    % ------------------------------methods-------------------------------
    % self = KernelPca()
    %
    %        explanation:
    %        make a instance and init params.
    % 
    % fit_pca(self, train_data, kernel)
    %
    %        explanation:
    %        fit pca and get the coefficient for projection with
    %        train_data.
    %        
    %        input auguments:
    %        train_data - low vector dataset (size:N * D, where N is the
    %        number of vectors and D is the dimention of each vector).
    %        kernel - a string data specifing kernel function ("linear",
    %        "gaussian", or "polynomial").
    % 
    % projected = project(self, data, dim)
    %
    %        explanation:
    %        project the data to subspace by using the coefficient.
    %
    %        input augument:
    %        data - low vector dataset.
    %
    %        output augument:
    %        projected - projected low vector dataset.
    %
    % set_compact(self)
    % 
    %        explanation:
    %        set the instance compact by releasing some properties
    %        not used for projection.
    %        
    %
    % ----------------------------parameters------------------------------
    % self.kernel_params - the structure consists of hyper parameters of 
    % the kernel functions.
    % (.gamma - hyper param of gaussian kernel function)
    % (.r and .d - hyper params of  polynomial kernel function)
    
    properties
        kernel_params
    end
    
    properties (SetAccess = protected)
        kernel
        train_data
        centered_train_data
        mean_train_data
        train_data_num
        train_gram_matrix
        coeff
    end
    
    
    methods
        function self = KernelPca()
            self.kernel = "";
            
            self.train_data = [];
            self.mean_train_data = [];
            self.centered_train_data = [];
            self.train_data_num = 0;
            self.train_gram_matrix = [];
            self.coeff = [];
            
            self.kernel_params.gamma = 0.01;
            self.kernel_params.r = 1;
            self.kernel_params.d = 2;
        end
        
        function fit_pca(self, train_data, kernel)
            % fit the coefficient for projection
            
            % checking augument
            if isstring(kernel)
                if ismember(kernel, ["linear", "gaussian", "poly"])
                    self.kernel = kernel;
                else
                    printf('Error: The kernel type must be one of ["linear", "gaussian", "poly"]')
                    return
                end
            else
                printf('Error: The kernel type must be specified as a string')
                return
            end
            
            % storing the train_data and its centered data
            self.train_data = train_data;
            self.mean_train_data = mean(self.train_data, 1);
            self.centered_train_data = train_data - self.mean_train_data;
            self.train_data_num = size(train_data, 1);
            
            % get gram_matrix
            self.train_gram_matrix = kr(self.centered_train_data', self.centered_train_data', self.kernel, self.kernel_params);
            
            % get coeff
            LN = zeros(self.train_data_num, self.train_data_num);
            LN(:, :) = 1 / self.train_data_num;
            C = self.train_gram_matrix ...
                - LN * self.train_gram_matrix ...
                - self.train_gram_matrix * LN ...
                + LN * self.train_gram_matrix * LN;
            [V, D] = eig(C);
            [~, ind] = sort(diag(D), 'descend');
            self.coeff = V(:, ind);
        end
        
        
        function projected = project(self, data, dim)
            % project a data to subspace using the coefficient
            
            subspace_coeff = self.coeff(:, 1:dim);
            
            data = data - self.mean_train_data;
            
            K = kr(self.centered_train_data', data', self.kernel, self.kernel_params);
            
            projected = transpose(subspace_coeff' * K);
        end
        
        function set_compact(self)
            % release the properties that are not used for projection
            
            self.train_data = [];
            self.train_gram_matrix = [];
        end
    end
    
    
    
end

function K = kr(vector1, vector2, kernel, kernel_params)
    if kernel == "gaussian"
        K = zeros(size(vector1, 2), size(vector2, 2));
        for i = 1:size(vector1, 2)
            K(i, :) = exp(-kernel_params.gamma .* sqrt(sum((vector1(:, i) - vector2) .^ 2, 1) .^ 2));
        end
    elseif kernel == "poly"
        K = (vector1' * vector2 + kernel_params.r) .^ kernel_params.d;
    elseif kernel == "linear"
        K = vector1' * vector2;
    end
end

