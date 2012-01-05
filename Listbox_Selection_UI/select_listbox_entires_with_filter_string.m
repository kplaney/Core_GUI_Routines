
function select_listbox_entires_with_filter_string(hObject, eventdata, listbox)

selection_idx = [];

listbox_entries = get(listbox, 'String');
N = size(listbox_entries,1);
	
if N > 0
	filter_string = get(hObject, 'String');

	if ~isempty(filter_string) && ~strcmp(filter_string, '')
		% Parse the individual filter strings which are separated by spaces
		parsed_filter_strings = parse_line_text(filter_string, ' ');
		
		% Strip out any empty cells corresponding to consecutive spaces in the filter string
		valid_idx = cellfun(@(str) ~isempty(str), parsed_filter_strings);
		parsed_filter_strings = parsed_filter_strings(valid_idx);
		
		% Loop over all the listbox entries and check if any filter strings match
		for n=1:N
			if any(cellfun(@(filter_str) ~isempty(regexp(listbox_entries{n}, filter_str)), parsed_filter_strings))
				selection_idx = [selection_idx n];
			end
		end
	end
end

set(listbox, 'Value', selection_idx);
