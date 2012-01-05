
function process_error_msg(error_msg, log_file, log_window_text_handle, varargin)

if nargin < 1
	disp(sprintf('No arguments passed to %s', mfilename));
	return;
end

if nargin < 2
	log_file = [];
end

if nargin < 3
	log_window_text_handle = [];
end

if length(varargin)
	use_time_stamp = varargin{1};
else
	use_time_stamp = true;
end

window_update_mode = 'append';

if ~iscellstr(error_msg)
	if isstr(error_msg)
  	error_msg = {error_msg};
	else
		disp(sprintf('%s: error_msg argument should be a text string or cell array of text strings', mfilename));
		return;
	end
end

for j=1:length(error_msg)
	if use_time_stamp
  	new_error_msg = sprintf('%s -> %s', datestr(now), error_msg{j});
	else
		new_error_msg = error_msg{j};
	end
	
  if ~isempty(log_file)
    fid = fopen(log_file, 'a');
    
    if fid == -1
      disp(sprintf('Unable to write to log file: %s', log_file));
    else
      fprintf(fid, '%s\n', new_error_msg);
      fclose(fid);
    end
  end
	
  if ~isempty(log_window_text_handle)
    if ishandle(log_window_text_handle)
      current_text = get(log_window_text_handle, 'str');
      
      if isempty(current_text)
        set(log_window_text_handle, 'str', {new_error_msg});
      else
        switch window_update_mode
         case 'prepend'
          % Prepend error msg on to current window text
          set(log_window_text_handle, 'str', cat(1, {new_error_msg}, current_text));
         case 'append'
          % Append error msg on to current window text
          set(log_window_text_handle, 'str', cat(1, current_text, {new_error_msg}));
         otherwise
          disp(sprintf('Unknown window update mode: %s', window_update_mode));
        end
      end
    end
  else
    disp(error_msg{j});
  end
end
