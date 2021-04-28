function plot_samples(stimulus,locs,clr1,clr2)
%% PLOT_SAMPLES  Create a figure which shows the values and locations of the
% visual samples drawn.
% 
%   ARGS:
%   stimulus                pixel values (NxN matrix)
%   locs                    unrolled indices corresponding to pixel locations
%   OPTIONAL ARGS:
%   clr1, clr2              two RGB triplets corresponding to opposite ends of
%                           the image color spectrum (default: red, blue)

%% Process inputs

if nargin<4, clr1=[1,0,0]; clr2=[0,0,1]; end
image_size=size(stimulus,1); samples=nan(size(stimulus));
[rows,cols]=ind2sub([image_size,image_size],locs);
% obtain the pixel intensities of the samples
for draw=1:length(locs)
    samples(rows(draw),cols(draw))=stimulus(rows(draw),cols(draw));
end

%% Create/save the stimulus image

figure; p=pcolor(samples); cmap=[linspace(clr1(1),clr2(1),256);...
    linspace(clr1(2),clr2(2),256);linspace(clr1(3),clr2(3),256)]';
set(gca,'color','w','fontsize',18,'Tickdir','out','Ticklength',[.03 .03],...
    'XColor','none','YColor','none'); colormap(cmap); 
set(gcf,'color','w','InvertHardCopy','off'); axis equal; 
hold on; xline(image_size,'color','k'); set(p,'EdgeColor','none')
xline(0,'color','k'); yline(0,'color','k'); yline(image_size,'color','k')
xlim([-1 image_size+1]); ylim([-1 image_size+1]); 

