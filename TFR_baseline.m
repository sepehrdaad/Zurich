function [TFR1,TFR2,TFR3] = TFR_baseline(TFR1,TFR2,TFR3,baseline);


% figure
% compute TF baseline
t = TFR1.time;

[~,samples_base1] = (min(abs(baseline(1)-t)));
[~,samples_base2] = (min(abs(baseline(2)-t)));
samples_base      = samples_base1:samples_base2;

% normalization to TFR1 baseline
TFbase = nanmean([  squeeze(nanmean(TFR1.powspctrm(1,:,samples_base),3))
                    squeeze(nanmean(TFR2.powspctrm(1,:,samples_base),3))
                    squeeze(nanmean(TFR3.powspctrm(1,:,samples_base),3))]);

TFbase_m(1,:,:) = repmat(TFbase',1,length(TFR1.time) );
TFR1.powspctrm = TFR1.powspctrm./TFbase_m;
TFR2.powspctrm = TFR2.powspctrm./TFbase_m;
TFR3.powspctrm = TFR3.powspctrm./TFbase_m;
 