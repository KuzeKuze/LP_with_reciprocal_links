%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��·Ԥ���������������Ի��ݱ�����
% Created in 2019-09-07 by Lijinsong
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;clc;
%% ��������
% addpath(genpath('../toolbox'));%�������繤����·��
addpath ./algorithm ./algorithm/Benchmarks ./algorithm/IRW_DRW ./algorithm/LNB ./algorithm/Reciprocal_Count ./function
path_dataset = '../data/';%���ݼ�·��
path_result = './results/';%�������·��
networks = char('ADO','HIG','PB','EMA','ATC','USA','CELE','FIG','FWFD','FWFW');
network_index = [1:8];
number_experiment = 30;%���ؿ���������
divide_ratio = [0.95:-0.05:0.6];
is_AUC = 1;is_PRE = 1;is_RS = 0;is_ROC = 0;%ѡ����õ����۷���
precision_L = 100;%���Ȳ��õĲ���
metrics = struct('isAUC',is_AUC,'isPRE',is_PRE,'isRS',is_RS,'isROC',is_ROC);
ExpSetup = struct('NetworkIndex',network_index,'NExpriment',number_experiment,'DivideRatio',divide_ratio,...
    'Metrics',metrics,'precision_L',precision_L);%ʵ������ṹ��
results = cell(7,length(network_index)+1);results(2:end,1) = {'AUC';'PRE';'RS';'vAUC';'vPRE';'vRS'};results(8,1) = {'Predictors'};
results_ratio = cell(2,length(divide_ratio));
%% ���ؿ������
% ��ith�ֻ��ֱ���
for ith_ratio = 1:length(divide_ratio)
    train_ratio = divide_ratio(ith_ratio);
    m_auc = [];m_precision = [];m_rs = [];v_auc = [];v_precision = [];v_rs = [];
    inetwork = 0;
    % ��ith�����ݼ�
    for ith_network = 1:length(network_index)
        inetwork = network_index(ith_network);
        origin_linklist = load(strcat(path_dataset,networks(inetwork,:),'.txt'));
        [adjmatrix,linklist] = FormNet(origin_linklist,'du');
        precision_L = ceil(nnz(adjmatrix)*0.01);%ȡ�ܱ���ǰ1%�Ĳ��Ա߼���Precision
        if precision_L<50 precision_L=50;end
        rho(ith_network) = nnz(adjmatrix.*adjmatrix')/nnz(adjmatrix)
        % ��ith�η���
        for ith_exp = 1:number_experiment
            disp(strcat(networks(inetwork,:),'(',num2str(ith_network),'/',num2str(length(network_index)),...
                '),',num2str(train_ratio),',',num2str(ith_exp),'/',num2str(number_experiment)));
            % �������ݼ�
            [train,test] = DivideNet(adjmatrix,train_ratio,'du');
            % ��������ָ��
            [allMetricValue,selected_indices] = TestAllIndices(train,test,precision_L,ExpSetup);
            allAUC(ith_exp,:) = allMetricValue(1,:);
            allPRE(ith_exp,:) = allMetricValue(2,:);
            allRS(ith_exp,:) = allMetricValue(3,:);
        end
        % �����ֵ������
        m_auc = mean(allAUC,1);v_auc = var(allAUC,1);
        m_precision = mean(allPRE,1);v_precision = var(allPRE,1);
        m_rs = mean(allRS,1);v_rs = var(allRS,1);
        % ����ÿ������Ľ��
        results(1,ith_network+1) = {networks(inetwork,:)};
        results(2:7,ith_network+1) = {m_auc;m_precision;m_rs;v_auc;v_precision;v_rs};
        results(8,2) = {selected_indices};
        save('../results/temp_results.mat','results');
    end
    % ����ÿ�����ֵĽ��
    results_ratio(1,ith_ratio) = {train_ratio};
    results_ratio(2,ith_ratio) = {results};
    save('../results/temp_results_ratio.mat','results_ratio');
end
disp('All done...');
