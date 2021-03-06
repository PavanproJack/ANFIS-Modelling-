function [outputArg1, outputArg2, outputArg3, outputArg4] = anfisEval(trainData, validationData, testData, genfisObject, number)
        %ANFISEVAL Summary of this function goes here
        %   Detailed explanation goes here
        
        anfisOpt = anfisOptions('InitialFIS',genfisObject);
        %anfisOpt.ErrorGoal = 0.9;
        anfisOpt.DisplayANFISInformation = 1;
        anfisOpt.DisplayErrorValues = 1;
        anfisOpt.DisplayStepSize = 1;
        anfisOpt.DisplayFinalResults = 1;
        anfisOpt.ValidationData = validationData;
        
        %  [fis,trainError,stepSize,chkFIS,chkError] = anfis(trainingData,options)

        fprintf('-->%s%d\n','Training ANFIS network ', number);
        
        %   outFis          : Trained fuzzy inference system
        %   trainError    : Root mean square training error
        %   stepSize       :  Training step size
        %   chkFIS          : Tuned FIS for which the validation error is minimum
        %   chkError      : Root mean square validation error
        
        %sprintf('%s%d', "Error training input", number);
        
        try
             [outFis, trainError, stepSize, chkFIS, chkError] = anfis(trainData(:,1:4), anfisOpt);
             
             %trnOut1 = evalfis(outFis, trainData(:,1:3) );
             %chkOut  = evalfis(chkFIS, testData(:,1:3) );   
             
             predictedTheta = evalfis(outFis, testData(:,1:3) );
             thetaDifference = testData(:,4) - predictedTheta;
             
             
                figure(1)
                subplot(3,1, number);
                plot(thetaDifference);
                ylabel(['theta ' num2str(number,'%d') ' Error']);
                titles= ['Desired theta' num2str(number,'%d' ) '- Predicted theta' num2str(number,'%d' ) '(degree)'];
                title(titles);
                
                %{
                figure(2)
                subplot(3,1, number);
                plot(trainError,'r')
                hold on;
                plot(chkError,'b')
                title('Checking Error and Training Error of theta1')
                xlabel('Number of Epochs')
                ylabel('Angle Error(degree)')
                legend('trainError','chkError')
                
                %}
             
                outputArg1 = thetaDifference;
                outputArg2 = trainError;
                outputArg3 = chkError;
                outputArg4 = 4;
             
        catch
           fprintf('-->%s%d\n','Error while training Anfis network : ', number);
        end

end

