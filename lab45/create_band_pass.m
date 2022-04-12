function band_pass = create_band_pass(fc_high, fc_low, BW, fs)
low_pass = create_low_pass(fc_low, BW, fs);
high_pass = create_high_pass(fc_high, BW, fs);
band_pass = conv(low_pass, high_pass);
end
