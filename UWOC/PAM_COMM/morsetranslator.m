function morsecode=morsetranslator(text,wpm,freq)
    
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
        
        fprintf('%s',morse{Morsecode});
    end
    %sound Part
    morsecode2=morsecode;
    morsecode3=strjoin(morsecode2);
    F_samp = 3*freq;
    alldot=count(morsecode3,'.');
    alldash=count(morsecode3,'-');
    allspace=count(morsecode3,'   ');
    letterspace=count(morsecode3,'  ');
    numdot=(2*alldot)+(2*alldash)+(3*alldash)+(7*(2*allspace))+(3*letterspace);
    dot_duration=3*(60/(wpm*numdot));
    t_dot=0:1/(3*freq):dot_duration;
    t_dash=0:1/(3*freq):3*dot_duration;
    t_code_space=0:1/(3*freq):dot_duration;
    t_letter_space=0:1/(3*freq):3*dot_duration;
    t_word_space=0:1/(3*freq):7*dot_duration;
    y_dot=cos(2*pi*freq*t_dot);
    y_dash=cos(2*pi*freq*t_dash);
    y_code_space=0*t_code_space;
    y_letter_space=0*t_letter_space;
    y_word_space=0*t_word_space;
    sound_signal=[];
    for t=(1:length(morsecode3))
        if morsecode3(t)=='.'
            sound_signal=[sound_signal,y_dot,y_code_space];
        elseif morsecode3(t)=='-'
            sound_signal=[sound_signal,y_dash,y_code_space];
        elseif morsecode3(t)==' '
            sound_signal=[sound_signal,y_letter_space,y_code_space];
        end
    end
    %sound(sound_signal,(3*F_samp));
    soundsc(sound_signal, 3*F_samp, 16);
    %sound(sound_signal);
end

