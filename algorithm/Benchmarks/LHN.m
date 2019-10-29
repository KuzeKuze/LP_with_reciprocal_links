function [auc,pre,rs,roc,sim] = LHN( train, test,L,metrics )
    %% ����LHN-Iָ�겢����AUCֵ
    sim = train * train;     
    % ��ɷ��ӵļ��㣬����ͬ��ͬ�ھ��㷨
    deg_out = sum(train,2);
    deg_in = sum(train,1);
    deg = deg_out*deg_in;                                         
    %��ɷ�ĸ�ļ���
    sim = sim ./ deg;                                      
    %���ƶȾ���ļ���
    sim(isnan(sim)) = 0; sim(isinf(sim)) = 0;  
    %%%%%
    auc = [];pre = [];rs = [];roc = [];
    if metrics.isAUC auc = CalcAUC_directed(train,test,sim, 10000,1);end
    if metrics.isPRE [pre,rs] = CalcPrecisionRS_directed( train, test, sim, L,1 );end
    if metrics.isROC roc = CalcROC(train,test,sim, 1);end
end
