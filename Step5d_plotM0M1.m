clear;
rng(2);
addpath('.\Library\');

m0DataPath_hist = '.\Results\M0\histogram\';
m1DataPath_hist = '.\Results\M1\histogram\';
m0starDataPath_hist = '.\Results\M0star\histogram\';

result_path = '.\Results\';

%create folder if not exist
if(~exist([result_path 'Plot_M0M1'],'dir'))
    mkdir([result_path 'Plot_M0M1']);
end

%read list of victim
victim_list = {};
fid = fopen('.\Data\Victim_List.txt');
while ~feof(fid)
    text_line = fgetl(fid);
    victim_list = [victim_list; text_line];
end
fclose(fid);

%read list of attacker
attacker_list = {};
fid = fopen('.\Data\Attacker_List.txt');
while ~feof(fid)
    text_line = fgetl(fid);
    attacker_list = [attacker_list; text_line];
end
fclose(fid);

%to match the index of data required
victimShift = 0;
%index shift, because first user start from 3
indexShift = 2 + victimShift;
modelType = 0;

allM0AvgEER = [];
allM1AvgEER = [];
allM0starAvgEER = [];
for attackerCount = 1:size(attacker_list, 1)
    attackerName = cell2mat(attacker_list(attackerCount));
    histM0_totalEER = [];
    histM1_totalEER = [];
    histM0star_totalEER = [];
    histM0_avgEER = [];
    histM1_avgEER = [];
    histM0star_avgEER = [];

    x = [1:1:10];
    y = [1:1:5];
    fig_path = [result_path 'Plot_M0M1'];

    for victimCount = 1 + victimShift:size(victim_list, 1) + victimShift
        victimName = cell2mat(victim_list(victimCount - victimShift));
        fprintf('Plot for M0 & M1, Attacker:%s vs Victim :%s\n', attackerName, victimName);

        histM0_EER = xlsread([m0DataPath_hist attackerName '\' victimName '.xlsx'], 'EER');
        histM1_EER = xlsread([m1DataPath_hist attackerName '\' victimName '.xlsx'], 'EER');
        histM0star_EER = xlsread([m0starDataPath_hist attackerName '\' victimName '.xlsx'], 'EER');
        histM0_totalEER = [histM0_totalEER; histM0_EER];
        histM1_totalEER = [histM1_totalEER; histM1_EER];
        histM0star_totalEER = [histM0star_totalEER; histM0star_EER];
        histM0_avgEER = [histM0_avgEER; mean(histM0_EER, 2)];
        histM1_avgEER = [histM1_avgEER; mean(histM1_EER, 2)];
        histM0star_avgEER = [histM0star_avgEER; mean(histM0star_EER, 2)];


        % plot histogram M0 & M1 (one attacker vs one victim) (5 rounds)
        figure
        plot(y,histM0_EER(1,:),y,histM1_EER(1,:),y,histM0star_EER(1,:))
        title(['EER of hist M0,M1,M0* Attacker : ' attackerName ' Victim ' victimName])
        xlabel('index of victims')
        ylabel('EER')
        legend({'M0','M1','M0*'},'Location','northeast')
        set(gca, 'YGrid', 'on', 'XGrid', 'off')
        if(~exist([fig_path '\histogram\' attackerName '\'],'dir'))
            mkdir([fig_path '\histogram\' attackerName '\']);
        end
        saveas(gcf,[fig_path '\histogram\' attackerName '\' victimName],'png');
        close;
    end

    % plot histogram M0 & M1 (one attacker vs all victim avg EER) 
    figure
    plot(x,histM0_avgEER,x,histM1_avgEER,x,histM0star_avgEER)
    title('Hist M0,M1,M0* : Attacker ', attackerName)
    xlabel('index of victims')
    ylabel('EER')    
    legend({'M0','M1','M0*'},'Location','northeast')
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    saveas(gcf,[fig_path '\histogram\' attackerName],'png');
    close;

   allM0AvgEER =  [allM0AvgEER; histM0_avgEER];
   allM1AvgEER =  [allM1AvgEER; histM1_avgEER];
   allM0starAvgEER =  [allM0starAvgEER; histM0star_avgEER];
end
filePath = ['.\Results\'];
xlswrite([filePath 'M0EER.xlsx'], allM0AvgEER, 'M0EER');
xlswrite([filePath 'M1EER.xlsx'], allM1AvgEER, 'M1EER');
xlswrite([filePath 'M0satrEER.xlsx'], allM0starAvgEER, 'M0satrEER');
