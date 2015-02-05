clear;
clc;
X=load('input_for_AB.txt');
for i=1:size(X,2)-1
    Total_Data(:,i)=X(:,i);
end
Total_label=X(:,size(X,2));
clear X;
val_factor=0.2;
rand=randperm(size(Total_Data,1));
rand_val=rand(1:size(Total_Data,1)*val_factor);
rand_train=rand(size(Total_Data,1)*val_factor+1:size(Total_Data,1));
val_size=size(rand_val,2);
train_size=size(rand_train,2);
Y2=[];
O=[];
Y=[];
D=[];
for i=1:val_size
    Y2=[Y2; Total_label(rand_val(i))];
    O=[O; Total_Data(rand_val(i),:)];
end
for i=1:train_size
    Y=[Y; Total_label(rand_train(i))];
    D=[D; Total_Data(rand_train(i),:)]; 
end
Out_size=size(O,1);
G=[];
data_size=size(D,1);
U_sum=[];
record=[];
iter=uint16(log(data_size));
et=[];
Total_U=[]; %%
%initial U
for i=1:data_size
    U(i,1)=1/size(Y,1);
end

U_sum=[U_sum sum(U(:,1))];
Sort_total=sort(D);
for T=1:iter
    z=T
    for i=1:size(D,2)
       Sort_data=Sort_total(:,i);
       Stump_data=[Sort_data(1)-1;Sort_data;Sort_data(data_size)+1];
       for j=1:data_size+1
           theda=(Stump_data(j)+Stump_data(j+1))/2;
           S=1;
           err=0;
           for k=1:data_size
                if S*sign(D(k,i)-theda) ~= Y(k)
                    err=err+U(k);
                end    
           end
           e=err/sum(U);
           S=-1;
           err=0;
           for k=1:data_size
                if S*sign(D(k,i)-theda) ~= Y(k)
                    err=err+U(k);
                end    
           end
           e2=err/sum(U);
           record=[record;1 theda i e;-1 theda i e2];
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
Eout=err/Out_size


