function [pre,rs] = CalcPrecisionRS_directed(train,test,sim,L_eric,direction)
        N_node = size(train,1);
        C = speye(N_node)+train;
        sim = sim - sim.*C; %��仰��һ��ͨ
        U = diag(ones(1,N_node));
        U = ~U;
        H = U-train;
        N_H = nnz(H);
        N_test = nnz(test);
        un_C = sim.*H;
        %��������
        [rank,index]=sort(un_C(:),'descend');
        n=length(L_eric);
        pre=[];
        %��L���Ͻ��м�����precision
        for i=1:n
        %ȡǰL��ֵ
        al=index(1:L_eric(i));
        %��m/L
        pre=[pre sum(test(al))./L_eric(i)];
        end
        pre = pre;
        rs = zeros(1,length(pre));
end