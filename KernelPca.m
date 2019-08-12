classdef KernelPca < handle
    % Kernel pca with three types of kernel function: linear(*1), gaussian,
    % and polynomial.
    % Optional pre-processing.
    % New data projection without re-training the model.
    % 
    % ------------------------------Methods--------------------------------
    %
    % kpca = KernelPca(train_data, kernel, Value)
    %
    %        ---- Description ----
    %        Making a kernel pca model using train_data
    %        
    %        ---- Requied Input Arguments ----
    %         train_data - row vector dataset (size:N-by-D, where N is the
    %                     number of vectors and D is the dimention of 
    %                     the vectors).
    %             kernel - type of kernel function specified as char.
    %                     ('linear', 'gaussian', or 'poly').
    %
    %        ---- Name-Value Pair Input Arguments (*2) ----
    %            'gamma' - hyper parameter of gaussian kernel
    %                      default:2
    %                'r' - hyper parameter of polynomial kernel
    %                      default:1
    %                'd' - hyper parameter of polynomial kernel
    %                      default:2
    %        'AutoScale' - flag for auto scaling
    %                      if this is true, each variable is scaled using 
    %                      its standard deviation.
    %                      default:false
    %
    %        ---- Output Arguments ----
    %               kpca - trained kernel pca model as a KernelPca class.
    %                      new data can be projected by this.
    %
    %
    % projected_data = project(kpca, data, dim)
    %
    %        ---- Description ----
    %        project the data to subspace by using kpca that is a fitted
    %        kernel pca model.
    %
    %        ---- Requied Input Arguments ----
    %        kpca - trained kernel pca model as a KernelPca class.
    %        data - row vector dataset.
    %         dim - subspace dimention number of the projected data
    %               (dim<D, where D is the original dimention number of 
    %               input data)
    %
    %        ---- Output Arguments ----
    %        projected_data - projected row vector dataset.
    %
    % set_compact(kpca, Value)
    % 
    %        ---- Description ----
    %        set the instance compact by releasing some properties
    %        not used for projection.
    %
    %        ---- Requied Input Arguments ----
    %            kpca - trained kernel pca model as a KernelPca class.
    %
    %        ---- Name-Value Pair Input Arguments (*2) ----
    %        'MaxDim' - max number of the subspace dimention specified as
    %                   an integer.
    %                   If you specify this, unnecessary part of the 
    %                   coefficient is released.
    %        
    %
    % ---------------------------------------------------------------------
    % (*1) Note that linear kernel is corresponding to the normal pca, but
    % the internal algorithm is different from it.
    % (*2) Specify optional comma-separated pairs of Name,Value arguments. 
    % Name is the argument name and Value is the corresponding value. 
    % Name must appear inside quotes. You can specify several name and 
    % value pair arguments in any order as Name1,Value1,...,NameN,ValueN.
    
    
    properties (SetAccess = protected)
        kernel = "";
            
        train_data = [];
        auto_scale = false;
        scale = [];
        mean_train_data = [];
        centered_train_data = [];
        train_data_num = 0;
        train_gram_matrix = [];
        contribution_ratio
        coeff = [];

        kernel_params
    end
    
    
    methods
        function self = KernelPca(train_data, kernel, varargin)
            % fit the coefficient for projection
            
            % dafault of kernel hyper parameters
            self.kernel_params.gamma = 2;
            self.kernel_params.r = 1;
            self.kernel_params.d = 2;
            
            % checking input auguments
            p = inputParser;
            p.PartialMatching = false;
            validationNum = @(x) isnumeric(x);
            addRequired(p, 'train_data', validationNum)
            validationFcn1 = @(x) ischar(x) && (strcmp(x, 'gaussian') || strcmp(x, 'polynomial') || strcmp(x, 'linear'));
            addRequired(p, 'kernel', validationFcn1);
            addParameter(p, 'gamma', validationNum);
            addParameter(p, 'r', validationNum);
            addParameter(p, 'd', validationNum);
            validationFcn2 = @(x) islogical(x) || (x == 1) || (x == 0);
            addParameter(p, 'AutoScale', validationFcn2);
            parse(p, train_data, kernel, varargin{:});
            fit_params = p.Results;
            
            % storing kernel type and its hyper parameter
            self.kernel = string(fit_params.kernel);
            if isnumeric(fit_params.gamma)
                self.kernel_params.gamma = fit_params.gamma;
            end
            if isnumeric(fit_params.r)
                self.kernel_params.r = fit_params.r;
            end
            if isnumeric(fit_params.d)
                self.kernel_params.d = fit_params.d;
            end
            
            % storing the train_data and its centered data
            % (if 'AutoScale' is true, each variable is scaled using its standard deviation)
            self.train_data = fit_params.train_data;
            fit_params.train_data = [];
            if islogical(fit_params.AutoScale) || isnumeric(fit_params.AutoScale)
                if fit_params.AutoScale == true
                    self.auto_scale = true;
                    self.scale = zeros([1, size(self.train_data, 2)]);
                    for valueble_index = 1:size(self.train_data, 2)
                        self.scale(1, valueble_index) = 1 / std2(self.train_data(:, valueble_index)); 
                    end
                    self.train_data = self.train_data .* self.scale;
                end
            end
            self.mean_train_data = mean(self.train_data, 1);
            self.centered_train_data = self.train_data - self.mean_train_data;
            self.train_data_num = size(train_data, 1);
            
            % get gram_matrix
            self.train_gram_matrix = ...
                kr(self.centered_train_data', self.centered_train_data', self.kernel, self.kernel_params);
            
            % get coeff
            LN = zeros(self.train_data_num, self.train_data_num);
            LN(:, :) = 1 / self.train_data_num;
            C = self.train_gram_matrix ...
                - LN * self.train_gram_matrix ...
                - self.train_gram_matrix * LN ...
                + LN * self.train_gram_matrix * LN;
            [V, D] = eig(C);
            [D, ind] = sort(diag(D), 'descend');
            D = abs(D);
            self.contribution_ratio = D / sum(D);
            self.coeff = V(:, ind);
        end
        
        
        function projected = project(self, data, dim)
            % project a data to subspace using the coefficient
            
            % checking input auguments
            p = inputParser;
            p.PartialMatching = false;
            validationNum = @(x) isnumeric(x);
            addRequired(p, 'data', validationNum)
            validationN = @(x) (x == floor(x)) || (x > 0);
            addRequired(p, 'dim', validationN)
            parse(p, data, dim);
            
            %subspace coefficient
            subspace_coeff = self.coeff(:, 1:dim);
            
            % data is scaled and centered using training data information,
            % assuming that new data follows the same distribution as training data
            if self.auto_scale == true
                data = data .* self.scale;
            end
            data = data - self.mean_train_data;
            
            K = kr(self.centered_train_data', data', self.kernel, self.kernel_params);
            
            projected = transpose(subspace_coeff' * K);
        end
        
        function set_compact(self, varargin)
            % release the properties that are not used for projection
            
            % checking input auguments
            p = inputParser;
            p.PartialMatching = false;
            validationN = @(x) (x == floor(x)) || (x > 0);
            addParameter(p, 'MaxDim', validationN);
            parse(p, varargin{:});
            
            if isnumeric(p.Results.MaxDim)
                self.coeff = self.coeff(:, 1:p.Results.MaxDim);
            end
            
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
    elseif kernel == "polynomial"
        K = (vector1' * vector2 + kernel_params.r) .^ kernel_params.d;
    elseif kernel == "linear"
        K = vector1' * vector2;
    end
end

