function stimulus=generate_stimulus(category,image_size,lambda_h,lambda_v)
%% GENRATE_STIMULUS  Create an image where pixel values are sampled from a 
% 2D Gaussian process with covariance function determined by the specified
% hyperparameters (lambdas). The image category is either patchy or stripy;
% stripes can be vertical or horizontal. Plot and save the image.
% 
%   ARGS:
%   category                0=patchy (cheetah), -1=stripy (zebra), vertical
%                           1=stripy (zebra), horizontal
%   image_size              N, where the image will consist of NxN pixels
%                           in resolution
%   OPTIONAL ARGS:
%   lambda_h, lambda_v      horizontal and vertical hyperparameters of 
%                           covariance function (defaults: see Methods of 
%                           Yang et. al.)
% 
%   OUTPUT:
%   stimulus                pixel values (NxN matrix)

%% Process inputs

if nargin<4
    if category==0, lambda_h=1.39; lambda_v=1.39;
    elseif category==-1, lambda_h=4.63; lambda_v=0.91;
    elseif category==1, lambda_h=0.91; lambda_v=4.63;
    end
end

%% Draw an image from a 2D Gaussian process

% generate arrays of evenly spaced coordinates for image rows and columns
coordinates=-round(image_size/2):round(image_size/2);
[X,Y]=meshgrid(coordinates);
% compute the covariance function
covariance=exp(-0.5*((1/lambda_h^2)*(X(:)-X(:)').^2+(1/lambda_v^2)*(Y(:)-Y(:)').^2));
% draw from the multivariate normal
stimulus=mvnrnd(zeros(length(coordinates)^2,1),covariance);
% if any value is outside of [-4,4], resample
while any(abs(stimulus)>4,'all')
    stimulus=mvnrnd(zeros(length(coordinates)^2,1),covariance);
end; stimulus=reshape(stimulus,size(X));

