
S = dir(fullfile("C:\ECG\E-HOL-03-0271-002\*.ecg"));
for k = 1:numel(S)
    
    T = extraction_script(append(S(k).folder,'\',S(k).name),0,86400);
    [~,F] = fileparts(S(k).name);
    F = sprintf('%s.mat',F);
    fullfilename = fullfile('C:\ECG\database_002\', F);
    save(fullfilename,'T') % <----------- function syntax !!!
end