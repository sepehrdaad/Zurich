

clear all
 info_summary_ExtraVirgin
 
 NUMBEROFCLUSTER = 1
 %                load files
 folderfiles_save = folderfiles_Enc_save;
 load clusterEnc.mat
 
 
 
for elem = 1:size(cluster{1,1},1)
    
    id = round(cluster{1,1}(elem,4)*1000);
    ch = round(cluster{1,1}(elem,5)*1000);
    
    clear TFR*
    
    
    for cond = 1:3 % Corr, incorr, miss????
        
%         WHEREWEARE = [cl elem cond]
        
        %%
        cfg = [];
        cfg.output     = 'pow';
        cfg.method     = 'mtmconvol';
        cfg.keeptrials = 'yes'         
        cfg.foi        = 2:1:30; %logspace(log10(1), log10(80),20);
        cfg.t_ftimwin  = 5./cfg.foi;
        cfg.tapsmofrq  = 0.4 *cfg.foi;
        cfg.toi        = -2:0.05:3;
        cfg.channel    = ch;
        %%
        
        switch cond
            case 1
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                              
                TFR1       = ft_freqanalysis(cfg, data);
              
            case 2
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')               
                TFR2       = ft_freqanalysis(cfg, data);
            
            case 3
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                 
                TFR3       = ft_freqanalysis(cfg, data);

        end
    end

 


%%
% start the baseline procedure
t = TFR1.time;

timebase = [-.5 -.2]
[~,samples_base1] = (min(abs(timebase(1)-TFR2.time)));
[~,samples_base2] = (min(abs(timebase(2)-TFR2.time)));
samples_base      = samples_base1:samples_base2;

% normalization to TFR1 baseline
TFbase = (squeeze(nanmean(nanmean(TFR1.powspctrm(:,:,:,samples_base)),4)));

TFR1_norm = TFR1;
TFR2_norm = TFR2;
TFR3_norm = TFR3;

for tr = 1:size(TFR1_norm.powspctrm,1)
    TFR1_norm.powspctrm(tr,1,:,:) = squeeze(TFR1.powspctrm(tr,:,:,:))./repmat(TFbase,1,length(TFR1.time));
end
for tr = 1:size(TFR2_norm.powspctrm,1)
    TFR2_norm.powspctrm(tr,1,:,:) = squeeze(TFR2.powspctrm(tr,:,:,:))./repmat(TFbase,1,length(TFR1.time));
end
for tr = 1:size(TFR3_norm.powspctrm,1)
    TFR3_norm.powspctrm(tr,1,:,:) = squeeze(TFR3.powspctrm(tr,:,:,:))./repmat(TFbase,1,length(TFR1.time));
end





end


%% 
% plot

% TF
cfg              = [];
cfg.baselinetype = 'db';
cfg.zlim         = [-1 2]
 figure('name','ENC TF absolute PowerPlot')
 subplot(3,1,1),     ft_singleplotTFR(cfg,  TFR1_norm); title ('Hit correct association')
 xlim([-1 2])
 subplot(3,1,2),     ft_singleplotTFR(cfg, TFR2_norm);title ('Hit Incorrect association')
 xlim([-1 2])
 subplot(3,1,3),     ft_singleplotTFR(cfg, TFR2_norm);title ('Miss')
xlim([-1 2])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%

%RET


clear all
 info_summary_ExtraVirgin
 
 NUMBEROFCLUSTER = 1
 %                load files
 folderfiles_save = folderfiles_Ret_save;
 load clusterRet.mat
 
 
 
for elem = 1:size(cluster{1,1},1)
    
    id = round(cluster{1,1}(elem,4)*1000);
    ch = round(cluster{1,1}(elem,5)*1000);
    
    clear TFR*
    
    
    for cond = 3:5 % Corr, incorr, miss????
        
%         WHEREWEARE = [cl elem cond]
        
        %%
        cfg = [];
        cfg.output     = 'pow';
        cfg.method     = 'mtmconvol';
        cfg.keeptrials = 'yes'         
        cfg.foi        = 2:1:30; %logspace(log10(1), log10(80),20);
        cfg.t_ftimwin  = 5./cfg.foi;
        cfg.tapsmofrq  = 0.4 *cfg.foi;
        cfg.toi        = -2:0.05:3;
        cfg.channel    = ch;
        %%
        
        switch cond
            case 3
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                              
                TFR1       = ft_freqanalysis(cfg, data);
              
            case 4
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')               
                TFR2       = ft_freqanalysis(cfg, data);
            
            case 5
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                 
                TFR3       = ft_freqanalysis(cfg, data);

        end
    end

 


%%
% start the baseline procedure
t = TFR1.time;

timebase = [-.5 -.2]
[~,samples_base1] = (min(abs(timebase(1)-TFR2.time)));
[~,samples_base2] = (min(abs(timebase(2)-TFR2.time)));
samples_base      = samples_base1:samples_base2;

% normalization to TFR1 baseline
TFbase = (squeeze(nanmean(nanmean(TFR1.powspctrm(:,:,:,samples_base)),4)));

TFR1_norm = TFR1;
TFR2_norm = TFR2;
TFR3_norm = TFR3;

for tr = 1:size(TFR1_norm.powspctrm,1)
    TFR1_norm.powspctrm(tr,1,:,:) = squeeze(TFR1.powspctrm(tr,:,:,:))./repmat(TFbase,1,length(TFR1.time));
end
for tr = 1:size(TFR2_norm.powspctrm,1)
    TFR2_norm.powspctrm(tr,1,:,:) = squeeze(TFR2.powspctrm(tr,:,:,:))./repmat(TFbase,1,length(TFR1.time));
end
for tr = 1:size(TFR3_norm.powspctrm,1)
    TFR3_norm.powspctrm(tr,1,:,:) = squeeze(TFR3.powspctrm(tr,:,:,:))./repmat(TFbase,1,length(TFR1.time));
end





end


%% 
% plot

% TF
cfg              = [];
cfg.baselinetype = 'db';
cfg.zlim         = [-1 2]
 figure('name','RET TF absolute PowerPlot')
 subplot(3,1,1),     ft_singleplotTFR(cfg,  TFR1_norm); title ('Hit correct association')
 xlim([-1 2])
 subplot(3,1,2),     ft_singleplotTFR(cfg, TFR2_norm);title ('Hit Incorrect association')
 xlim([-1 2])
 subplot(3,1,3),     ft_singleplotTFR(cfg, TFR2_norm);title ('Miss')
xlim([-1 2])
