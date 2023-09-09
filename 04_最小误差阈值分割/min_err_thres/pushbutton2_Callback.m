% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.I, 0)
    return;
end
% 直接二值化
bw_direct = im2bw(handles.I, graythresh(handles.I));
axes(handles.axes2);
imshow(bw_direct, []);
title('直接二值化分割');
handles.bw_direct = bw_direct;
guidata(hObject, handles);