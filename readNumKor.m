function pronunciation = readNumKor(number)
%% read arabic numbers into Korean (not Soon-Urimal)
%  e.g. '123' --> 'one hundred twenty three'

% 2016-07-13
% by Yeonjung hong

% if input is numeric,  convert it to string
if isnumeric(number)
    number = num2str(number);
end

% check if it has floating numbers
if isempty(regexp(number, '\.', 'match')); % if it has no DOT
    isfloating = false;
else % if it has DOT
    isfloating = true;
end

%%%%%%%%%%%%
switch isfloating
    %% integers
    case false
        pronunciation = readInt(number);
        
        %% floating numbers
    case true
        split = strsplit(number, '.');
        integer = split{1};
        floating = split{2};
        pronunciation = {strjoin([readInt(integer), 'point', readDigits(floating)])};
end
pronunciation = pronunciation(~cellfun(@isempty, pronunciation));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function pronunciation = readInt(number)

% if input is numeric,  convert it to string
if isnumeric(number)
    number = num2str(number);
end

% check if it is integer
if ~isempty(regexp(number, '\.', 'match')); % if it has no DOT
    error('Input must be integers');
end

% figure out the unit of digit
len = length(number);
unitDelimiter= floor((len-1)/4);
unitMod = mod(len,4);

%preparation
tenthou = {char(47564)}; %maan
hundmill =  {char(50613)}; % eok

switch unitDelimiter
    %% unit 1~4
    case 0
        pronunciation = read1to4digits(number);
        
        %% unit 5~8
    case 1
        switch unitMod
            case 1
                pronunciation = [read1to4digits(number(1)), tenthou, ...
                    read1to4digits(number(2:end))];
            case 2
                pronunciation = [read1to4digits(number(1:2)), tenthou, ...
                    read1to4digits(number(3:end))];
            case 3
                pronunciation = [read1to4digits(number(1:3)), tenthou, ...
                    read1to4digits(number(4:end))];
            case 0
                pronunciation = [read1to4digits(number(1:4)), tenthou, ...
                    read1to4digits(number(5:end))];
        end
        %% unit 9~12
    case 2
        switch unitMod
            case 1
                pronunciation = [read1to4digits(number(1)), hundmill,...
                    read1to4digits(number(2:5)), tenthou,...
                    read1to4digits(number(6:end))];
            case 2
                pronunciation = [read1to4digits(number(1:2)), hundmill,...
                    read1to4digits(number(3:6)), tenthou,...
                    read1to4digits(number(7:end))];
            case 3
                pronunciation = [read1to4digits(number(1:3)), hundmill, ...
                    read1to4digits(number(4:7)), tenthou,...
                    read1to4digits(number(8:end))];
            case 0
                pronunciation = [read1to4digits(number(1:4)), hundmill,...
                    read1to4digits(number(5:8)), tenthou,...
                    read1to4digits(number(9:end))];
        end
end

if sum(cellfun(@isempty, pronunciation)) ~= 0
    idx = find(cellfun(@isempty, pronunciation));
    idx = [idx, idx+1];
    idx = ismember(1:length(pronunciation), idx);
    pronunciation(idx) = [];
end
pronunciation = {strjoin(pronunciation)};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function pronunciation = read1to4digits(number)

%% if input is numeric,  convert it to string
if isnumeric(number)
    number = num2str(number);
end

%% if a sequence of 0 is added in the front, delete it
number = regexprep(number, '^0+', '');

%% figure out the unit of digit
len = length(number);

%% preparation
noZero = {'1', '2', '3', '4', '5', '6', '7', '8', '9'};
ten = {char(49901)};
hundred = {char(48177)};
thousand = {char(52380)};

switch len
    case 0 
        pronunciation = {''};
    %% 1-digit (e.g.two)
    case 1
        pronunciation = readDigits(number);
        %% 2-digit (e.g. thrity five)
    case 2
        if strcmp(number(1), '1')
            pronunciation = ten;
        else
            pronunciation = [readDigits(number(1)), ten];
        end
        if ismember(number(2), noZero) % if 0 in 1st digit, ignor
            pronunciation = [pronunciation, readDigits(number(2))];
        end
        pronunciation = {strjoin(pronunciation)}; % concatenate to one string of cell array
        
        %% 3-digit (e.g. three hundred twenty five)
    case 3
        if strcmp(number(1), '1') %100~199
            pronunciation = hundred;
        else %200~999
            pronunciation = [readDigits(number(1)), hundred];
        end
        
        if ismember(number(2), noZero)
            if strcmp(number(2), '1')
                pronunciation = [pronunciation, ten];
            else
                pronunciation = [pronunciation, readDigits(number(2)), ten];
            end
        end
        
        if ismember(number(3), noZero)
            pronunciation = [pronunciation, readDigits(number(3))];
        end
        pronunciation = {strjoin(pronunciation)}; % concatenate to one string of cell array
        
        %% 4-digit (e.g. two thousand three hundred twenty five)
    case 4
        if strcmp(number(1), '1') %1000~1999
            pronunciation = thousand;
        else %2000~9999
            pronunciation = [readDigits(number(1)), thousand];
        end
        
        if ismember(number(2), noZero)
            if strcmp(number(2), '1')
                pronunciation = [pronunciation, hundred];
            else
                pronunciation = [pronunciation, readDigits(number(2)), hundred];
            end
        end
        
        if ismember(number(3), noZero)
            if strcmp(number(3), '1')
                pronunciation = [pronunciation, ten];
            else
                pronunciation = [pronunciation, readDigits(number(3)), ten];
            end
        end
        
        if ismember(number(4), noZero)
            pronunciation = [pronunciation, readDigits(number(4))];
        end
        pronunciation = {strjoin(pronunciation)}; % concatenate to one string of cell array
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function pronunciation_concat = readDigits(number)
%INPUT: integer only (either string or numeric)
%OUTPUT: 1-by-1 cell array
%                   OR
%                  2-by-1 cell array (double pronunciations for 0)


% if input is numeric,  convert it to string
if isnumeric(number)
    number = num2str(number);
end

%%%%%%%%%%%%
%% integers
% figure out the unit of digit
len = length(number);

% pronunciation
pron = {char(50689), char(44277), char(51068), char(51060), ...
    char(49340), char(49324), char(50724), char(50977), ...
    char(52832), char(54036), char(44396), char(49901)};
digit = {'0','0','1','2','3','4','5','6','7','8','9'};

% pre-allocation
pronunciation = cell(2,len); % prepare the space for 2 versions

% iterate for each digit
for i = 1:len
    % map pronunciation and digit
    each = pron(ismember(digit, number(i)));
    
    if length(each) > 1 % the case of 0
        pronunciation(1,i) = each(1);
        pronunciation(2,i) = each(2);
    else
        pronunciation(:,i) = repmat(each, 2,1);
    end
    
end


% delete one version if duplicated
if isequal(pronunciation(1,:), pronunciation(2,:))
    pronunciation = pronunciation(1,:);
end


% pre-allocation the final output
pronunciation_concat = cell(size(pronunciation,1), 1);

% string join
for n = 1:size(pronunciation,1)
    pronunciation_concat{n,1} = strjoin(pronunciation(n,:));
end