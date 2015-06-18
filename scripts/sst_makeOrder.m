function sst_makeOrder(subID,thePath)

%% initialize rand.
rng('shuffle');

%% Load in the stimulus list
[~,TXT,~] = xlsread('inputlist_itemTest.xls');

num_towns = 12;

imgID = TXT(2:num_towns+1,1);
imgFile = TXT(2:num_towns+1,3);

% Create the order
T.index = 1:length(imgID);

stimOrder = T.index;
T.imgID = imgID(stimOrder);
T.imgFile = imgFile(stimOrder);

%% Save stims to subdir (create if needed)
cd(thePath.orderfiles);
subDir = fullfile(thePath.orderfiles, [subID]);
if ~exist(subDir)
   mkdir(subDir);
end
cd(subDir);

eval(['save ' subID '_stims T']);

%% now make text file with the full list
txtName = [subID '_itemTestList.txt'];
fid = fopen(txtName, 'wt');
fprintf(fid, 'index\timgID\timgFile\n');
for e = 1:length(T.index)
    fprintf(fid, '%d\t%s\t%s\n',...
        T.index(e), T.imgID{e}, T.imgFile{e});
end


