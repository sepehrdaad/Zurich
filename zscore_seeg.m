function data = zscore_seeg(data, timebase)   

% function to reduce number of channels in the ft struct
% input:
% data, timebase [seconds]
% output
% data zscored with data.zscore value for each trial, channel
 
[~,samples_base1] =  (min(abs(timebase(1)-data.time{1,1})));
[~,samples_base2] =  (min(abs(timebase(2)-data.time{1,1})));

samples_base = samples_base1:samples_base2;

for tr = 1:length(data.trial)
      for ch = 1:length(data.label)
          [tr ch]
        data.zscore(tr,ch)  = std(data.trial{1,tr}(ch,samples_base));
        data.trial{1,tr}(ch,:) = data.trial{1,tr}(ch,:)/data.zscore(tr);
    end    
end

