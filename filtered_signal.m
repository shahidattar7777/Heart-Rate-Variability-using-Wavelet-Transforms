% f_low = 5;
% f_high = 15;
% fs = 200;
% [b,a] = butter(2, [f_low, f_high]/ (fs/2), "bandpass");
% filtered_signal1 = filtfilt(b, a, qrsEx);



function dataframe = filtered_signal(sig)
    qrsEx = sig.T(:,1);
    numberOfLevels = 6;
    wt = modwt(qrsEx,"sym6",numberOfLevels);
    
    % Energy by level for the decomposition
    energyByLevel = 100*sum((wt.^2),2)/sum(wt.^2,"all");
    
    
    wtrec = zeros(size(wt));
    wtrec([3 4 5 6],:) = wt([3 4 5 6],:);
    
    y = imodwt(wtrec,'sym6');
    average = mean(abs(y));
    t = 1:length(wt);
    
    [~, rpeak] = findpeaks(y, 'MinPeakHeight', 50);
    
    normalized_sig = (y - min(y))/(max(y) - min(y)) * 2 - 1;
    
    
    r_label(1:length(rpeak)) = 'r';
    p_wave_locations = zeros(size(rpeak));
    p = zeros(size(rpeak));
    p_label = string(zeros(size(rpeak)));
    q_wave_locations = zeros(size(rpeak));
    q = zeros(size(rpeak));
    q_label = string(zeros(size(rpeak)));
    s_wave_locations = zeros(size(rpeak));
    s = zeros(size(rpeak));
    s_label = string(zeros(size(rpeak)));
    t_wave_locations = zeros(size(rpeak));
    tt= zeros(size(rpeak));
    t_label = string(zeros(size(rpeak)));
    
    i=0;
    for j = 1:length(rpeak)
        if rpeak(j) - 20 > 0 && j==1
            [p(j), p_wave_locations(j)] = max(normalized_sig(1:(rpeak(j)-20)));
    
            [q(j), w] = min(normalized_sig((rpeak(j)-11):rpeak(j)));
            q_wave_locations(j) = rpeak(j) - 11 + w -1;
            q_label(j) = 'q';
            p_label(j) = 'p';
         
            %p_wave_locations(j) = normalized_sig(j:(rpeak(j)-20)).index(p);
            %i = rpeak(j+1);
        elseif j <= length(rpeak) && rpeak(j)-36 >= 0
            [p(j), v] = max(normalized_sig((rpeak(j)-36):rpeak(j)-20));
            [q(j), w] = min(normalized_sig((rpeak(j)-11):rpeak(j)));
            p_wave_locations(j) = rpeak(j) - 36 + v -1;
            q_wave_locations(j) = rpeak(j) - 11 + w -1;
            q_label(j) = 'q';
            p_label(j) = 'p';
            %i = rpeak(j+1);
            %fprintf('2')
        end
    
        if rpeak(j) < (rpeak(length(rpeak))-10)
            [s(j), x] = min(normalized_sig(rpeak(j):(rpeak(j)+10)));
            s_wave_locations(j)= rpeak(j) + x -1;
            s_label(j) = 's';
            %fprintf('3')
        end
    
        if rpeak(j) < (rpeak(length(rpeak)) - 54)
            [tt(j), z] = max(normalized_sig(rpeak(j) + 34:(rpeak(j)+54)));
            t_wave_locations(j)= rpeak(j) + 34 +  z - 1;
            %fprintf('4')
            t_label(j) = 't';
        end
    
    end
    
    p_table = table(transpose(p_label),transpose(p_wave_locations));
    p_table.Properties.VariableNames = ["label","location"];
    q_table = table(transpose(q_label),transpose(q_wave_locations));
    q_table.Properties.VariableNames = ["label","location"];
    s_table = table(transpose(s_label),transpose(s_wave_locations));
    s_table.Properties.VariableNames = ["label","location"];
    t_table = table(transpose(t_label),transpose(t_wave_locations));
    t_table.Properties.VariableNames = ["label","location"];
    r_table = table(transpose(r_label),transpose(rpeak));
    r_table.Properties.VariableNames = ["label","location"];

    signal_table = table(sig.T,transpose(t));
    signal_table.Properties.VariableNames = ["sig", "Key"];


    combined_data = [p_table; q_table; r_table; s_table; t_table];
    combined_data.Properties.VariableNames = ["label", "Key"];

    
    
    dataframe = outerjoin(signal_table,combined_data,'Type','left','MergeKeys', true);
    % figure;
    % plot(t, normalized_sig);
    % 
    % 
    % hold on;
    % plot(p_wave_locations,p,'ro');
    % 
    % hold on;
    % 
    % plot(q_wave_locations,q,'bo');
    % 
    % hold on;
    % 
    % plot(s_wave_locations,s,'go');
    % 
    % hold on;
    % 
    % plot(t_wave_locations,tt,'go');

end
    