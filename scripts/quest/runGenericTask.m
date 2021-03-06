function [results] = runGenericTask(wPtr,deviceNum,expParams,params)

bg = expParams.bkgd;
tx = expParams.txtColor;

res = expParams.res;

p.alloutdir = 'output_files';   % ALL results files will save here

qWidth=min(size(expParams.Qs));

if ~isfield(expParams,'instrTxSize')
    if qWidth > 1
        instrTxSize = 26;
    else
        instrTxSize = 30;
    end
else
    instrTxSize = expParams.instrTxSize;
end

if ~isfield(expParams,'promptTxSize')
    promptTxSize = 26;   % ALL results files will save here
else
    promptTxSize = expParams.promptTxSize;
end

if ~isfield(expParams,'qTxSize')
    qTxSize = 36;   % ALL results files will save here
else
    qTxSize = expParams.qTxSize;
end

if ~isfield(expParams,'instrWrap')
    instrWrap = 90;   % ALL results files will save here
else
    instrWrap = expParams.instrWrap;
end

if ~isfield(expParams,'qxPos')
%     qxPos = 'center';  
    qxPos = round(res(1)*0.1);  
else
    qxPos = expParams.qxPos;
end

if ~isfield(expParams,'rWrap')
    rWrap = 14;   % ALL results files will save here
else
    rWrap = expParams.rWrap;
end


if ~isfield(params,'alloutdir')
    params.alloutdir = 'output_files';   % ALL results files will save here
end

if ~isfield(expParams,'rNumShift')
    expParams.rNumShift = 0;  % shift numeric scale leftward by this # (e.g., 1 shifts 1-7 scale to 0-6)
end

if ~isfield(params,'pcFontAdj')
    params.pcFontAdj = 0;   
end
if ~isfield(params,'LjustMult')
    params.LjustMult = 0.1;   
end

params.deviceNum = deviceNum;

params.responseOptions = expParams.scaleOptions;
params.responseChoices = length(expParams.scaleOptions);   % Likert scale


% LineCoords = [(res(1)*.115),(res(1)*.885),0.76*res(2),0.78*res(2)]; % [x_start x_end y_start y_end]
LineCoords = [(res(1)*.115),(res(1)*.885),0.7*res(2),0.78*res(2)]; % [x_start x_end y_start y_end]


% Let's get started
Screen('FillRect',wPtr,bg);
Screen('Flip',wPtr);

Screen('TextSize',wPtr,instrTxSize-params.pcFontAdj); %%%%%%%%%%%%%%

if qWidth >1
    SG_DrawFormattedText(wPtr,expParams.instructions,res(1)*params.LjustMult,'center',tx,instrWrap+10,1.5);
else
    SG_DrawFormattedText(wPtr,expParams.instructions,res(1)*params.LjustMult,'center',tx,instrWrap,1.5);
end

Screen('TextSize',wPtr,28-params.pcFontAdj); %%%%%%%%%%%%%%

HideCursor;

if ~expParams.analog || qWidth >1
    textContent = 'Please press any key to continue...';
    [textFrame] = Screen('TextBounds', wPtr, textContent);
    textWidth = textFrame(3);
    if qWidth >1
        Screen('TextSize',wPtr,24-params.pcFontAdj); %%%%%%%%%%%%%%
        SG_DrawFormattedText(wPtr,textContent,round(res(1)*0.9-textWidth),round(res(2)*0.9),tx,70,1.25);
        Screen('TextSize',wPtr,28-params.pcFontAdj); %%%%%%%%%%%%%%
    else
        SG_DrawFormattedText(wPtr,textContent,round(res(1)*0.9-textWidth),round(res(2)*0.9),tx,70,1.25);
    end
    Screen('Flip',wPtr);
    WaitSecs(0.75);
    KbWait(params.deviceNum);
%     KbWait(-1);
    
else
    textContent = 'Please click the mouse button to continue...';
    [textFrame] = Screen('TextBounds', wPtr, textContent);
    textWidth = textFrame(3);
    SG_DrawFormattedText(wPtr,textContent,round(res(1)*0.9-textWidth),round(res(2)*0.9),tx,70,1.25);
    Screen('Flip',wPtr);
    WaitSecs(0.75);
    GetClicks(wPtr);
end

centerX = expParams.screenRect(3)/2; % x center of main window
centerY = expParams.screenRect(4)/2; % y center of main window
mainRes = Screen('Resolution', params.screenNumber); 
mainX = mainRes.width;

% pixPerChar = 17;
pixPerChar = 6;

if isempty(expParams.prompt) || length(expParams.prompt)<5
    qMultY = 0.3;
    expParams.prompt = ' ';
else
    qMultY = 0.5;
end

if iscell(expParams.prompt)
    multiPromptFlag = 1;
    tmpPrompts = expParams.prompt;
else
    multiPromptFlag = 0;    
end

%% RunTrial:

for trial=1:length(expParams.Qs)
    results.scalePath{trial} = [];
    
    % If multiple different prompts, assigning to each question based on
    % promptInds variable:
    if multiPromptFlag
        expParams.prompt = tmpPrompts{expParams.promptInds(trial)};
    end

    
    for wi = 1:qWidth   % going through width of question cell array in case there are multiple screens per Q

        Screen('TextSize',wPtr,promptTxSize-params.pcFontAdj);
        SG_DrawFormattedText(wPtr,expParams.prompt,'center',round(res(2)*0.25),tx,55);

        if qWidth==1
            Screen('TextSize',wPtr,qTxSize-params.pcFontAdj);
            if isfield(expParams,'Qjustify')
                if strcmp(expParams.Qjustify,'center')
                    SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},expParams.Qjustify,'center',tx,instrWrap, 1.5);
                else
                    SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},round(res(1)*expParams.Qjustify),'center',tx,instrWrap, 1.5);
                end
            else

                SG_DrawFormattedText(wPtr,expParams.Qs{trial},qxPos,round(res(2)*qMultY),tx,instrWrap, 1.5);
            end
        else
            Screen('TextSize',wPtr,qTxSize-params.pcFontAdj);
%             SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},'center',round(res(2)*qMultY),tx,50, 1.5);

            if wi<qWidth

                if isfield(expParams,'Qjustify')
                    if strcmp(expParams.Qjustify,'center')
                        SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},expParams.Qjustify,'center',tx,instrWrap, 1.5);
                    else
                        SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},round(res(1)*expParams.Qjustify),'center',tx,instrWrap, 1.5);                        
                    end
                else
                    SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},round(res(1)*params.LjustMult),'center',tx,instrWrap, 1.5);
                end
                
                HideCursor;
                Screen(wPtr, 'Flip');
                scrStart = GetSecs;
                WaitSecs(0.75);
%                 KbWait(-1);
                KbWait(params.deviceNum);
                results.RT(trial,wi) = GetSecs - scrStart;
            else
                SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},'center','center',tx,instrWrap, 1.5);
            end
        end

        if qWidth==wi   % last "Q" per trial

            for r=1:params.responseChoices
                %             spaceInterval = 0.94*res(1) - 0.05*res(1);
                spaceInterval = 0.885*res(1) - 0.115*res(1);
                xval = 0.115*res(1) + (r-1)*(spaceInterval/(params.responseChoices-1));

                if ~expParams.analog
                    Screen('TextSize',wPtr, 32-params.pcFontAdj);
                    textContent = num2str(r) - expParams.rNumShift;
% %                     find(expParams.scaleOptions{1}=='\')
                    [textFrame] = Screen('TextBounds', wPtr, textContent);
                    textWidth = textFrame(3);
                    if expParams.drawLine
                        DrawFormattedText(wPtr,textContent,round(xval - textWidth/2),(0.8*res(2)),tx,12);
%                         DrawFormattedText(wPtr,textContent,round(xval - textWidth/2),(0.5*res(2)),tx,12);
                    else
%                         ydim = (0.73*res(2));
                        ydim_val_scale = 0.6;
                        ydim_val = (ydim_val_scale*res(2));
                        if qWidth >1    % HACK to deal with shifted scale ends in MJ
                            DrawFormattedText(wPtr,textContent,xval-textWidth/5,ydim_val,tx,12);
                        else
                            DrawFormattedText(wPtr,textContent,round(xval - textWidth/2),ydim_val,tx,12);
                        end
                    end
                    Screen('TextSize',wPtr, 20-params.pcFontAdj);
                    textContent = params.responseOptions{r};
                    textLine1ind = find(textContent=='\');
                    if ~isempty(textLine1ind)
                        textLine1 = textContent(1:textLine1ind(1)-1);
                    else
                        textLine1 = textContent;
                    end
                    [textFrame] = Screen('TextBounds', wPtr, textLine1);
                    textWidth = textFrame(3);
                    textWidth = round(min([16*pixPerChar,textFrame(3)]));

%                     textWidth = min([8*pixPerChar,textFrame(3)]);
%                     textWidth = 13*pixPerChar;
                    if expParams.drawLine
                        DrawFormattedText(wPtr,textContent,round(xval - textWidth/2),round(0.87*res(2)),tx,rWrap);
                    else
                        ydim_txt_scale = ydim_val_scale + .09; %.82 default
                        ydim_txt = (ydim_txt_scale*res(2));
                        DrawFormattedText(wPtr,textContent,round(xval - textWidth/2),round(ydim_txt),tx,rWrap);
                    end
                else
                    ShowCursor;
                    Screen('TextSize',wPtr, 20-params.pcFontAdj);
                    textContent = params.responseOptions{r};
                    [textFrame] = Screen('TextBounds', wPtr, textContent);
                    textWidth = textFrame(3);
                    textWidth = round(min([16*pixPerChar,textFrame(3)]));
                    if qWidth >1    % HACK to deal with shifted scale ends in MJ
                        DrawFormattedText(wPtr,textContent,round(xval - textWidth/4),round(0.82*res(2)),tx,12);
                    else
                        DrawFormattedText(wPtr,textContent,round(xval - textWidth/2),round(0.82*res(2)),tx,12);
                    end

                end

            end
            if expParams.drawLine
                %             LineCoords = [(res(1)*.115),(res(1)*.885),0.76*res(2),0.78*res(2)]; % [x_start x_end y_start y_end]
                Screen('DrawLine',wPtr,tx,LineCoords(1),mean([LineCoords(3),LineCoords(4)]),LineCoords(2),mean([LineCoords(3),LineCoords(4)]), 5);
                Screen('DrawLine',wPtr,tx,LineCoords(1),LineCoords(4),LineCoords(1),LineCoords(3), 5);
                Screen('DrawLine',wPtr,tx,LineCoords(2),LineCoords(4),LineCoords(2),LineCoords(3), 5);
                if ~expParams.omitMidLine
                    Screen('DrawLine',wPtr,tx,mean([LineCoords(1),LineCoords(2)]), LineCoords(4),mean([LineCoords(1),LineCoords(2)]),LineCoords(3), 5);
                end
            end

            Screen(wPtr, 'Flip');
            if ~expParams.analog
                WaitSecs(expParams.preRTwait);
            end

            if expParams.analog
                moveStart = GetSecs;
                %         ShowCursor(expParams.analogCursor);
                if IsOSX
                    SetMouse(centerX, centerY+70,wPtr);
                else
                    SetMouse(centerX+mainX, centerY+70); % width of main screen + the 2nd one.
                end
                ShowCursor(0);
                onScale = 0;    % Has cursor made it to scale area?

                while (1) % track movement
                    [theX, theY, buttons] = GetMouse(wPtr);
                    Screen('FillRect',wPtr,bg);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    Screen('TextSize',wPtr,promptTxSize-params.pcFontAdj);
                    DrawFormattedText(wPtr,expParams.prompt,'center',round(res(2)*0.25),tx,70);

                    if qWidth==1
                        Screen('TextSize',wPtr,qTxSize-params.pcFontAdj);
                        SG_DrawFormattedText(wPtr,expParams.Qs{trial},qxPos,round(res(2)*qMultY),tx,50, 1.5);
                    else
                        Screen('TextSize',wPtr,qTxSize-params.pcFontAdj);
%                         SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},'center',round(res(2)*qMultY),tx,60, 1.5);
                        SG_DrawFormattedText(wPtr,expParams.Qs{trial,wi},'center','center',tx,45, 1.5);
                    end
                    % % Screen('DrawTexture', wPtr, MtextureIndex);

                    for r=1:params.responseChoices
                        %             spaceInterval = 0.94*res(1) - 0.05*res(1);
                        spaceInterval = 0.885*res(1) - 0.115*res(1);
                        xval = 0.115*res(1) + (r-1)*(spaceInterval/(params.responseChoices-1));

                        Screen('TextSize',wPtr, 20-params.pcFontAdj);
                        textContent = params.responseOptions{r};
                        [textFrame] = Screen('TextBounds', wPtr, textContent);
                        textWidth = textFrame(3);
                        textWidth = min([16*pixPerChar,textFrame(3)]);
                        if qWidth >1    % HACK to deal with shifted scale ends in MJ
                            DrawFormattedText(wPtr,textContent,round(xval-textWidth/4),(0.82*res(2)),tx,12);
                        else
                            DrawFormattedText(wPtr,textContent,round(xval - textWidth/2),(0.82*res(2)),tx,12);
                        end
                    end
                    if expParams.drawLine
                        %             LineCoords = [(res(1)*.115),(res(1)*.885),0.76*res(2),0.78*res(2)]; % [x_start x_end y_start y_end]
                        Screen('DrawLine',wPtr,tx,LineCoords(1),mean([LineCoords(3),LineCoords(4)]),LineCoords(2),mean([LineCoords(3),LineCoords(4)]), 5);
                        Screen('DrawLine',wPtr,tx,LineCoords(1),LineCoords(4),LineCoords(1),LineCoords(3), 5);
                        Screen('DrawLine',wPtr,tx,LineCoords(2),LineCoords(4),LineCoords(2),LineCoords(3), 5);
                        if ~expParams.omitMidLine
                            Screen('DrawLine',wPtr,tx,mean([LineCoords(1),LineCoords(2)]), LineCoords(4),mean([LineCoords(1),LineCoords(2)]),LineCoords(3), 5);
                        end
                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    if ~onScale
                        if ((theY>LineCoords(3) && theY<LineCoords(4)) && ((theX>LineCoords(1) && theX<LineCoords(2))))
                            HideCursor;
                            onScale = 1;
                            Screen('DrawLine',wPtr,tx,theX, LineCoords(4),theX,LineCoords(3), 8);
                            theRealX = theX;    % X bounded by scale ends
                        end
                    else
                        if theX<LineCoords(1)
                            theRealX=LineCoords(1);
                        elseif theX>LineCoords(2)
                            theRealX=LineCoords(2);
                        else
                            theRealX = theX;    % X bounded by scale ends
                        end

                        if isempty(results.scalePath{trial})
                            results.scaleStartRate(trial) = theRealX;
                            results.scaleStartTime(trial) = GetSecs-moveStart;                            
                            results.scalePath{trial} = [results.scalePath{trial} theRealX];
                            nextCheck = GetSecs+0.01;
                        elseif GetSecs>nextCheck
                            results.scalePath{trial} = [results.scalePath{trial} theRealX];
                            nextCheck = GetSecs+0.01;
                        end
     
                        
                        Screen('DrawLine',wPtr,tx,theRealX, LineCoords(4),theRealX,LineCoords(3), 8);

                        if buttons(1)       % clicked on scale
                            curRate = (theRealX - LineCoords(1))/(LineCoords(2) - LineCoords(1));
                        end
                    end

                    if buttons(1)       % clicked on scale
                        if ((theY>LineCoords(3) && theY<LineCoords(4)) && ((theX>LineCoords(1) && theX<LineCoords(2)))) || onScale
                            if theX<LineCoords(1)
                                theRealX=LineCoords(1);
                            elseif theX>LineCoords(2)
                                theRealX=LineCoords(2);
                            else
                                theRealX = theX;    % X bounded by scale ends
                            end
                            curRate = (theRealX - LineCoords(1))/(LineCoords(2) - LineCoords(1));
                            break;
                        end
                    end
                    %             else
                    %                 ShowCursor(0);
                    Screen(wPtr, 'Flip');

                end

                results.Rating(trial) = curRate;
                                
                if isempty(results.scalePath{trial})
                    results.maxScalePt(trial) = curRate; results.minScalePt(trial) = curRate; results.scaleStartRate(trial) = curRate;
                else
                    results.maxScalePt(trial) = (max(results.scalePath{trial}) - LineCoords(1))/(LineCoords(2) - LineCoords(1));
                    results.minScalePt(trial) = (min(results.scalePath{trial}) - LineCoords(1))/(LineCoords(2) - LineCoords(1));
                    results.scaleStartRate(trial) = (results.scaleStartRate(trial) - LineCoords(1))/(LineCoords(2) - LineCoords(1));
                end
                % REVERSED SIGN for 0806 and 17715 (fixed 6/11/09):
                results.RT(trial,wi) = GetSecs - moveStart;

            else
                rArray = [1:params.responseChoices] - expParams.rNumShift;
                [results.Rating(trial),results.RT(trial)] = SG_collectResponse(expParams.maxRT,params.deviceNum,rArray); %rArray in [].
                results.RT(trial,wi) = results.RT(trial) + expParams.preRTwait;
            end
        end

        Screen('FillRect',wPtr,bg);
        % % Screen('TextSize',wPtr,30-params.pcFontAdj);
        % % DrawFormattedText(wPtr,'+','center','center',tx);
        Screen(wPtr, 'Flip');

%         save(fullfile(params.alloutdir,expParams.outfile),'results','expParams');

    end
end


if iscell(expParams.prompt)
    expParams.prompt = tmpPrompts;
end

Screen('FillRect',wPtr,bg);
Screen(wPtr, 'Flip');
WaitSecs(0.5);



