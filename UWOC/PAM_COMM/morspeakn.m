function out=morspeakn(str_ip,dotlen,dashlen, modulate_freq)
%MORSPEAK Convert text into Morse code audio.
%	MORSPEAK('text') converts 'text' into Morse
%	code and plays it.
%
%       MORSPEAK('text',dotlen) produces Morse code with
%       dots dotlen seconds long. Dashes are twice as long as dots.
%
%	MORSPEAK('text',dotlen,dashlen) produces Morse code
%	where the length of dots is dotlen (in seconds) and
%	the length of dashes is dashlen.
%
%	Y = MORSPEAK('text') produces a vector containing
%	the Morse-encoded signal.

% D. Thomas 3/24/95

%  a .-     b -...   c -.-.   d -..    e .      f ..-.   g --.
%  h ....   i ..     j .---   k -.-    l .-..   m --     n -.
%  o ---    p .--.   q --.-   r .-.    s ...    t -      u ..-
%  v ...-   w .--    x -..-   y -.--   z --..

str_ip=lower(str_ip);

mortab = [1 2 0 0
    2 1 1 1
    2 1 2 1
    2 1 1 0
    1 0 0 0
    1 1 2 1
    2 2 1 0
    1 1 1 1
    1 1 0 0
    1 2 2 2
    2 1 2 0
    1 2 1 1
    2 2 0 0
    2 1 0 0
    2 2 2 0
    1 2 2 1
    2 2 1 2
    1 2 1 0
    1 1 1 0
    2 0 0 0
    1 1 2 0
    1 1 1 2
    1 2 2 0
    2 1 1 2
    2 1 2 2
    2 2 1 1
    3 3 3 3];

mornum = [2 2 2 2 2
    1 2 2 2 2
    1 1 2 2 2
    1 1 1 2 2
    1 1 1 1 2
    1 1 1 1 1
    2 1 1 1 1
    2 2 1 1 1
    2 2 2 1 1
    2 2 2 2 1];



if (nargin == 1)
    %dashlen = .14;
    %dotlen  = .05;
    dashlen = 0.18;
    dotlen  = 0.06;
elseif (nargin == 2)
    %dashlen = 2*dotlen;
    dashlen = 3*dotlen;
end


str_ip(find(str_ip == ' ')) = 123*(ones(size(find(str_ip == ' '))));
str_ip = str_ip(:)-96;

% Start Code added 980609 -- Frank Fisher
mortab = [mortab zeros(size(mortab,1),1)];
stri = find(str_ip > 0);
nstri = find(str_ip < -38 & str_ip > -49);
nstr  = str_ip(nstri)+49;
code = [];
for k1 = 1:length(str_ip)
    if str_ip(k1) > 0
        code = [code; mortab(str_ip(k1),:)];
    elseif str_ip(k1) < 0
        code = [code; mornum(str_ip(k1)+49,:)];
    end
end
% End Code added 980609 -- Frank Fisher

% code = mortab(str,:);
code = [code 3*ones(length(str_ip),1)]';
code(find(code == 0)) = [];
code = [code(:) 3*ones(length(code(:)),1)]';
ind = find(code(1,:) == 3);
code(2,ind) = zeros(size(ind));
code = code(:);
code(find(code == 0)) = [];
code(find(code == 3)) = zeros(size(find(code == 3)));

F_samp = 3*modulate_freq;
tdot  = 0:1/F_samp:dotlen;
tdash = 0:1/F_samp:dashlen;
dot = sin(tdot*modulate_freq);
dash = sin(tdash*modulate_freq);
ldot = length(dot);
ldash = length(dash);
dot(1:10)=(.1:.1:1).*dot(1:10);
dot(ldot-9:ldot)=(1:-.1:.1).*dot(ldot-9:ldot);
dash(1:10)=(.1:.1:1).*dash(1:10);
dash(ldash-9:ldash)=(1:-.1:.1).*dash(ldash-9:ldash);


audio = zeros(ldot*sum(code < 2)+ldash*sum(code == 2)+1,1);
curpt=2;
audio(1)=3;

for i=1:length(code),
    if (code(i) == 1),
        audio(curpt:curpt+ldot-1) = dot;
        curpt=curpt+ldot+1;
    elseif (code(i) == 2),
        audio(curpt:curpt+ldash-1) = dash;
        curpt=curpt+ldash+1;
    else
        curpt=round(curpt+ldash/2+1);
    end
end

Fs = F_samp;
bits = 16;

if (nargout == 0)
    soundsc(audio,Fs,bits);
    audiowrite(strcat(str_ip,'.wav'), audio, Fs);
%     wavplay(audio,Fs,bits);
%     sound(audio);
else
    out=audio;
end





