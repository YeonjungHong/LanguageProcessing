function pronunciation = readNum(number)
%% read arabic numbers into English
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
unitDelimiter= floor((len-1)/3);
unitMod = mod(len,3);

switch unitDelimiter
    %% unit 1~3
    case 0
        pronunciation = read1to3digits(number);
        
        %% unit 4~6
    case 1
        switch unitMod
            case 1
                pronunciation = [read1to3digits(number(1)), {'thousand'}, ...
                    read1to3digits(number(2:end))];
            case 2
                pronunciation = [read1to3digits(number(1:2)), {'thousand'}, ...
                    read1to3digits(number(3:end))];
            case 0
                pronunciation = [read1to3digits(number(1:3)), {'thousand'}, ...
                    read1to3digits(number(4:end))];
        end
        %% unit 7~9
    case 2
        switch unitMod
            case 1
                pronunciation = [read1to3digits(number(1)), {'million'},...
                    read1to3digits(number(2:4)), {'thousand'},...
                    read1to3digits(number(5:end))];
            case 2
                pronunciation = [read1to3digits(number(1:2)), {'million'}
                    read1to3digits(number(3:5)), {'thousand'},...
                    read1to3digits(number(6:end))];
            case 0
                pronunciation = [read1to3digits(number(1:3)), {'million'},...
                    read1to3digits(number(4:6)), {'thousand'},...
                    read1to3digits(number(7:end))];
        end
        %% unit 10~12
    case 3
        switch unitMod
            case 1
                pronunciation = [read1to3digits(number(1)), {'billion'},...
                    read1to3digits(number(2:4)), {'million'},...
                    read1to3digits(number(5:7)), {'thousand'},...
                    read1to3digits(number(8:end))];
            case 2
                pronunciation = [read1to3digits(number(1:2)), {'billion'},...
                    read1to3digits(number(3:5)), {'million'},...
                    read1to3digits(number(6:8)), {'thousand'},...
                    read1to3digits(number(9:end))];
            case 0
                pronunciation = [read1to3digits(number(1:3)), {'billion'},...
                    read1to3digits(number(4:6)), {'million'},...
                    read1to3digits(number(7:9)), {'thousand'},...
                    read1to3digits(number(10:end))];
        end
end

if sum(cellfun(@isempty, pronunciation)) ~= 0
    idx = find(cellfun(@isempty, pronunciation));
    idx = [idx, idx+1];
    idx = ismember(1:length(pronunciation), idx);
    pronunciation(idx) = [];
end
pronunciation = {strjoin(pronunciation)};


function pronunciation = read1to3digits(number)

%% preparation
digits2 = {'0','1','2', '3', '4','5','6','7','8','9'};
digits2Pro = {'','','twenty', 'thirty', 'fourty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'};

digits2idio = {'10', '11', '12', '13', '14', '15', '16', '17', '18', '19'};
digits2idioPro = {'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'};


%% if input is numeric,  convert it to string
if isnumeric(number)
    number = num2str(number);
end

%% if a sequence of 0 is added in the front, delete it
number = regexprep(number, '^0+', '');

%% figure out the unit of digit
len = length(number);

switch len
    case 0
        pronunciation = {''};
        %% 1-digit (e.g.two)
    case 1
        pronunciation = readDigits(number);
        
        %% 2-digit (e.g. thrity five)
    case 2
        if strcmp(number(1), '1') % 10~19
            pronunciation = digits2idioPro(ismember(digits2idio, number));
        else %20~99
            pronunciation =digits2Pro(ismember(digits2, number(1)));
            if ~strcmp(number(2), '0') % if 0 in 1st digit, ignore
                pronunciation = [pronunciation, readDigits(number(2))];
            end
        end
        pronunciation = {strjoin(pronunciation)}; % concatenate to one string of cell array
        
        %% 3-digit (e.g. three hundred twenty five)
    case 3
        pronunciation = [readDigits(number(1)),{'hundred'}];
        if ~strcmp(number(2), '0') % ignore 0 in the 2nd digit
            if strcmp(number(2), '1') %10~19
                pronunciation = [pronunciation, digits2idioPro(ismember(digits2idio, number(2)))];
            else %20~99
                pronunciation = [pronunciation, digits2Pro(ismember(digits2, number(2)))];
                if ~strcmp(number(3), '0') % ignore 0 in the last digit
                    pronunciation = [pronunciation, readDigits(number(3))];
                end
            end
        end
        pronunciation = {strjoin(pronunciation)}; % concatenate to one string of cell array
end


function pronunciation_concat = readDigits(number)
%INPUT: integer only (either string or numeric)
%OUTPUT: 1-by-1 cell array
%                   OR
%                  2-by-1 cell array (double pronunciations for 0 (zero and oh))


% if input is numeric,  convert it to string
if isnumeric(number)
    number = num2str(number);
end

%%%%%%%%%%%%
%% integers
% figure out the unit of digit
len = length(number);

% pronunciation
pron = {'zero', 'oh', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'};
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