function [ net,mlinklist ] = FormNet( linklist,type )
    %% ���������б�linklist�����������ڽӾ���net
    %---- ����ڵ��Ŵ�0��ʼ�������нڵ��ż�1��matlab���±��1��ʼ��
    if ~all(all(linklist(:,1:2)))
        linklist(:,1:2) = linklist(:,1:2)+1;
    end
    if size(linklist,2) == 4 linklist = linklist(:,1:3);end %ȥ��ʱ����
    linklist = unique(linklist,'rows');%ɾ���ظ���
    if(strcmp(type,'uu')||strcmp(type,'du')||size(linklist,2)==2)
    %----������ͼ����������Ԫ����Ϊ1
        linklist(:,3) = 1;
    end
    net = spconvert(linklist);
    nodenum = length(net);
    net(nodenum,nodenum) = 0;                               
    % �˴�ɾ���Ի����Խ�ԪΪ0�Ա�֤Ϊ����
    net = net-diag(diag(net));
    if(strcmp(type,'uu')||strcmp(type,'uw'))
        net = spones(net + net'); % ������Ȩ�������ô˾�ת��Ϊ�Գƾ���
    % ȷ���ڽӾ���Ϊ�Գƾ��󣬼���Ӧ����������
    end
    [x,y,w] = find(net);
    mlinklist = [x,y,w];
end 
% ת�����̽������õ�������ڽӾ���
