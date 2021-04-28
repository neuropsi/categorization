function [p_patchy,likelihoods]=update_posterior(stimulus,locs,noise,lambdas)
%% UPDATE_POSTERIOR  Use the pixel values of image locations revealed thus 
% far to update the posterior distribution over categories.
% 
%   ARG:
%   stimulus                pixel values (NxN matrix)
%   locs                    unrolled indices corresponding to pixel locations
%   OPTIONAL ARS:
%   noise                   participant's perceptual noise (default=0.17)
%   lambdas                 hyperparameters corresponding to the Gaussian
%                           process from which stimulus values were drawn
%                           rows are categories: 1=horiz. stripy, 2=patchy,
%                           3=vert. stripy; col 1=lambda_horiz,
%                           col2=lambda_vert
% 
%   OUTPUT:
%   p_patchy                p(category=patchy|data) -- compute p(stripy)
%                           outside of this function by taking 1-p(patchy)
%   likelihoods             p(data|lambdas)

%% Process inputs

if nargin<4
    % patchy=(2,:), horizontal stripy=(1,:), vertical stripy=(3,:)
    lambdas=[4.63,0.91;1.39,1.39;0.91,4.63];
    if nargin<3, noise=0.17; end
end
image_size=size(stimulus,1); stimulus=stimulus(:); likelihoods=nan(3,1);
locs(isnan(locs))=[];

%% Compute likelihoods P(data|category) and posterior P(category|data)

% generate arrays of evenly spaced coordinates for image rows and columns
coordinates=-floor(image_size/2):floor(image_size/2);
[X,Y]=meshgrid(coordinates); X=X(:); Y=Y(:);
% compute likelihoods
for category=-1:1, cat=category+2;
    covariance=exp(-0.5*((1/lambdas(cat,1)^2)*(X(locs)-X(locs)').^2+...
        (1/lambdas(cat,2)^2)*(Y(locs)-Y(locs)').^2));
    likelihoods(cat)=mvnpdf(stimulus(locs),0,covariance+(noise^2)*eye(length(locs)));
end
% compute posterior
p_patchy=likelihoods(2)/(likelihoods(2)+0.5*likelihoods(1)+0.5*likelihoods(3));

