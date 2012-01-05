
function set_tag_for_GUI_child(child_handle, parent_handle, child_GUI_description, varargin)

if length(varargin)
	text_separator = varargin{1};
else
	text_separator = ' ';
end

if ishandle(child_handle) && isstr(child_GUI_description)
	if ishandle(parent_handle)
		child_GUI_tag = strcat(get(parent_handle, 'Tag'), text_separator, child_GUI_description);
	else
		child_GUI_tag = child_GUI_description;
	end
	
	set(child_handle, 'Tag', child_GUI_tag);
else
	disp(sprintf('%s: unable to set the tag for GUI child - invalid argument(s) passed', mfilename));
	return;
end