function high_pass = create_high_pass(fc, BW, fs)
high_pass = inverse_filter(create_low_pass(fc, BW, fs));
end
