%% debugged and approved by T. Fedele on 08.04.2020
% please do not touch anymore!

info_summary_190520

%%

for id = 1:length(subj_ID) 
    
    char(subj_ID(id))
    %%
    for session = 1:2
        
               
        switch session
            case 1
                % Encoding
                foldertrials     =  [datafile_sep_Enc_trials char(subj_ID(id)) '\'] ;
                folderfiles      =  datafile_sep_Enc;
                folderfiles_save = folderfiles_Enc_save;
                good_chans_file  = good_chans_Enc_file;
                list_trial_type   = ls(foldertrials);
                list_trial_type(1:2,:) = [];
                for trltyp = 1:size(list_trial_type,1)
                     folderin = [foldertrials list_trial_type(trltyp,1) '\']
                 trialcollector181220(folderin, datafile_sep_Enc, char(subj_ID(id)),list_trial_type(trltyp,1));
                end
                
            case 2
                % Retrieval
                foldertrials     =  [datafile_sep_Ret_trials char(subj_ID(id)) '\'] ;                
                folderfiles      =  datafile_sep_Ret;
                folderfiles_save = folderfiles_Ret_save;
                good_chans_file  = good_chans_Ret_file;
                list_trial_type   = ls(foldertrials);
                list_trial_type(1:2,:) = [];
                for trltyp = 1:size(list_trial_type,1)
                     folderin = [foldertrials list_trial_type(trltyp,1) '\']
                 trialcollector181220(folderin, datafile_sep_Ret, char(subj_ID(id)),list_trial_type(trltyp,1));
                end
        end
        
        
        %% merging trial
        
        
        list           = ls([folderfiles '\*' char(subj_ID(id)) '*.mat']); % check the list of trials
        good_chs       = find(xlsread(good_chans_file,char(subj_ID(id)),'A1:A100'));
        [~,good_chs_labels,~]       =  xlsread(good_chans_file,char(subj_ID(id)),'C1:C100');
        
        
        if session == 2 & id == 4
            good_chs = good_chs-12;
            good_chsciao=good_chs<1;
            good_chs(good_chsciao)=[]
            good_chs_labels(good_chsciao)=[]
            good_chs_labels (1:4)= []
        end
        
        %channel_labels = xlsread(regionsfile,char(subj_ID(id)),'A3:A100');
        
        coord          = xlsread(regionsfile,char(subj_ID(id)),char(subj_excel_regions2(id)));    
        [~,anat_label]= xlsread(regionsfile,char(subj_ID(id)),char(subj_excel_anatomy(id)));
        
        %%
        for ff = 1:size(list,1)    % assemble trials in one file ft format
            
            char(subj_ID(id))
            
            WHEREWEARE = [id session ff]
            
            clear data
            
            load([folderfiles list(ff,:)])
            
            
            %select only good channels
            
            
            if  id == 4
                for tr = 1:size(data.trial,2)
                    data.trial{1,tr}(1:12,:) = [];
                end                
                data.label(1:12) = []; 
            end
            
            if  session == 1 & id == 6
                for tr = 1:size(data.trial,2)
                    data.trial{1,tr}([1:20 37:44],:) = [];
                end                
                data.label([1:20 37:44]) = [];             
            end
            
            if  id == 7 & session == 2  
                for tr = 1:size(data.trial,2)
                data.trial{1,tr}(25:end,:) = [];
                end
                data.label(25:end) = [];
            end
                
%             [lia,locb] = ismember(data.label, good_chs_labels(good_chs));
%              [ data.label(find(locb)) good_chs_labels(good_chs(locb(find(lia))))]
%              good_chs = find(locb);
            data = prunedata(data, good_chs, coord, subj_ID, id, ff, anat_label);   
            
%             %zscore data
timebase = [-.7 0]; % interval for the baseline in seconds
data = zscore_seeg(data,timebase)
            
            
            [ data.label good_chs_labels(good_chs)]
            [sum(ismember(data.label, good_chs_labels(good_chs))) length(data.label)]
            data.label = good_chs_labels(good_chs);
                        
                        data.label

            ch_trials = [length(data.label) length(data.trial)]
            
            mkdir(folderfiles_save)
            
            save([folderfiles_save list(ff,:)],'data')
            
            
            
        end % condition
        
        data
        
    end % session
    
end % subject
