% ERP generator
% this script combines two of Tommaso's script with slight modifications,
% to produce ERP of all channels in encoding for HIt

info_summary_TomLocal

% clusterEnc = load('clusterEnc.mat'); clusterEnc = clusterEnc.cluster;
% cluster = clusterEnc ;
% % clusterRetr = load('ClusterRet.mat'); clusterRetr = clusterRetr.cluster;
%
% % [~,index_A,index_B] = intersect(clusterEnc{1,1}, clusterRetr{1,1},'rows');
% NUMBEROFCLUSTER = 1
mask_sign = ones(100,1);
%
% %%
%
% figure,
% % inda would extract the first element which is the numbre of recordings,
% % out of this struct
% [NCL,~]=size(clusterEnc{1,1}); % COMPACT Style
%  NCL =size(clusterEnc{1,1},1); % you can decide which dimension to take, in this case is 1

% NCL = inda;

%% YOU DO NOT NEED THIS BLOCK - it can be deleted actually
% %%
% % Just to append the conditions into 1
% for session = 1 % should become a FOR
%
%         switch session
%             case 1
%                 % Encoding
%
%                folderfiles_save = folderfiles_Enc_save;
%                  load clusterEnc.mat
%                  %to delete channels
% %                  cluster{1,1}(mask_ciao,:)=[];
% %                  mask_sign(mask_ciao )=[];
%
%             case 2
%                 % Retrieval
%
%                 folderfiles_save = folderfiles_Ret_save;
%
%         end
%
% %%
%
% clear tl*
% tl_CorrAss.trial    = [];
% tl_IncorrAss.trial  = [];
% tl_Miss.trial       = [];
%
%
%
%
% for cl = NUMBEROFCLUSTER%:length(cluster)
%
%     tr_end1 = 1
%     tr_end2 = 1
%     tr_end3 = 1
%
%     % pick subject
%
%     for elem = 1:size(cluster{1,cl},1)
%
%         id = round(cluster{1,cl}(elem,4)*1000);
%         ch = round(cluster{1,cl}(elem,5)*1000);
%
%         for cond = 1:3
%
%             switch cond
%                 case 1
%                     load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')
%                     fs = 1/(data.time{1,1}(2)-data.time{1,1}(1));
%                     for tr = 1:length(data.trial)
%                         tl_CorrAss.trial(tr_end1,1,:) = data.trial{1,tr}(ch,:);
%                         tr_end1 = 1+ tr_end1;
%                     end
%                     tl_CorrAss.time       = data.time{1,1}(1,:);
%                     tl_CorrAss.history.label{elem,1}    = [char(subj_ID(id)) '  ' char(data.label(ch))];
%                     tl_CorrAss.history.trials( elem,1)  = tr;
%                     tl_CorrAss.history.anatomy{elem,1}  = data.anatomy{ch,:};
%                     tl_CorrAss.label{1}  = ['cluster' num2str(cl)];
%                     tl_CorrAss.fsample   = fs;
%                     tl_CorrAss.dimord    = 'rpt_chan_time';
%
%                 case 2
%                     load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')
%                      for tr = 1:length(data.trial)
%                         tl_IncorrAss.trial(tr_end2,1,:) = data.trial{1,tr}(ch,:);
%                         tr_end2 = 1+ tr_end2;
%                     end
%                     tl_IncorrAss.time    = data.time{1,1}(1,:);
%                     tl_IncorrAss.history.label{elem,1}    = [char(subj_ID(id)) '  ' char(data.label(ch))];
%                     tl_IncorrAss.history.trials( elem,1)    = tr;
%                     tl_IncorrAss.history.anatomy{elem,1}   = data.anatomy{ch,:};
%                     tl_IncorrAss.label{1} = ['cluster' num2str(cl)];
%                     tl_IncorrAss.fsample   = fs;
%                     tl_IncorrAss.dimord    = 'rpt_chan_time';
%
%                 case 3
%                     load([folderfiles_save,'\alltrials_' char(subj_ID(id))   '_cond' num2str(cond) '.mat'],'data')
%                       for tr = 1:length(data.trial)
%                         tl_Miss.trial(tr_end3,1,:) = data.trial{1,tr}(ch,:);
%                         tr_end3 = 1+ tr_end3;
%                       end
%                      tl_Miss.time         = data.time{1,1}(1,:);
%                    tl_Miss.history.label{elem,1}    = [char(subj_ID(id)) '  ' char(data.label(ch))];
%                     tl_Miss.history.trials( elem,1)    = tr;
%                     tl_Miss.history.anatomy{elem,1}   = data.anatomy{ch,:};
%                     tl_Miss.label{1} = ['cluster' num2str(cl)];
%                     tl_Miss.fsample   = fs;
%                     tl_Miss.dimord    = 'rpt_chan_time';
%
%
%             end
%
%
%
%         end
%     end
%
% %     iterative_cluster_plot
% end
%
% cfg =[]
%
% test = ft_appenddata(cfg, tl_CorrAss, tl_IncorrAss)
% for tr = 1:length(test.trial)
%     tl_CorrAss.trial(tr,1,:) = test.trial{1,tr}(1,:);
% end
%
%
% %
%%
for session = 1 
    
    figure(session)
    
    switch session
        case 1
            % Encoding
            folderfiles_save = folderfiles_Enc_save;
            clusterEnc = load('D:\_DATA\Sep\clusterEnc.mat'); cluster = clusterEnc.cluster;
            Ncond = 3; %otherwise you take only CorrAss
            
        case 2
            % Retrieval
            folderfiles_save = folderfiles_Ret_save;
            clusterRetr = load('D:\_DATA\Sep\ClusterRet.mat');
            cluster = clusterRetr.cluster;
            Ncond = 5;
            
    end
    
    NCL =size(cluster{1,1},1);
    
    M = []
    for elem = 1:NCL% channels
        
        id = round(cluster {1,1}(elem,4)*1000);
        ch = round(cluster {1,1}(elem,5)*1000);
        
        %     for session = 1 I bring this out of the look to call the cluster
        %     struct and create the figure
        
        
        
        %         switch session
        %             case 1
        %                 % Encoding
        %                   folderfiles_save = folderfiles_Enc_save;
        %                   cluster{1,1}     =  clusterEnc{1,1}(inda,:);
        %                 Ncond = 1;
        %
        %             case 2
        %                 % Retrieval
        % %                                 folderfiles_save = folderfiles_Ret_save;
        %
        % %                 cluster{1,1}     =  clusterRetr{1,1}(index_B,:);
        % %                 Ncond = 5;
        %
        %         end
        
        %         id = round(clusterEnc{1,1}(elem,4)*1000); REPETITION!
        %         ch = round(clusterEnc{1,1}(elem,5)*1000);
        
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
        
        
        %         m = mean(squeeze(tl_Miss.trial    ));
        %         s= std(squeeze(tl_Miss.trial    ));
        %         N = size(squeeze(tl_Miss.trial    ),1);
        %
        
        
        
        
        switch session % rename
            case 1, shadedErrorBar(t, m , s/sqrt(N),'b'), text(-.5,1,[char(subj_ID(id)) ' ' char(data.label(ch)) ' ' num2str(id)  ' ' num2str(ch)]);
            case 2, shadedErrorBar(t, m , s/sqrt(N),'r'), text(-.5,1.5,[char(subj_ID(id)) ' ' char(data.label(ch)) ' ' num2str(id)  ' ' num2str(ch)]);
        end
        hold on
        axis([-1 2 -2 2])
        
        M = [M m']
     end % channels% elem
    
    
    
    
    
    %
    
end % session
%% plot