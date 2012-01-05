
function reactivate_parent_GUI(h, ev, parent_GUI_handle, fig)

set(parent_GUI_handle, 'Visible', 'on');
delete(fig);
