function plot_outcomes(ndraws,outcomes,clr1,clr2)
%% PLOT_OUTCOMES  Create a figure which plots the probability of 
% choosing the image category correctly under different sampling strategies.
% 
%   ARGS:
%   ndraws                  vector containing the number of "saccades" for
%                           each experimental condition
%   outcomes                cell (1=random, 2=BAS) containing arrays with
%                           decision outcomes of each trial (0=patchy, 1=stripy)
%                               array dim 1: category (1=patchy,2=stripy)
%                               dim 2: saccade number (use ndraws to interpret)
%                               dim 3: stimulus number (1 to nstimuli)
% 
%   OPTIONAL ARGS:
%   clr1, clr2              two RGB triplets corresponding to different 
%                           sampling strategies -- clr1=random, clr2=BAS 
%                           (default: red, blue)

%%

if nargin<3, clr1=[1,0,0]; clr2=[0,0,1]; end
figure('position',[0 0 500 450]); hold on; movegui(gcf,'center');
set(gcf,'color','w','InvertHardCopy','off'); 
for strategy=1:2; if strategy==1, clr=clr1; else, clr=clr2; end
    scatter(ndraws,100*mean([squeeze(1-outcomes{strategy,1}(1,:,:)),...
        squeeze(outcomes{strategy,1}(2,:,:))],2,'omitnan'),100,...
        'markerfacecolor',clr,'markeredgecolor','k'); 
end
legend({'random sensing', 'Bayesian sensing'},'location',...
    'northoutside','orientation','horizontal'); 
xlim([min(ndraws)-5 max(ndraws)+5]); ylim([0 100]); 
ylabel('% correct'); xlabel('# samples'); legend boxoff
set(gca,'color','w','fontsize',18,'Tickdir','out','Ticklength',[.03 .03]);

