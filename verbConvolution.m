%%% simulated reverb via convolution 
%%% will banks, ECE Undergraduate @UKY

%%% define inputs

[in, fs] = audioread('coffee.wav'); % input signal defined
    in = in(:,1); % converts signal to mono, if needed

[verb, ~] = audioread('warehouse.wav'); % reverb response signal defined
    verb = verb(:,1); % converts signal to mono, if needed

%%% inputs are columns. zero pad command requires rows 

    %%% convert signals to rows
    
        in_row = in.';
        verb_row = verb.';

    %%% zero pad the input signal
    
        zeros_needed = length(verb) - length(in_row);
        
        in_padded_row = [in_row, zeros(1,zeros_needed)];

%%% convert the padded signal from a row to column

    in_padded = in_padded_row.';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% convolution of the input (in_padded) and response (verb)

%%% define sampling stuff

    nfft = length(in);                  % nfft points equal to length of input
    window = fs/105;                    % window length value defined
    nfftPSD = window.*8;                % number of FFT points proportional to window length
    wTape = hamming(window);            % ham that window
    olap = floor(window/2);             % overlap proportional to half of window length

%%% Z transforms, XzT-> input, HzT->response, YzT->out

    XzT = fft(in_padded, nfft);
    HzT = fft(verb, nfft);
    
    YzT = XzT.*HzT;

%%% inverse Z transforms, x-> input, h->response, y->out

    y = ifft(YzT, nfft);

    out = (1/20).*y; % output amplitude is decreased

%%% mixer, if needed    

    A = .05;
    B = 1;
    mix = A.*out + B.*in;

%soundsc(mix,fs)

%%% plots

    % define time axis

        tAxis_in = (0:length(in)-1)/fs;
        tAxis_verb = (0:length(verb)-1)/fs;
        tAxis_out = (0:length(out)-1)/fs;
    
    % define x limits
    
        xlim_in = [0, length(in)/fs];
        xlim_verb = [0, length(verb)/fs];
        xlim_out = [0, length(out)/fs];
    
        
        
% plot signals on one figure

figure(1)
tiledlayout(2,1);
    
    nexttile % plot x[n] and h[n] characteristics
        
        plot(tAxis_in, in)
        hold on
        plot(tAxis_verb, verb);
        title('Input vs. Response')
        xlabel('Seconds')
        ylabel('Amplitude')
        xlim(xlim_verb)
        
    nexttile % plot convoluted output characteristics
    
        plot(tAxis_out, out);
        
        title('Output Signal')
        xlabel('Seconds')
        ylabel('Amplitude')
        xlim(xlim_out)
















%


