
function valid_double = check_is_valid_double(value)

valid_double = true;
valid_double = valid_double & ~isempty(value);
valid_double = valid_double & ~isnan(value);
valid_double = valid_double & (imag(value) == 0);
