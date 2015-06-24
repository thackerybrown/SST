function [itemTestData] = sst_behavAnalysis_itemtest(subID)
% Outputs trial information for each itemTest run
[~,thePath] = setupScript();

% Load in mat file
cd(fullfile(thePath.data,subID));
itemTestMat = [subID '_itemTest_cat.mat'];
load(itemTestMat);
nRuns = size(itemTestData,2);
trialsPerRun = 12;
numItems = 3;

% Create txt file
itemTestTxt = [subID '_behav_itemTest.csv'];
% fid = fopen(itemTestTxt,'wt');
fid = fopen(itemTestTxt,'wt');
fprintf(fid, 'index,run,trial,onset,duration,town,pic,itemNum,resp,respRT\n');
formatString = '%d,%d,%d,%.4f,%.4f,%s,%s,%d,%s,%.4f\n';

counter = 1;
for run = 1:nRuns
    for t = 1:trialsPerRun
        
        trial = t;
        onset = itemTestData(run).onset(t);
        dur = itemTestData(run).dur(t);
        town = itemTestData(run).imgID{t};
        pic = itemTestData(run).imgFile{t};
        
        % behavioral
        for itemNum = 1:numItems
            resp = eval(['itemTestData(run).stimResp', num2str(itemNum),'{t}']);
            respRT = eval(['itemTestData(run).stimRT', num2str(itemNum),'{t}']);
            
            %index,run,trial,onset,duration,town,pic,resp,respRT
            fprintf(fid, formatString, counter, run, trial, onset, dur, town, pic, itemNum,resp, respRT);
            counter = counter + 1;
        end


    end
end

cd(thePath.data);

end