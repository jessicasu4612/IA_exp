clear;
addpath('.\Library\');
rng(2);

feature_path = ['.\Data\featureDistribution\'];

result_path = ['.\Data\featureDistribution\'];
% create folder if not exist
if not(isfolder(result_path))
    mkdir(result_path)
end

[removeFeature] = xlsread([feature_path  'victimsFeature.xlsx'], 'removeFeature');
numofRemoval = size(removeFeature,2);

fid = fopen("Data\Attacker_List.txt");
while ~feof(fid)
    attacker_text_line = fgetl(fid);
    [initialFeature] = xlsread([feature_path  'selectedFeature.xlsx'], attacker_text_line);
    
    for index1 = 1:numofRemoval
        for index2 = 1:size(initialFeature,2)
            if initialFeature(1,index2) == removeFeature(1,index1)
                initialFeature(1,index2) = 0;
            end
        end 
    end

    % save the final selected weak feature
    finalFeature = initialFeature(find(initialFeature>0));
    xlswrite([result_path 'tempSelected.xlsx'],finalFeature,attacker_text_line,['A1']);
end


