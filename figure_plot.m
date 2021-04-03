t = tl_CorrAss.time;

figure('Name',num2str(cl))


m = mean(squeeze(tl_CorrAss.trial    ));
s = std(squeeze(tl_CorrAss.trial    ));
N = size(squeeze(tl_CorrAss.trial    ),1);
shadedErrorBar(t, m , s/sqrt(N),'b')
hold on
m = mean(squeeze(tl_IncorrAss.trial    ));
s = std(squeeze(tl_IncorrAss.trial    ));
N = size(squeeze(tl_IncorrAss.trial    ),1);
shadedErrorBar(t, m , s/sqrt(N),'g')
hold on
m = mean(squeeze(tl_Miss.trial    ));
s = std(squeeze(tl_Miss.trial    ));
N = size(squeeze(tl_Miss.trial    ),1);
shadedErrorBar(t, m , s/sqrt(N),'r')