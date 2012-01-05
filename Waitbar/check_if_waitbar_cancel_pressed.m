
function waitbar_cancel_status = check_if_waitbar_cancel_pressed(waitbar_handle)

waitbar_cancel_status = ~isempty(get(waitbar_handle, 'UserData'));
