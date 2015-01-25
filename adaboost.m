clear;
clc;
X=load('hw2_adaboost_train.txt');
for i=1:size(X,2)-1
    D(:,i)=X(:,i);
end
Y=X(:,size(X,2));
clear X;
X=load('hw2_adaboost_test.txt');
for i=1:size(X,2)-1
    O(:,i)=X(:,i);
end
Y2=X(:,size(X,2));
%initial U
Out_size=size(O,1);
G=[];
data_size=size(D,1);
U_sum=[]
record=[];
iter=300;
et=[];
for i=1:data_size
    U(i,1)=1/size(Y,1);
    
end
U_sum=[U_sum sum(U(:,1))];
for T=1:iter
    for i=1:size(D,2)
       Sort_data=sort(D(:,i));
       Stump_data=[Sort_data(1)-1;Sort_data;Sort_data(data_size)+1];
       for j=1:data_size+1
           theda=Stump_data(j)+Stump_data(j+1);
           S=1;
           err=0;
           for k=1:data_size
                if S*sign(D(k,i)-theda) ~= Y(k)
                    err=err+U(k);
                end    
           end
           e=err/sum(U);
           record=[record;1 theda i e;-1 theda i 1-e];
       end
    end
    %record G
    [minum,index]=min(record(:,4));
    et=[et minum];
    diamond=((1-minum)/minum)^0.5;
    G=[G;record(index,1:3) log(diamond)];
    record=[];
    %update u
    temp_S=G(T,1);
    temp_theda=G(T,2);
    temp_dim=G(T,3);
    for j=1:data_size
        if temp_S*sign(D(j,temp_dim)-temp_theda) == Y(j)
            U(j)=U(j)/diamond;
        else
            U(j)=U(j)*diamond;
        end
    end
    U_sum=[U_sum sum(U(:,1))];
end
% claculate Ein 
err=0;
for i=1:data_size
    value=0;
    for j=1:iter
        S=G(j,1);
        theda=G(j,2);
        dim=G(j,3);
        alpha=G(j,4);
        value=value+alpha*S*sign(D(i,dim)-theda);
    end
    if sign(value)~=Y(i)
        err=err+1;
    end
end
Ein=err/data_size

% claculate Eout 
err=0;
for i=1:Out_size
    value=0;
    for j=1:iter
        S=G(j,1);
        theda=G(j,2);
        dim=G(j,3);
        alpha=G(j,4);
        value=value+alpha*S*sign(O(i,dim)-theda);
    end
    if sign(value)~=Y2(i)
        err=err+1;
    end
end
Eout=err/Out_size;




