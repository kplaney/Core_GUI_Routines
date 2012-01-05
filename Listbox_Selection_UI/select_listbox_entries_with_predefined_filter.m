
function select_listbox_entries_with_predefined_filter(hObject, eventdata, listbox, selection_filter_func)

selection_idx = [];

if ~isa(selection_filter_func, 'function_handle')
	uiwait(errordlg('4th argument (selection_filter_func) should be a valid function handle', mfilename));
	return;
end

filter_types = get(hObject, 'String');
filter_selection = get(hObject, 'Value');
filter_name = filter_types{filter_selection};

if ~isempty(filter_selection) && ~strcmp(filter_selection, '')
	listbox_entries = get(listbox, 'String');
end

selection_idx = selection_filter_func(filter_name, listbox_entries);

set(listbox, 'Value', selection_idx);


