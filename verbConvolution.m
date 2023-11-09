%%% reverb emulation via convolution 
%%% Will Banks - EE Undergrad @UKY

%%% read inputs & convert to mono (if needed)

    %%% vox signal
    
        [input, fs] = audioread('smash_hit.wav');
            input = input(:,1); % converts to mono 

            tAxis_in = (0:length(input)-1)/fs; %defines time axis and converts index units to seconds      
    
    %%% system response signal
    
        [verb, ~] = audioread('warehouse2.wav');
            verb = verb(:,1); % converts to mono

            tAxis_verb = (0:length(input)-1)/fs; %defines time axis and converts index units to seconds    

%%% define various sampling stuff for PSD

    nfft = fs;                          % number of nfft points equals sampling rate
    window = fs/105;                    % window length value defined
    nfftPSD = window.*8;                % number of FFT points proportional to window length
    wTape = hamming(window);            % ham that window
    olap = floor(window/2);             % overlap proportional to half of window length

%%% identity: y(t) = x(t)*h(t) --> Y(z) = X(z)H(z)

    Xz = fft(input, nfft); % input Z transform
        XzdB = 20.*log10(abs(Xz)); % dB conversion for plot
    
    Hz = fft(verb, nfft); % response Z transform
        HzdB = 20.*log10(abs(Hz)); % dB conversion for plot
    
    Yz = Xz.*Hz; % Z transform convolution property
        YzdB = 20.*log10(abs(Yz)); % dB conversion for plot

%%% convert output into real domain

    y = ifft(Yz, nfft); % inverse fft with nfft = nfft;

%%% PSD definitions

    [PSD_in, fAxis] = pwelch(input, window, olap, nfftPSD, fs);         % defines pwelch for noise floor
        PSD_in2dB = 20.*log10(abs(PSD_in));                             % converts to decibel scale
    
    [PSD_resp, fAxis_resp] = pwelch(verb, window, olap, nfft, fs);      % defines pwelch for resting heartrate
        PSD_resp2dB = 20.*log10(abs(PSD_resp));                         % converts to decibel scale

    [PSD_out, fAxis_out] = pwelch(YzdB, window, olap, nfft, fs);        %defines pwelch for noise floor
        PSD_out2dB = 20.*log10(abs(PSD_out));                           %converts to decibel scale

%%% plots plots plots

    tiledlayout(2,1);
        
        nexttile
        
            plot(fAxis, PSD_in2dB);
                
            hold on
            
            plot(fAxis_resp, PSD_resp2dB)
            
                set(gca, 'XScale', 'log')
                title('Input Signal (Blue) Against Response Signal (Orange)')
                xlabel('Frequency (Hz)')
                ylabel('Gain (dB)')
            
                xlim([20 20e3])
                ylim([-222 -80])
        
        nexttile
        
            plot(tAxis_in, input);
                title('Input Signal')
                xlabel('Amplitude')
                ylabel('Seconds')

            hold on
            
            plot(tAxis_verb, verb);

            title('Input vs. Response Signal')
                xlabel('Seconds')
                ylabel('Amplitude')
                
            
                xlim([0 1.05])

%%% play output signal

soundsc(y,fs)





















