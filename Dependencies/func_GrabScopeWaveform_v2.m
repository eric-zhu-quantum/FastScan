


function [Trace] = func_GrabScopeWaveform_v2(AgScope, preambleBlock,  wl_start, wl_stop, sweepSpeed)

     fprintf(AgScope, ':STOP');
%      preambleBlock = query(AgScope,':WAVEFORM:PREAMBLE?');
    % The preamble block contains all of the current WAVEFORM settings.  
    % It is returned in the form <preamble_block><NL> where <preamble_block> is:
    %    FORMAT        : int16 - 0 = BYTE, 1 = WORD, 2 = ASCII.
    %    TYPE          : int16 - 0 = NORMAL, 1 = PEAK DETECT, 2 = AVERAGE
    %    POINTS        : int32 - number of data points transferred.
    %    COUNT         : int32 - 1 and is always 1.
    %    XINCREMENT    : float64 - time difference between data points.
    %    XORIGIN       : float64 - always the first data point in memory.
    %    XREFERENCE    : int32 - specifies the data point associated with
    %                            x-origin.
    %    YINCREMENT    : float32 - voltage diff between data points.
    %    YORIGIN       : float32 - value is the voltage at center screen.
    %    YREFERENCE    : int32 - specifies the data point where y-origin
    %                            occurs.
    % Now send commmand to read data
    fprintf(AgScope,':WAV:DATA?\n');
%     pause(0.01);
    % read back the BINBLOCK with the data in specified format and sto re it in
    % the waveform structure. FREAD removes the extra terminator in the buffer
    waveform = binblockread(AgScope,'uint8'); 
%     pause(0.1);
    fread(AgScope,1);
    % Read back the error queue on the instrument
%     instrumentError = query(AgScope,':SYSTEM:ERR?');
%     while ~isequal(instrumentError,['+0,"No error"' char(10)])
% %         disp(['Instrument Error: ' instrumentError]);
%         instrumentError = query(AgScope,':SYSTEM:ERR?');
%     end
    
    fprintf(AgScope, ':RUN');
    fprintf(AgScope, ':DIGITIZE'); % this is the trick!
%     clrdevice(AgScope);
%     fprintf(AgScope, ':DIGITIZE');
    % Data processing: Post process the data retreived from the scope
    % Extract the X, Y data and plot it 

    % Maximum value storable in a INT16
%     maxVal = 255; 

    %  split the preambleBlock into individual pieces of info
%     preambleBlock = regexp(preambleBlock,',','split');

    % store all this information into a waveform structure for later use
%     waveform
%     waveform.Format = str2double(preambleBlock{1});     % This should be 1, since we're specifying INT16 output
%     waveform.Type = str2double(preambleBlock{2});
%     waveform.Points = str2double(preambleBlock{3});
%     waveform.Count = str2double(preambleBlock{4});      % This is always 1
%     waveform.XIncrement = str2double(preambleBlock{5}); % in seconds
%     waveform.XOrigin = str2double(preambleBlock{6});    % in seconds
%     waveform.XReference = str2double(preambleBlock{7});
%     waveform.YIncrement = str2double(preambleBlock{8}); % V
%     waveform.YOrigin = str2double(preambleBlock{9});
%     waveform.YReference = str2double(preambleBlock{10});
%     waveform.VoltsPerDiv = (maxVal * waveform.YIncrement / 8);      % V
%     waveform.Offset = ((maxVal/2 - waveform.YReference) * waveform.YIncrement + waveform.YOrigin);         % V
%     waveform.SecPerDiv = waveform.Points * waveform.XIncrement/10 ; % seconds
%     waveform.Delay = ((waveform.Points/2 - waveform.XReference) * waveform.XIncrement + waveform.XOrigin); % seconds

    Time2WL = @(t)  wl_start+((t-0)*sweepSpeed*sign(wl_stop-wl_start));
    % Generate X & Y Data
    Trace.XData = preambleBlock.XINCREMENT.*((0:(length(waveform)-1)) - preambleBlock.XREFERENCE) + preambleBlock.XORIGIN;
    Trace.XData =  Time2WL(Trace.XData);
    %
    Trace.YData = (preambleBlock.YINCREMENT.*(waveform - preambleBlock.YREFERENCE)) + preambleBlock.YORIGIN; 


    

    

end