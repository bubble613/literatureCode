clc;clear;

function varargout = MainForm(varargin)
% MAINFORM MATLAB code for MainForm.fig
%      MAINFORM, by itself, creates a new MAINFORM or raises the existing
%      singleton*.
%
%      H = MAINFORM returns the handle to a new MAINFORM or the handle to
%      the existing singleton*.
%
%      MAINFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINFORM.M with the given input arguments.
%
%      MAINFORM('Property','Value',...) creates a new MAINFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainForm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainForm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainForm

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct(...
    'gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MainForm_OpeningFcn, ...
    'gui_OutputFcn',  @MainForm_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
% End initialization code - DO NOT EDIT
end


function InitAxes(handles)
clc;
axes(handles.axes1); 
cla reset;
set(handles.axes1, 'XTick', [], 'YTick', [], ...
    'XTickLabel', '', 'YTickLabel', '', 'Color', ...
    [0.7020 0.7804 1.0000], 'Box', 'On');
axes(handles.axes2);
cla reset;
set(handles.axes2, 'XTick', [], 'YTick', [], ...
    'XTickLabel', '', 'YTickLabel', '', 'Color', ...
    [0.7020 0.7804 1.0000], 'Box', 'On');
end

function filePath = OpenFile(imgfilePath)
% 打开文件
% 输出参数：
% filePath——文件路径

if nargin < 1
    imgfilePath = fullfile(pwd, 'hehua.jpeg');
end

[filename, pathname, ~] = uigetfile( ...
    { '*.jpg','All jpg Files';...
    '*.png','All png Files';...
    '*.*',  '所有文件 (*.*)'}, ...
    '选择文件', ...
    'MultiSelect', 'off', ...
    imgfilePath);

filePath = 0;

if isequal(filename, 0) || isequal(pathname, 0)
    return;
end

filePath = fullfile(pathname, filename);
end


% --- Executes just before MainForm is made visible.
function MainForm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainForm (see VARARGIN)

% Choose default command line output for MainForm
handles.output = hObject;
InitAxes(handles);
handles.I = 0;
handles.J = 0;
handles.bw_direct = 0;
handles.bw_poly = 0;
handles.bw__kittler = 0;
handles.bw_temp = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainForm wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = MainForm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


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
end


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
end



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
end


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
    end



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
end