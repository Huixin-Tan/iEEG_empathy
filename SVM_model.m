function [test_accuracy_for_iter, class_weight_for_iter] = SVM_model(temp_feature,label,no_fold)

%% temp_feature:feature matrix, n(trial)*n(feature);
%% label: the label of each trial
%% no_fold:number of fold for cross validation
%% test_accuracy_for_iter: classification accuracy
%% class_weight_for_iter:classification weight

    c = cvpartition(label,'KFold',no_fold);
    
    for j = 1:no_fold
        
        testIdx = test(c, j); %% get the index of test data
        trIdx = training(c, j); %% get the index of training data


        x_train =temp_feature(trIdx,:);
        y_train = label(trIdx);

        x_test = temp_feature(testIdx,:);
        y_test = label(testIdx);

        %% rescale the features into [0,1]
        feature_min_train = repmat(min(x_train,[],1),size(x_train,1),1);
        feature_max_train = repmat(max(x_train,[],1),size(x_train,1),1);

        feature_min_test = repmat(min(x_train,[],1),size(x_test,1),1);
        feature_max_test = repmat(max(x_train,[],1),size(x_test,1),1);

        x_train = (x_train - feature_min_train)./(feature_max_train - feature_min_train);
        x_test = (x_test - feature_min_test)./(feature_max_test - feature_min_test);



       %% Best hyperparameters
       Md1 = fitcsvm(x_train,y_train,'KernelFunction','linear','Solver','SMO'); 

      %% Final test with test set
      test_accuracy_for_iter(j) = sum((predict(Md1,x_test) == y_test))/length(y_test)*100;
      class_weight_for_iter(j,:) = abs(Md1.Beta);
      

  end
end



