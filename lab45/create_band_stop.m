function band_stop = create_band_stop(fc_low, fc_high, BW, window)
%CREATE_BAND_STOP Summary of this function goes here
%   Detailed explanation goes here
low_pass = create_low_pass(fc_low, BW, window);
high_pass = create_high_pass(fc_high, BW, window);
band_stop = low_pass + high_pass;
end
