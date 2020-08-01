function varargout = FastScan_GPIB_v1(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FastScan_GPIB_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @FastScan_GPIB_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%
%
%
%some global variables:
global wl_start_nm wl_stop_nm sweepspeed_nm Vmax TypeOfScan preambleBlock
global AgScope
global PreviousSaveDir



% --- Executes just before FastScan_GPIB_v1 is made visible.
function FastScan_GPIB_v1_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%
%
global AgScope TLS;
AgScope = visa('agilent','USB0::0x0957::0x1773::MY48020004::INSTR');
% Set the buffer size
AgScope.InputBufferSize = 100000;
% Set the timeout value
AgScope.Timeout = 0.1;
% Set the Byte order
AgScope.ByteOrder = 'littleEndian';
% Open the connection
addpath(genpath('C:\Users\Eric\Desktop\Eric\Dependencies')); % this needs to be changed nnnn




% --- Outputs from this function are returned to the command line.
function varargout = FastScan_GPIB_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function wl_start_Callback(hObject, eventdata, handles)
% hObject    handle to wl_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wl_start as text
%        str2double(get(hObject,'String')) returns contents of wl_start as a double
global wl_start_nm
wl_start_nm = str2double(get(hObject, 'String'));



% --- Executes during object creation, after setting all properties.
function wl_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wl_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wl_stop_Callback(hObject, eventdata, handles)
% hObject    handle to wl_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wl_stop as text
%        str2double(get(hObject,'String')) returns contents of wl_stop as a double
global wl_stop_nm
wl_stop_nm = str2double(get(hObject, 'String'));



% --- Executes during object creation, after setting all properties.
function wl_stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wl_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SweepSpeed.
function SweepSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to SweepSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SweepSpeed contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SweepSpeed
global sweepspeed_nm
Allspeeds = str2double(cellstr(get(hObject,'String')));
sweepspeed_nm = Allspeeds(get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function SweepSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SweepSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Vmax_Callback(hObject, eventdata, handles)
% hObject    handle to Vmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Vmax as text
%        str2double(get(hObject,'String')) returns contents of Vmax as a double
global Vmax
Vmax = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Vmax_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to Vmax (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function LaserSource = OpenLaser()
    
    LaserSource= gpib('agilent', 32, 20);
    if  strcmp(LaserSource.Status, 'open')
        fclose(LaserSource);               
    end
    fopen(LaserSource);
    
    

function CloseLaser_TurnOff(LaserSource)
    
    if  strcmp(LaserSource.Status, 'closed')
        fopen(LaserSource);      
    end
    fprintf(LaserSource,'outp 0');
    fclose(LaserSource);

        



    
    
% --- Executes on button press in Butt_UpdateTLS_Scope.
function Butt_UpdateTLS_Scope_Callback(hObject, eventdata, handles)

delete(instrfind)
% hObject    handle to Butt_UpdateTLS_Scope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
%
global wl_start_nm wl_stop_nm sweepspeed_nm Vmax TypeOfScan preambleBlock Channel
global AgScope TLS
%

wl_start_nm = str2double(get(handles.wl_start, 'String'));
wl_stop_nm = str2double(get(handles.wl_stop, 'String'));
sweepspeed_nm = str2double(get(handles.SweepSpeed, 'String'))
sweepspeed_nm  = sweepspeed_nm(get(handles.SweepSpeed, 'Value'));

%test whether (wl_stop_nm-wl_start_nm)/sweep_speed_nm > 0.1
if (wl_stop_nm <= wl_start_nm)
    uiwait(msgbox('Start wl must be greater than Stop wl!'))
    return 
end


TimesAllowed = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0];


TimePerCycle = (wl_stop_nm-wl_start_nm)/sweepspeed_nm;
Mantissas = [1,2,5,10];
if sum(TimePerCycle == TimesAllowed)==0 % no suitable scan times found
    uiwait(msgbox('No suitable scan times!!  Readusting... '));    
    [Mantissa, Exponent] = RipFloatApart(    TimePerCycle);
    [tmp,ind_min] = min(abs(Mantissa-Mantissas))
    
    Mantissa = Mantissas(ind_min);% make it 1,2,5, or 10
    
    if (Mantissa == 10)
        Mantissa = 1
        Exponent = Exponent+1   
    end
    
    NewTimePerCycle = Mantissa * 10^(Exponent)
    
    if (NewTimePerCycle > max(TimesAllowed)) || (NewTimePerCycle < min(TimesAllowed))
        uiwait(msgbox('Settings out of range! Stopping... '));
        return; 
    end
    
    wl_middle = 0.5*(wl_start_nm + wl_stop_nm);
    wl_start_nm = wl_middle - 0.5*NewTimePerCycle*sweepspeed_nm;
    wl_stop_nm = wl_middle + 0.5*NewTimePerCycle*sweepspeed_nm;
    set(handles.wl_start, 'String', num2str(wl_start_nm));
    set(handles.wl_stop, 'String', num2str(wl_stop_nm));
end


Vmax = str2double(get(handles.Vmax, 'String'));
%

Channel = str2double(get(handles.Channel, 'String'));% get the array of values 
Channel  = Channel(get(handles.Channel, 'Value')) %actual element
%
getelem = @(Array, k) Array(k);
TypeOfScan = getelem(get(handles.ScanType, 'String'), ... 
                               get(handles.ScanType, 'Value'));
switch TypeOfScan{1}
    case 'Single Scan'
        cycles = 1;
    case 'Continuous Scan'
        cycles = 99;
end

fprintf(1, '%2.3f - %2.3f nm, at %2.2f nm/s, Vmax = %2.2f V\n', wl_start_nm, wl_stop_nm, sweepspeed_nm, Vmax);
%
%TLS open:
% TLS = gpib('agilent', 32, 20);
% fopen(TLS);
TLS = OpenLaser()
%
%

fprintf('Set TLS Sweep: \n')


fprintf(TLS, 'wav:swe:mode CONT') % continuous mode

if (cycles == 1)
    fprintf(TLS, 'wav:swe:rep onew')    % single-direction scan
else    
    fprintf(TLS, 'wav:swe:rep twow')    % turn on two-way (bi-dir) sweep
end

% # cycles, wl_start_nm, wl_stop_nm, sweepspeed_nm
fprintf(TLS, sprintf('wav:swe:cycl %i', cycles))
fprintf(TLS, sprintf('wav:swe:star %inm', wl_start_nm))
fprintf(TLS, sprintf('wav:swe:stop %inm', wl_stop_nm ))
fprintf(TLS, sprintf('wav:swe:spe  %inm/s', sweepspeed_nm ))

%TLS will be  kept open;
%
fprintf('Set TLS RF Trigger Output: \n');
fprintf(TLS, 'trig:inp ign')           % ignore input
fprintf(TLS, 'trig:outp SWSTarted')    % output = sweep started

%Agilent Scope:
AgScope = visa('agilent','USB0::0x0957::0x1773::MY48020004::INSTR');
% Set the buffer size
AgScope.InputBufferSize = 100000;
% Set the timeout value
AgScope.Timeout = .1;
% Set the Byte order
AgScope.ByteOrder = 'littleEndian';
% Open the connection
%   
%   
%
fopen(AgScope);
clrdevice(AgScope); % extremely important, flushes everything out
%    
fprintf(AgScope,':WAVEFORM:SOURCE CHAN%i', Channel);   
fprintf(AgScope,':WAVEFORM:FORMAT BYTE');
fprintf(AgScope,':SYSTem:PRECision 0'); % should make acquisition faster
fprintf(AgScope,':WAV:POINTS:MODE NORM');
fprintf(AgScope,':WAV:POINTS 10000');
%    
%set the timebase
fprintf(AgScope,':TIMEBASE:MODE MAIN');
BestTotalTimeLength = [1,2,5];
%     wlsweeprange
%     speed
ActualTime = 0.99*abs(max(wl_stop_nm) - min(wl_start_nm))/(sweepspeed_nm);
%
[Mantissa,Power] = RipFloatApart(ActualTime);
%
if (Mantissa<=2)
    Mantissa  = 2;
elseif Mantissa <=5
    Mantissa = 5;
%        
elseif Mantissa <=10
    Mantissa = 10;
end
%
TotalTimeLength = Mantissa * 10^(Power);
%
%
%   
fprintf(AgScope, ':TIMEbase:POsition %2.2f',TotalTimeLength*0.5);
fprintf(AgScope, ':TIMEbase:Range %2.2f', TotalTimeLength); 
fprintf(AgScope, sprintf(':CHAN%i:RANGE %2.2f' ,Channel,Vmax));
fprintf(AgScope, sprintf(':CHAN%i:offset %2.2f',Channel,Vmax*0.5));
%
%
%set the trigger:
fprintf(AgScope, ':TRIGger:SWEep NORMAL');
fprintf(AgScope, ':TRIGger:HOLDOFF 6e-8');
fprintf(AgScope, ':TRIGger:EDGE:SOURce EXT');
fprintf(AgScope, ':TRIGger:EDGE:SLOPE POS');
fprintf(AgScope, ':TRIGger:EDGE:LEVEL 5e-1');    
%   
%    
fprintf(AgScope,':ACQuire:TYPE NORM'); %
fprintf(AgScope, ':ACQuire:COMPlete 95');
%
%
%      preambleBlock = query(AgScope,':WAVEFORM:PREAMBLE?');
% The preamble block contains all of the current WAVEFORM settings.  
% It is returned in the form <preamble_block><NL> where <preamble_block> is:
preambleBlock.FORMAT = 0; % byte
%    FORMAT        : int16 - 0 = BYTE, 1 = WORD, 2 = ASCII.
preambleBlock.TYPE = 0; %NORMAl acquisition, no averaging
%    TYPE          : int16 - 0 = NORMAL, 1 = PEAK DETECT, 2 = AVERAGE
preambleBlock.POINTS = 1000; % raw, no precision
%    POINTS        : int32 - number of data points transferred.
%    COUNT         : int32 - 1 and is always 1.
preambleBlock.XINCREMENT = TotalTimeLength/preambleBlock.POINTS;
%    XINCREMENT    : float64 - time difference between data points.
preambleBlock.XORIGIN = 0;
%    XORIGIN       : float64 - always the first data point in memory.
%    XREFERENCE    : int32 - specifies the data point associated with
%                            x-origin.
preambleBlock.XREFERENCE = 0;
preambleBlock.YINCREMENT = Vmax/256;
%    YINCREMENT    : float32 - voltage diff between data points.
preambleBlock.YORIGIN = Vmax/2;
%    YORIGIN       : float32 - value is the voltage at center screen.    
%    YREFERENCE    : int32 - specifies the data point where y-origin
%                            occurs.
preambleBlock.YREFERENCE = 256/2;
% Now send commmand to read data
%
fclose(AgScope);
fprintf(1, [query(TLS, 'sour0:wav:swe:chec?'), '\n'])




% --- Executes on selection change in ScanType.
function ScanType_Callback(hObject, eventdata, handles)
% hObject    handle to ScanType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ScanType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ScanType


% --- Executes during object creation, after setting all properties.
function ScanType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScanType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Butt_StartScan.
%just a wrapper for Butt_StartScan_Child
function Butt_StartScan_Callback(hObject, eventdata, handles)

%
global wl_start_nm wl_stop_nm sweepspeed_nm Vmax TypeOfScan preambleBlock
global AgScope TLS




Butt_UpdateTLS_Scope_Callback(hObject, eventdata, handles)

if strcmp(TypeOfScan, 'Single Scan') == 1
    %turn on the laser:
    fprintf(1, 'Turn On Laser: ')
    fprintf(TLS, 'outp on')
    Butt_StartScan_Child(hObject, eventdata, handles); % execute once
    pause(3);
    CloseLaser_TurnOff(TLS)
else % continuous scan     
    %turn on the laser
    fprintf(1, 'Turn On Laser:')
    fprintf(TLS, 'outp on')
    %
    while (get(handles.HaltScan, 'Value') == 0)
        Butt_StartScan_Child(hObject, eventdata, handles); % execute once
    end
    set(handles.HaltScan, 'Value', 0);  
    %turn off the laser
    fprintf(1, 'Turn Off Laser: ');
    pause(3);
    CloseLaser_TurnOff(TLS)
    uiwait(msgbox('Scan stopped.  Laser is off!'))
end



function HaltScan_Callback(hObject, eventdata, handles)
%do nothing.




function Butt_StartScan_Child(hObject, eventdata, handles)
% hObject    handle to Butt_StartScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
global wl_start_nm wl_stop_nm sweepspeed_nm Vmax TypeOfScan preambleBlock Channel
global AgScope TLS


    fprintf(TLS, 'wav:swe STOP') %stop sweep, if it was not previously started 
	if strcmp(AgScope.Status, 'closed') % closed
        fopen(AgScope);
        clrdevice(AgScope);
    else % still open...
        fclose(AgScope);
        fopen(AgScope);
        clrdevice(AgScope);        
    end
    

    fprintf(1, 'Set wavelength back to wl_start: \n')
    % ViStatus _VI_FUNC hp816x_set_TLS_wavelength(ViSession ihandle, ViInt32 TLSSlot, ViInt32 wavelengthSelection, ViReal64 wavelength);
    % long hp816x_set_TLS_wavelength(ulong, long, long, double)
    
    wl_start_nm
    'Wait for previous sweep to stop'

    State_str = '+1';
    while (str2num(State_str) == 1) % still running sweep
        pause(0.5);
        State_str = query(TLS, 'wav:swe?')        
    end
    
    
    fprintf(AgScope, ':RUN'); pause(0.5);
    fprintf(AgScope, ':DIGITIZE'); pause(0.5);
    fprintf(AgScope,':ACQuire:TYPE NORM'); %
    fprintf(AgScope, ':ACQuire:COMPlete 90');

    fprintf(AgScope, sprintf(':CHANnel%i:DISPlay 1',Channel));
    fprintf(AgScope, sprintf(':CHANnel%i:DISPlay 0',3-Channel));    
    
    fprintf(sprintf('Run the Sweep \n'))        
    fprintf(TLS, 'wav:swe START')
    
    
    if (strcmp(TypeOfScan, 'Single Scan'))
        cycles = 1;
    else
        cycles = 99;
    end
    wls = [];


    % sweep time vs PerentageCompleted would be better
    % wl readings are done at a rate of 20 points/0.5 seconds... 
    % or 40 points/sec
    sweepspeed_nm_vs_PercentageCompleted = [ ...
        100         0.93
        80          0.93
        40          0.90
        20          0.99
        10          0.99
        5           0.99
        ];
    
    PercentageCompleted = sweepspeed_nm_vs_PercentageCompleted((sweepspeed_nm_vs_PercentageCompleted == sweepspeed_nm),2)
    
    cyclecount = 0;
    while (cyclecount < cycles)        
        
        wl = str2num(query(TLS, 'wav?')) *1e9;
    
        wls(end+1) = wl;
        plot(handles.axes2, wls);

        if (length(wls) < 2)
            continue;
        end

        drawnow();

        %increasing wavelength sweep 
        if (mod(cyclecount,2) == 0 && (wl>=(wl_start_nm+PercentageCompleted*(wl_stop_nm-wl_start_nm))) && (wls(end)>=wls(end-1)))  % rising
            fprintf(1, 'grabbing trace %i\n', cyclecount);
            Trace = func_GrabScopeWaveform_v2(AgScope, preambleBlock, wl_start_nm, wl_stop_nm, sweepspeed_nm);
            plot(handles.axes1, Trace.XData,Trace.YData);
            
            title(handles.axes1, sprintf('%i', cyclecount));
            axis(handles.axes1, [wl_start_nm, wl_stop_nm, 0, Vmax]);            
            drawnow();
            %
            Vmax = str2double(get(handles.Vmax, 'String')); 
            fprintf(AgScope, sprintf(':CHAN%i:RANGE %2.2f',Channel,Vmax));
            fprintf(AgScope, sprintf(':CHAN%i:offset %2.2f',Channel,Vmax*0.5));            
            preambleBlock.YINCREMENT = Vmax/256;
            %    YINCREMENT    : float32 - voltage diff between data points.
            preambleBlock.YORIGIN = Vmax/2;            
            %
            cyclecount = cyclecount+1;
            fprintf(1, sprintf('cyclecount %i\n', cyclecount))
            continue;
        end    


        if (mod(cyclecount,2) == 1 && (wl<=(wl_stop_nm-PercentageCompleted*(wl_stop_nm-wl_start_nm))) && (wls(end)<=wls(end-1)))  % falling
            fprintf(1, 'grabbing trace %i\n', cyclecount);
            Trace = func_GrabScopeWaveform_v2(AgScope, preambleBlock, wl_stop_nm, wl_start_nm, sweepspeed_nm);
    %         Trace.XData = fliplr(Trace.XData);
    %         plot(figax2, Trace(end:(-1):1));
            plot(handles.axes1, Trace.XData,Trace.YData);
            title(handles.axes1, sprintf('%i', cyclecount));
            axis(handles.axes1, [wl_start_nm, wl_stop_nm, 0, Vmax]);
            %
            Vmax = str2double(get(handles.Vmax, 'String')); 
             fprintf(AgScope, sprintf(':CHAN%i:RANGE %2.2f',Channel,Vmax));
             fprintf(AgScope, sprintf(':CHAN%i:offset %2.2f',Channel,Vmax*0.5));       
            preambleBlock.YINCREMENT = Vmax/256;
            %    YINCREMENT    : float32 - voltage diff between data points.
            preambleBlock.YORIGIN = Vmax/2;            
            %            
            drawnow();
            cyclecount = cyclecount+1;            
            fprintf(1, sprintf('cyclecount %i\n', cyclecount))                
            continue;
        end    


        if (length(wls) > 100) && abs(mean(wls((end-100):end)) - wl_stop_nm)<0.01e-9
            fprintf(AgScope, ':STOP');
            break;
        end


    end      
    
    fprintf(AgScope, ':STOP');
    if (strcmp(TypeOfScan,'Single Scan'))
%         FastScan_CloseTLS();        
%         break;
    end
    fclose(AgScope);
% end
%
if (get(handles.HaltScan, 'Value') == 1) %halt!
%     fprintf(AgScope, ':STOP');
    fprintf(sprintf('Halt the sweep! \n'))
%     ViStatus = calllib('hp816x_32', 'hp816x_TLS_sweepControl', InstrHandle, int32(1), int32(0));    
end



% --- Executes during object deletion, before destroying properties.
function axes1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unloadlibrary('hp816x_32')



function InstrHandle_Callback(hObject, eventdata, handles)
% hObject    handle to InstrHandle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InstrHandle as text
%        str2double(get(hObject,'String')) returns contents of InstrHandle as a double


% --- Executes during object creation, after setting all properties.
function InstrHandle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InstrHandle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Butt_SaveFig.
function Butt_SaveFig_Callback(hObject, eventdata, handles)
% hObject    handle to Butt_SaveFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%send the Halt Command:
global PreviousSaveDir;
set(handles.HaltScan, 'Value', 1);
figure; newax = gca;
newfig = gcf;
hold(newax, 'on');        
    colors = ['rkbgmrkbgmrkbgmrkbgmrkbgmrkbgmrkbgmrkbgmrkbgm'];
    [NewTraces, NumTraces] = func_ExtractTracesFromFig(handles.figure1);
    for k = 1:NumTraces
        plot( newax, NewTraces(k).XData,  NewTraces(k).YData, colors(k), 'linewidth', 2);
    end        
hold(newax, 'off');
set(newax, 'FontSize', 15);
xlabel('wavelength (nm)');
ylabel('Voltage (V)');
%
%
DefaultSaveFolder = PreviousSaveDir;
DefaultFileName = ['*.fig'];
DateString = [datestr(now,'yyyy-mm-dd-HH_MM_SS'), '.fig'];
[FileName,PathName] = uiputfile([DefaultSaveFolder, '\', DefaultFileName]);
if (length(FileName)*length(PathName)>1)
    PreviousSaveDir = PathName;
    sprintf('%s%s',PathName,FileName)
    saveas(newfig, sprintf('%s%s%s',PathName,FileName(1:(end-3)), DateString));   
end
close(newfig); 
set(handles.HaltScan, 'Value', 0);


% --- Executes on selection change in Channel.
function Channel_Callback(hObject, eventdata, handles)
% hObject    handle to Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Channel


% --- Executes during object creation, after setting all properties.
function Channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
