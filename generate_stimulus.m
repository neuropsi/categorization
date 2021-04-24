function stimulus=generate_stimulus(category,image_size,clr1,clr2,lambda_h,lambda_v)
%% GENRATE_STIMULUS  Create an image where pixel values are sampled from a 
% 2D Gaussian process with covariance function determined by the specified
% hyperparameters (lambdas). The image category is either patchy or stripy;
% stripes can be vertical or horizontal. Plot and save the image.
% 
%   ARG:
%   category                0=patchy (cheetah), -1=stripy (zebra), vertical
%                           1=stripy (zebra), horizontal
%   OPTIONAL ARGS:
%   image_size              N, where the image will consist of NxN pixels
%                           in resolution (default: N=110)
%   clr1, clr2              two RGB triplets corresponding to opposite ends of
%                           the image color spectrum (default: red, blue)
%   lambda_h, lambda_v      horizontal and vertical hyperparameters of 
%                           covariance function (defaults: see Methods of 
%                           Yang et. al.)
% 
%   OUTPUT:
%   stimulus                

%% Process inputs/pre-allocate

if nargin~=6
    if category==0, lambda_h=1.39; lambda_v=1.39;
    elseif category==-1, lambda_h=4.63; lambda_v=0.91;
    elseif category==1, lambda_h=0.91; lambda_v=4.63;
    end
    if nargin<4, clr1=[1,0,0]; clr2=[0,0,1]; end
    if nargin==1, image_size=110; end
end

%% Draw an image from a 2D Gaussian process

% generate arrays of evenly spaced coordinates for image rows and columns
coordinates=-round(image_size/2):round(image_size/2);
[X,Y]=meshgrid(coordinates); pixels=[X(:),Y(:)];
% compute the covariance function
covariance=exp(-0.5*((1/lambda_h^2)*(X(:)-X(:)').^2+(1/lambda_v^2)*(Y(:)-Y(:)').^2));
% draw from the multivariate normal and reshape into an image
stimulus=mvnrnd(zeros(length(coordinates)^2,1),covariance);
stimulus=reshape(stimulus,size(X));

%% Create the stimulus image

figure; imagesc(stimulus); colorbar; axis equal

