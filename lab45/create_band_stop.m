function band_stop = create_band_stop(fc_low, fc_high, BW, fs)
low_pass = create_low_pass(fc_low, BW, fs);
high_pass = create_high_pass(fc_high, BW, fs);
band_stop = low_pass + high_pass;
end
