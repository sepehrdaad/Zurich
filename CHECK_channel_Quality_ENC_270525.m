

% info_summary_AV 

info_summary_ExtraVirgin

% NUMBEROFCLUSTER = 5 % works
 NUMBEROFCLUSTER = 1
 
for session =1 % should become a FOR
        
        switch session
            case 1
                % Encoding
               
                 folderfiles_save = folderfiles_Enc_save;
                 load clusterEnc.mat
                 %to delete channels
%                  cluster{1,1}(mask_ciao,:)=[];
                  
 
                
            case 2
                % Retrieval
                
                folderfiles_save = folderfiles_Retr_save;
                load([data_info_folder 'Files\clusterRetr.mat'])

        end


 %%
    
    clear TFR*
       

close all
% figure
cl = 1 ;

% Round 1 
for elem = 1:round(size(cluster{1,cl},1)/3)
    
    id = round(cluster{1,cl}(elem,4)*1000);
    ch = round(cluster{1,cl}(elem,5)*1000);
    
    clear TFR*
    
    
    for cond = 1:3 % Corr, incorr, miss????
        
        WHEREWEARE = [cl elem cond]
        
        %%
        cfg = [];
        cfg.output     = 'pow';
        cfg.method     = 'mtmconvol';
        cfg.keeptrials = 'yes'         
        cfg.foi        = 2:1:30; %logspace(log10(1), log10(80),20);
        cfg.t_ftimwin  = 5./cfg.foi;
        cfg.tapsmofrq  = 0.4 *cfg.foi;
        cfg.toi        = -1:0.05:2;
        cfg.channel    = ch;
        %%
        
        switch cond
            case 1
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                              
                TFR1       = ft_freqanalysis(cfg, data);
                data1      = ft_timelockanalysis(cfg, data);
            case 2
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')               
                TFR2       = ft_freqanalysis(cfg, data);
                data2      = ft_timelockanalysis(cfg, data);
            case 3
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                 
                TFR3       = ft_freqanalysis(cfg, data);
                data3      = ft_timelockanalysis(cfg, data);
                
        end
    end
    
    CLUSTERpics_ERP_TIMEFREQ_200525
%     aspe= 1
end
set(gcf,'units','normalized','outerposition',[0 0 1 1])


%%
% Round 2
for elem = round(size(cluster{1,cl},1)/3):2*round(size(cluster{1,cl},1)/3)
    
    id = round(cluster{1,cl}(elem,4)*1000);
    ch = round(cluster{1,cl}(elem,5)*1000);
    
    clear TFR*
    
    
    for cond = 1:3 % Corr, incorr, miss????
        
        WHEREWEARE = [cl elem cond]
        
        %%
        cfg = [];
        cfg.output     = 'pow';
        cfg.method     = 'mtmconvol';
        cfg.keeptrials = 'yes'         
        cfg.foi        = 2:1:30; %logspace(log10(1), log10(80),20);
        cfg.t_ftimwin  = 5./cfg.foi;
        cfg.tapsmofrq  = 0.4 *cfg.foi;
        cfg.toi        = -1:0.05:2;
        cfg.channel    = ch;
        %%
        
        switch cond
            case 1
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                              
                TFR1       = ft_freqanalysis(cfg, data);
                data1      = ft_timelockanalysis(cfg, data);
            case 2
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')               
                TFR2       = ft_freqanalysis(cfg, data);
                data2      = ft_timelockanalysis(cfg, data);
            case 3
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                 
                TFR3       = ft_freqanalysis(cfg, data);
                data3      = ft_timelockanalysis(cfg, data);
                
        end
    end
    
    CLUSTERpics_ERP_TIMEFREQ_200525
%     aspe= 1
end
set(gcf,'units','normalized','outerposition',[0 0 1 1])
% % % Save figure here!!! NAME: session cluster 
% close all
%%
% Round 3
for elem = 2*round(size(cluster{1,cl},1)/3):3*round(size(cluster{1,cl},1)/3)
    
    id = round(cluster{1,cl}(elem,4)*1000);
    ch = round(cluster{1,cl}(elem,5)*1000);
    
    clear TFR*
    
    
    for cond = 1:3 % Corr, incorr, miss????
        
        WHEREWEARE = [cl elem cond]
        
        %%
        cfg = [];
        cfg.output     = 'pow';
        cfg.method     = 'mtmconvol';
        cfg.keeptrials = 'yes'         
        cfg.foi        = 2:1:30; %logspace(log10(1), log10(80),20);
        cfg.t_ftimwin  = 5./cfg.foi;
        cfg.tapsmofrq  = 0.4 *cfg.foi;
        cfg.toi        = -1:0.05:2;
        cfg.channel    = ch;
        %%
        
        switch cond
            case 1
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                              
                TFR1       = ft_freqanalysis(cfg, data);
                data1      = ft_timelockanalysis(cfg, data);
            case 2
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')               
                TFR2       = ft_freqanalysis(cfg, data);
                data2      = ft_timelockanalysis(cfg, data);
            case 3
                load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')                 
                TFR3       = ft_freqanalysis(cfg, data);
                data3      = ft_timelockanalysis(cfg, data);
                
        end
    end
    
    CLUSTERpics_ERP_TIMEFREQ_200525
%     aspe= 1
end
set(gcf,'units','normalized','outerposition',[0 0 1 1])
% % % Save figure here!!! NAME: session cluster 
% close all

 end


