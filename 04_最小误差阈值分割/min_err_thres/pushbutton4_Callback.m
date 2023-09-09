% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.bw_poly, 0)
    return;
end
% 图像归一化
IE = mat2gray(handles.I);
% 对比度增强
IE = imadjust(IE, [0.532 0.72], [0 1]);
IE = im2uint8(mat2gray(IE));
I = im2uint8(mat2gray(handles.I));
% 显示
axes(handles.axes2);
imshow(IE, []);
title('图像增强');
figure;
subplot(2, 2, 1); imshow(I); title('原图像');
subplot(2, 2, 2); imshow(IE); title('增强图像');
subplot(2, 2, 3); imhist(I); title('原图像直方图');
subplot(2, 2, 4); imhist(IE); title('增强图像直方图');
JE = IE;
JE(handles.bw_poly) = 255;
handles.JE = JE;
guidata(hObject, handles);