
function handles = setup_log_file_and_log_window(handles, varargin)

% Initialise log file to empty
handles.log_file = [];

% Optional tag for log window
if length(varargin)
  tag = varargin{1};
else
	tag = 'Log window';
end

% If log dir is valid then get the log filename
if isfield(handles, 'log_dir') && isdir(handles.log_dir)
  log_filename = get(handles.log_filename_edit_field, 'String');
  
  % If log filename is a valid string then set up the complete log filepath
  if isstr(log_filename)
    handles.log_file = fullfile(handles.log_dir, log_filename);
  end
end

% Set up log window
if isfield(handles, 'log_window') && ishandle(handles.log_window) && strcmp(get(handles.log_window, 'Name'), tag)
  figure(handles.log_window);
else
	[TLHC_next_GUI_x, TLHC_next_GUI_y] = get_TLHC_for_next_GUI(handles.DICOMAT_GUI);
	width = 0.6; height = 0.6;
	log_window_position = [TLHC_next_GUI_x max([0 (TLHC_next_GUI_y-height)]) width height];
	
  handles.log_window = figure('Units', 'normalized', 'Position', log_window_position, ...
                              'Name', tag, 'Numbertitle', 'off', 'toolbar', 'none', 'Tag', tag);
  	
  handles.log_window_text = uicontrol('Units', 'normalized', 'Position', [0 0 1 1], ...
  																		'style', 'edit', 'string', '', 'Max', 2, 'Min', 0, ...
  																		'Fontunits', 'normalized', 'Fontsize', 0.02, ...
                                      'HorizontalAlignment', 'left', 'enable', 'on');
end
