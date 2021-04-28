function next_sample=bayes_active_sense(stimulus,locs,likelihoods,p_patchy,noise,lambdas)
%% BAYES_ACTIVE_SENSE  Choose another image location to reveal based upon the 
% pixel values of what has been revealed so far, using Bayesian statistics.
% Compute a score for each image location and maximize this score.
% 
%   ARGS:
%   stimulus                pixel values (NxN matrix)
%   locs                    unrolled indices corresponding to pixel locations
%   likelihoods             p(data|lambdas)
%   p_patchy                p(category=patchy|data)
%   OPTIONAL ARGS:
%   noise                   participant's perceptual noise (default=0.17)
%   lambdas                 hyperparameters corresponding to the Gaussian
%                           process from which stimulus values were drawn
%                           rows are categories: 1=horiz. stripy, 2=patchy,
%                           3=vert. stripy; col 1=lambda_horiz,
%                           col2=lambda_vert
% 
%   OUTPUT:
%   next_sample             unrolled index of next location to sample

%% Process inputs

if nargin<6
    % patchy=(2,:), horiz. stripy=(1,:), vert. stripy=(3,:)
    lambdas=[4.63,0.91;1.39,1.39;0.91,4.63];
    if nargin<5, noise=0.17; end
end
image_size=size(stimulus,1); stimulus=stimulus(:); z=-4:0.1:4;
pre_predictives=nan(length(stimulus),length(z),3); locs(isnan(locs))=[];
predictives=nan(length(stimulus),length(z),2);

%% Compute pre-predictive distributions P(z*|x*,lambdas,D)

% generate arrays of evenly spaced coordinates for image rows and columns
coordinates=-floor(image_size/2):floor(image_size/2);
[X,Y]=meshgrid(coordinates); X=X(:); Y=Y(:);
for category=-1:1, cat=category+2; 
    for loc=1:length(stimulus)
        % compute covariance functions
        covariance_A=exp(-0.5*((1/lambdas(cat,1)^2)*(X(locs)'-X(loc)).^2+...
            (1/lambdas(cat,2)^2)*(Y(locs)'-Y(loc)).^2));
        covariance_B=exp(-0.5*((1/lambdas(cat,1)^2)*(X(locs)-X(locs)').^2+...
            (1/lambdas(cat,2)^2)*(Y(locs)-Y(locs)').^2));
        covariance_C=exp(-0.5*((1/lambdas(cat,1)^2)*(X(loc)-X(loc)).^2+...
            (1/lambdas(cat,2)^2)*(Y(loc)-Y(loc)).^2));
        covariance_D=exp(-0.5*((1/lambdas(cat,1)^2)*(X(loc)-X(locs)).^2+...
            (1/lambdas(cat,2)^2)*(Y(loc)-Y(locs)).^2));
        % compute pre-predictives: 
        pre_predictives(loc,:,cat)=normpdf(z,covariance_A*...
            ((covariance_B+noise^2*eye(length(locs)))\stimulus(locs)),...
            covariance_C-covariance_A*((covariance_B+noise^2*...
            eye(length(locs)))\covariance_D)+noise^2);
    end
end

%% Compute predictives P(z*|x*,c,D)

predictives(:,:,1)=pre_predictives(:,:,2); % patchy
predictives(:,:,2)=(likelihoods(1)/(likelihoods(1)+likelihoods(3)))*...
    pre_predictives(:,:,1)+(likelihoods(3)/(likelihoods(1)+likelihoods(3)))*...
    pre_predictives(:,:,3);

%% Compute entropies H(z*|x*,D) and H(z*|x*,c,D)

% compute category non-specific entropy
expected_predictive=p_patchy*predictives(:,:,1)+(1-p_patchy)*predictives(:,:,2);
entropy=sum(expected_predictive.*log(expected_predictive),2,'omitnan');
% compute category-specific entropies and take weighted sum
entropy_patchy=sum(predictives(:,:,1).*log(predictives(:,:,1)),2,'omitnan');
entropy_stripy=sum(predictives(:,:,2).*log(predictives(:,:,2)),2,'omitnan');
expected_entropy=p_patchy*entropy_patchy+(1-p_patchy)*entropy_stripy;

%% Compute score and take next sample

score=entropy-expected_entropy; [~,next_sample]=min(score,[],'omitnan');
