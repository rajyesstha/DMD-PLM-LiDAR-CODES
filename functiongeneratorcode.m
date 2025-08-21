function functiongeneratorcode()

    % USB resource string
    resource = 'USB0::0x1AB1::0x0642::DG1ZA223001682::INSTR';
    freq1 = 30000; % Hz
    freq2 = 30000; % Hz
    vpp   = 5;
    offset= 2.5;
    duty  = 40;
    period= 0.010001; % internal trigger period

    % Define sequence of orders and corresponding delays (in seconds)
    orders     = [3, -1, 4, 1, -2, -1, 2];
    delays_ch1 = [59.6, 61.7, 59.0, 60.5, 62.5, 61.7, 60.0] * 1e-6;
    delays_ch2 = [57.6, 59.6, 57.0, 58.3, 61.0, 59.6, 57.9] * 1e-6;
    pause_time = 0.7;

    dg = visa('ni', resource);

    try
        fopen(dg);

        for k = 1:numel(orders)
            order = orders(k);
            tdel1 = delays_ch1(k);
            tdel2 = delays_ch2(k);

            fprintf('⚙️ Setting order %d (%d/%d)\n', order, k, numel(orders));
            configure_order(dg, freq1, freq2, vpp, offset, duty, period, tdel1, tdel2);

            pause(pause_time);
        end

        fclose(dg);
        delete(dg);
        fprintf('✅ All orders completed successfully.\n');

    catch ME
        % Error handling
        fprintf(2, '❌ Error: %s\n', ME.message);
        if strcmp(dg.Status, 'open')
            fclose(dg);
        end
        delete(dg);
        rethrow(ME);
    end
end


function configure_order(dg, freq1, freq2, vpp, offset, duty, period, tdel1, tdel2)

    % Turn outputs OFF before configuring
    fprintf(dg, ':OUTP1:OFF');
    fprintf(dg, ':OUTP2:OFF');

    % Configure Channel 1
    setup_channel(dg, 1, freq1, vpp, offset, duty, period, tdel1);

    % Configure Channel 2
    setup_channel(dg, 2, freq2, vpp, offset, duty, period, tdel2);

    % Turn outputs ON
    fprintf(dg, ':OUTP1:ON');
    fprintf(dg, ':OUTP2:ON');
end


function setup_channel(dg, ch, freq, vpp, offset, duty, period, delay)

    fprintf(dg, sprintf(':SOUR%d:APPL:PULS %g,%g,%g,0', ch, freq, vpp, offset));
    fprintf(dg, sprintf(':SOUR%d:PULS:DCYC %g', ch, duty));
    fprintf(dg, sprintf(':SOUR%d:BURS ON', ch));
    fprintf(dg, sprintf(':SOUR%d:BURS:MODE TRIG', ch));
    fprintf(dg, sprintf(':SOUR%d:BURS NCYC 1', ch));
    fprintf(dg, sprintf(':SOUR%d:BURS:TRIG:SOUR INT', ch));
    fprintf(dg, sprintf(':SOUR%d:BURS:INT:PER %.6f', ch, period));
    fprintf(dg, sprintf(':SOUR%d:BURS:TRIG:SOUR EXT', ch));
    fprintf(dg, sprintf(':SOUR%d:BURS:TDEL %.7f', ch, delay));
end
