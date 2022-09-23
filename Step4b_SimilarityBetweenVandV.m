clear;
addpath('.\Library\');
rng(2);

feature_path = ['.\Data\Feature\49Feature\'];

result_path = ['.\Data\featureDistribution\victims\'];
% create folder if not exist
if not(isfolder(result_path))
    mkdir(result_path)
end

%read list of filename
Vfid = fopen("Data\Victim_List.txt");
% Victim_List
% Attacker_List

[bindata,bintextdata] = xlsread([".\Data\binsize.xlsx"],'binsize');
selectedFeatureAll = [3:10 12 13 17:19 22 27 28 29:39 55:65 81:91];
lowerbound = bindata(selectedFeatureAll,3);
upperbound = bindata(selectedFeatureAll,4);
interval = bindata(selectedFeatureAll,5);
allDistribution = [];

victimList = [];
while ~feof(Vfid)
    text_line = fgetl(Vfid);
    string_line = convertCharsToStrings(text_line);
    victimList = [victimList; string_line];
end
% 
% columnIndex = 1;
% for index1 = 1:size(victimList,1)
%     victim1_name = [];
%     victim2_name = [];
% %     anotherVictimList = [];
% 
%     victim1_name = convertStringsToChars(victimList(index1,:));
%     victim1_file = [victim1_name '-Victim'];
%     [victim1_Flick] = xlsread([feature_path victim1_file '_featuredata.xlsx'], 'userFlick');
%     [victim1_FeatureData] = xlsread([feature_path victim1_file '_featuredata.xlsx'], 'featuredata');
% %     if index1 == 1
% %         anotherVictimList = [victimList(index1+1:size(victimList,1),:)];
% %     elseif index1 == size(victimList,1)
% %         anotherVictimList = [victimList(1:size(victimList,1)-1,:)];
% %     else
% %         anotherVictimList = [victimList(1:index1-1,:);victimList(index1+1:size(victimList,1),:)];
% %     end
% 
%     for index2 = 1+index1:size(victimList,1)
%         victim2_name = convertStringsToChars(victimList(index2,:));
%         victim2_file = [victim2_name '-Victim'];
%         [victim2_Flick] = xlsread([feature_path victim2_file '_featuredata.xlsx'], 'userFlick');
%         [victim2_FeatureData] = xlsread([feature_path victim2_file '_featuredata.xlsx'], 'featuredata');
%         
% %         對所有的features(1~49)
% %         依照feature的index讀取受害者1和受害者2的feature(轉換成hist型式)
% %         透過統計test比較兩者間的data distribution
%         diff = [];
%         for featureIndex = 1:49
%             % 讀取第一個受害者的data distribution(hist)
%             % collect victim 1 data distribution
%             featureDistribution = zeros(1,ceil((upperbound(featureIndex,:) - lowerbound(featureIndex,:))/interval(featureIndex,:)) + 2 );
%             for dataIndex = 1:size(victim1_FeatureData(:,1))
%                 if victim1_FeatureData(dataIndex,featureIndex) < lowerbound(featureIndex,:)
%                     featureDistribution(1,1) = featureDistribution(1,1) + 1;
%                 elseif victim1_FeatureData(dataIndex,featureIndex) > upperbound(featureIndex,:)
%                     featureDistribution(1,size(featureDistribution,2)) = featureDistribution(1,size(featureDistribution,2)) + 1;
%                 else
%                     intervalIndex = 2;
%                     tempLowerbound = lowerbound(featureIndex,1);
%                     while~(tempLowerbound>upperbound(featureIndex,1))
%                         if victim1_FeatureData(dataIndex,featureIndex) >= tempLowerbound && victim1_FeatureData(dataIndex,featureIndex) < tempLowerbound + interval(featureIndex,1)
%                             featureDistribution(1,intervalIndex) = featureDistribution(1,intervalIndex) + 1;
%                             break;
%                         end
%                         tempLowerbound = tempLowerbound + interval(featureIndex,1);
%                         intervalIndex = intervalIndex + 1;
%                     end
%                 end
%             end
%             victim1Distribution = featureDistribution(1,2:size(featureDistribution,2)-1);
%     
%     
%             % 讀取第二個受害者的data distribution(hist)
%             % collect victim 2 data distribution
%             featureDistribution = zeros(1,ceil((upperbound(featureIndex,:) - lowerbound(featureIndex,:))/interval(featureIndex,:)) + 2 );
%             for dataIndex = 1:size(victim2_FeatureData(:,1))
%                 if victim2_FeatureData(dataIndex,featureIndex) < lowerbound(featureIndex,:)
%                     featureDistribution(1,1) = featureDistribution(1,1) + 1;
%                 elseif victim2_FeatureData(dataIndex,featureIndex) > upperbound(featureIndex,:)
%                     featureDistribution(1,size(featureDistribution,2)) = featureDistribution(1,size(featureDistribution,2)) + 1;
%                 else
%                     intervalIndex = 2;
%                     tempLowerbound = lowerbound(featureIndex,1);
%                     while~(tempLowerbound>upperbound(featureIndex,1))
%                         if victim2_FeatureData(dataIndex,featureIndex) >= tempLowerbound && victim2_FeatureData(dataIndex,featureIndex) < tempLowerbound + interval(featureIndex,1)
%                             featureDistribution(1,intervalIndex) = featureDistribution(1,intervalIndex) + 1;
%                             break;
%                         end
%                         tempLowerbound = tempLowerbound + interval(featureIndex,1);
%                         intervalIndex = intervalIndex + 1;
%                     end
%                 end
%             end
%             victim2Distribution = featureDistribution(1,2:size(featureDistribution,2)-1);
% 
%             % 針對此features，比較兩個使用者間的data distribution
%             % compare one feature distribution (similarity) between victims
%             [p,h] = signrank(victim1Distribution,victim2Distribution);
%             % 紀錄兩個使用者間的所有features的比較結果
%             diff = [diff;h];
%         end        
% 
%         % 寫下所有受害者feature的data distribution表格
%         stringIndex = num2str(columnIndex);
%         xlswrite([result_path 'allVictimsDistribution.xlsx'],transpose(diff),'distributionResult',['A' stringIndex]);
%         columnIndex = columnIndex + 1;
% 
%     end
% end



% 依據上面寫下之表格，統計並挑選出與其他victim相似度高的features(t暫時=0.3)

selectResult_path = ['.\Data\featureDistribution\'];
[victimFeature] = xlsread([result_path 'allVictimsDistribution.xlsx'], 'distributionResult');
comparisonCount = size(victimList,1)*(size(victimList,1)-1)/2;
count = victimFeature(1,:);
for index2 = 2:size(victimFeature,1)
    count = count + victimFeature(index2,:);
end

removeFeature = [];
threshold1 = round(0.3*comparisonCount);

for featureIndex = 1:49
    if count(1,featureIndex) <= threshold1
        removeFeature = [removeFeature;featureIndex];
    end
end
xlswrite([selectResult_path 'victimsFeature.xlsx'],transpose(removeFeature),'removeFeature',['A1']);


% 依據上面寫下之表格，統計並挑選出與其他victim相似度低的features(t暫時=0.8)

selectedFeature = [];
threshold2 = round(0.6*comparisonCount);

for featureIndex = 1:49
    if count(1,featureIndex) >= threshold2
        selectedFeature = [selectedFeature;featureIndex];
    end
end
xlswrite([selectResult_path 'victimsFeature.xlsx'],transpose(selectedFeature),'selectedFeature',['A1']);



