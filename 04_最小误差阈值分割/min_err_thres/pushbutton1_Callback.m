% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filePath = OpenFile();
if isequal(filePath, 0)
    return;
end
Img = imread(filePath);
% 灰度化
if ndims(Img) == 3
    I = rgb2gray(Img);
else
    I = Img;
end
axes(handles.axes1);
imshow(I, []);
title('原图像');
handles.I = I;
guidata(hObject, handles);