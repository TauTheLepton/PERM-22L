function high_pass = create_high_pass(fc, BW, window)
%CREATE_HIGH_PASS Summary of this function goes here
%   Detailed explanation goes here
high_pass = inverse_filter(create_low_pass(fc, BW, window));
end
