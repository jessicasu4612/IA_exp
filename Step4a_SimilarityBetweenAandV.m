clear;
addpath('.\Library\');
rng(2);

feature_path = ['.\Data\Feature\49Feature\'];

result_path = ['.\Data\featureDistribution\'];
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

% while ~feof(Vfid)
%     text_line = fgetl(Vfid);
%     pivot3 = strfind(text_line,'-');
%     stringIndex = num2str(str2num(text_line(1:pivot3-1))-2);
% %     pivot3 = strfind(text_line,'.xlsx');
% %     fileName = text_line(1:pivot3-1);
%     fileName = [text_line '-Victim'];
%     [victimFlick] = xlsread([feature_path fileName '_featuredata.xlsx'], 'userFlick');
%     [victimFeatureData] = xlsread([feature_path fileName '_featuredata.xlsx'], 'featuredata');
%     userRecord = [];
% 
% %     feature_num = 49;
% %     maxInterval = 0;
% %     for index = 1 : 49
% %         if maxInterval < upperbound(index,:) - lowerbound(index,:)/interval(index,:)
% %             maxInterval = ceil((upperbound(index,:) - lowerbound(index,:))/interval(index,:));
% %         end
% %     end
% %     victimDistribution = zeros(feature_num,maxInterval);
% %     victimDistribution(featureIndex,1:size(featureDistribution,2)) = featureDistribution;
%     
%     Afid = fopen("Data\Attacker_List.txt");
%     while ~feof(Afid)
%         attacker_text_line = fgetl(Afid);
%         attackerName = attacker_text_line;
%         attackerFileName = [text_line(1:pivot3) attacker_text_line '-Attacker-v3'];
%         [attackerFlick] = xlsread([feature_path attackerFileName '_featuredata.xlsx'], 'userFlick');
%         [attackerFeatureData] = xlsread([feature_path attackerFileName '_featuredata.xlsx'], 'featuredata');
%         userRecord = [];
%         diff = [];
% 
%         for featureIndex = 1:49
%             record = [];
%             temp = 0;
%             % collect victims data distribution
%             featureDistribution = zeros(1,ceil((upperbound(featureIndex,:) - lowerbound(featureIndex,:))/interval(featureIndex,:)) + 2 );
%             for dataIndex = 1:size(victimFeatureData(:,1))
%                 if victimFeatureData(dataIndex,featureIndex) < lowerbound(featureIndex,:)
%                     featureDistribution(1,1) = featureDistribution(1,1) + 1;
%                     if temp ~= [featureIndex victimFlick(dataIndex,6) 1]
%                         record = [record; featureIndex victimFlick(dataIndex,6) 1];
%                     end
%                     temp = [featureIndex victimFlick(dataIndex,6) 1];
%                 elseif victimFeatureData(dataIndex,featureIndex) > upperbound(featureIndex,:)
%                     featureDistribution(1,size(featureDistribution,2)) = featureDistribution(1,size(featureDistribution,2)) + 1;
%                     if temp ~= [featureIndex victimFlick(dataIndex,6) 2]
%                         record = [record; featureIndex victimFlick(dataIndex,6) 2];
%                     end
%                     temp = [featureIndex victimFlick(dataIndex,6) 2];
%                 else
%                     intervalIndex = 2;
%                     tempLowerbound = lowerbound(featureIndex,1);
%                     while~(tempLowerbound>upperbound(featureIndex,1))
%                         if victimFeatureData(dataIndex,featureIndex) >= tempLowerbound && victimFeatureData(dataIndex,featureIndex) < tempLowerbound + interval(featureIndex,1)
%                             featureDistribution(1,intervalIndex) = featureDistribution(1,intervalIndex) + 1;
%                             break;
%                         end
%                         tempLowerbound = tempLowerbound + interval(featureIndex,1);
%                         intervalIndex = intervalIndex + 1;
%                     end
%                 end
%             end
%             victimDistribution = featureDistribution(1,2:size(featureDistribution,2)-1);
% 
%             % collect attackers data distribution
%             record = [];
%             temp = 0;
%             featureDistribution = zeros(1,ceil((upperbound(featureIndex,:) - lowerbound(featureIndex,:))/interval(featureIndex,:)) + 2 );
%             for dataIndex = 1:size(attackerFeatureData(:,1))
%                 if attackerFeatureData(dataIndex,featureIndex) < lowerbound(featureIndex,:)
%                     featureDistribution(1,1) = featureDistribution(1,1) + 1;
%                     if temp ~= [featureIndex attackerFlick(dataIndex,6) 1]
%                         record = [record; featureIndex attackerFlick(dataIndex,6) 1];
%                     end
%                     temp = [featureIndex attackerFlick(dataIndex,6) 1];
%                 elseif attackerFeatureData(dataIndex,featureIndex) > upperbound(featureIndex,:)
%                     featureDistribution(1,size(featureDistribution,2)) = featureDistribution(1,size(featureDistribution,2)) + 1;
%                     if temp ~= [featureIndex attackerFlick(dataIndex,6) 2]
%                         record = [record; featureIndex attackerFlick(dataIndex,6) 2];
%                     end
%                     temp = [featureIndex attackerFlick(dataIndex,6) 2];
%                 else
%                     intervalIndex = 2;
%                     tempLowerbound = lowerbound(featureIndex,1);
%                     while~(tempLowerbound>upperbound(featureIndex,1))
%                         if attackerFeatureData(dataIndex,featureIndex) >= tempLowerbound && attackerFeatureData(dataIndex,featureIndex) < tempLowerbound + interval(featureIndex,1)
%                             featureDistribution(1,intervalIndex) = featureDistribution(1,intervalIndex) + 1;
%                             break;
%                         end
%                         tempLowerbound = tempLowerbound + interval(featureIndex,1);
%                         intervalIndex = intervalIndex + 1;
%                     end
%                 end
%             end
%             attackerDistribution = featureDistribution(1,2:size(featureDistribution,2)-1);
% 
% 
%             %比較受害者與攻擊者間的差異
%             % compare victims & attackers one feature distribution (similarity)
% %             difference = victimDistribution - attackerDistribution;
%             [p,h] = signrank(victimDistribution,attackerDistribution);
%             diff = [diff;h];
% %             userRecord = [userRecord; record];
%         end
% 
%         if not(isfolder([result_path attackerName '\']))
%             mkdir([result_path attackerName '\'])
%         end
%         xlswrite([result_path attackerName '\distributionResult.xlsx'],transpose(diff),'distributionResult',['A' stringIndex]);
%     end
% end

Afid = fopen("Data\Attacker_List.txt");
while ~feof(Afid)
    attacker_text_line = fgetl(Afid);
    [attackerFeature] = xlsread([result_path attacker_text_line '\distributionResult.xlsx'], 'distributionResult');
    count = attackerFeature(1,:);
    for index = 2:size(attackerFeature,1)
        count = count + attackerFeature(index,:);
    end
    selectedFeature = [];
    threshold = 3;
    for featureIndex = 1:49
        if count(1,featureIndex) <= threshold
            selectedFeature = [selectedFeature;featureIndex];
        end
    end
    xlswrite([result_path  '\selectedFeature.xlsx'],transpose(selectedFeature),attacker_text_line,['A1']);
end



