   
% info_summary_ZSCORE
% info_summary_TomLocal

% mask_ciao = [6 7 10 21 22 23 24 27]
mask_sign = -1 * ones(1,27);
%  mask_sign([3 8 9 13 15:20 21]) = 1


for session = 1 % should become a FOR
    
    switch session
        case 1
            % Encoding
            
            folderfiles_save = folderfiles_Enc_save;
            load([folder_with_matfile 'clusterEnc.mat'])
            cluster{1,1}(mask_ciao,:)=[];
            
        case 2
            % Retrieval
            
            folderfiles_save = folderfiles_Ret_save;
            load([folder_with_matfile 'ClusterRet.mat'])
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
        cfg.t_ftimwin  = 5./cfg.foi;
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
cfg = [];
cfg.channel          = 1;
cfg.latency          = [0 1];
cfg.frequency        = [1 10];
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 1;    
cfg.tail             = 0;  % -1, 1 or 0 (default = 0); one-sided or two-sided test
cfg.clustertail      = 0;
cfg.alpha            = 0.05;
cfg.numrandomization = 1000  ;      % number of draws from the permutation distribution
 
cfg.channel       = TFR1.label;     % cell-array with selected channel labels
for ch = 1    
    neighbours(ch).label = char(TFR1.label);
    neighbours(ch).neighblabel = {''};
end
cfg.neighbours    = neighbours;  % the neighbours specify for each sensor with

subj = size(TFR1_ALL.powspctrm,1);
design = zeros(2,2*subj);
for i = 1:subj
  design(1,i) = i;
end
for i = 1:subj
  design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design   = design;
cfg.uvar     = 1;
cfg.ivar     = 2;


% corrASS vs incorrAss
 [stat12] = ft_freqstatistics(cfg, TFR1_ALL, TFR2_ALL);

% corrASS vs Miss 
[stat13] = ft_freqstatistics(cfg, TFR1_ALL, TFR3_ALL);

% incorrAss vs Miss 
[stat23] = ft_freqstatistics(cfg, TFR2_ALL, TFR3_ALL);


%% Plotting
close all
for aa=1:3
    switch aa
        case 1, stat = stat12, name  = 'Corr-Incorr'
        case 2, stat = stat13, name  = 'Corr-Miss'
        case 3, stat = stat23, name  = 'Incorr-Miss'
    end
        
    figure('Name',name)
    subplot(3,2,1), imagesc(stat.time, stat.freq,     squeeze(stat.prob),[0 .5]),colorbar, title('p val'),%set(gca,'YDir','normal','yscale','log','ytick',logspace(log10(min(stat.freq)),log10(max(stat.freq)),3),'yticklabel',round(logspace(log10(min(stat.freq)),log10(max(stat.freq)),3)/10)*10)
    set(gca,'YDir','normal'), xlabel('Time (s)'), ylabel('Frequency (Hz) ')
    signif = find (stat.mask(ch,:) >0);
    if length(signif)
        hold on
        subplot(3,2,2), imagesc(stat.time, stat.freq,     squeeze(stat.posclusterslabelmat)),colorbar , title('pos cluster'),%set(gca,'YDir','normal','yscale','log','ytick',logspace(log10(min(stat.freq)),log10(max(stat.freq)),3),'yticklabel',round(logspace(log10(min(stat.freq)),log10(max(stat.freq)),3)/10)*10)
        set(gca,'YDir','normal'), xlabel('Time (s)'), ylabel('Frequency (Hz) ')
        subplot(3,2,4), imagesc(stat.time, stat.freq,     squeeze(stat.negclusterslabelmat)),colorbar, title('neg cluster'),%set(gca,'YDir','normal','yscale','log','ytick',logspace(log10(min(stat.freq)),log10(max(stat.freq)),3),'yticklabel',round(logspace(log10(min(stat.freq)),log10(max(stat.freq)),3)/10)*10)
        set(gca,'YDir','normal'), xlabel('Time (s)'), ylabel('Frequency (Hz) ')
    end
    subplot(3,2,3), imagesc(stat.time, stat.freq,     squeeze(stat.mask)),colorbar, title('mask'),%set(gca,'YDir','normal','yscale','log','ytick',logspace(log10(min(stat.freq)),log10(max(stat.freq)),3),'yticklabel',round(logspace(log10(min(stat.freq)),log10(max(stat.freq)),3)/10)*10)
    set(gca,'YDir','normal'), xlabel('Time (s)'), ylabel('Frequency (Hz) ')
    subplot(3,2,5), imagesc(stat.time, stat.freq,     squeeze(stat.stat)),colorbar, title('stat'),%set(gca,'YDir','normal','yscale','log','ytick',logspace(log10(min(stat.freq)),log10(max(stat.freq)),3),'yticklabel',round(logspace(log10(min(stat.freq)),log10(max(stat.freq)),3)/10)*10)
    set(gca,'YDir','normal'), xlabel('Time (s)'), ylabel('Frequency (Hz) ')
    
end


