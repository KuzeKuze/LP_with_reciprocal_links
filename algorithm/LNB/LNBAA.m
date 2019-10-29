function [auc,pre,rs,roc,sim] = LNBAA(train,test,L,metrics)
    %LNBRA index
    A = train;
    %%%%%
    s = size(A,1)*(size(A,1)-1) / nnz(A) -1;  
    % ����ÿ�������еĳ���s
    tri = diag(A*A*A)/2;     
    % ����ÿ�������ڵ������θ���
    tri_max = sum(A,2).*(sum(A,2)-1)/2;  
    % ÿ�������������ڵ������θ���
    R_w = (tri+1)./(tri_max+1);
    % �����������ǰ��չ�ʽ����ÿ����Ľ�ɫ  
    SR_w = (log(s)+log(R_w))./log(sum(A,2));
    SR_w(isnan(SR_w)) = 0; SR_w(isinf(SR_w)) = 0;
    SR_w = repmat(SR_w,[1,size(A,1)]) .* A;   
    % �ڵ�Ľ�ɫ�������
    sim = spones(A) * SR_w;
    %%%%%
    auc = [];pre = [];rs = [];roc = [];
    if metrics.isAUC auc = CalcAUC_directed(train,test,sim, 10000,1);end
    if metrics.isPRE [pre,rs] = CalcPrecisionRS_directed( train, test, sim, L,1 );end
    if metrics.isROC roc = CalcROC(train,test,sim, 1);end
end
