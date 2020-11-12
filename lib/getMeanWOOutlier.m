 
filename = '../sizemat_withmean.xlsx';
dataset = xlsread(filename);
dataset_new = [];
numParticipant = 20;
numTrial = 3200;

for i = 1 : numTrial
    sizes = dataset(i, :);
    outlierPos_L = sizes(1, 31);
    outlierPos_R = sizes(1, 32);

    sizes(1, outlierPos_L) = 0;
    sizes(1, outlierPos_R + 15) = 0;
    
    sizes_left = sizes(1, 1:15);
    sizes_right = sizes(1, 16:30);
    
    m_woOutlier_L = sum(sizes_left)/14;
    m_woOutlier_R = sum(sizes_right)/14;
    
    sizes(1, 33) = m_woOutlier_L;
    sizes(1, 34) = m_woOutlier_R;
    
    dataset_new = [dataset_new ; sizes];
end

filename_new = 'sizemat_withmean_new.xlsx';
xlswrite(filename_new, dataset_new);

