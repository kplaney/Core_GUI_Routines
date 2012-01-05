
function handles = Select_Scans_GUI_initialisation(handles)

% Get DICOM study dir and update text field
handles.study_dir = getappdata(handles.Parent_GUI, 'study_dir');

if ~isempty(handles.study_dir)
	if ~isdir(handles.study_dir)
		uiwait(errordlg('Invalid DICOM study directory in GUI handle...', 'Select Scans'));
		setappdata(handles.Parent_GUI, 'study_dir', []);
	else
  	set(handles.study_dir_text_field, 'String', handles.study_dir);
	end
else
	set(handles.study_dir_text_field, 'String', []);
end

% Get index for the selected study format and update uicontrols
handles.study_format_selection_idx = getappdata(handles.Parent_GUI, 'study_format_selection_idx');
handles.scan_dir_depth = getappdata(handles.Parent_GUI, 'scan_dir_depth');

% Check for any incompatibility in the study format variables
if xor(isempty(handles.study_format_selection_idx), isempty(handles.scan_dir_depth))
	uiwait(errordlg('Incompatibility between selected study variables in GUI handle...', 'Select Scans'));
	return;
end

if ~isempty(handles.study_format_selection_idx) && ~isempty(handles.scan_dir_depth)
	% Update the Study Format popupmenu
	set(handles.study_format_popupmenu, 'Value', handles.study_format_selection_idx, 'Enable', 'on');
	
	if handles.scan_dir_depth > 0
		% Set up scan listbox selection
		handles.absolute_scan_dirpaths = getappdata(handles.Parent_GUI, 'absolute_scan_dirpaths');
		handles.relative_scan_dirpaths = getappdata(handles.Parent_GUI, 'relative_scan_dirpaths');

		if xor(isempty(handles.absolute_scan_dirpaths), isempty(handles.relative_scan_dirpaths))
			uiwait(errordlg('Incompatibility between relative and absolute scan dirpath in GUI handle...', 'Select Scans'));
			return;
		end

		if ~isempty(handles.absolute_scan_dirpaths) && ~isempty(handles.relative_scan_dirpaths)
			% Create or update an existing scan selection listbox
			selected_scan_dirs_idx = getappdata(handles.Parent_GUI, 'selected_scan_dirs_idx');
			handles.scans_listbox = Create_Listbox_Selection_UI(handles.scan_selection_panel, handles.relative_scan_dirpaths, selected_scan_dirs_idx);
		end
	end
	
	if handles.scan_dir_depth >= 0
		% Activate Done button
		set(handles.done_pushbutton, 'Enable', 'on');
	else
		% Deactivate Done button
		set(handles.done_pushbutton, 'Enable', 'off');
	end
else
	set(handles.done_pushbutton, 'Enable', 'off');
end
