%% Bayesian Active Sensing -- modeled after Yang, Lengyel, Wolpert 2016
% Bayesian Modeling of Behavior (Spring 2021)
% DOCUMENT EACH OF THE VARIABLES HERE

%% Perform multiple experiments in parallel and plot outcomes

image_size=110; nstimuli=50; ndraws=[5:5:25]; d=datestr(now,'yyyymmddhhMM');
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
% CHOOSE WHAT STIMULUS? ETC. AND ONLY INCLUDE THOSE WHICH ARE GOING TO GO
% ONTO THE PAPER/POWERPOINT

plot_stimulus(stimulus,clr1,clr2)
saveas(gcf,['C:\Users\lt1686\Documents\GitHub\categorization\stimulus_',d,'.png'])
plot_samples(stimulus{1,1},rands,clr1,clr2)
saveas(gcf,['C:\Users\lt1686\Documents\GitHub\categorization\samples_',d,'.png'])