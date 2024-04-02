% Read ISHNE ecgSig file : 
%  function mat=read_ishne(fileName, startOffset, length);    
% Input--------------------------------------------------------       
%  fileName : the ishne filename including the path
%  startOffset: the start offset to read ecgSig
%  length:      length of ecgSig to read
% Ouput--------------------------------------------------------
%  ecgSig : ECG signal
%
function [ecgSig]= extraction_script(fileName, startOffset, length)
fid=fopen(fileName,'r');
if ne(fid,-1)
    
    %Magic number
    magicNumber = fread(fid, 8, 'char');
   
    % get checksum
	checksum = fread(fid, 1, 'uint16');
	
	%read header
    Var_length_block_size = fread(fid, 1, 'long');
    ishneHeader.Sample_Size_ECG = fread(fid, 1, 'long');	
    Offset_var_lenght_block = fread(fid, 1, 'long');
    Offset_ECG_block = fread(fid, 1, 'long');
    File_Version = fread(fid, 1, 'short');
    First_Name = fread(fid, 40, 'char');  									        								
    Last_Name = fread(fid, 40, 'char');  									        								
    ID = fread(fid, 20, 'char');  									        								
    Sex = fread(fid, 1, 'short');
    Race = fread(fid, 1, 'short');
    Birth_Date = fread(fid, 3, 'short');	
    Record_Date = fread(fid, 3, 'short');	
    File_Date = fread(fid, 3, 'short');	
    Start_Time = fread(fid, 3, 'short');	
    ishneHeader.nbLeads = fread(fid, 1, 'short');
    ihsneHeader.Lead_Spec = fread(fid, 12, 'short');	
    ihsneHeader.Lead_Qual = fread(fid, 12, 'short');	
    ishneHeader.Resolution = fread(fid, 12, 'short');	
    Pacemaker = fread(fid, 1, 'short');	
    Recorder = fread(fid, 40, 'char');;
    ishneHeader.Sampling_Rate = fread(fid, 1, 'short');	
    Proprietary = fread(fid, 80, 'char');
    Copyright = fread(fid, 80, 'char');
    Reserved = fread(fid, 88, 'char');
    
    % read variable_length block
    varblock = fread(fid, Var_length_block_size, 'char');
    
    % get data at start
    offset = startOffset*ishneHeader.Sampling_Rate*ishneHeader.nbLeads*2; % each data has 2 bytes
    fseek(fid, Offset_ECG_block+offset, 'bof');
    
   
    % read ecgSig signal
    numSample = length*ishneHeader.Sampling_Rate;
    ecgSig = fread(fid, [ishneHeader.nbLeads, numSample], 'int16')';
     
    fclose(fid);
 else
     ihsneHeader = [];
     ecgSig=[];
 end
