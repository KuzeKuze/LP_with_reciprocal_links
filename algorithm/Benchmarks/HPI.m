function [auc,pre,rs,roc,sim] = HPI( train, test,L,metrics )
    %% ����HPIָ�겢����AUCֵ
    sim = train * train;       
    % ��ɷ��ӵļ��㣬����ͬ��ͬ�ھ��㷨
    deg_in = repmat(sum(train,1), [size(train,1),1]);
    deg_in = deg_in .* spones(sim);
    deg_out = repmat(sum(train,2), [1,size(train,1)]);
    deg_out = deg_out .* spones(sim);
    deg_min = min(deg_in, deg_out); 
    % ��ɷ�ĸ�ļ��㣬����Ԫ��(i,j)��ʾȡ�˽ڵ�i�ͽڵ�j�Ķȵ���Сֵ
    sim = sim ./ deg_min; clear deg_min;      
    % ������ƶȾ���ļ���
    sim(isnan(sim)) = 0; sim(isinf(sim)) = 0;    
    %%%%%
    auc = [];pre = [];rs = [];roc = [];
    if metrics.isAUC auc = CalcAUC_directed(train,test,sim, 10000,1);end
    if metrics.isPRE [pre,rs] = CalcPrecisionRS_directed( train, test, sim, L,1 );end
    if metrics.isROC roc = CalcROC(train,test,sim, 1);end
end
