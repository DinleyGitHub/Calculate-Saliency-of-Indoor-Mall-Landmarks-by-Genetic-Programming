function [boom_gene_outputs]=boomtrain(data,predict_data)
sum_end=0; %ĳ�����������Ӧ����������
for j=1:size(data,1)
    one_rank=rmmissing(data(j,:));  % ���һ������������ȥ����ֵ
    n=size(one_rank,2);
    sum_end=sum_end+n;
    sum_bef=sum_end-n+1;
    rank_data=predict_data(sum_bef:sum_end,:);
    [sort_rank_data,id1]=sort(rank_data,'descend'); %�Ӵ�С����֮ǰ��λ��
    %��������ظ�����
    [sort_rank_data,id2]=sort(sort_rank_data,'descend'); %�Ӵ�С�������ڵ�λ��
    big_sort_rank_data=sort_rank_data+sort(id2,'descend'); %ͬһλ�÷Ŵ�
    if n==3
       M1=containers.Map([1,2,3],{'A','B','C'});
       M3=containers.Map({'A','B','C'},one_rank);
    else
        if  n==4
            M1=containers.Map([1,2,3,4],{'A','B','C','D'});
            M3=containers.Map({'A','B','C','D'},one_rank);
        else
            disp(['���ȳ���',length(one_rank)]);
        end
    end
    M2 = containers.Map(big_sort_rank_data,id1);
    outputs={};
    rank_outputs=[]; %����������������
    for k=1:n  %�Ѽ����ֵ����1,2,3,4
        outputs{k}=M1(M2(big_sort_rank_data(k,:)));
        rank_outputs(k)=M3(outputs{k});
    end

    boom_gene_outputs(1,j)=rank_outputs;
end
end