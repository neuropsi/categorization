function plot_specific_outcomes(ndraws,outcomes,clr1,clr2)
%% PLOT_SPECIFIC_OUTCOMES  Create a figure which plots the probability of 
% choosing stripy when the true image was patchy or stripy, under a
% specific sampling strategy (implied by the input).
% 
%   ARGS:
%   ndraws                  vector containing the number of "saccades" for
%                           each experimental condition
%   outcomes                array with decision outcomes of each trial 
%                           (0=patchy, 1=stripy)
%                               dim 1: category (1=patchy,2=stripy)
%                               dim 2: saccade number (use ndraws to interpret)
%                               dim 3: stimulus number (1 to nstimuli)
% 
%   OPTIONAL ARGS:
%   clr1, clr2              two RGB triplets corresponding to different 
%                           true stimulus categories -- clr1=patchy,
%                           clr2=stripy (default: red, blue)

%%

if nargin<3, clr1=[1,0,0]; clr2=[0,0,1]; end
figure('position',[0 0 500 450]); hold on; movegui(gcf,'center');
set(gcf,'color','w','InvertHardCopy','off'); 
for c=1:2; if c==1, clr=clr1; else, clr=clr2; end
    scatter(ndraws,mean(squeeze(outcomes(c,:,:)),2,'omitnan'),100,...
        'markerfacecolor',clr,'markeredgecolor','k'); 
end
legend({'image = patchy', 'image = stripy'},'location','northoutside',...
    'orientation','horizontal'); 
xlim([min(ndraws)-5 max(ndraws)+5]); ylim([0 1]); legend boxoff
ylabel('choose patchy <--> choose stripy'); xlabel('# samples')
set(gca,'color','w','fontsize',18,'Tickdir','out','Ticklength',[.03 .03]);

