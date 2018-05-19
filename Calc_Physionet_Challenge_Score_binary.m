function [F1n,F1a,F1,AA]= Calc_Physionet_Challenge_Score_binary(indications_stats)

siz=size(indications_stats);
N=siz(1);
RECORDS=indications_stats(:,1);
ANSWERS=indications_stats;
target=indications_stats(:,1);
%% Scoring
% We do not assume that the references and the answers are sorted in the
% same order, so we search for the location of the individual records in answer.txt file.
AA=zeros(2,2);
BB=zeros(2,2);
CC=zeros(2,2);

for n = 1:N
 
    this_answer=ANSWERS(n,2);
                if target(n)
                    if this_answer
                                        AA(1,1) = AA(1,1)+1;
                    else
                                        AA(1,2) = AA(1,2)+1;                        
                    end
                else                    
                    if ~this_answer
                                        AA(2,2) = AA(2,2)+1;                        
                    else
                                        AA(2,1) = AA(2,1)+1;                        
                    end                    
                end
    
end

F1n=2*AA(1,1)/(sum(AA(1,:))+sum(AA(:,1)));
F1a=2*AA(2,2)/(sum(AA(2,:))+sum(AA(:,2)));
%F1=(F1n+F1a+F1o+F1p)/4;
F1=(F1n+F1a)/2;


str = ['F1 measure for Normal rhythm:  ' '%1.4f\n'];
fprintf(str,F1n)
str = ['F1 measure for Non- normal rhythm:  ' '%1.4f\n'];
fprintf(str,F1a)
str = ['Final F1 measure:  ' '%1.4f\n'];
fprintf(str,F1)
