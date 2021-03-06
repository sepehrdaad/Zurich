% the version that works
% info_summary_ZSCORE
% info_summary_190520
clear all
info_summary_ExtraVirgin


 NUMBEROFCLUSTER = 1
  %  250520 CIAO
%  mask_ciao = [1 2 3 4 11 14 15 17]
mask_ciao= [1 2 3 4 11 12 13 14 15 16 17] %% TO BE CHANGED excluding SA for low performance


  
 
%  mask_ciao = [1 2 3 7 12 13 15 17]
%  mask_ciao = [1 2 3 ]
 mask_sign = ones(1,20);

%  mask_sign([4 6 8 10 11 14 16]) = -1; %if commented flipping is not applied 

 % This similiar to the original version I used which had polarity problem ( and for
 % predefense)
 
 
 
 
 
 
 
 
 
 
 
%  from cluster

% mask_ciao = [1 2 3 17]
%  mask_sign = ones(1,20);
%  mask_sign([4 8 9 10 11 16]) = -1; %if commented flipping is not applied 
% %  This one Gives Blueee

%  mask_sign([ 2 4 7 8 10 14 17]) = -1 % V3

for session = 2 % should become a FOR
        
        switch session
            case 1
                % Encoding
               
                folderfiles_save = folderfiles_Enc_save;
%                  load clusterEnc.mat
                 %to delete channels
%                  cluster{1,1}(mask_ciao,:)=[];
%                  mask_sign(mask_ciao )=[];
                 
%                  cluster = xlswrite('C:\Users\Sep\Desktop\Kingdom\Word and Excel Files\regions2.xlsx','Hipp Region For Cluster','A1:E27')

                
            case 2
                % Retrieval
                  load ClusterRet.mat
                folderfiles_save = folderfiles_Ret_save;
                   cluster{1,1}(mask_ciao,:)=[];
                 mask_sign(mask_ciao )=[];
                 
        end

%% read out and prepare for stats

clear tl*
tl_CorrAss.trial    = [];
tl_IncorrAss.trial  = [];
tl_Miss.trial       = [];


for cl = NUMBEROFCLUSTER%:length(cluster)
    
    tr_end1 = 1
    tr_end2 = 1
    tr_end3 = 1
    
    % pick subject
    
    for elem = 1:size(cluster{1,cl},1)
        
        id = round(cluster{1,cl}(elem,4)*1000);
        ch = round(cluster{1,cl}(elem,5)*1000);
        
        for cond = 3:5
            
            switch cond
                case 3
                    load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')
                    fs = 1/(data.time{1,1}(2)-data.time{1,1}(1));
                    for tr = 1:length(data.trial)
                          tl_CorrAss.trial(tr_end1,1,:) = mask_sign(elem)*data.trial{1,tr}(ch,:);
                        tr_end1 = 1+ tr_end1;
                         
                    end
                    tl_CorrAss.time    = data.time{1,1}(1,:);
                    tl_CorrAss.history.label{elem,1}    = [char(subj_ID(id)) '  ' char(data.label(ch))];
                    tl_CorrAss.history.trials( elem,1)    = tr;
                    tl_CorrAss.history.anatomy{elem,1}   = data.anatomy{ch,:};
                    tl_CorrAss.label{1} = ['cluster' num2str(cl)];
                    tl_CorrAss.fsample   = fs;
                    tl_CorrAss.dimord    = 'rpt_chan_time';
                    
                case 4
                    load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')
                     for tr = 1:length(data.trial)
                        tl_IncorrAss.trial(tr_end2,1,:) = mask_sign(elem)*data.trial{1,tr}(ch,:);
                        tr_end2 = 1+ tr_end2;
                    end
                    tl_IncorrAss.time    = data.time{1,1}(1,:);
                    tl_IncorrAss.history.label{elem,1}    = [char(subj_ID(id)) '  ' char(data.label(ch))];
                    tl_IncorrAss.history.trials( elem,1)    = tr;
                    tl_IncorrAss.history.anatomy{elem,1}   = data.anatomy{ch,:};
                    tl_IncorrAss.label{1} = ['cluster' num2str(cl)];
                    tl_IncorrAss.fsample   = fs;
                    tl_IncorrAss.dimord    = 'rpt_chan_time';
                    
                case 5
                    load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')
                      for tr = 1:length(data.trial)
                        tl_Miss.trial(tr_end3,1,:) = mask_sign(elem)*data.trial{1,tr}(ch,:);
                        tr_end3 = 1+ tr_end3;
                      end
                     tl_Miss.time         = data.time{1,1}(1,:);
                   tl_Miss.history.label{elem,1}    = [char(subj_ID(id)) '  ' char(data.label(ch))];
                    tl_Miss.history.trials( elem,1)    = tr;
                    tl_Miss.history.anatomy{elem,1}   = data.anatomy{ch,:};
                    tl_Miss.label{1} = ['cluster' num2str(cl)];
                    tl_Miss.fsample   = fs;
                    tl_Miss.dimord    = 'rpt_chan_time';
                    
                  
            end
            
            

        end
    end
     
%     iterative_cluster_plot
end
cfg =[]

hit = ft_appenddata(cfg, tl_CorrAss, tl_IncorrAss)
for tr = 1:length(hit.trial)
    tl_CorrAss.trial(tr,1,:) = hit.trial{1,tr}(1,:);
end


%%            
            cfg = [];
            cfg.method = 'montecarlo';       % use the Monte Carlo Method to calculate the significance probability
            cfg.statistic = 'ft_statfun_indepsamplesT'; % use the independent samples T-statistic as a measure to
            % evaluate the effect at the sample level
            cfg.correctm = 'cluster';
            cfg.clusteralpha = 0.05;         % alpha level of the sample-specific test statistic that
            % will be used for thresholding
            cfg.clusterstatistic = 'maxsum'; % test statistic that will be evaluated under the
            % permutation distribution.
            cfg.minnbchan = 0;               % minimum number of neighborhood channels that is
            % required for a selected sample to be included
            % in the clustering algorithm (default=0).
            % cfg.neighbours = neighbours;   % see below
            cfg.tail = 0;                    % -1, 1 or 0 (default = 0); one-sided or two-sided test
            cfg.clustertail = 0;
            cfg.alpha = 0.05;               % alpha level of the permutation test
            cfg.numrandomization = 1000 ;      % number of draws from the permutation distribution
            
            
            cfg.ivar  = 1;                   % number or list with indices indicating the independent variable(s)
            
            %%
            
            cfg.channel       = tl_CorrAss.label;     % cell-array with selected channel labels
            cfg.latency       = [0 2];       % time interval over which the experimental
            % conditions must be compared (in seconds)
            
            for ch = 1
                
                neighbours(ch).label = char(tl_CorrAss.label);
                neighbours(ch).neighblabel = {''};
            end
            cfg.neighbours    = neighbours;  % the neighbours specify for each sensor with
            
            % corrASS vs incorrAss
%             design = zeros(1,size(tl_CorrAss.trial,1) + size(tl_IncorrAss.trial,1)  );
%             design(1,1:size(tl_CorrAss.trial,1)) = 1;
%             design(1,(size(tl_CorrAss.trial,1)+1):(size(tl_CorrAss.trial,1) + size(tl_IncorrAss.trial,1)))= 2;
%             cfg.design = design;             % design matrix
%             [stat12] = ft_timelockstatistics(cfg, tl_CorrAss, tl_IncorrAss);
%             
            % corrASS vs Miss
           design = zeros(1,size(tl_CorrAss.trial,1)   + size(tl_Miss.trial,1));
            design(1,1:size(tl_CorrAss.trial,1)) = 1;
            design(1,(size(tl_CorrAss.trial,1)+1):(size(tl_CorrAss.trial,1) + size(tl_Miss.trial,1)))= 2;
            cfg.design = design;             % design matrix
            [stat13] = ft_timelockstatistics(cfg, tl_CorrAss, tl_Miss);
            
%             % incorrAss vs Miss
%             design = zeros(1,  size(tl_IncorrAss.trial,1)  + size(tl_Miss.trial,1));
%             design(1,1:size(tl_IncorrAss.trial,1)) = 1;
%             design(1,(size(tl_IncorrAss.trial,1)+1):(size(tl_IncorrAss.trial,1) + size(tl_Miss.trial,1)))= 2;
%             cfg.design = design;             % design matrix
%             [stat23] = ft_timelockstatistics(cfg, tl_IncorrAss, tl_Miss);
%             
%             figure,
%             plot(stat12.time,[1*stat12.mask; .75*stat13.mask; .5*stat23.mask])
%             legend({'corrass vs incorrass','corrass vs miss','incorrass vs miss'})
%             
%             stat{ch}.time = stat12.time;
%             stat{ch}.mask = [1*stat12.mask; .75*stat13.mask; .5*stat23.mask];
%             
         
     
    %
%     save([harddisk '\Tom_Local\Results\MoscowTaskAlicia\EPOCHED 180606\ZSCORED\BP' BAND 'Hz_Encoding'],'stat')
    
 
 %% plotting
    %         %%
%         if 0
            close all
          
                
                   
                    stat = stat13, name  = 'Hit-Miss'
                   
            
                
                figure('Name',name)
                subplot(3,2,1), imagesc(stat.time, 1:8,     stat.prob,[0 .5]),colorbar, title('p val')
                subplot(3,2,2), imagesc(stat.time, 1:8,     stat.posclusterslabelmat),colorbar , title('pos cluster')
                subplot(3,2,4), imagesc(stat.time, 1:8,     stat.negclusterslabelmat),colorbar, title('neg cluster')
                % subplot(3,2,4), imagesc(stat.cirange),colorbar
                subplot(3,2,3), imagesc(stat.time, 1:8,     stat.mask),colorbar, title('mask')
                subplot(3,2,5), imagesc(stat.time, 1:8,     stat.stat),colorbar, title('stat')
              
           
            
            CLULSTERpics_HM_200210
%           CLULSTERpics300520
%             CLULSTERpics200207


end
