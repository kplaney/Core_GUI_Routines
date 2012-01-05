
% --- Gets the top left hand corner for GUI opening on the button press
function [TLHC_next_GUI_x, TLHC_next_GUI_y] = get_TLHC_for_next_GUI(hObject)

set(hObject, 'Units', 'normalized');
position_vec = get(hObject, 'Position');

TRHC_x = position_vec(1) + position_vec(3);
TRHC_y = position_vec(2) + position_vec(4);

TLHC_next_GUI_x = TRHC_x + 0.01;
TLHC_next_GUI_y = TRHC_y;