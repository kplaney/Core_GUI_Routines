
function valid_integer = check_is_valid_integer(value)

valid_integer = true;
valid_integer = valid_integer & ~isempty(value);
valid_integer = valid_integer & ~isnan(value);
valid_integer = valid_integer & (imag(value) == 0);
valid_integer = valid_integer & (ceil(value) - value == 0);
