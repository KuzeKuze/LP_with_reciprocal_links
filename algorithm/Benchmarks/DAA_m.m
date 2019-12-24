function [auc,pre,rs,roc,sim] = DAA_m(train,test,L,metrics)
    %DAA index
    A = train;
    k_out = repmat(log(sum(A,2)),[1,size(A,1)]);
    k_in = repmat(log(sum(A,1)),[size(A,1),1]);
    %%%%%
    temp = A ./ (k_out.*k_in'); 
    % ����ÿ���ڵ��Ȩ�أ�1/log(k_i),�����ģ����ʱ��Ҫ�ֿ鴦��
    temp(isnan(temp)) = 0; temp(isinf(temp)) = 0;  
    % ������Ϊ0�õ����쳣ֵ��Ϊ0
    sim = A * temp;
    %%%%%
    auc = [];pre = [];rs = [];roc = [];
    if metrics.isAUC auc = CalcAUC_directed(train,test,sim, 10000,1);end
    if metrics.isPRE [pre,rs] = CalcPrecisionRS_directed( train, test, sim, L,1 );end
    if metrics.isROC roc = CalcROC(train,test,sim, 1);end
end
