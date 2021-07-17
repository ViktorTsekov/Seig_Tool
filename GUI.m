function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%guid
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 16-Jul-2021 18:49:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function BlockSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BlockSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlockSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of BlockSizeEdit as a double


% --- Executes during object creation, after setting all properties.
function BlockSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlockSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MatrixSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MatrixSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MatrixSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of MatrixSizeEdit as a double


% --- Executes during object creation, after setting all properties.
function MatrixSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MatrixSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in StructureEdit.
function StructureEdit_Callback(hObject, eventdata, handles)
% hObject    handle to StructureEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns StructureEdit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from StructureEdit


% --- Executes during object creation, after setting all properties.
function StructureEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StructureEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PerturbationsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PerturbationsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PerturbationsEdit as text
%        str2double(get(hObject,'String')) returns contents of PerturbationsEdit as a double


% --- Executes during object creation, after setting all properties.
function PerturbationsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PerturbationsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EpsilonEdit_Callback(hObject, eventdata, handles)
% hObject    handle to EpsilonEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EpsilonEdit as text
%        str2double(get(hObject,'String')) returns contents of EpsilonEdit as a double


% --- Executes during object creation, after setting all properties.
function EpsilonEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EpsilonEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SymmetricityEdit.
function SymmetricityEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SymmetricityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SymmetricityEdit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SymmetricityEdit


% --- Executes during object creation, after setting all properties.
function SymmetricityEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SymmetricityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in GoButton.
function GoButton_Callback(hObject, eventdata, handles)
    % Take input
    blockSize = get(handles.BlockSizeEdit, 'String');
    matrixSize = get(handles.MatrixSizeEdit, 'String');
    numberOfPerturbations = get(handles.PerturbationsEdit, 'String');
    epsilon = get(handles.EpsilonEdit, 'String');
    retainMatrix = get(handles.RetainMatrix, 'Value');
    isSymmetric = 0;
    isDefault = 0;

    structureContents = get(handles.StructureEdit,'String'); 
    structure = structureContents{get(handles.StructureEdit,'Value')};
    
    symmetricityContents = get(handles.SymmetricityEdit,'String'); 
    symmetricity = symmetricityContents{get(handles.SymmetricityEdit,'Value')};
    
    matrixTypeContents = get(handles.MatrixTypeEdit,'String'); 
    matrixType = matrixTypeContents{get(handles.MatrixTypeEdit,'Value')};
    
    % Sanitize input
    if(isempty(blockSize) || isnan(str2double(blockSize)))
        msgbox('Invalid Input Provided');
        return
    elseif(isempty(matrixSize) || isnan(str2double(matrixSize)))
        msgbox('Invalid Input Provided');
        return
    elseif(isempty(numberOfPerturbations) || isnan(str2double(numberOfPerturbations)))
        msgbox('Invalid Input Provided');
        return
    elseif(isempty(epsilon) || isnan(str2double(epsilon)))
        msgbox('Invalid Input Provided');
        return
    end
    
    blockSize = uint8(str2double(blockSize));
    matrixSize = uint8(str2double(matrixSize));
    numberOfPerturbations = uint8(str2double(numberOfPerturbations));
    epsilon = str2double(epsilon);
    
    % Calculate based on the given parameters
    if(strcmp(symmetricity, 'Symmetric') == 1)
        isSymmetric = 1;
    end
    
    if(strcmp(matrixType, 'None') == 1)
        return
    elseif(strcmp(matrixType, 'Default') == 1)
        isDefault = 1;
    end
    
    if(strcmp(structure, 'Unstructured') == 1)
        unstructured_pseudospectra(matrixSize, numberOfPerturbations, epsilon, isDefault, retainMatrix);
    elseif(strcmp(structure, 'Block Toeplitz') == 1)
        block_toeplitz_pseudospectra(blockSize, matrixSize, numberOfPerturbations, epsilon, isSymmetric, isDefault, retainMatrix, 0);
    elseif(strcmp(structure, 'Block Hankel') == 1)
        block_toeplitz_pseudospectra(blockSize, matrixSize, numberOfPerturbations, epsilon, isSymmetric, isDefault, retainMatrix, 1);
    end
    
    
    
% hObject    handle to GoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in MatrixTypeEdit.
function MatrixTypeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MatrixTypeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MatrixTypeEdit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MatrixTypeEdit


% --- Executes during object creation, after setting all properties.
function MatrixTypeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MatrixTypeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearPlotButton.
function ClearPlotButton_Callback(hObject, eventdata, handles)
    cla reset;
    A = [];
    save('matrixA.mat', 'A');
% hObject    handle to ClearPlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RetainMatrix.
function RetainMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to RetainMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RetainMatrix
