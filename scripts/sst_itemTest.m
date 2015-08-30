function [theData,S] = sst_itemTest(thePath,listName,S,block,saveName,theData)

%% initialize rand.
rng('shuffle');
kbNum=S.kbNum;

%% Read the input file
subDir = fullfile(thePath.orderfiles, S.subID);
cd(subDir);
theList = read_table(listName);
theData.index = theList.col1;
theData.imgID = theList.col2;
theData.imgFile = theList.col3;

listLength = length(theData.index);

%% Shuffle the order for this block, and save order file
item_types = {'Item 1', 'Item 2', 'Item 3'};

env_ext = {'_1.jpg', '_2.jpg', '_3.jpg'};
pic_order = [1, 2, 3];
pics_per_town = size(pic_order,2);

stimOrder = Shuffle(theData.index);
theData.imgID = theData.imgID(stimOrder);
theData.imgFile = theData.imgFile(stimOrder);

cd(thePath.orderfiles);
subDir = fullfile(thePath.orderfiles, S.subID);
cd(subDir);

% now make text file with the full list
txtName = [S.subID '_itemTestList_block', num2str(block), '.txt'];
fid = fopen(txtName, 'wt');
fprintf(fid, 'index\timgID\timgFile\n');
for e = 1:length(theData.index)
    fprintf(fid, '%d\t%s\t%s\n',...
        theData.index(e), theData.imgID{e}, theData.imgFile{e});
end


%% Trial Outline
leadIn = 1;
leadOut = 1;

%% Screen commands and device specification
Window = S.Window;
myRect = S.myRect;
Screen(Window,'TextSize', S.fontsize);
Screen('TextFont', Window, S.font);
Screen('TextStyle', Window, 1);

lengthLine = 40; % num characters in line

RETURN = 10;
DELETE = 8;

% get center and box points
xcenter = myRect(3)/2;
ycenter = myRect(4)/2;
yCoor_type = ycenter+250;

Screen(Window,'FillRect', S.screenColor);
Screen(Window,'Flip');

%% Pre-load images 

S.LjustMult = 0.1;
S.res = myRect(3:4);
S.instrWrap = 65;

% Print instructions
Screen(Window,'FillRect', S.screenColor);
message = ['In this task you will be tested on which items are found in each town. You will be presented ', ...
    'with an image from each town, and asked to recall the 3 items found in that town, in any order. To enter your responses, ', ...
    'you will type in a brief description of a given item, and press the RETURN key to advance to the next item (or town). If you ', ...
    'can''t remember all the items, please just type ''?'', and then RETURN. ', ...
    'Any questions? \n\nWhen you''re ready to start, please press the ''g'' button.'];
SG_DrawFormattedText(Window,message,S.res(1)*S.LjustMult,'center',S.textColor,S.instrWrap,1.5);
Screen(Window,'Flip');
getKey('g',S.kbNum);


% Print reminder
Screen(Window,'FillRect', S.screenColor);
message = ['BLOCK ' num2str(block)];
DrawFormattedText(Window,message,'center',ycenter,S.textColor);
Screen(Window,'Flip');
getKey('g',S.kbNum);

% Load the stim pictures for the current block
for n = 1:listLength % for each town 
    for picnum = 1:pics_per_town % iterate through pics per town
        picname = [theData.imgFile{n}, env_ext{picnum}];  % This is the filename of the image
        pic = imread(picname);
        [imgheight(n), imgwidth(n), ~] = size(pic);
        imgPtrs{n,picnum} = Screen('MakeTexture',Window,pic);
    end
end

% Figure out where pics will be displayed
destRects = cell(pics_per_town); %init cell array of destination rects
h = imgheight(1);
w = imgwidth(1);
margin_size = 5;
screen_w = myRect(3);
screen_x = 0;

scaled_imgw = (screen_w - ((pics_per_town+1)*margin_size))/pics_per_town;
scaled_proportion = w/scaled_imgw;
scaled_imgh = h/scaled_proportion;

for rectnum = 1:pics_per_town
    destRects{rectnum} = [screen_x+margin_size  ycenter-(scaled_imgh/2) screen_x+margin_size+scaled_imgw ycenter+(scaled_imgh/2)];
    screen_x = screen_x+margin_size+scaled_imgw;
end


%% Get everything else ready

% preallocate shit:
trialcount = 0;
for preall = 1:listLength
    theData.onset(preall) = 0;
    theData.dur(preall) =  0;

    for item = 1:length(item_types)
        eval(['theData.stimResp',num2str(item),'{preall} = ''NR'';']);
        eval(['theData.stimRT',num2str(item),'{preall} = 0;']);
    end

    theData.picShown{preall} = 'blank';
    theData.shuffle_pic_order{preall} = [];
end

% get ready screen
Screen(Window,'FillRect', S.screenColor);
message = ['Get ready!'];
DrawFormattedText(Window,message,'center',ycenter,S.textColor);  
Screen(Window,'Flip');

% get cursor out of the way
SetMouse(0,myRect(4));

% initiate experiment and begin recording time...
status = 1;
while 1
    getKey('g',S.kbNum);
    if S.scanner == 1
        [status, startTime] = startScan;
    else
        status = 0;
        S.boxNum = S.kbNum;
        startTime = GetSecs;
    end
    if status == 0 % status=0 when startScan is successful
        break
    end
end

%% Start task

Priority(MaxPriority(Window));

% Show (lead-in)
goTime = 0;
goTime = goTime + leadIn;
Screen(Window,'FillRect', S.screenColor);
Screen(Window,'Flip');
recordKeys(startTime,goTime,kbNum);

cd(S.subData); % for saving data

% Loop through stimulus trials
for Trial = 1:listLength
    
    % get shuffled pic order
    theData.shuffle_pic_order{Trial} = Shuffle(pic_order);
    
    theData.onset(Trial) = GetSecs - startTime;

    for item_num = 1:length(item_types)
        onset_item = GetSecs;
 
        string_spec = '';
        FlushEvents ('keyDown');
        ListenChar(2);
        
        keys = {'NR'};
        RT = 0;

        % Blank
        Screen(Window,'FillRect', S.screenColor);

        % Draw the item num
        Screen(Window,'TextSize', S.fontsize);
        word = item_types{item_num};
        DrawFormattedText(Window,word,'center',ycenter-(imgheight(Trial)/2+50),S.textColor);

        % Draw the images
        for picnum = 1:pics_per_town 
            Screen('DrawTexture',Window,imgPtrs{Trial,theData.shuffle_pic_order{Trial}(picnum)},[],destRects{picnum});
            theData.picShown{Trial} = theData.imgID{Trial};
        end

        % Flip
        Screen(Window,'Flip');
        
        
        % Collect responses during stimulus presentation
        numReturns = 0;
        while 1
            typedInput = GetChar;
            switch(abs(typedInput))
                case{RETURN},
                    break;
                case {DELETE},
                    if ~isempty(string_spec);
                        string_spec= string_spec(1:length(string_spec)-1);
                        Screen('TextSize',Window);
                        DrawFormattedText(Window,string_spec,'center',yCoor_type,S.textColorResp);
                    end;
                otherwise, % all other keys
                    string_spec= [string_spec typedInput];
                    Screen('TextSize',Window);

                    % new line if too long!
                    if length(string_spec)-(numReturns*lengthLine) > lengthLine
                        numReturns = numReturns +1;
                        string_spec = [string_spec '\n'];
                        DrawFormattedText(Window,string_spec,'center',yCoor_type,S.textColorResp);
                    else
                        DrawFormattedText(Window,string_spec,'center',yCoor_type,S.textColorResp);
                    end
            end
        
            % Draw the item num
            Screen(Window,'TextSize', S.fontsize);
            word = item_types{item_num};
            DrawFormattedText(Window,word,'center',ycenter-(imgheight(Trial)/2+50),S.textColor);

            % Draw the images
            for picnum = 1:pics_per_town
                Screen('DrawTexture',Window,imgPtrs{Trial,theData.shuffle_pic_order{Trial}(picnum)},[],destRects{picnum});
                theData.picShown{Trial} = theData.imgID{Trial};
            end
            Screen('Flip', Window);
            FlushEvents(['keyDown']);
            
        end

        
        RT = GetSecs - onset_item;
        keys = string_spec;
        
        if RT < 0.001 % so that RTs of 0 will stand out if they get averaged accidentally
            RT = 999;
        end

        eval(['theData.stimResp', num2str(item_num), '{Trial} = keys;']);
        eval(['theData.stimRT', num2str(item_num), '{Trial} = RT;']);

    end
    
    % Record trial duration
    theData.dur(Trial) = (GetSecs - startTime) - theData.onset(Trial); % duration from stim onset

    % Save to mat file 
    matName = [saveName '.mat'];
    cmd = ['save ' matName];
    eval(cmd);
end

% Show (lead-out)
goTime = leadOut;
Screen(Window,'FillRect', S.screenColor);
Screen(Window,'Flip');
recordKeys(startTime,goTime,kbNum);

Priority(0);
end

