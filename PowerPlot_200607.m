

clear all

 info_summary_ExtraVirgin
mask_ciao = [6 7 10 21 22 23 24 27]
mask_sign = 1 * ones(1,27);
%  mask_sign([3 8 9 13 15:20 21]) = 1

 NUMBEROFCLUSTER = 1
 %                load files

 

%%


for session = 1 % should become a FOR
    
    switch session
        case 1
            % Encoding
            
            folderfiles_save = folderfiles_Enc_save;
            load ClusterEnc.mat
            cluster{1,1}(mask_ciao,:)=[];
             mask_sign(mask_ciao )=[];
        case 2
            % Retrieval
%             
%             folderfiles_save = folderfiles_Ret_save;
%             load([folder_with_matfile 'ClusterRet.mat'])
%              cluster{1,1}(mask_ciao,:)=[];
%              mask_sign(mask_ciao )=[];
%             
    end
    
    %% read out and prepare for stats
    
    cl = 1
    
    % pick subject
    
    for elem = 1:size(cluster{1,cl},1)
        
        id = round(cluster{1,cl}(elem,4)*1000);
        ch = round(cluster{1,cl}(elem,5)*1000);
        
        clear tl*
        tl_CorrAss.trial    = [];
        tl_IncorrAss.trial  = [];
        tl_Miss.trial       = [];
        tr_end1 = 1
        tr_end2 = 1
        tr_end3 = 1
        
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
        
        
        cfg = [];
        cfg.output     = 'pow';
        cfg.method     = 'mtmconvol';
        
        cfg.foi        = 1:1:80 %logspace(log10(1), log10(80),20);
        cfg.t_ftimwin  = 3./cfg.foi;
        cfg.tapsmofrq  = 0.4 *cfg.foi;
        cfg.toi        = -2:0.05:3;
        
        TFR1       = ft_freqanalysis(cfg, tl_CorrAss);
        TFR2       = ft_freqanalysis(cfg, tl_IncorrAss);
        TFR3       = ft_freqanalysis(cfg, tl_Miss);
        
        baseline = [-1.5 -0.5];
        [TFR1,TFR2,TFR3] = TFR_baseline(TFR1,TFR2,TFR3,baseline);
        
        if elem == 1
            TFR1_ALL = rmfield(TFR1,'powspctrm');
            TFR2_ALL = rmfield(TFR2,'powspctrm');
            TFR3_ALL = rmfield(TFR3,'powspctrm');
        end
        
        TFR1_ALL.powspctrm(elem,1,:,:) = squeeze(TFR1.powspctrm);
        TFR2_ALL.powspctrm(elem,1,:,:) = squeeze(TFR2.powspctrm);
        TFR3_ALL.powspctrm(elem,1,:,:) = squeeze(TFR3.powspctrm);
        
    end
end


TFR1_ALL.dimord  = 'subj_chan_freq_time';
TFR2_ALL.dimord  = 'subj_chan_freq_time';
TFR3_ALL.dimord  = 'subj_chan_freq_time';

%% 
% plot

% TF
cfg              = [];
cfg.baselinetype = 'db';
cfg.zlim         = [-5e-1  17.9e-1]
 figure('name','ENC TF absolute PowerPlot')
 subplot(3,1,1),     ft_singleplotTFR(cfg,  TFR1_ALL); title ('Hit correct association')
 xlim([0 1])
 subplot(3,1,2),     ft_singleplotTFR(cfg, TFR2_ALL);title ('Hit Incorrect association')
 xlim([0 1])
 subplot(3,1,3),     ft_singleplotTFR(cfg,TFR3_ALL);title ('Miss')
xlim([0 1])


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%RET

clear all

 info_summary_ExtraVirgin
mask_ciao = [1 2 3 4 11 14 15 17]
mask_sign = 1 * ones(1,27);
%  mask_sign([3 8 9 13 15:20 21]) = 1

 NUMBEROFCLUSTER = 1
 %                load files

 

%%


for session = 2 % should become a FOR
    
    switch session
        case 1
            % Encoding
            
%             folderfiles_save = folderfiles_Enc_save;
%             load ClusterEnc.mat
%             cluster{1,1}(mask_ciao,:)=[];
% %              mask_sign(mask_ciao )=[];
        case 2
            % Retrieval
%             
            folderfiles_save = folderfiles_Ret_save;
            load ClusterRet.mat
             cluster{1,1}(mask_ciao,:)=[];
             mask_sign(mask_ciao )=[];
            
    end
    
    %% read out and prepare for stats
    
    cl = 1
    
    % pick subject
    
    for elem = 1:size(cluster{1,cl},1)
        
        id = round(cluster{1,cl}(elem,4)*1000);
        ch = round(cluster{1,cl}(elem,5)*1000);
        
        clear tl*
        tl_CorrAss.trial    = [];
        tl_IncorrAss.trial  = [];
        tl_Miss.trial       = [];
        tr_end1 = 1
        tr_end2 = 1
        tr_end3 = 1
        
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
        
        %%
        cfg = [];
        cfg.output     = 'pow';
        cfg.method     = 'mtmconvol';
        
        cfg.foi        = 1:1:80 %logspace(log10(1), log10(80),20);
        cfg.t_ftimwin  = 3./cfg.foi;
        cfg.tapsmofrq  = 0.4 *cfg.foi;
        cfg.toi        = -2:0.05:3;
        
        TFR1       = ft_freqanalysis(cfg, tl_CorrAss);
        TFR2       = ft_freqanalysis(cfg, tl_IncorrAss);
        TFR3       = ft_freqanalysis(cfg, tl_Miss);
        
        baseline = [-1.5 -0.5];
        [TFR1,TFR2,TFR3] = TFR_baseline(TFR1,TFR2,TFR3,baseline);
        
        if elem == 1
            TFR1_ALL = rmfield(TFR1,'powspctrm');
            TFR2_ALL = rmfield(TFR2,'powspctrm');
            TFR3_ALL = rmfield(TFR3,'powspctrm');
        end
        
        TFR1_ALL.powspctrm(elem,1,:,:) = squeeze(TFR1.powspctrm);
        TFR2_ALL.powspctrm(elem,1,:,:) = squeeze(TFR2.powspctrm);
        TFR3_ALL.powspctrm(elem,1,:,:) = squeeze(TFR3.powspctrm);
        
    end
end


TFR1_ALL.dimord  = 'subj_chan_freq_time';
TFR2_ALL.dimord  = 'subj_chan_freq_time';
TFR3_ALL.dimord  = 'subj_chan_freq_time';

%% 
% plot

% TF
cfg              = [];
cfg.baselinetype = 'db';
cfg.zlim         = [-5e-1  17.9e-1]
 figure('name','Ret TF absolute PowerPlot')
 subplot(3,1,1),     ft_singleplotTFR(cfg,  TFR1_ALL); title ('Hit correct association')
 xlim([0 1])
 subplot(3,1,2),     ft_singleplotTFR(cfg, TFR2_ALL);title ('Hit Incorrect association')
 xlim([0 1])
 subplot(3,1,3),     ft_singleplotTFR(cfg,TFR3_ALL);title ('Miss')
xlim([0 1])
