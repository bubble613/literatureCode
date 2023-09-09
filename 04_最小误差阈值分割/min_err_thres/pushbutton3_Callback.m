% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.bw_direct, 0)
    return;
end
% 圈选胃区域空气

bw_poly = roipoly(handles.bw_direct, c, r);
axes(handles.axes2);
imshow(handles.I, []);
hold on;
plot(c, r, 'r-', 'LineWidth', 2);
hold off;
title('胃区域空气选择');
handles.bw_poly = bw_poly;
guidata(hObject, handles);
