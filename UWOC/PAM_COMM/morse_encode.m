function morsecode= morse_encode(text,wpm, modulate_freq)
%MORSE_ENCODE Summary of this function goes here
%   Detailed explanation goes here
% text: string to be converted to morse 
% wpm : words per minute 
% modulate_freq: modulated signal frequency 

    morse={'.---- ','..--- ','...-- ','....- ','..... ','-.... ','--... ',...
        '---.. ','----. ','----- ','.- ','-... ','-.-. ','-.. ','. ',...
        '..-. ','--. ','.... ','.. ','.--- ','-.- ','.-.. ','-- ','-. ',...
        '--- ','.--. ','--.- ','.-. ','... ','- ','..- ','...- ','.-- ',...
        '-..- ','-.-- ','--.. ','---- ','---. ','   ','.- ','-... ',...
        '-.-. ','-.. ','. ','..-. ','--. ','.... ','.. ','.--- ','-.- ',...
        '.-.. ','-- ','-. ','--- ','.--. ','--.- ','.-. ','... ','- ',...
        '..- ','...- ','.-- ','-..- ','-.-- ','--.. '};
    
    number_and_letter={'1','2','3','4','5','6','7','8','9','0','a','b','c',...
        'd','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t',...
        'u','v','w','x','y','z','?','.',' ','A','B','C','D','E','F','G','H',...
        'I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y',...
        'Z'};

    morsecode=[];
    for i=1:length(text)
        [~ , Morsecode] = ismember(text(i), number_and_letter);
        
        morsecode=[morsecode,morse(Morsecode)];

    end
    morse_string = strjoin(morsecode);
    num_dots = count(morse_string,'.');
    num_dashes = count(morse_string,'-');
    word_spaces = count(morse_string,'   '); % total spaces between words
    all_spaces = count(morse_string,'  '); %Total number of spaces

    size = num_dots + num_dashes + word_spaces + all_spaces;

    duration = 60/(wpm*size);
    F_samp = 4*modulate_freq;
    t_dot = 1:1/F_samp:duration;
    t_dash = 1:1/F_samp:2*duration;

end

