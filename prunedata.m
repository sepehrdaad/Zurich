function data = prunedata(data, good_chs, coord, subj_ID, id, ff, anat_label)   

% function to reduce number of channels in the ft struct
% input:
% data, good_chs, coord, subj_ID, id, ff,anat_label
% output
% data pruned
% % check



for tr = 1:length(data.trial)
    data.trial{1,tr} = data.trial{1,tr}(good_chs,:);
end

data.elec.chanpos = coord(good_chs,:);
data.elec.elecpos = coord(good_chs,:);
data.elec.label   = data.label(good_chs);
data.elec.tra     = eye(length(good_chs));
data.label        = data.label(good_chs);
data.anatomy      = anat_label(good_chs);

 

