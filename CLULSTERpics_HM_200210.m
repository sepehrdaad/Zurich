 
t = tl_CorrAss.time;

figure('Name',num2str(cl))

m = mean(squeeze(tl_CorrAss.trial    ));
s = std(squeeze(tl_CorrAss.trial    ));
N = size(squeeze(tl_CorrAss.trial    ),1);
shadedErrorBar(t, m , s/sqrt(N),'b')
 hold on
m = mean(squeeze(tl_Miss.trial    ));
s = std(squeeze(tl_Miss.trial    ));
N = size(squeeze(tl_Miss.trial    ),1);
shadedErrorBar(t, m , s/sqrt(N),'r')

 

signi = find(stat13.mask(ch,:)>0);
            if length(signi)
                hold on,
                plot(stat13.time(signi),  -0.9e-4*ones(1,length(signi)),'b*','linewidth',4)
            end
             signi = find(stat13.mask(ch,:)>0);
             
         axis([-1 2 -1e-4 1e-4]) 
            xlabel('Time (s)'), ylabel('Amplitude ( V) ')

grid off

 




 
 
