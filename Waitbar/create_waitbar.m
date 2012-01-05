
function waitbar_handle = create_waitbar(waitbar_title, varargin)

waitbar_fontsize = 8;
waitbar_width = 100;

if length(varargin)
  waitbar_fontsize = varargin{1};
end

if length(varargin) > 1
  waitbar_width = varargin{2};
end

% Get the parent figure window position
parent_fig_position = get(gcf, 'Position');

% Create initial waitbar message string which will set the size of the waitbar
pad_str = strcat(repmat('-', 1, round(waitbar_width/2)), '\n');
waitbar_msg = strcat(pad_str, ' Initialising ', pad_str);

% Setup waitbar - make it invisible until we properly centre it
waitbar_handle = waitbar(0, sprintf(waitbar_msg), 'Visible', 'off', 'CreateCancelBtn', 'set(gcbf, ''UserData'', 1)');
set(waitbar_handle, 'Name', waitbar_title, 'Units', 'normalized');

% Centre the waitbar in the centre of the parent figure window
waitbar_position = get(waitbar_handle, 'Position');
new_waitbar_x_offset = parent_fig_position(1) + 0.5*(parent_fig_position(3) - waitbar_position(3));
new_waitbar_y_offset = parent_fig_position(2) + 0.5*(parent_fig_position(4) - waitbar_position(4));
new_waitbar_position = [new_waitbar_x_offset new_waitbar_y_offset waitbar_position(3) waitbar_position(4)];
set(waitbar_handle, 'Position', new_waitbar_position, 'Visible', 'on');

% Set the waitbar fontsize
wbar_axes_handle = get(waitbar_handle, 'CurrentAxes');
wbar_text_handle = get(wbar_axes_handle, 'Title');
set(wbar_text_handle, 'Fontsize', waitbar_fontsize);
