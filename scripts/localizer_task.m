function theData = localizer_task(thePath,listName,S,block,saveName,theData)

%% initialize rand.
rand('twister',sum(100*clock));
kbNum=S.kbNum;

% save file name
matName = [saveName '.mat'];

%% Come up with response labels
if S.respMap == 1
    respCodes = {'Yes' 'No'};
    labelReminder = 'loc_response_mapping1.jpg';
elseif S.respMap == 2
    respCodes = {'Yes' 'No'};
    labelReminder = 'loc_response_mapping2.jpg';
end
respOpts = {'1', '2'};
scanner_respOpts = {'1!', '2@'};

if S.scanner == 2
    theData.respOpts = respOpts;
else
    theData.respOpts = scanner_respOpts;
end

theData.respCodes = respCodes;

%% Read the input file
subDir = fullfile(thePath.orderfiles, S.subID);
cd(subDir);
theList = read_table(listName);
theData.index = theList.col1;
theData.block = theList.col2;
theData.condID = theList.col3;
theData.cond = theList.col4;
theData.rep = theList.col5;
theData.imgID = theList.col6;
theData.imgFile = theList.col7;

listLength = length(theData.index);


%% Trial Outline
stimTime = .6;
nullTime = 1;

%% Screen commands and device specification
Window = S.Window;
myRect = S.myRect;
Screen(Window,'TextSize', S.fontsize);
Screen('TextFont', Window, S.font);
Screen('TextStyle', Window, 1);

% get center and box points
xcenter = myRect(3)/2;
ycenter = myRect(4)/2;

Screen(Window,'FillRect', S.screenColor);
Screen(Window,'Flip');


%% Remind subject about response options before starting

% Load reminder of key labels
cd(thePath.stim);
pic = imread(labelReminder);
labelRemind = Screen(Window,'MakeTexture', pic);

% Print reminder
Screen(Window,'FillRect', S.screenColor);
message = ['TASK BLOCK ' num2str(block)];
DrawFormattedText(Window,message,'center',ycenter-400,S.textColor);
Screen(Window, 'DrawTexture', labelRemind);
Screen(Window,'Flip');
getKey('g',S.kbNum);

%% Pre-load images

% Load fixation
fileName = 'fix.jpg';
pic = imread(fileName);
fix = Screen(Window,'MakeTexture', pic);

% Load the stim pictures for the current block
for n = 1:listLength
    if (theData.block(n)==block)
        if theData.condID(n) > 0
            picname = theData.imgFile{n};  % This is the filename of the image
            pic = imread(picname);
            [imgheight(n), imgwidth(n), ~] = size(pic);
            imgPtrs(n) = Screen('MakeTexture',Window,pic);    
        end
    end
end

%% Get everything else ready

% preallocate shit:
theData.trigger_raw = 0;
for preall = 1:listLength
    if (theData.block(preall)==block)
        theData.onset(preall) = 0;
        theData.onset_raw(preall) = 0;
        theData.dur(preall) =  0;
        theData.stimResp{preall} = 'NR';
        theData.stimRT{preall} = 0;
        theData.stimCodedResp{preall} = 'NR';
        theData.isiResp{preall} = 'NR';
        theData.isiRT{preall} = 0;
        theData.isiCodedResp{preall} = 'NR';
        theData.picShown{preall} = 'blank';
        theData.corrResp{preall} = 'NR';
    end
end

% get ready screen
Screen(Window,'FillRect', S.screenColor);
message = ['Get ready!'];
DrawFormattedText(Window,message,'center','center',S.textColor);
Screen(Window,'Flip');

% get cursor out of the way
SetMouse(0,myRect(4));

% initiate experiment and begin recording time...
status = 1;
while 1
    getKey('g',S.kbNum);
    if S.scanner == 1
        [startTime,~,status,~] = trigger_scanner;
        theData.trigger_raw = GetSecs;
        goTime = 0;
%         fprintf('Serial port = %d\n', sp);
    else
        status = 0;
        S.boxNum = S.kbNum;
        startTime = GetSecs;
        goTime = 0;
    end
    
    if status == 0 % status=0 when startScan is successful
        break
    else
        message = 'Trigger failed, "g" to retry';
        DrawFormattedText(Window, message, 'center', 'center', S.textColor);
        Screen(Window, 'Flip');
    end
end

%% Start task
Priority(MaxPriority(Window));

% Show fixation (lead-in)
goTime = goTime + S.leadIn;
Screen(Window,'FillRect', S.screenColor);
Screen(Window, 'DrawTexture', fix);
Screen(Window,'Flip');
recordKeys(startTime,goTime,kbNum);

cd(S.subData); % for saving data

% Loop through stimulus trials
for Trial = 1:listLength
    if (theData.block(Trial)==block)
                
        keys = {'NR'};
        RT = 0;
        
        if theData.condID(Trial) == 0 % if rest
            % Set up screen
            % Blank
            Screen(Window,'FillRect', S.screenColor);
            Screen(Window, 'DrawTexture', fix);
            Screen(Window,'Flip');

            theData.onset(Trial) = GetSecs - startTime;
            theData.onset_raw(Trial) = GetSecs;

            % Save for now
            cmd = ['save ' matName];
            eval(cmd);
            
            % Collect responses during rest
            goTime = goTime + S.restTime;
            [keys, RT] = recordKeys(startTime,goTime,S.boxNum);

            if RT < 0.001 % so that RTs of 0 will stand out if they get averaged accidentally
                RT = 999;
            end

            theData.stimResp{Trial} = keys;
            theData.stimRT{Trial} = RT;
            theData.stimCodedResp{Trial} = 'rest';
            
        else
            
            %% Show stimulus

            % Set up screen
            % Blank
            Screen(Window,'FillRect', S.screenColor);

            % Draw pic
            destRect = [xcenter-imgwidth(Trial)/2 ycenter-imgheight(Trial)/2 xcenter+imgwidth(Trial)/2 ycenter+imgheight(Trial)/2];
            Screen('DrawTexture',Window,imgPtrs(Trial),[],destRect);
            theData.picShown{Trial} = theData.imgFile;

            % Start!
            theData.onset(Trial) = GetSecs - startTime;
            Screen(Window,'Flip');


            % Collect responses during stimulus presentation
            goTime = goTime + stimTime;
            [keys, RT] = recordKeys(startTime,goTime,S.boxNum);


            if RT < 0.001 % so that RTs of 0 will stand out if they get averaged accidentally
                RT = 999;
            end

            theData.stimResp{Trial} = keys;
            theData.stimRT{Trial} = RT;


            %% Present fixation during ITI
            Screen(Window,'FillRect', S.screenColor);
            Screen(Window, 'DrawTexture', fix);
            Screen(Window,'Flip');

            % Collect responses during iti
            goTime = goTime + nullTime;
            [keys, RT] = recordKeys(startTime,goTime,S.boxNum);

            if RT < 0.001 % so that RTs of 0 will stand out if they get averaged accidentally
                RT = 999;
            end

            theData.isiResp{Trial} = keys;
            theData.isiRT{Trial} = RT;
        end
            
        % Record trial duration
        theData.dur(Trial) = (GetSecs - startTime) - theData.onset(Trial); % duration from stim onset
        
    end
end

% Save to mat file
cmd = ['save ' matName];
eval(cmd);

% Show fixation (lead-out)
goTime = goTime + S.leadOut;
Screen(Window,'FillRect', S.screenColor);
Screen(Window, 'DrawTexture', fix);
Screen(Window,'Flip');
recordKeys(startTime,goTime,kbNum);

Screen(Window,'FillRect', S.screenColor);
Screen(Window,'Flip');

Priority(0);
end

