function rands=rand_draw(ndraws,image_size,SD)
%% RAND_DRAW  Draw samples from an image according to an isotropic Gaussian 
% distribution centered at (0,0) with a given SD. 
% 
%   ARGS:
%   ndraws                  number of pixels to draw
%   image_size              N, where the image consists of NxN pixels
%   OPTIONAL ARG:
%   SD                      standard deviation of Gaussian (default=9.27)
%   
%   OUTPUT:
%   rands                   samples are indices of the unrolled image matrix

%% 

if nargin<3, SD=9.27; end
% generate arrays of evenly spaced coordinates for image rows and columns
coordinates=-round(image_size/2):round(image_size/2);
[X,Y]=meshgrid(coordinates); rands=nan(ndraws,1);
% compute distances of each pixel to the image center
distances=sqrt(X(:).^2+Y(:).^2);
% compute and normalize Gaussian PDF; generate CDF
probabilities=normpdf(distances,0,SD); 
probabilities=probabilities/sum(probabilities); CDF=cumsum(probabilities);
% sample pixels according to probabilities
for sample=1:ndraws, rands(sample)=find(CDF>rand(1),1,'first'); end

