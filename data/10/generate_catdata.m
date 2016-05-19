
subID = '10';

itemTestData = []
for block_num =1:5
    saveName = [subID '_block' num2str(block_num) '_itemTest'];
    load(saveName);
    
    itemTestData = [itemTestData, theData];
end


 cat_saveName = [subID '_itemTest_cat'];
 save(cat_saveName, 'itemTestData');
