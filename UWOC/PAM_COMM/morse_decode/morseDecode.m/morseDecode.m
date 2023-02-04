function [msg, MsgToneFreq, ditstat, dahstat] = morseDecode(y, Fs, setToneFreq)
%morseDecode Decodes Morse audio signals
%
% [msg, ToneFreq, ditstat, dahstat] = morseDecode(y, Fs, [ToneFreq])
%
%   INPUT
%      y - audio signal, [nsmpl, number_of_messages]
%      Fs - sampling frequency
%      ToneFreq - tone frequency, better be within 30 Hz of the actual one,
%      if not set or is empty the actual tone frequency will be estimated
%      from the signal, if set to 0, the default 1000 Hz will be used
%
%   OUTPUT
%      msg - decoded message
%      ToneFreq - estimated tone frequency
%      ditstat - "dit" interval statistics: [mean, std, min, max]
%      dahstat - "dah" interval statistics: [mean, std, min, max]
%
% Based on decode.m from
% https://github.com/drid/morse-audio-decoder
% 
% Peter L. Volegov    
% Version 1.0.0.0, 05/17/2022  

%Defaults
dit_len = 0.06;
dah_len = 3*dit_len;
spc_len = dit_len;
spc_wrd = dah_len;

defToneFreq = 1000;
minToneFreq = 500;
maxToneFreq = 2500;
defBandwidth = 5/dit_len;

defDetThr = 0.75;

if ~exist('setToneFreq', 'var')
    setToneFreq = [];
elseif setToneFreq == 0
    setToneFreq = defToneFreq;
end

% Data size
[nsmpl, nmsg] = size(y);
msg = cell(nmsg, 1);
MsgToneFreq = zeros(1, nmsg);
ditstat = zeros(nmsg, 4);
dahstat = zeros(nmsg, 4);
dit_smpl = floor(dit_len*Fs);

for iMsg = 1:nmsg
    curSig = y(:,iMsg);

    if isempty(setToneFreq)
        % Detect tone using PSD over dit length intervals
        win_size = dit_smpl;

        %Hanning window
        m = win_size-1;
        window = 0.5 - 0.5 * cos (2 * pi * (0 : m)' / m);

        % build matrix of windowed data slices
        overlap = ceil(length(window)/2);
        step = win_size - overlap;

        offset = 1:step:nsmpl-win_size;
        nslc = length(offset);
        P = zeros (win_size, nslc);
        for i=1:nslc
            P(:, i) = curSig(offset(i):offset(i)+win_size-1) .* window;
        end

        % compute Fourier transform
        P = fft(P, [], 1);

        % extract the positive frequency components
        if rem(win_size,2)==1
            iNyq = (win_size+1)/2;
        else
            iNyq = win_size/2;
        end
        P = P(1:iNyq, :);

        % Compute PSD
        P = mean(conj(P).*P, 2);

        %Find dominating frequency
        [~, im] = max(P);
        ToneFreq = Fs/win_size*(im-1);
        sig_strength = P(im)/median(P);
        if (ToneFreq < minToneFreq)||(ToneFreq > maxToneFreq)||(sig_strength < 2)
            warning('Unreliable tone detection! Check the signal.')
        end

    else
        %Use the specified tone frequency
        ToneFreq = setToneFreq;
    end
    MsgToneFreq(iMsg) = ToneFreq;

    % Filter around the tone frequency
    [b, a] = butter (5, [ToneFreq - defBandwidth/2, ToneFreq + defBandwidth]*2/ Fs);
    curSig = filtfilt (b, a, curSig);

    % Make analytic signal and compute the signal envelope
    curSig = hilbert(curSig);
    sigEnv = abs(curSig);

    % Convert to logic levels
    level_threshold = defDetThr*max(sigEnv);
    binSig = sigEnv >= level_threshold;

    % Detect transitions
    iSta = find(diff(binSig) == 1);
    iEnd = find(diff(binSig) == -1);
    len_on = iEnd-iSta;

    % Estimate actual symbol duration
    max_len = max(len_on);
    min_len = min(len_on);
    thr = (max_len+min_len)/2;

    % Average dit
    bDit = (len_on < thr);
    iDit = find(bDit);
    avrg_dit_len = mean(len_on(iDit));
    std_dit_len = std(len_on(iDit));

    % Outliers
    iout = abs(len_on(iDit) - avrg_dit_len) > 6*std_dit_len;
    bDit(iout) = 0;

    % Re-evaluate
    iDit = find(bDit);
    avrg_dit_len = mean(len_on(iDit));
    avrg_dit = avrg_dit_len/Fs;
    std_dit_len = std(len_on(iDit));
    max_dit_len = max(len_on(iDit));
    min_dit_len = min(len_on(iDit));
    ditstat(iMsg,:) = [avrg_dit, std_dit_len/Fs, min_dit_len/Fs, max_dit_len/Fs];

    % Average dah
    bDah = (len_on > thr);
    iDah = find(bDah);
    avrg_dah_len = mean(len_on(iDah));
    std_dah_len = std(len_on(iDah));

    % Outliers
    iout = abs(len_on(iDah) - avrg_dah_len) > 6*std_dah_len;
    bDah(iout) = 0;

    % Re-evaluate
    iDah = find(bDah);
    avrg_dah_len = mean(len_on(iDah));
    avrg_dah = avrg_dah_len/Fs;
    std_dah_len = std(len_on(iDah));
    max_dah_len = max(len_on(iDah));
    min_dah_len = min(len_on(iDah));
    dahstat(iMsg,:) = [avrg_dah, std_dah_len/Fs, min_dah_len/Fs, max_dah_len/Fs];

    % Silence intervals
    len_off = iSta(2:end)-iEnd(1:end-1);
    len_off(end+1) = length(binSig) - iEnd(end);

    % Detect morse letters
    symbol_threshold = (min_dah_len + max_dit_len)/2;
    letter_threshold = avrg_dah_len - 3*std_dah_len;

    morseC='';
    curMsg='';

    nints = length(len_on);
    for idx = 1:1:nints
        if bDah(idx)
            morseC = strcat(morseC, "-");
        elseif bDit(idx)
            morseC = strcat(morseC, ".");
        end

        if len_off(idx) > letter_threshold
            curMsg = strcat(curMsg, morse2char(morseC));
            morseC='';
        end

        if len_off(idx) > 4*letter_threshold
            if idx < nints
                curMsg = strcat(curMsg, ' ');
            end
        end

    end

    msg{iMsg} = curMsg;

end

msg = char(msg{:});

function character = morse2char(mc)
% morse2char.m from
% https://github.com/drid/morse-audio-decoder
character = '';
switch mc
    case ".-"
        character = 'A';
        return
    case "-..."
        character = 'B';
        return
    case "-.-."
        character = 'C';
        return
    case "-.."
        character = 'D';
        return
    case "."
        character = 'E';
        return
    case "..-."
        character = 'F';
        return
    case "--."
        character = 'G';
        return
    case "...."
        character = 'H';
        return
    case ".."
        character = 'I';
        return
    case ".---"
        character = 'J';
        return
    case "-.-"
        character = 'K';
        return
    case ".-.."
        character = 'L';
        return
    case "--"
        character = 'M';
        return
    case "-."
        character = 'N';
        return
    case "---"
        character = 'O';
        return
    case ".--."
        character = 'P';
        return
    case "--.-"
        character = 'Q';
        return
    case ".-."
        character = 'R';
        return
    case "..."
        character = 'S';
        return
    case "-"
        character = 'T';
        return
    case "..-"
        character = 'U';
        return
    case "...-"
        character = 'V';
        return
    case ".--"
        character = 'W';
        return
    case "-..-"
        character = 'X';
        return
    case "-.--"
        character = 'Y';
        return
    case "--.."
        character = 'Z';
        return
    case ".----"
        character = '1';
        return
    case "..---"
        character = '2';
        return
    case "...--"
        character = '3';
        return
    case "....-"
        character = '4';
        return
    case "....."
        character = '5';
        return
    case "-...."
        character = '6';
        return
    case "--..."
        character = '7';
        return
    case "---.."
        character = '8';
        return
    case "----."
        character = '9';
        return
    case "-----"
        character = '0';
        return
end
