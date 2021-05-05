%% Bayesian Active Sensing -- modeled after Yang, Lengyel, Wolpert 2016
% Bayesian Modeling of Behavior (Spring 2021)

%% Parameters

%   image_size              N, where the image will consist of NxN pixels
%                           in resolution
%   nstimuli                number of trials for each category (on each trial, 
%                           a new stimulus is generated) -- the number of 
%                           horizontal and vertical stripy trials will each
%                           be equal to nstimuli/2
%   ndraws                  vector containing the number of "saccades" for
%                           each experimental condition -- this could be a
%                           range, such as 5,10,15,20,25

%% Functions

% EXPERIMENT  Run an experiment where a number of stimuli with the specified
% dimensions will be generated, and a number of pixel locations will be
% sampled for the purpose of guessing the category of the image. The
% posterior distribution over categories will be continuously updated to
% inform sensing (Bayesian Active Sensor) and choice (Ideal Observer).
    % GENRATE_STIMULUS  Create an image where pixel values are sampled from a 
    % 2D Gaussian process with covariance function determined by the specified
    % hyperparameters (lambdas). The image category is either patchy or stripy;
    % stripes can be vertical or horizontal. Plot and save the image.
    % RAND_DRAW  Draw samples from an image according to an isotropic Gaussian 
    % distribution centered at (0,0) with a given SD. 
    % BAYES_ACTIVE_SENSE  Choose another image location to reveal based upon the 
    % pixel values of what has been revealed so far, using Bayesian statistics.
    % Compute a score for each image location and maximize this score.
    % UPDATE_POSTERIOR  Use the pixel values of image locations revealed thus 
    % far to update the posterior distribution over categories.
% PLOT_STIMULUS  Create a figure which depicts the pixel intensities for an 
% image through the use of a colormap.
% PLOT_SAMPLES  Create a figure which shows the values and locations of the
% visual samples drawn.
% PLOT_OUTCOMES  Create a figure which plots the probability of 
% choosing the image category correctly under different sampling strategies.
% PLOT_SPECIFIC_OUTCOMES  Create a figure which plots the probability of 
% choosing stripy when the true image was patchy or stripy, under a
% specific sampling strategy (implied by the input).


%% Outputs

%   stimuli                 cell array with pixel values for all stimuli
%                           generated in the experiment
%                               dim 1: category (1=patchy,2=stripy)
%                               dim 2: saccade number (e.g. 1 = 5 saccades,
%                               2 = 10 saccades, ... ,5 = 25 saccades); use 
%                               the ndraws vector to interpret
%                               dim 3: stimulus number (1 to nstimuli)
%                           each cell contains an NxN matrix of pixel values
%   samples                 cell array contiaining unrolled indices
%                           corresponding to the sampled pixels
%                               dim 1: category (1=patchy,2=stripy)
%                               dim 2: saccade number (use ndraws to interpret)
%                               dim 3: sampling strategy -- 1=random, 2=BAS
%                           each cell contains a nsamples x nstimuli matrix
%                           (e.g. if the matrix of a cell is 5x100, this
%                           matrix contains the samples for the condition
%                           where there were 5 saccades for each of 100 stimuli
%                           in that category)
%   outcomes                cell (1=random, 2=BAS) containing arrays with
%                           decision outcomes of each trial (0=patchy, 1=stripy)
%                               array dim 1: category (1=patchy,2=stripy)
%                               dim 2: saccade number (use ndraws to interpret)
%                               dim 3: stimulus number (1 to nstimuli)

%% Perform experiment and plot outcome

image_size=77; nstimuli=100; ndraws=[5:5:25]; d=datestr(now,'yyyymmddhhMM');
tic; [stimuli,samples,outcomes]=experiment(image_size,nstimuli,ndraws); toc
save(['C:\Users\lt1686\Documents\GitHub\categorization\experiment_',d,'.mat'],...
    'stimuli','samples','outcomes','-v7.3') % save experiment

clr1=[4,99,110]/255; clr2=[166,207,19]/255;
plot_outcomes(ndraws,outcomes,clr1,clr2)
saveas(gcf,['C:\Users\lt1686\Documents\GitHub\categorization\outcomes_',d,'.png'])

clr1=[230,195,99]/255; clr2=[165,47,245]/255;
plot_specific_outcomes(ndraws,outcomes{1,1},clr1,clr2)
saveas(gcf,['C:\Users\lt1686\Documents\GitHub\categorization\random_',d,'.png'])
plot_specific_outcomes(ndraws,outcomes{2,1},clr1,clr2)
saveas(gcf,['C:\Users\lt1686\Documents\GitHub\categorization\BAS_',d,'.png'])

%% Make satellite plots

c=2; draw=5; stim=49; strat=2; clr1=[252,186,3]/255; clr2=[207,78,222]/255;
plot_stimulus(stimuli{c,draw,stim},clr1,clr2)
saveas(gcf,['C:\Users\lt1686\Documents\GitHub\categorization\stimulus_',d,'.png'])
plot_samples(stimuli{c,draw,stim},samples{c,draw,strat}(:,stim),clr1,clr2)
saveas(gcf,['C:\Users\lt1686\Documents\GitHub\categorization\samples_',d,'.png'])
