
function update_waitbar(x, waitbar_handle, msg)

if ~isempty(waitbar_handle)
	waitbar(x, waitbar_handle, msg);
else
	disp(msg);
end