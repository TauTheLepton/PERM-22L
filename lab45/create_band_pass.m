function band_pass = create_band_pass(fc_high, fc_low, BW, window)
%CREATE_BAND_PASS Summary of this function goes here
%   Detailed explanation goes here
low_pass = create_low_pass(fc_low, BW, window);
high_pass = create_high_pass(fc_high, BW, window);
band_pass = conv(low_pass, high_pass);
end
