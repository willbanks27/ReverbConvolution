


%%% goal: to have the length of 'in' equal the length of 'verb'

%%% below is code that padds the input signal to have the same index length

%%% define inputs

[in, fs] = audioread('ghosts.wav'); % input signal defined
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

%%% defining sampling stuff

    nfft = length(in);                  % nfft points equal to length of input
    window = fs/105;                    % window length value defined
    nfftPSD = window.*8;                % number of FFT points proportional to window length
    wTape = hamming(window);            % ham that window
    olap = floor(window/2);             % overlap proportional to half of window length

%%% Z transforms, XzT-> input, HzT->response, YzT->output

    XzT = fft(in_padded, nfft);
    HzT = fft(verb, nfft);
    
    YzT = XzT.*HzT;

%%% inverse Z transforms, x-> input, h->response, y->output

    y = ifft(YzT, nfft);

%%% mixer    

    A = .05;
    B = 1;
    mix = A.*y + B.*in;

soundsc(mix,fs)























%


