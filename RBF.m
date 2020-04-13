
l1 = 10; % length of first arm
l2 = 7; % length of second arm
l3 = 5; % length of third arm
%%traning data
theta1 = rand(1,12)*90; % all possible theta1 values
theta2 = rand(1,12)*90; % all possible theta2 values
theta3 = rand(1,12)*90; % all possible theta3 values
% generate a grid of theta1 and theta2 and theta3 values
[THETA1, THETA2,THETA3] = ndgrid(theta1, theta2, theta3); 
% compute x coordinates
X = l1 * cos(THETA1*pi/180) + l2 * cos(THETA1*pi/180 + THETA2*pi/180) + l3*cos(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180); 
  % compute y coordinates
Y = l1 * sin(THETA1*pi/180) + l2 * sin(THETA1*pi/180 + THETA2*pi/180) + l3*sin(THETA1*pi/180+THETA2*pi/180+THETA3*pi/180);
phi = THETA1 + THETA2 + THETA3;
% create training dataset
data = [X(:) Y(:) phi(:) THETA1(:) THETA2(:) THETA3(:)]; 

data_ = data(  randperm( size(data, 1) ),   :  );

%Data Splitting
train_partition_1 = data_(1:round( size(data_,1)*5/7),1:4);  
train_partition_2 = data_(1:round(size(data_,1)*5/7),[1,2,3,5]);
train_partition_3 = data_(1:round(size(data_,1)*5/7),[1,2,3,6]);  

check_partition_1 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),1:4);
check_partition_2 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),[1,2,3,5]);
check_partition_3 = data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),[1,2,3,6]);

test_partition_1 = data_(round(size(data_,1)*6/7)+1:size(data_,1),1:4);
test_partition_2 = data_(round(size(data_,1)*6/7)+1:size(data_,1),[1,2,3,5]);
test_partition_3 = data_(round(size(data_,1)*6/7)+1:size(data_,1),[1,2,3,6]);
%


%net1=newrb(train_partition_1(:,1:3)',train_partition_1(:,4)',0.8,5,300,8);
net1= fitnet(8);
net1.layers{1}.transferFcn = 'radbas';
tic
net1 = train(net1,train_partition_1(:,1:3)',train_partition_1(:,4)');
toc
thetar1=sim(net1,test_partition_1(:,1:3)');

%net2=newrb(trndata2(:,1:3)',trndata2(:,4)',0.8,5,300,8);
net2= fitnet(8);
net2.layers{1}.transferFcn = 'radbas';
tic
net2 = train(net2,train_partition_2(:,1:3)',train_partition_2(:,4)');
toc
thetar2=sim(net2,test_partition_2(:,1:3)');

%net3=newrb(trndata3(:,1:3)',trndata3(:,4)',0.8,5,300,8);
net3= fitnet(8);
net3.layers{1}.transferFcn = 'radbas';
tic
net3 = train(net3,train_partition_3(:,1:3)',train_partition_3(:,4)');
toc
thetar3=sim(net3,test_partition_3(:,1:3)');

Xr = l1 * cos(thetar1*pi/180) + l2 * cos(thetar1*pi/180 + thetar2*pi/180) 
+l3*cos(thetar1*pi/180 + thetar2*pi/180 + thetar3*pi/180); 
Yr = l1 * sin(thetar1*pi/180) + l2 * sin(thetar1*pi/180 + thetar2*pi/180) 
+l3*sin(thetar1*pi/180 + thetar2*pi/180 + thetar3*pi/180);
thetar1_diff=test_partition_1(:,4)-thetar1(:);
thetar2_diff=test_partition_2(:,4)-thetar2(:);
thetar3_diff=test_partition_3(:,4)-thetar3(:);
xr_diff=test_partition_1(:,1)-Xr(:);
yr_diff=test_partition_1(:,2)-Yr(:);
%error=sum(sqrt(xr_diff.^2+yr_diff.^2))/length(xr_diff);
xyrMSE=sum(xr_diff.^2+yr_diff.^2)/length(xr_diff);
xyrMAE=sum(abs(xr_diff)+abs(yr_diff))/length(xr_diff);
figure()
subplot(3,1,1);
plot(thetar1_diff);
ylabel('theta1 error')
title('Desired theta1 - Predicted theta1(degree)')

subplot(3,1,2);
plot(thetar2_diff);
ylabel('theta2 error')
title('Desired theta2 - Predicted theta2(degree)')

subplot(3,1,3);
plot(thetar3_diff);
ylabel('theta3 error')
title('Desired theta3 - Predicted theta3(degree)')

figure()
quiver(test_partition_1(:,1),test_partition_1(:,2),xr_diff,yr_diff)



