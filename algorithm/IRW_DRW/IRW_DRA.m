function [auc,pre,rs,roc,sim] = IRW_DRA(train,test,recip,L,metrics)
    %DRA index
    %%%%%
    A = train;
    degree_out = repmat((sum(A,2)),[1,size(A,1)]);
    degree_in = repmat((sum(A,1)),[size(A,1),1]);
    temp = recip*A'./(degree_out);
    temp(isnan(temp)) = 0; temp(isinf(temp)) = 0;  
    W = A+temp; 
    
    temp = W./repmat(sum(A,2),[1,size(A,1)]);
    temp(isnan(temp)) = 0; temp(isinf(temp)) = 0;  
    sim = W*temp;
    %%%%%
    auc = [];pre = [];rs = [];roc = [];
    if metrics.isAUC auc = CalcAUC_directed(train,test,sim, 10000,1);end
    if metrics.isPRE [pre,rs] = CalcPrecisionRS_directed( train, test, sim, L,1 );end
    if metrics.isROC roc = CalcROC(train,test,sim, 1);end
end
