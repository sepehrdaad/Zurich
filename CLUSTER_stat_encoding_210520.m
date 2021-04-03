
% info_summary_ZSCORE
info_summary_190520
% Ciao is deactivated ??


 NUMBEROFCLUSTER = 1
 
 

 
% This setup is the original one that I used and had significant results
% but wrong polarity and then everything turned out wrong about it
% mask_ciao = [6 7 10 21 22 23 24 27]
 mask_sign = -1 * ones(1,27);
%  mask_sign([3 8 9 13 15:20 21]) = 1


 
 
 %  mask_ciao = [6 7 10 21 22 23 24 27]
%  mask_sign = ones(1,27);
%  mask_sign([1 2 11 14]) = -1;; %if commented flipping is not applied 
%  gives blueeeee
%  
 
%    mask_ciao = [1 2 3 6 7 10 18 19 20 27] % 24 is absent, closer to RET
%  mask_sign = ones(1,27);
%  mask_sign([4 14 15 16 17 ]) = -1;; 

%  this version also works and it's closer to retrieval 
% It gives blue bar ( associative memory) 



% %  from cluster
%  mask_ciao = [1 2 3 6 7 10 21 22 23 24 27]
%  mask_sign = ones(1,27);
%  mask_sign([4 11 14 ]) = -1;; %if commented flipping is not applied 
%  
% %  This works sometimes
 




for session = 1 % should become a FOR
        
        switch session
            case 1
                % Encoding
               
                folderfiles_save = folderfiles_Enc_save;
                clusterEnc = load('D:\_DATA\Sep\clusterEnc.mat'); cluster = clusterEnc.cluster;
%                  %to delete channels
%                  cluster{1,1}(mask_ciao,:)=[];
%                  mask_sign(mask_ciao )=[];
% %                  


%                  cluster = xlswrite('C:\Users\Sep\Desktop\Kingdom\Word and Excel Files\regions2.xlsx','Hipp Region For Cluster','A1:E27')

                
            case 2
                % Retrieval
                
                folderfiles_save = folderfiles_Ret_save;
                 
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
        
        for cond = 1:3
            
            switch cond
                case 1
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
                    
                case 2
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
                    
                case 3
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
            design = zeros(1,size(tl_CorrAss.trial,1) + size(tl_IncorrAss.trial,1)  );
            design(1,1:size(tl_CorrAss.trial,1)) = 1;
            design(1,(size(tl_CorrAss.trial,1)+1):(size(tl_CorrAss.trial,1) + size(tl_IncorrAss.trial,1)))= 2;
            cfg.design = design;             % design matrix
            [stat12] = ft_timelockstatistics(cfg, tl_CorrAss, tl_IncorrAss);
            
            % corrASS vs Miss
            design = zeros(1,size(tl_CorrAss.trial,1)   + size(tl_Miss.trial,1));
            design(1,1:size(tl_CorrAss.trial,1)) = 1;
            design(1,(size(tl_CorrAss.trial,1)+1):(size(tl_CorrAss.trial,1) + size(tl_Miss.trial,1)))= 2;
            cfg.design = design;             % design matrix
            [stat13] = ft_timelockstatistics(cfg, tl_CorrAss, tl_Miss);
            
            % incorrAss vs Miss
            design = zeros(1,  size(tl_IncorrAss.trial,1)  + size(tl_Miss.trial,1));
            design(1,1:size(tl_IncorrAss.trial,1)) = 1;
            design(1,(size(tl_IncorrAss.trial,1)+1):(size(tl_IncorrAss.trial,1) + size(tl_Miss.trial,1)))= 2;
            cfg.design = design;             % design matrix
            [stat23] = ft_timelockstatistics(cfg, tl_IncorrAss, tl_Miss);
            
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
            for aa=1:3
                switch aa
                    case 1, stat = stat12, name  = 'Corr-Incorr'
                    case 2, stat = stat13, name  = 'Corr-Miss'
                    case 3, stat = stat23, name  = 'Incorr-Miss'
                end
                
                figure('Name',name)
                subplot(3,2,1), imagesc(stat.time, 1:8,     stat.prob,[0 .5]),colorbar, title('p val')
                subplot(3,2,2), imagesc(stat.time, 1:8,     stat.posclusterslabelmat),colorbar , title('pos cluster')
                subplot(3,2,4), imagesc(stat.time, 1:8,     stat.negclusterslabelmat),colorbar, title('neg cluster')
                % subplot(3,2,4), imagesc(stat.cirange),colorbar
                subplot(3,2,3), imagesc(stat.time, 1:8,     stat.mask),colorbar, title('mask')
                subplot(3,2,5), imagesc(stat.time, 1:8,     stat.stat),colorbar, title('stat')
            end
            
            
            
            CLULSTERpics200207


end
