% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.JE, 0)
    return;
end
J = handles.JE;
% 直方图统计
[counts, gray_style] = imhist(J);
% 亮度级别
gray_level = length(gray_style);
% 计算各灰度概率
gray_probability  = counts ./ sum(counts);
% 统计像素均值
gray_mean = gray_style' * gray_probability;
% 初始化

gray_vector(1) = realmax;
ks = gray_level-1;
for k = 1 : ks
    % 迭代计算
   
    % 判断是否收敛
    if (w < eps) || (w > 1-eps)
        gray_vector(k+1) = realmax;
    else
        % 计算均值
        mean_k1 = mean_k / w;
        mean_k2 = (gray_mean-mean_k) / (1-w);
        % 计算方差
    end
end

        
End