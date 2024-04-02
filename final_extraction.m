
S = dir(fullfile("C:\ECG\database_001\*.mat"));
for k = 1:numel(S)
    
    T = filtered_signal(load(append(S(k).folder,'\',S(k).name)));
    [~,F] = fileparts(S(k).name);
    F = sprintf('%s.mat',F);
    fullfilename = fullfile("C:\ECG\Final_df_001", F);
    save(fullfilename,'T') % <----------- function syntax !!!
end