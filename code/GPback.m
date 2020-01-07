function GP()
clc;
name='valbest';    %valbest    testbest    best
runnum=0;  err=0; i=0;  iteration=3;
rank_rate2=0;
accuracy_out={};
while true
    runnum=runnum+1;   %ͳ���Ŵ��滮�����˶��ٴ�
    [rank_rate,gp]=run(name,runnum); %������Լ�����õ�ģ��Ԥ��ľ���
%     rank_rate1=rank_rate;
     accuracy_out{runnum,1}=rank_rate;
%     
%     if rank_rate1-rank_rate2>=err   %�����ڽ����ε����
%         i=i+1;   %ͳ�������ڽ����ε����ĸ���
%     else          
%         i=0;   %�����һ�����е�������Ҫ��i���¹�Ϊ0����֤��������
%     end
%     rank_rate2=rank_rate1;
%     
%     if i==iteration   %�ﵽ����������ͣ��
%         break;
%     end
    
    save accuracy_out;
    if rank_rate>0.7
        break;
    end
end

%report(gp,name);
disp(['���д���',num2str(runnum)]);
end


function [rank_rate,gp]=run(name,runnum)

disp('>>rungp(''GP_config'');');
%�˿����ɲ���֤
[gp,n]=rungp('GP_config');

disp(['>>runtree(gp,',name,');']);

%��Matlab���������ʾ��Ⱥ��(�����ڷ��Żع�����)���ģ��(�����������)����ѧ�򻯰汾��
%���ڲ���������ִ�е���õ�ģ��(������ڵĻ�)�������Ѹ������ص㣬����Ĳ�����Ҫ��
disp(['>>gppretty(gp,',name,');']); %��֤������õĸ���Ҳ������ѵ��������õĸ��壬��������֤������õ�
exprSym=gppretty(gp,name,0,1,0,1);
evalstr=strrep(char(vpa(exprSym,4)),'*','.*');
evalstr=strrep(evalstr,'^','.^');
%evalstr=strrep(evalstr,'x','p');
rank_rate=test_accuracy(evalstr,gp,n,runnum);    %ֱ�Ӳ���

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