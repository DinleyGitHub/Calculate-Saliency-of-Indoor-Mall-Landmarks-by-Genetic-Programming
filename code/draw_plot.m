
% ��ͼ����
function draw_plot(Proportion)
a=sort(Proportion(:,1));
b=sort(Proportion(:,2));
huatu(a);
huatu(b);
% �ֲ��������
end



function huatu(all_salience)
[mu,sigma]=normfit(all_salience);
if isnormal(sort(all_salience),mu,sigma,0.05) % �ж��Ƿ������̬�ֲ�
    gauss_tatal(sort(all_salience), sigma, mu);  % ��ʵȫ�������ȵĸ�˹�ֲ�[��׼�����]
else
    disp('�����ͼ��');
end
end

% �ж��Ƿ������̬�ֲ�
function a =isnormal(x,mu,sigma,alpha)
p = normcdf(x,mu,sigma);
[h1,~]=kstest(x,[x,p],alpha);
if h1==0
    disp('������̬�ֲ���');
    a=true;
else
    disp('��������̬�ֲ���');
    a=false;
end

end

% �����ֲ�ͼ
function gauss_tatal(x, sig, mu)
figure;
y = gaussmf(x,[sig mu]);
[counts,centers] = hist(x, 4);
bar(centers, counts);
% bar(centers, counts / sum(counts));
hold on; %������ͼ����ͬһ��ͼ��
plot(x,y);
xlabel(['gaussmf, P=[','sig=',num2str(sig),'  mu=',num2str(mu),']']);

end