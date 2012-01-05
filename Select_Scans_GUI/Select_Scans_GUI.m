function varargout = Select_Scans_GUI(varargin)
%SELECT_SCANS_GUI M-file for Select_Scans_GUI.fig
%      SELECT_SCANS_GUI, by itself, creates a new SELECT_SCANS_GUI or raises the existing
%      singleton*.
%
%      H = SELECT_SCANS_GUI returns the handle to a new SELECT_SCANS_GUI or the handle to
%      the existing singleton*.
%
%      SELECT_SCANS_GUI('Property','Value',...) creates a new SELECT_SCANS_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Select_Scans_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SELECT_SCANS_GUI('CALLBACK') and SELECT_SCANS_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SELECT_SCANS_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Select_Scans_GUI

% Last Modified by GUIDE v2.5 06-Nov-2011 22:00:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Select_Scans_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Select_Scans_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Select_Scans_GUI is made visible.
function Select_Scans_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Check that the handle to the main Parent_GUI was passed
if length(varargin) < 1 || ~ishandle(varargin{1})
	disp(sprintf('%s: must pass a handle to the main Select Scans GUI as the first argument.', mfilename));
	close(hObject);
	return;
end

% Choose default command line output for Select_Scans_GUI
handles.output = hObject;

% Add Parent_GUI handle to handles struct for this GUI
handles.Parent_GUI = varargin{1};

% Set the Tag for this GUI and prefix with the parent GUI name to enable easy deletion
set_tag_for_GUI_child(hObject, handles.Parent_GUI, 'Select Scans GUI');

% Set the study dir button text and the study format popupmenu strings
select_study_dir_button_text = getappdata(handles.Parent_GUI, 'select_study_dir_button_text');
study_format_popupmenu_strings = getappdata(handles.Parent_GUI, 'study_format_popupmenu_strings');

if isempty(select_study_dir_button_text) || isempty(study_format_popupmenu_strings)
	disp(sprintf('%s: cannot render GUI - missing field(s) select_study_dir_button_text and/or study_format_popupmenu_strings', mfilename));
	return;
else
	set(handles.select_study_dir_button, 'String', select_study_dir_button_text);
	set(handles.study_format_popupmenu, 'String', study_format_popupmenu_strings);
end

% Initialise GUI fields
handles = Select_Scans_GUI_initialisation(handles);

% Set the figure window close request function
set(hObject, 'CloseRequestFcn', {@cancel_pushbutton_Callback, handles});

% Position GUI:
% First get Top Left Hand Corner (TLHC)
[TLHC_x, TLHC_y] = get_TLHC_for_next_GUI(handles.Parent_GUI);

set(hObject, 'Units', 'normalized');
position_vec = get(hObject, 'Position');
position_vec(1:2) = [TLHC_x (TLHC_y - position_vec(4))];
set(hObject, 'Position', position_vec);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Select_Scans_GUI wait for user response (see UIRESUME)
% uiwait(handles.Select_Scans_GUI);


% --- Outputs from this function are returned to the command line.
function varargout = Select_Scans_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

if ~isempty(handles)
	varargout{1} = handles.output;
end


% --- Executes on button press in select_study_dir_button.
function select_study_dir_button_Callback(hObject, eventdata, handles)
% hObject    handle to select_study_dir_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open a directory selection dialog box
handles.study_dir = uigetdir(handles.study_dir);

% Proceed if the user didn't press cancel
if handles.study_dir
	% Update the text field showing the current study dir
	set(handles.study_dir_text_field, 'String', handles.study_dir);
	
	% Enable the study format popupmenu
	set(handles.study_format_popupmenu, 'Enable', 'on');

	% Update GUI figure with the latest handles struct
	guidata(handles.Select_Scans_GUI, handles);
		
	% Finally update the rest of the GUI based on the current study format popupmenu selection
	study_format_popupmenu_Callback(handles.study_format_popupmenu, [], handles);
end


% --- Executes on selection change in study_format_popupmenu.
function study_format_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to study_format_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns study_format_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from study_format_popupmenu

% See which study format is currently selected
study_format_options = cellstr(get(hObject,'String'));
scan_dir_depths = cellfun(@(study_format_string) length(strfind(study_format_string, filesep))-1, study_format_options);

handles.study_format_selection_idx = get(hObject,'Value');
handles.scan_dir_depth = scan_dir_depths(handles.study_format_selection_idx);

% Now get the absolute and relative scan paths for this study dir to the required dir depth
handles.absolute_scan_dirpaths = get_recursive_dirlist(handles.study_dir, handles.scan_dir_depth);
handles.relative_scan_dirpaths = strrep(handles.absolute_scan_dirpaths, strcat(handles.study_dir, filesep), '');

if handles.scan_dir_depth > 0
	% Create or update an existing scan selection listbox
	if isfield(handles, 'scans_listbox') && ishandle(handles.scans_listbox)
		set(handles.scans_listbox, 'String', handles.relative_scan_dirpaths, 'Value', [], 'ListboxTop', 1);
	else
		handles.scans_listbox = Create_Listbox_Selection_UI(handles.scan_selection_panel, handles.relative_scan_dirpaths);
	end
else
	% Delete any existing UIs from the scan selection panel
	delete(get(handles.scan_selection_panel, 'Children'));
end

% Activate/Deactivate Done button
if handles.scan_dir_depth >= 0
	set(handles.done_pushbutton, 'Enable', 'on');
else
	set(handles.done_pushbutton, 'Enable', 'off');
end

% Update GUI figure with the latest handles struct
guidata(handles.Select_Scans_GUI, handles);


% --- Executes during object creation, after setting all properties.
function study_format_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to study_format_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
	

% --- Executes on button press in done_pushbutton.
function done_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to done_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isdir(handles.study_dir)
	% Save study dir scan directory listing and study format
	setappdata(handles.Parent_GUI, 'study_dir', handles.study_dir);
	
	setappdata(handles.Parent_GUI, 'study_format_selection_idx', handles.study_format_selection_idx);
	setappdata(handles.Parent_GUI, 'scan_dir_depth', handles.scan_dir_depth);
	
	% Get the scan selections
	if handles.scan_dir_depth > 0	
		selected_scan_dirs_idx = get(handles.scans_listbox, 'Value');		
	else
		handles.absolute_scan_dirpaths = {handles.study_dir};
		handles.relative_scan_dirpaths = '.';
		selected_scan_dirs_idx = 1;
	end

	% Save scan dirpaths and selected scans idx
	setappdata(handles.Parent_GUI, 'absolute_scan_dirpaths', handles.absolute_scan_dirpaths);
	setappdata(handles.Parent_GUI, 'relative_scan_dirpaths', handles.relative_scan_dirpaths);
	setappdata(handles.Parent_GUI, 'selected_scan_dirs_idx', selected_scan_dirs_idx);
	
	% Clear any pre-existing series selections
	setappdata(handles.Parent_GUI, 'absolute_series_dirpaths', []);
	setappdata(handles.Parent_GUI, 'annotated_series_dirpaths', []);
	setappdata(handles.Parent_GUI, 'selected_series_dirs_idx', []);
end

update_buttons_function_handle = getappdata(handles.Parent_GUI, 'update_buttons_function_handle');
update_buttons_function_handle(handles.Parent_GUI);
close(handles.Select_Scans_GUI);


% --- Executes on button press in cancel_pushbutton.
function cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_buttons_function_handle = getappdata(handles.Parent_GUI, 'update_buttons_function_handle');
update_buttons_function_handle(handles.Parent_GUI);
delete(handles.Select_Scans_GUI);
