
function sst_run(subID,thePath)

%% Inputs

taskType = input('itemTest(1), quest(2), loc-prac(3), loc-scan(4)? ');
taskType_lab = {'Item Test', 'Questionnaires', 'Localizer Practice', 'Localizer Task'};

if ismember(taskType, [3 4])
    S.respMap = input('Response mapping (1, 2)? ');
end

block = input('Enter block number: ');

S.scanner = input('inside scanner(1) or outside(2)? ');

% Stress or Control Group
S.stressGroup = input('control(1) or stress(2)? ');

S.xptr = input('What are the experimenter''s initials? (e.g., SG): ','s');
if strcmpi(S.xptr,'SG')
    S.emailRecipient = {'stephanie.a.gagnon@gmail.com'};
    S.email = 1;
elseif strcmpi(S.xptr,'TB')
    S.emailRecipient = {'thackery@stanford.edu'};
    S.email = 1;
else
    S.emailRecipient = {'stephanie.a.gagnon@gmail.com'};
    S.email = 0;
end

% Set up email
try
    if S.email == 1
        setupEmail;
    end
catch
    disp('Can''t send email!');
end


S.study_name = 'SST';
S.subID = subID;

%% Set input device (keyboard or buttonbox)
[~, hostname]=system('hostname');
if S.scanner == 1
    S.boxNum = getBoxNumber;  % buttonbox
    S.kbNum = getKeyboardNumber(hostname(1:end-1)); %getKeyboardNumberWendyo; % keyboard
elseif S.scanner == 2
    S.boxNum = getKeyboardNumber(hostname(1:end-1));  % keyboard
    S.kbNum = getKeyboardNumber(hostname(1:end-1)); % keyboard
end

%% Set up subj-specific data directory
S.subData = fullfile(thePath.data, [subID]);
if ~exist(S.subData)
   mkdir(S.subData);
end
cd(S.subData);

%% Screen commands
S.screenNumber = max(Screen('Screens'));
S.screenColor = 224; 
S.textColor = 0;
S.textColorResp = 0;
S.endtextColor = 0;
S.font = 'Kannada Sangam MN';

if S.scanner == 2
    S.fontsize = 36;
elseif S.scanner == 1
    S.fontsize = 48;
end

[S.Window, S.myRect] = Screen(S.screenNumber, 'OpenWindow', S.screenColor, [], 32);
Screen('TextSize', S.Window, S.fontsize);
Screen('TextFont', S.Window, S.font);
Screen('TextStyle', S.Window, 1);
S.on = 1;  % Screen now on

%% Some other stuff (for shock)
[c] = getColors;

S.sessionStart = GetSecs;

%% Run Experiment Scripts
switch taskType
    
    % Run Item Test
    case 1
        for block_num = block % added to loop through all for behav
            listName = [subID '_itemTestList.txt'];
            saveName = [subID '_block' num2str(block_num) '_itemTest'];
            cat_saveName = [subID '_itemTest_cat']; % combines test data across blocks

            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Load in data from prev blocks
            try
                if block_num > 1
                    load(cat_saveName);
                    prevData = getPrevData(itemTestData, block_num);
                else
                    prevData = struct;
                end        
            catch err
                outputError(thePath.data, S.subData, err);
            end    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Run itemTest
            try
                [itemTestData(block_num), S] = sst_itemTest(thePath,listName,S,block_num,saveName,prevData);
            catch err
                outputError(thePath.data, S.subData, err);
            end
            
            % Save out concatenated data
            save(cat_saveName, 'itemTestData');
            Screen('Close'); % help comp memory
            
            % Save subj to group file after first block
            if block_num == 1
                cd(thePath.data);
                dataFile = fopen([S.study_name,'_subids.txt'], 'a');
                fprintf(dataFile,([subID,'\n']));
            end
            
            % Send email
            try
                if S.email == 1
                    sendmail(S.emailRecipient,[S.study_name ' Subject ',num2str(S.subID),' - Session completed'],...
                        ['Subject ',num2str(S.subID),' completed session ', ...
                        taskType_lab{taskType}, ' (Block ', num2str(block_num), ...
                        ') in ',num2str((GetSecs-S.sessionStart)/60),' minutes.']);
                end
            catch
                disp('Can''t send email');
            end
        end    

    % questionnaires
    case 2
        try
            % Trait/State Questionnaires
            S.Questgroup = ['post',num2str(1)]; % version of questionnaires
            S.QuestscaFlag = 0; % Have runQuest close screen and clear vars when done? (NO)
%             S.questionnaire_params = {'QSRparams', 'QSR2params'}; 
            S.questionnaire_params = {'QSRparams', 'QSR2params', 'BISBASparams','SMMparams','STAI_Tparams'}; % for end of task assessment
            [theData.Questp,theData.Questsession,theData.Questpars] = ...
                runQuestionnaires(S.questionnaire_params,S.study_name,num2str(S.subID),S.Questgroup,...
                S.screenNumber,S,S.QuestscaFlag,thePath);
        catch err
           %open file
           cd(thePath.data)
           fid = fopen('logFile.txt','a+');
           % write the error to file
           % first line: message
           fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'))

           % close file
           fclose(fid)                    
        end
        
    % Run Localizer Practice
    case 3
        listName = [subID '_locList_prac.txt'];
        saveName = [subID '_localizer_prac'];    
        
        S.restTime = 3; % between block rest
        S.leadIn = 1;
        S.leadOut = 1;
        
        % Run practice
        try
            localizer_task(thePath,listName,S,1,saveName,struct);
        catch err
            outputError(thePath.data, S.subData, err);
        end
        
    % Run Localizer Task
    case 4
        listName = [subID '_locList.txt'];
        cat_saveName = [subID '_localizer_cat']; % combines test data across blocks

        for block_num = block:2
            saveName = [subID '_block' num2str(block_num) '_localizer']; 

            % Load in data from prev blocks
            % If crashed on block 1, comment out this try statement, and
            % just specify:
%             prevData = struct;
            try
                if block_num > 1
                    load(cat_saveName);
                    prevData = getPrevData(localizerData, block_num);
                else
                    prevData = struct;
                end        
            catch err
                outputError(thePath.data, S.subData, err);
            end

            
            
            S.restTime = 10; % between block rest (fixation)
            S.leadIn = 12;
            S.leadOut = 12;
            
            % Run task
            try
                localizerData(block_num) = localizer_task(thePath,listName,S,block_num,saveName,prevData);
            catch err
                outputError(thePath.data, S.subData, err);
            end

            % Save out concatenated data
            save(cat_saveName, 'localizerData');
            Screen('Close');
        end   
end

Screen('TextSize', S.Window, S.fontsize);
Screen('TextFont', S.Window, S.font);
message = 'Press g to exit';
DrawFormattedText(S.Window,message,'center','center',S.endtextColor);
Screen(S.Window,'Flip');

% Send email
try
    if S.email == 1
        sendmail(S.emailRecipient,[S.study_name ' Subject ',num2str(S.subID),' - Session completed'],...
            ['Subject ',num2str(S.subID),' completed session ', taskType_lab{taskType},' in ',num2str((GetSecs-S.sessionStart)/60),' minutes.']);
    end
catch
    disp('Can''t send email');
end

clear screen;
Screen('Close')
cd(thePath.scripts);
