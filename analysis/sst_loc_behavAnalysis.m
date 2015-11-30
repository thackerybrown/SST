function [locData] = sst_loc_behavAnalysis(subID)
% Outputs trial information for each freeresp run
[S,thePath] = setupScript();

% Load in mat file
currDir = pwd;
cd(fullfile(thePath.data,subID));
locMat = [subID '_localizer_cat.mat'];
load(locMat);
nRuns = size(localizerData,2);
locData = localizerData(nRuns); % change!

% Determine response group & mappings for each category
locBlock1 = [subID '_block1_localizer.mat'];
block1 = load(locBlock1);
respMap = block1.S.respMap;

if respMap == 1
    respCodes = {'0', '1'}; % diff, same
elseif respMap == 2
    respCodes = {'1', '0'}; % same, diff
end

% Determine accuracy
totalTrials = length(locData.onset);
trialsPerRun = totalTrials/nRuns; %220


% locData.respOpts = {'1!', '2@'}; % if subj gets the wrong keys!
locData.respOpts = {'2@', '3#'};

for t = 1:totalTrials 
    if locData.onset(t) > 0
        
        % Determine respCodes for this trial (based on type)
        subcond = locData.cond{t};
        
        if ~strcmp(subcond, 'rest')

            % convert button box resp during stim presentation to cond code
            % (if made more than one resp, take *LAST* resp)
            locData.stimCodedResp{t} = codeBehavResp(locData.stimResp{t}, respCodes, locData.respOpts, 'last');

            % if made more than one resp during stim presentation, take *LAST* RT
            locData.stimRT{t} = locData.stimRT{t}(end);


            % convert button box resp during ISI to cond code
            % (if made more than one resp, take *FIRST* resp)
            locData.isiCodedResp{t} = codeBehavResp(locData.isiResp{t}, respCodes, locData.respOpts, 'first');


            % if made more than one resp during ISI, take *FIRST* RT
            locData.isiRT{t} = locData.isiRT{t}(1);


            % depending on resp, determine accuracy
            if strcmp(locData.stimCodedResp(t), num2str(locData.rep(t)))
                locData.acc{t} = 1; % hit
            else
                locData.acc{t} = 0; % miss
            end

            % responses during ISI
            if strcmp(locData.isiCodedResp(t), num2str(locData.rep(t)))
                locData.ISIacc{t} = 1; % hit
            else
                locData.ISIacc{t} = 0; % miss
            end
            
            
        else % rest trial
            
            % Add this in to deal with trigger ts
            locData.stimCodedResp{t} = codeBehavResp(locData.stimResp{t}, respCodes, locData.respOpts, 'last');
            locData.stimRT{t} = locData.stimRT{t}(end);
            locData.isiCodedResp{t} = codeBehavResp(locData.isiResp{t}, respCodes, locData.respOpts, 'first');
            locData.isiRT{t} = locData.isiRT{t}(1);
            
            locData.acc{t} = 1;
            locData.ISIacc{t} = 1;
        
        end   
    end   
end

% Save new mat file with accuracy info
save([subID '_test_cat_acc.mat'],'locData');

% Create txt file
freerespTxt = [subID '_behav_localizer.csv'];
fid = fopen(freerespTxt,'wt');
fprintf(fid, ['index,run,trial,onset,duration,cond,rep,',...
    'resp,acc,respRT,ISIresp,ISIacc,ISIrespRT\n']);
formatString = ['%d,%d,%d,%.4f,%.4f,%s,%d,%s,%d,%.4f,%s,%d,%.4f\n'];


for t = 1:totalTrials
    if locData.onset(t) > 0
        run = locData.block(t);
        trial = t - trialsPerRun*(run - 1);
        onset = locData.onset(t);
        dur = locData.dur(t);
        cond = locData.cond{t};
        rep = locData.rep(t);
        resp = locData.stimCodedResp{t};
        acc = locData.acc{t};
        respRT = locData.stimRT{t};
        isiResp = locData.isiCodedResp{t};
        isiAcc = locData.ISIacc{t};
        isiRespRT = locData.isiRT{t};
        
        fprintf(fid, formatString, t, run, trial, onset, dur, cond, rep,...
            resp, acc, respRT, isiResp, isiAcc, isiRespRT);
    end    
end

cd(currDir);

end
