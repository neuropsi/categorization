%% Bayesian Active Sensing -- modeled after Yang, Lengyel, Wolpert 2016
% Bayesian Modeling of Behavior (Spring 2021)

%% Generate stimuli

image_size=100; nstimuli=1; clr1=[230,195,99]/255; clr2=[165,47,245]/255;
stimulus=cell(nstimuli,3); d=datestr(now,'yyyymmddhhMM');
for category=-1:1, pause(1); close all; for stim=1:nstimuli
    stimulus{stim,category+2}=generate_stimulus(category,image_size,clr1,clr2);
shg; end; end
save(['C:\Users\lt1686\Documents\GitHub\categorization\stimulus_',d,'.mat'],...
    'stimulus','-v7.3')

%% Draw pixels (this is actually just work in progress)

ndraws=200; if mod(image_size,2)==0; pad=1; else, pad=0; end
rands=rand_draw(ndraws,image_size); 
[rows,cols]=ind2sub([image_size+pad,image_size+pad],rands);

% Put this as a separate function for imaging samples
samples=nan(image_size+pad);
for draw=1:ndraws
    samples(rows(draw),cols(draw))=stimulus{1,1}(rows(draw),cols(draw));
end
figure; p=pcolor(samples); cmap=[linspace(clr1(1),clr2(1),256);...
    linspace(clr1(2),clr2(2),256);linspace(clr1(3),clr2(3),256)]';
set(gca,'color','w','fontsize',18,'Tickdir','out','Ticklength',[.03 .03],...
    'XColor','none','YColor','none'); colormap(cmap); 
set(gcf,'color','w','InvertHardCopy','off'); axis equal; 
hold on; xline(image_size+pad,'color','k'); set(p,'EdgeColor','none')
xline(0,'color','k'); yline(0,'color','k'); yline(image_size+pad,'color','k')
xlim([-1 image_size+pad+1]); ylim([-1 image_size+pad+1]); 