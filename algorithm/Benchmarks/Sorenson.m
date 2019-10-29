function [auc,pre,rs,roc,sim] = Sorenson( train, test,L,metrics )
    %% ����Sorensonָ�겢����AUCֵ
    sim = train * train;                                            
    % �������
    deg_out = repmat(sum(train,2), [1 size(train,1)]); 
    deg_in = repmat(sum(train,1), [size(train,1),1]);
    % �����ĸ
    deg_sum = deg_out + deg_in;
    sim = 2 * sim ./ deg_sum;                             
    % ���ƶȾ���������
    sim(isnan(sim)) = 0; sim(isinf(sim)) = 0;       
    %%%%%
    auc = [];pre = [];rs = [];roc = [];
    if metrics.isAUC auc = CalcAUC_directed(train,test,sim, 10000,1);end
    if metrics.isPRE [pre,rs] = CalcPrecisionRS_directed( train, test, sim, L,1 );end
    if metrics.isROC roc = CalcROC(train,test,sim, 1);end
end
