%% Bayesian Active Sensing -- modeled after Yang, Lengyel, Wolpert 2016
% Bayesian Modeling of Behavior (Spring 2021)

%% Generate stimuli

image_size=10; nstimuli=2; clr1=[230,195,99]/255; clr2=[165,47,245]/255;
stimulus=cell(nstimuli,3); d=datestr(now,'yyyymmddhhMM');
for category=-1:1, pause(1); close all; for stim=1:nstimuli
    stimulus{stim,category+2}=generate_stimulus(category,image_size,clr1,clr2);
shg; end; end
save(['C:\Users\lt1686\Documents\GitHub\categorization\stimulus_',d,'.mat'],...
    'stimulus','-v7.3')

%% 