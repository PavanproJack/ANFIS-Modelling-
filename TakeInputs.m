clc, clear 

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

trndata1=data_(1:round( size(data_,1)*5/7),1:4); %21600*4
chkdata1=data_(round(size(data_,1)*5/7)+1:round(size(data_,1)*6/7),1:4);
tesdata1=data_(round(size(data_,1)*6/7)+1:size(data_,1),1:4);

clusteringType = input('Input the type of clustering :   ');

switch clusteringType
      case 1  % GridPartition
          
            genOpt = genfisOptions('GridPartition');
            genOpt.NumMembershipFunctions = [4 4 4];
            genOpt.InputMembershipFunctionType = ["trimf" "gaussmf", "gaussmf"];
            genfisObject=genfis(trndata1(:, 1:3),trndata1(:, 4), genOpt);
            
            %{
                [x,mf] = plotmf(genfisObject, 'input',1);
                subplot(3, 1, 1);
                plot(x,mf)
                xlabel('Membership Functions for Input 1')

                [x,mf] = plotmf(genfisObject, 'input',2);
                subplot(3, 1, 2);
                plot(x,mf)
                xlabel('Membership Functions for Input 2')

                [x,mf] = plotmf(genfisObject, 'input',3);
                subplot(3, 1, 3);
                plot(x,mf)
                xlabel('Membership Functions for Input 3')
                %}
            
      case 2  % FCM Clustering
          
            genOpt = genfisOptions('FCMClustering' );
            genfisObject=genfis(trndata1(:, 1:3),trndata1(:, 4), genOpt);
            
      case 3  % Subtractive Clustering
          
            genOpt = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange',[0.5 0.25 0.3 0.4]); 
            genfisObject=genfis(trndata1(:, 1:3),trndata1(:, 4), genOpt);
            
    otherwise 
            disp('Something went wrong')
end


anfisOpt = anfisOptions('InitialFIS',genfisObject);
anfisOpt.DisplayANFISInformation = 0;
anfisOpt.DisplayErrorValues = 0;
anfisOpt.DisplayStepSize = 0;
anfisOpt.DisplayFinalResults = 0;
anfisOpt.ValidationData = chkdata1;

%  [fis,trainError,stepSize,chkFIS,chkError] = anfis(trainingData,options)

fprintf('-->%s\n','Start training first ANFIS network.')
%outFIS = anfis(trndata1(:,1:4), anfisOpt);

[outFis,trainError,stepSize, chkFIS, chkError] = anfis(trndata1(:,1:4), anfisOpt);

chkOut1 = evalfis(chkFIS, tesdata1(:,1:3) );   

theta1_diff=tesdata1(:,4)-chkOut1;

figure()
subplot(3,1,1);
plot(theta1_diff);
ylabel('theta1 error')
title('Desired theta1 - Predicted theta1(degree)')








