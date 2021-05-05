function [stimuli,samples,outcomes]=experiment(image_size,nstimuli,ndraws)
%% EXPERIMENT  Run an experiment where a number of stimuli with the specified
% dimensions will be generated, and a number of pixel locations will be
% sampled for the purpose of guessing the category of the image. The
% posterior distribution over categories will be continuously updated to
% inform sensing (Bayesian Active Sensor) and choice (Ideal Observer).
% 
%   ARGS:
%   image_size              N, where the image will consist of NxN pixels
%                           in resolution
%   nstimuli                number of trials for each category (on each trial, 
%                           a new stimulus is generated) -- the number of 
%                           horizontal and vertical stripy trials will each
%                           be equal to nstimuli/2
%   ndraws                  vector containing the number of "saccades" for
%                           each experimental condition -- this could be a
%                           range, such as 5,10,15,20,25
% 
%   OUTPUTS:
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

%%

% pre-allocate
stimuli=cell(2,length(ndraws),nstimuli); 
samples=cell(2,length(ndraws),2); outcomes=cell(2,1); 
for strategy=1:2, outcomes{strategy,1}=nan(2,length(ndraws),nstimuli); end

for category=-1:1
    if category~=0, nstim=floor(nstimuli/2); c=2; C='stripy';
    else, nstim=nstimuli; c=1; C='patchy'; end
    for draw=1:length(ndraws)
        % display experiment progress, as experiments might be lengthy
        progress=(length(ndraws)*(category+1)+draw)*100/(3*length(ndraws));
        disp(['(',num2str(progress),'%) simulating ',C,' category, ',...
            num2str(ndraws(draw)),' draws']);
        % pre-allocate for each sampling strategy
        if category~=1, for strategy=1:2
            samples{c,draw,strategy}=nan(ndraws(draw),nstimuli); end; end
        for stim=1:nstim, if category==1, s=stim+nstim; else, s=stim; end
            % [1] generate the stimulus
            stimuli{c,draw,s}=generate_stimulus(category,image_size);
            % [2] draw random samples, update the posterior, and determine
            % the outcome
            samples{c,draw,1}(:,s)=rand_draw(ndraws(draw),image_size); 
            [p_patchy,~]=update_posterior(stimuli{c,draw,s},samples{c,draw,1}(:,s));
            if p_patchy>0.5, outcomes{1,1}(c,draw,s)=0; else, outcomes{1,1}(c,draw,s)=1; end
            % [3] perform Bayesian active sensing
            samples{c,draw,2}(1,s)=rand_draw(1,image_size);
            [p_patchy,likelihoods]=update_posterior(stimuli{c,draw,s},samples{c,draw,2}(1,s));
            for saccade=2:ndraws(draw)
                samples{c,draw,2}(saccade,s)=bayes_active_sense(stimuli{c,draw,s},...
                    samples{c,draw,2}(:,s),likelihoods,p_patchy);
                [p_patchy,likelihoods]=update_posterior(stimuli{c,draw,s},...
                    samples{c,draw,2}(:,s));
            end
            if p_patchy>0.5, outcomes{2,1}(c,draw,s)=0; else, outcomes{2,1}(c,draw,s)=1; end
        end
    end
end

