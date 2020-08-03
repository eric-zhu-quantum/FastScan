%usage:
%       [Traces, NumTraces] = func_ExtractTracesFromFig(fig)
%
%
% 'fig' can either be a figure handle or filename
%
%
%%Example #1:
% figname = 'Vpp=2.9V,5MHz,x=12.50,z=6.00,Trace1.fig';
% 
% [Traces, NumTraces] = func_ExtractTracesFromFig(figname)
% 
% figure, plot(Traces(1).XData, Traces(1).YData, Traces(2).XData, Traces(2).YData)
% 
% 
% %Another Example:
% 
% figure; newfig = gcf;
% x = -5:0.01:5;
% y = 25*exp(-x.^2./3.^2);
% plot(gca, x,y);
% 
% [Traces, NumTraces] = func_ExtractTracesFromFig(newfig)
% 
% figure, plot(Traces.XData, Traces.YData)
%
function [Traces, NumTraces] = func_ExtractTracesFromFig(fig)

    if (length(fig)==1) % just a figure handle
        thefigure = fig;
    else   %a filename
        thefigure = openfig(fig);
    end

    
    axes = get(thefigure, 'CurrentAxes');

    Axes = get(axes, 'child')

    Traces = [];
    for k = 1:length(Axes)
        Traces(k).XData = get(Axes(k), 'XData');
        Traces(k).YData = get(Axes(k), 'YData');    
    end

    if length(fig)>1
        close(thefigure);
    end
    
    NumTraces = length(Traces);
    
end