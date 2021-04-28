function plot_stimulus(stimulus,clr1,clr2)
%% PLOT_STIMULUS  Create a figure which depicts the pixel intensities for an 
% image through the use of a colormap.
% 
%   ARG:
%   stimulus                pixel values (NxN matrix)
%   OPTIONAL ARGS:
%   clr1, clr2              two RGB triplets corresponding to opposite ends of
%                           the image color spectrum (default: red, blue)

%%

if nargin<3, clr1=[1,0,0]; clr2=[0,0,1]; end
figure; imagesc(stimulus); cmap=[linspace(clr1(1),clr2(1),256);...
    linspace(clr1(2),clr2(2),256);linspace(clr1(3),clr2(3),256)]';
set(gca,'color','w','fontsize',18,'Tickdir','out','Ticklength',[.03 .03],...
    'XColor','none','YColor','none'); colormap(cmap); box off
set(gcf,'color','w','InvertHardCopy','off'); axis equal; 

