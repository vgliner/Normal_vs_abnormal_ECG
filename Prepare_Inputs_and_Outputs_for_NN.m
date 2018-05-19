function [Inputs,Outputs,Parameters_log_for_SVM,Parameters_log_not_for_SVM]=Prepare_Inputs_and_Outputs_for_NN(Parameters_log)
Others=find(Parameters_log(:,1)==79);
Not_Others=find(Parameters_log(:,1)~=79);
Special_Parameters_log=Parameters_log;
Special_Parameters_log(Others,1)=1;
Special_Parameters_log(Not_Others,1)=0;
Inputs=Special_Parameters_log(:,2:end);
Outputs=Special_Parameters_log(:,1);
is_in_use=[true true true false false false false true true true true false true true true true true true true true true false true true true true true true false false false false true false false true true true false false false true false false true true true true true false false true false true false false true false false true true true true false false false true false false false true true true true true true true true true true true true true false false false false false false false true false false false false false false false false false false false false false  false false false  false false  false false false false  false false];
is_in_use(92)=1;
is_in_use(98)=1;
is_in_use(99)=0;
is_in_use(100)=0;
is_in_use(101)=1;

is_in_use(102)=1;
is_in_use(103)=1;

is_in_use(104)=1;
is_in_use(96)=1;
is_in_use(15)=0;
is_in_use(63)=0;
is_in_use(61)=0;
is_in_use(27)=0;
is_in_use(13)=1;
is_in_use(59)=1;

is_in_use(108)=1;
is_in_use(109)=1;
is_in_use(110)=1;
is_in_use(111)=0;

is_in_use(112)=0;
is_in_use(113)=1;
is_in_use(114)=0;
is_in_use(115)=1;

is_in_use(101)=0;
Inputs_sorted=Inputs(:,is_in_use);
Inputs=Inputs_sorted;
Parameters_log_for_SVM=Parameters_log(Not_Others,:);
Parameters_log_not_for_SVM=Parameters_log;
Parameters_log_not_for_SVM(Not_Others,1)=0;
