% ERP generator for all trials to check channel quality  
 
info_summary_190520
 
mask_sign = ones(100,1);
 
folder_with_matfile = 'D:\_DATA\Sep\'
 
yrange = [-2 2]% for zscore. Change it for not zscored data!!!

%%
for session = 1:2 
    
    figure(session)
    
    switch session
        case 1
            % Encoding
            folderfiles_save = folderfiles_Enc_save;
            clusterEnc = load([folder_with_matfile 'clusterEnc.mat']); cluster = clusterEnc.cluster;
            Ncond = 3; %otherwise you take only CorrAss
            
        case 2
            % Retrieval
            folderfiles_save = folderfiles_Ret_save;
            clusterRetr = load([folder_with_matfile 'ClusterRet.mat']);
            cluster = clusterRetr.cluster;
            Ncond = 5;
            
    end
    
    NCL =size(cluster{1,1},1);
    
     for elem = 1:NCL% channels
        
        id = round(cluster {1,1}(elem,4)*1000);
        ch = round(cluster {1,1}(elem,5)*1000); 
         
        tl_ALL = []
        tr_end1 = 1
        
        for cond = 1%:Ncond % files
            
            load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')
            fs = 1/(data.time{1,1}(2)-data.time{1,1}(1));
            for tr = 1:length(data.trial)
                tl_ALL.trial(tr_end1,1,:) = mask_sign(elem)*data.trial{1,tr}(ch,:);
                tr_end1 = 1+ tr_end1;
                
            end
            tl_ALL.time    = data.time{1,1}(1,:);
            tl_ALL.fsample   = fs;
            tl_ALL.dimord    = 'rpt_chan_time';  
             
        end % files end
        
        t = tl_ALL.time;
        
        subplot(4,round(NCL/4),elem)
        m = mean(squeeze(tl_ALL.trial    ));
        s = std(squeeze(tl_ALL.trial    ));
        N = size(squeeze(tl_ALL.trial    ),1);  
        
        switch session % rename
            case 1, shadedErrorBar(t, m , s/sqrt(N),'b'), text(-.5,1,[char(subj_ID(id)) ' ' char(data.label(ch)) ' ' num2str(id)  ' ' num2str(ch)]);
            case 2, shadedErrorBar(t, m , s/sqrt(N),'r'), text(-.5,1.5,[char(subj_ID(id)) ' ' char(data.label(ch)) ' ' num2str(id)  ' ' num2str(ch)]);
        end
        hold on
        axis([-2 3 yrange])
        
      end % channels% elem 
    
end % session
 