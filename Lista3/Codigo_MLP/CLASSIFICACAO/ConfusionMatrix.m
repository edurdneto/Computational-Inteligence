load t2_in.mat;
load t2_out.mat;
exp = T2_in';
obt = T2_out';

classes = [1 0 0 0 0 0;
            0 1 0 0 0 0; 
            0 0 1 0 0 0;
            0 0 0 1 0 0;
            0 0 0 0 1 0;
            0 0 0 0 0 1];
        
[~, ex] = ismember(exp(1+72*10:72*10+72,1:6), classes,'rows')    

[~, ob] = ismember(obt(1+72*10:72*10+72,1:6), classes,'rows')    

num_observations = length(ex);
num_classes = size(classes,1);
res=accumarray([ex,ob],ones(num_observations,1),[num_classes,num_classes])

save('confusion_min_Perceptron.mat','res');


