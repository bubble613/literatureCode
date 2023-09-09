function InitAxes(handles)

clc;

axes(handles.axes1); cla reset;
set(handles.axes1, 'XTick', [], 'YTick', [], ...
    'XTickLabel', '', 'YTickLabel', '', 'Color', [0.7020 0.7804 1.0000], 'Box', 'On');
axes(handles.axes2); cla reset;
set(handles.axes2, 'XTick', [], 'YTick', [], ...
    'XTickLabel', '', 'YTickLabel', '', 'Color', [0.7020 0.7804 1.0000], 'Box', 'On');