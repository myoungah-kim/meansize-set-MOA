 
filename = 'bias.xlsx';
dataset = xlsread(filename);
dataset_new = [];
numParticipant = 20;
numTrial = 128;

for i = 1:numParticipant
    my_field = strcat('p',num2str(i));
    participantData.(my_field) = dataset( 1+(numTrial*(i-1)) : (numTrial*(i-1))+numTrial , :);
end

for i = 1:numParticipant
    my_field = strcat('p',num2str(i));
    
    for k = 1:numTrial
        cond = participantData.(my_field)(k, 13);
        
        if cond == 1
            (my_field).attL = participantData.(my_field)(k, :);
        elseif cond == 2
            (my_field).attS = participantData.(my_field)(k, :);
        elseif cond == 3
            (my_field).unattL = participantData.(my_field)(k, :);
        elseif cond == 4
            (my_field).unattS = participantData.(my_field)(k, :);
        end
    end
    
end

for i = 1:numParticipant
    my_field = strcat('p',num2str(i));
    string = bias.(my_field);
    lowend = mean.(my_field) - (2*var.(my_field));
    highend = mean.(my_field) + (2*var.(my_field));
    for k = 1:numTrial
        if bias.(my_field)(k, 1) <= lowend || bias.(my_field)(k, 1) >= highend
            bias.(my_field)(k, 1) = NaN;
        end
    end
    dataset_new = [dataset_new ; bias.(my_field)];
    
end
filename_new = 'bias_new.xlsx';
xlswrite(filename_new,dataset_new);

