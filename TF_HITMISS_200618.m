close all
clear all
info_summary_ExtraVirgin
% info_summary_TomLocal %% TO BE CHANGED

NUMBEROFCLUSTER = 1
cluster_Enc = load([folder_scritps '\clusterEnc.mat']) %% TO BE CHANGED
cluster_Ret = load([folder_scritps '\ClusterRet.mat']) %% TO BE CHANGED

baseline = [-1.5 -.5] %% TO BE CHANGED
% baseline = [-.5 0] %% TO BE CHANGED

% mask_ciao_Enc = [6 7 8 9 10 15 16 17] %% TO BE CHANGED
% mask_ciao_Retr= [1 2 3 4 11 14 15 17] %% TO BE CHANGED

mask_ciao_Enc = [6 7 8 9 10 15 16 17 18 21 22 23 24] %% TO BE CHANGED Excluding SA
mask_ciao_Retr= [1 2 3 4 11 12 13 14 15 16 17] %% TO BE CHANGED excluding SA for low performance


for session = 1:2  
    
    switch session
        case 1
            % Encoding
            
            folderfiles_save = folderfiles_Enc_save;
            cluster = cluster_Enc.cluster;
            cluster{1,1}(mask_ciao_Enc,:)=[];
            cond1 = 1;
            cond2 = 2;
            cond3 = 3;
            
            
        case 2
            % Retrieval
            
            folderfiles_save = folderfiles_Ret_save;
            cluster = cluster_Ret.cluster;
            cluster{1,1}(mask_ciao_Retr,:)=[];
            cond1 = 3;
            cond2 = 4;
            cond3 = 5;            %
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
                        load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond1) '.mat'],'data')
                        fs = 1/(data.time{1,1}(2)-data.time{1,1}(1));
                        for tr = 1:length(data.trial)
                            tl_CorrAss.trial(tr_end1,1,:) = data.trial{1,tr}(ch,:);
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
                        load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond2) '.mat'],'data')
                        for tr = 1:length(data.trial)
                            tl_IncorrAss.trial(tr_end2,1,:) = data.trial{1,tr}(ch,:);
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
                        load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond3) '.mat'],'data')
                        for tr = 1:length(data.trial)
                            tl_Miss.trial(tr_end3,1,:) = data.trial{1,tr}(ch,:);
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
        
    end
    
    cfg =[]

hit = ft_appenddata(cfg, tl_CorrAss, tl_IncorrAss)
for tr = 1:length(hit.trial)
    tl_CorrAss.trial(tr,1,:) = hit.trial{1,tr}(1,:);
end

    
    
    cfg = [];
    cfg.output     = 'pow';
    cfg.method     = 'mtmconvol';
    cfg.keeptrials = 'yes'
    % Staresina ELife 2016 low freq
    cfg.taper      =  'hanning';
    cfg.foi        = 2:29; %logspace(log10(1), log10(80),30);1:1:80 %
    cfg.toi        = -2:0.01:3;
    cfg.t_ftimwin  = 5./cfg.foi;
    cfg.tapsmofrq  = 10*ones(length(cfg.foi),1);
    TFR1l       = ft_freqanalysis(cfg, tl_CorrAss);

    TFR3l       = ft_freqanalysis(cfg, tl_Miss);
    
    % Staresina ELife 2016 gamma
    cfg.taper      = 'dpss';
    cfg.foi        = 30:5:100; %logspace(log10(1), log10(80),30);1:1:80 %
    cfg.toi        = -2:0.01:3;
    cfg.t_ftimwin  = .4*ones(length(cfg.foi),1);
    cfg.tapsmofrq  = 20*ones(length(cfg.foi),1);
    TFR1h       = ft_freqanalysis(cfg, tl_CorrAss);

    TFR3h       = ft_freqanalysis(cfg, tl_Miss);
    
     
    
    cfg =[]
    cfg.parameter  = 'powspctrm'
    TFR1 = ft_appendfreq(cfg, TFR1l, TFR1h);

    TFR3 = ft_appendfreq(cfg, TFR3l, TFR3h)

% 
%  The configuration should contain
%    cfg.parameter  = string, the name of the field to concatenate

    
    % normalize to baseline interval at single trial level
    [TFR1, TFR3] = TFR_baseline_trials_hitmiss(TFR1, TFR3, baseline)
    
    figure(100)
    cfg              = [];
    cfg.zlim         = [0.5 1.5]
    subplot(2,3,1+3*(session-1)), ft_singleplotTFR(cfg,  TFR1); title('Hit')
%     subplot(2,3,2+3*(session-1)), ft_singleplotTFR(cfg,  TFR2); title('IA')
    subplot(2,3,3+3*(session-1)), ft_singleplotTFR(cfg,  TFR3); title('Miss')

    
    
    %%  stat  
    
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
    cfg.numrandomization = 1000  ;      % number of draws from the permutation distribution
    cfg.ivar  = 1;                   % number or list with indices indicating the independent variable(s)

    cfg.channel       = TFR1.label;     % cell-array with selected channel labels
    cfg.latency       = [0 2];       % time interval over which the experimental
    % conditions must
    for ch = 1
        neighbours(ch).label = char(TFR1.label);
        neighbours(ch).neighblabel = {''};
    end
    cfg.neighbours    = neighbours;  % the neighbours specify for each sensor with
    
    % corrASS vs incorrAss
%     design = zeros(1,size(TFR1.powspctrm,1) + size(TFR2.powspctrm,1)  );
%     design(1,1:size(TFR1.powspctrm,1)) = 1;
%     design(1,(size(TFR1.powspctrm,1)+1):(size(TFR1.powspctrm,1) + size(TFR2.powspctrm,1)))= 2;
%     cfg.design = design;             % design matrix
%     [stat12] = ft_freqstatistics(cfg, TFR1, TFR2);
    
    % corrASS vs Miss
    design = zeros(1,size(TFR1.powspctrm,1)   + size(TFR3.powspctrm,1));
    design(1,1:size(TFR1.powspctrm,1)) = 1;
    design(1,(size(TFR1.powspctrm,1)+1):(size(TFR1.powspctrm,1) + size(TFR3.powspctrm,1)))= 2;
    cfg.design = design;             % design matrix
    [stat13] = ft_freqstatistics(cfg, TFR1, TFR3);
    
    % incorrAss vs Miss
%     design = zeros(1,  size(TFR2.powspctrm,1)  + size(TFR3.powspctrm,1));
%     design(1,1:size(TFR2.powspctrm,1)) = 1;
%     design(1,(size(TFR2.powspctrm,1)+1):(size(TFR2.powspctrm,1) + size(TFR3.powspctrm,1)))= 2;
%     cfg.design = design;             % design matrix
%     [stat23] = ft_freqstatistics(cfg, TFR2, TFR3);
%     
    
    %% Plotting
%     close all
   
     
          stat = stat13, name  = 'hit-Miss'
     
       
        
        figure('Name',name)
        subplot(3,2,1), 
        cfg = []; cfg.parameter = 'prob';
        ft_singleplotTFR(cfg,  stat)
       
        signif = find (stat.mask  >0);
        if length(signif)
            hold on        
            subplot(3,2,2), 
            cfg = []; cfg.parameter = 'posclusterslabelmat';
            ft_singleplotTFR(cfg,  stat)
             subplot(3,2,4), 
             cfg = []; cfg.parameter = 'negclusterslabelmat';
            ft_singleplotTFR(cfg,  stat)
            
        end
        subplot(3,2,3),cfg = []; cfg.parameter = 'mask';             ft_singleplotTFR(cfg,  stat)

subplot(3,2,5), cfg = []; cfg.parameter = 'stat'; 
        ft_singleplotTFR(cfg,  stat)

 end
    

