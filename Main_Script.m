%%  Trying classification app

%%  Cleaning
% clc
% clear
% close all

warning off
 load Parameters_log116.mat
CC(1:2,1:2)=0;
%%  Settingspath='C:\Users\vgliner\Desktop\Uploading to the challenge\validation';
%  [Record_name,Type] = importfile_records_type('C:\Users\vgliner\Desktop\Uploading to the challenge\validation\REFERENCE.csv',1, 300);
% 
data_source_path='C:\Users\vgliner\Desktop\Private\Master\Thesis\Challenge_2017\training2017\training2017';
[Record_name,Type] = importfile_records_type('C:\Users\vgliner\Desktop\Private\Master\Thesis\Challenge_2017\training2017\training2017\REFERENCE_My_corr.csv',1, 8528);      

noisy_records=Record_name(strcmp(Type,'~'));
AFIB_records=Record_name(strcmp(Type,'A'));
normal_records=Record_name(strcmp(Type,'N'));
other_records=Record_name(strcmp(Type,'O'));
database_model=[numel(normal_records) numel(noisy_records) numel(AFIB_records) numel(other_records) ]/numel(Record_name)*100;
listing= dir([data_source_path '\*.mat']);


%% Make a representative sample
total_sample_quota=1;
sample_mix=[120 2 18 60];
sample_mix=sample_mix*total_sample_quota;
small_sample=[];
small_sample=[small_sample normal_records(1:sample_mix(1))'];
small_sample=[small_sample noisy_records(1:sample_mix(2))'];
small_sample=[small_sample AFIB_records(1:sample_mix(3))'];
small_sample=[small_sample other_records(1:sample_mix(4))'];

%% Testing spectrum of noisy records
Fs = 300;            % Sampling frequency  % 360
T = 1/Fs;             % Sampling period
%%  Flags
plot_flag=0;
online_flag=0;
write_parameters_flag=0;
apply_estimators=1;
load netAO.mat
if ~online_flag

v=1:7:8528;
%v=1:8528;
v=v';
Parameters_log_training=Parameters_log;
Parameters_log_training(v,:)=[];
Parameters_log_validation=Parameters_log(v,:);    
end
if plot_flag
    figure
end

how_much_of_each=10;
        clear indications_stats indications_stats3
        loop_counter=1;
        log_counter=1; 
        
%% My models


%for optimization_counter=40:70
clear  indications_stats3
if write_parameters_flag
 %   clear Parameters_log
else

end
%%  Defining Partition
%           data_source_path='C:\Users\vgliner\Desktop\Uploading to the challenge\validation';
%          [Record_name,Type] = importfile_records_type('C:\Users\vgliner\Desktop\Uploading to the challenge\validation\REFERENCE.csv',1, 300);
listing= dir([data_source_path '\*.mat']);

 if  (~online_flag) %~write_parameters_flag) ||
 load Parameters_log116.mat
 load indications_stats_detailed.mat
end
load correlation_template.mat
load others_template.mat
load T_elevation_template.mat
load trainedClassifierGold.mat
load additional_net.mat
load Last_SVM_102_plus.mat
load is_in_use.mat
% load Parameters_log102.mat
for general_log_counter=1%:15
%        [trainedClassifier_not_others(optimization_counter), validationAccuracy] = trainClassifier_3_out_of_4(Parameters_log_for_SVM);

%              [Inputs,Outputs,Parameters_log_for_SVM,Parameters_log_not_for_SVM]=Prepare_Inputs_and_Outputs_for_NN(Parameters_log);
%              net=NN_train(Inputs,Outputs);    
             for optimization_counter=1:7%numel(is_feature_in_use)
 
%             data_source_path='C:\Users\vgliner\Desktop\Private\Master\Thesis\Challenge_2017\training2017\training2017';
%              [Record_name,Type] = importfile_records_type('C:\Users\vgliner\Desktop\Private\Master\Thesis\Challenge_2017\training2017\training2017\REFERENCE_My_corr.csv',1, 8528);      
% 
            clear  indications_stats3    
            
             [Record_name,Type] = importfile_records_type('C:\Users\vgliner\Desktop\Private\Master\Thesis\Challenge_2017\training2017\training2017\REFERENCE.csv',1, 8528);           
                 v=optimization_counter:7:8528;
 %            v=1:numel(Record_name);

            %% For grade estimation
            v=v';
            Parameters_log_training=Parameters_log;
            Parameters_log_training(v,:)=[];
            Parameters_log_validation=Parameters_log(v,:);  
            try
            Record_name=Record_name(v); 
            Type=Type(v);
            catch
                disp('Debug')
            end
            
            
  %% Gold 0.7889%%                      [trainedClassifier, validationAccuracy] =trainClassifierGedas14Optimization(Parameters_log_training,b,general_log_counter); 
  %% Last submission 0.7947  [trainedClassifier, validationAccuracy] =trainClassifierGedas17(Parameters_log_training,12); 

        %% Print
        try
        [~,max_log_indx]=max(General_log(:,4));
        disp('General log max:')       
       General_log(max_log_indx,:)
       general_log_counter
        catch
            
        end
        %%  Training section
        [Inputs,Outputs,Parameters_log_for_SVM,Parameters_log_not_for_SVM]=Prepare_Inputs_and_Outputs_for_NN(Parameters_log_training);
%         [trainedClassifier_others(optimization_counter), validationAccuracy] = trainClassifier_trees_Others(Parameters_log_not_for_SVM);
%          [trainedClassifier_not_others(optimization_counter), validationAccuracy] = trainClassifier_3_out_of_4(Parameters_log_for_SVM);


%      net=NN_train(Inputs,Outputs);
%         if general_log_counter==1
%          [trainedClassifier(optimization_counter), validationAccuracy] = trainClassifier116(Parameters_log_training,general_log_counter);
%         end
%         if general_log_counter==20
%           [trainedClassifier(optimization_counter), validationAccuracy] = trainClassifier102_plus(Parameters_log_training,general_log_counter);
%           [trainedClassifier, validationAccuracy] = trainClassifier102_plus(Parameters_log,general_log_counter);
%         end
    valid_indxs=find(Parameters_log_training(:,1)==78);
    Parameters_log_training(:,1)=0;
    Parameters_log_training(valid_indxs,1)=1;
  [trainedClassifier_binary_linear(optimization_counter), validationAccuracy] = trainClassifier_binary_linear_discriminant(Parameters_log_training);
  [trainedClassifier_binary_SVM(optimization_counter), validationAccuracy] = trainClassifier_binary_quadratic_SVM(Parameters_log_training);
  [trainedClassifier_binary_trees(optimization_counter), validationAccuracy] = trainClassifier_binary_RUSBoostedTrees(Parameters_log_training);

 %         [trainedClassifier, validationAccuracy] = trainClassifier102(Parameters_log(:,1:102));

       %     my_deepnet=train_deepnet(Parameters_log_training,general_log_counter);
            loop_counter=1; %%   
                    for counter=1:numel(v)% indxs_to_inspect'%:numel(v)%fails'%%[normal_records(1:how_much_of_each)' AFIB_records(1:how_much_of_each)' other_records(1:how_much_of_each)' noisy_records(1:how_much_of_each)']%1:numel(Record_name)%[other_records(1:how_much_of_each)' noisy_records(1:how_much_of_each)']%1:numel(Record_name)%noisy_records(1:how_much_of_each)'%[normal_records(1:how_much_of_each)'   AFIB_records(1:how_much_of_each)' other_records(1:how_much_of_each)' noisy_records(1:how_much_of_each)']%%numel(Record_name)%[normal_records(1:how_much_of_each)'   AFIB_records(1:how_much_of_each)' other_records(1:how_much_of_each)' noisy_records(1:46)'][noisy_records(1:how_much_of_each)' AFIB_records(1:how_much_of_each)']%1:numel(Record_name)%[normal_records(1:how_much_of_each)'   AFIB_records(1:how_much_of_each)' other_records(1:how_much_of_each)' noisy_records(1:how_much_of_each)']%other_records(1:how_much_of_each)' %1:numel(Record_name)%[normal_records(1:how_much_of_each)'   AFIB_records(1:how_much_of_each)' other_records(1:how_much_of_each)' noisy_records(1:how_much_of_each)']%1:numel(Record_name)%numel(Record_name)%[normal_records(1:how_much_of_each)'   AFIB_records(1:how_much_of_each)' other_records(1:how_much_of_each)' noisy_records(1:46)']
                        counter
                        if online_flag
                        test=listing(v(counter)).name;
%                        test=listing((counter)).name;
                        clear tm ecg;
                        [tm,ecg,fs,siginfo]=rdmat([data_source_path '\' test(1:end-4)]);
                        full_record_name=[data_source_path '\' test(1:end-4)];
                        [data_for_log]=segment_classifier(ecg,fs,plot_flag,counter,Record_name,Type,general_log_counter,full_record_name,correlation_template,others_template,T_elevation_template);
                        else
                         data_for_log=Parameters_log_validation(counter,2:end);%%%%%%%%%%%%    
%                        data_for_log=Parameters_log(counter,2:end);
                        end     
                            if apply_estimators||~online_flag

                                   %% SVM_partial

                                    yfit1 =trainedClassifier_binary_linear(optimization_counter).predictFcn(data_for_log); %trainedClassifier_new
                                    yfit2 =trainedClassifier_binary_SVM(optimization_counter).predictFcn(data_for_log); %trainedClassifier_new
                                    yfit3 =trainedClassifier_binary_trees(optimization_counter).predictFcn(data_for_log); %trainedClassifier_new
                                    
%                                        if       trainedClassifier_others(optimization_counter).predictFcn(data_for_log)==79
%                                            yfit3 =79;
%                                        else
%                                             yfit3 =trainedClassifier_not_others(optimization_counter).predictFcn(data_for_log); %trainedClassifier_new
%                                        end
%                                     new_classification3=additional_conditions_classifier(cellstr(char(yfit3)),data_for_log(17),data_for_log,[],[],general_log_counter);
%                                     if strcmp(new_classification3,'N')
%                                         if net(data_for_log(find(is_in_use))')>0.65
%                                             new_classification3='O';
%                                         end
%                                     end
                                    log_type=strcmp(Type(counter),'N');
                                    indications_stats3(loop_counter,1:4)=[log_type yfit1  yfit2 yfit3]; 
                                   disp('Result large set:')                                   
                                  [F1n1,F1a1,F11]= Calc_Physionet_Challenge_Score_binary(indications_stats3(:,1:2));  
                                  [F1n2,F1a2,F12,AA]= Calc_Physionet_Challenge_Score_binary(indications_stats3(:,[1 3]));  
                                  [F1n3,F1a3,F13]= Calc_Physionet_Challenge_Score_binary(indications_stats3(:,[1 4]));                                    
                            end
                       %% 
                        if plot_flag    
                            subplot(3,2,1)
                            try
                            title_str=['Record ' num2str(Record_name(counter)) ' ' Type(counter) 'My classifier: '   cellstr(char(yfit3))];
                            title(title_str)  ;   
                            catch

                            end

                        end
            %                       if mean_qrs_width>0.12
             %                         waitforbuttonpress
            %                       end
%                            keyboard
                           if online_flag
                               if write_parameters_flag
                                    Parameters_log(counter,:)=[double(char(Type(counter)))  data_for_log];    %cellstr(data_for_log(2)) cellstr(data_for_log(3)) cellstr(data_for_log(4)) cellstr(Type(counter))
                               end
%                                if plot_flag && ~strcmp(Type(counter), cellstr(char(new_classification3)))
%                               disp('Found')
%                                if data_for_log(105)>5
                               keyboard
%                                end
% %    %                          waitforbuttonpress 
%                                end
                           end
                       log_counter=log_counter+1;
%                         
%                         if ~(strcmp(indications_stats3(loop_counter,1),indications_stats3(loop_counter,2)))
%                         keyboard%waitforbuttonpress%keyboard
%                         end
                   loop_counter=loop_counter+1;
                    end
            %          data_source_path='C:\Users\vgliner\Desktop\Uploading to the challenge\validation';
            %          [Record_name,Type] = importfile_records_type('C:\Users\vgliner\Desktop\Uploading to the challenge\validation\REFERENCE.csv',1, 300);
            %         load Parameters_log_validation_set.mat
            %         clear  indications_stats3      
            %         loop_counter=1;
            %         for counter=1:300
            %             data_for_log=Parameters_log(counter,2:end);%%%%%%%%%%%%                          
            %             yfit3 =trainedClassifier_new.predictFcn(data_for_log);
            %             new_classification3=additional_conditions_classifier(cellstr(char(yfit3)),data_for_log(17),data_for_log(1:66),net_others_vs_normals,net_AO,optimization_counter);
            %             indications_stats3(loop_counter,1:2)=[Type(counter) cellstr(char(new_classification3))]; 
            %             disp('Result Validation Set:')                                   
            %            [F1n_validation,F1a_validation,F1o_validation,F1_validation]= Calc_Physionet_Challenge_Score(indications_stats3);  
            %            loop_counter=loop_counter+1;
            %         end 
                    CC=CC+AA;
                  Optimization_log(optimization_counter,:)= [F1n1,F1a1,F11,F1n2,F1a2,F12,F1n3,F1a3,F13];                                         
                  
              end
General_log(general_log_counter,1:4)=mean(Optimization_log); 
if (General_log(general_log_counter,4)==max(General_log(:,4)))
    save('best_net.mat','net')
end
%save(['Parameters_log108_general_log_add' num2str(general_log_counter)
%'.mat'],'Parameters_log');
end

%%  Find all data in the resource
%csvwrite('Log_for_optimization.csv',log)