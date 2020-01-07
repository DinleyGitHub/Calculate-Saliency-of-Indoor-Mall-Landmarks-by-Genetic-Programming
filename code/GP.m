function [gp_pre_data,gp_top1,gp_sort,gp_evalstr,gp,runnum,gptoc,valid_acc]=GP(runnum,n,train_porp,train_rank,test_porp,test_rank,val_porp,val_rank)
tic;
name='valbest';    %valbest    testbest    best
accuracy_out={runnum,4}; 

for i=1:runnum
    disp(['��',num2str(n),'��  ','��',num2str(i),'��/��',num2str(runnum),'��']);
    [evalstr1,gp]=run(name,train_porp,train_rank,test_porp,test_rank,val_porp,val_rank); %�����֤������õ�ģ��Ԥ��ľ���
    accuracy_out{i,1}=evalstr1;
    accuracy_out{i,2}=gp.results.valbest.valfitness;
    if gp.results.valbest.valfitness>1
      pause;
    end
    accuracy_out{i,3}=gp.results.valbest.returnvalues;
    accuracy_out{i,4}=gp.results.valbest.eval_individual;
end
%dlmwrite (['5fold_crass\Fold',num2str(n),'valbestreturnvalues.txt'],num2str(gp.results.valbest.returnvalues),'delimiter','\t','newline','pc');
dlmwrite (['5fold_crass\Fold',num2str(n),'valid_accuracy.txt'],cell2mat(accuracy_out(:,2)),'delimiter','\t','newline','pc');
%dlmwrite (['5fold_crass\Fold',num2str(n),'gp_valid_accuracy.txt'],cell2mat(accuracy_out(:,3)),'delimiter','\t','newline','pc');
save (['5fold_crass\Fold',num2str(n),'gp_train_out']);
[valid_acc,index]=max(cell2mat(accuracy_out(:,2)));
gp_evalstr=accuracy_out{index,1};
returnvalues=accuracy_out{index,3};
eval_individual=accuracy_out{index,4};
[gp_top1,gp_sort,gp_pre_data]=test_accuracy(returnvalues,eval_individual,gp.userdata.test_rank,gp.userdata.xtest,gp.userdata.ytest);
gptoc=toc;

disp(['��֤�����ֵ',num2str(valid_acc)]);
end

function [evalstr,gp]=run(name,train_porp,train_rank,test_porp,test_rank,val_porp,val_rank)
gp=rungp('GP_config',train_porp,train_rank,test_porp,test_rank,val_porp,val_rank);
disp(['>>gppretty(gp,',name,');']); %��֤������õĸ���Ҳ������ѵ��������õĸ��壬��������֤������õ�
disp('-----------------------------------------------------------');
exprSym=gppretty(gp,name,0,1,0,1);
evalstr=char(vpa(exprSym,4));
end

function report(gp,name)

%��ʾGP������ģ�͵�����Ƶ������ͼ��
%��Դ��ѵ�����ϵ�R2 >= 0.6������R2Ϊģ����ѵ�������ϵ��ж�ϵ����
gppopvars(gp,0.75);

%plot the best and mean fitness, ��Դ��ѵ�����ϵ�
%�������й����е����(logֵ)��ƽ����Ӧ�ȡ�
summary(gp);  

%�����ǰ�����еġ���ѡ��������Ϊ�����Լ��л�����֤���ϵ�
runtree(gp,name);

%Ϊ��ѵ��������ִ�е���õ�ģ������һ������(��������ݴ��ڵĻ�)�� modelreport.htm
%Ϊ����֤������ִ�е���õ�ģ������һ������(��������ݴ��ڵĻ�)��
%Ϊ�ڲ���������ִ�е���õ�ģ������һ������(��������ݴ��ڵĻ�)��
gpmodelreport(gp,name); 

%����һ����Ϊpareto��HTML���档htm��GPTIPS���ݽṹGP
%�ж������Żع�ģ�ͱ�︴����/R2������ǰ���о� pareto.htm
paretoreport(gp); 

%���ڲ���������ִ�е���õĸ���(��������ݴ���)������ trees.htm
drawtrees(gp,name); 

end