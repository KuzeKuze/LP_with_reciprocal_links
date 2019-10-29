function [auc,pre,rs,roc,sim] = Jaccard( train, test,L,metrics )
    %% ����jaccardָ�겢����AUCֵ
    sim = train * train;               
    % ��ɷ��ӵļ��㣬����ͬ��ͬ�ھ��㷨
    deg_in = repmat(sum(train,1), [size(train,1),1]);
    deg_in = deg_in .* spones(sim);  
    deg_out= repmat(sum(train,2), [1,size(train,1)]);
    deg_out = deg_out .* spones(sim);
    % ֻ�豣�����Ӳ�Ϊ0��Ӧ��Ԫ��
    deg_sum = deg_in + deg_out;                      
    % ����ڵ��(x,y)�����ڵ�Ķ�֮��
    sim = sim./(deg_sum.*spones(sim)-sim); clear deg_sum;           
    % �������ƶȾ��� �ڵ�x��y������Ԫ����Ŀ = x��y�Ķ�֮�� - ������Ԫ����Ŀ
    sim(isnan(sim)) = 0; sim(isinf(sim)) = 0;
    %%%%%
    auc = [];pre = [];rs = [];roc = [];
    if metrics.isAUC auc = CalcAUC_directed(train,test,sim, 10000,1);end
    if metrics.isPRE [pre,rs] = CalcPrecisionRS_directed( train, test, sim, L,1 );end
    if metrics.isROC roc = CalcROC(train,test,sim, 1);end
end
