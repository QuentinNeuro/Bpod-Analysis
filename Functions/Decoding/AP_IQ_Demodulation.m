function [M, P] = AP_IQ_Demodulation(rawData, F_s, F_mod, varargin)
%IQ_DEMODULATION performs the I/Q-demodulation of a signal
% 
% [M, P] = IQ_DEMODULATION(rawData, F_s, F_mod, varargin)
% 
% Basic input arguments (mandatory):
% ----------------------------------
% rawData: The modulated input signal
% F_s:     The sampling freuency
% F_mod:   The signal's modulation frequency
% 
% Additional arguements specified as Name-Value-pairs (optional, names must be given as strings):
% -----------------------------------------------------------------------------------------------
% - Argument 'CutOff':
%   - The cut-off frequency for the necessary low-pass filtering in the
%     demodulation process. Must be given as numerical value in Hz in the range
%     between 0 and F_s/2.
%   - Default value: 15
% - Argument 'PaddingType':
%   - The way of adding padded data to the beginning of the demodulated data
%     before performing the final low-pass filtering. The padded data will be 
%     removed after filtering! The padding type must be given as strings:
%     - 'None':
%       No padding
%     - 'Const':
%       The first sample of the unmodulated data will be append to the beginning
%       for one second
%     - 'Even':
%       The first second (including the first sample) of the demodulated data
%       will be append to the beginning of the signal in a mirrored order.
%     - 'Odd':
%       The first second (excluding the first sample) of the demodulated data
%       will be append to the beginning of the signal in a mirrored order.
%     - 'Rand':
%       The demodulated signal will be append with one second of samples,
%       randomly chosen from the first second of the demodulated signal.
%   - Default: 'None'
%
% Output arguments:
% -----------------
% M: The envelope (magnitude) of the modulated input signal
% P: The phase information of the modulated input signal (in degree)
%
% Examples:
% ---------
% 
% M = IQ_DEMODULATION(rawData, F_s, F_mod, 'CutOff', F_c);
% ------------------------------------------------------------------------------
% Performs the I/Q-demodulation of the (modulated) signal vector stored in 
% rawData based on a sampling frequency provided by F_s. The modulation
% frequency of the signal is given through the arguement F_mod. Additionally,
% the result of the demodulation is filtered with a fifth-order Butterworth
% low-pass filter with a cut-off frequency provided by F_c.
% The result is the envelope of the modulated signal stored in rawData.
%
% M = IQ_DEMODULATION(rawData, F_s, F_mod, 'CutOff', F_c, 'PaddingType', 'Rand');
% ------------------------------------------------------------------------------
% Performs the I/Q-demodulation of the (modulated) signal vector stored in 
% rawData based on a sampling frequency provided by F_s. The modulation
% frequency of the signal is given through the arguement F_mod. Additionally,
% the result of the demodulation is filtered with a fifth-order Butterworth
% low-pass filter with a cut-off frequency provided by F_c. Before performing
% the filtering, the beginning of the signal is padded with one second of 
% samples randomly taken from the signal's first second to suppress transients 
% caused by the filtering. After filtering, the padding is removed again.
% The result is the envelope of the modulated signal stored in rawData.
%
% Acknowledgment:
% ---------------
% Based on the implementation of Fitz Sturgill and Quentin Chevy
%
% Author: Michael Wulf
%         Cold Spring Harbor Laboratory
%         Kepecs Lab
%
% Version: 1.00.00
% Date:    2019/07/11
%
% VERSION HISTORY:
% -  1.00.00: Initial version

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set function filename for error reporting
funcName  = 'AM_Demodulation';
mFilename = sprintf('%s.mat', funcName);

% Set default values in case optional arguments are not specified
F_cutoff    = 15;
PaddingType = 'None';

%% Validate arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function needs at least 3 arguments (raw data, sampling freq. and mod. freq.)!
if (nargin < 3)
    error('Unsupported number of arguments for function %s!', funcName);
end
narginchk(3, 7);

% Validate basic arguments
validateattributes(rawData, {'numeric'}, {'vector', 'nonempty'}, mFilename, 'rawData', 1);
validateattributes(F_s, {'numeric'}, {'scalar', 'nonempty'}, mFilename, 'F_s', 2);
validateattributes(F_mod, {'numeric'}, {'scalar', 'nonempty'}, mFilename, 'F_mod', 3);

% Check that rawData is a row-vector; if not, transpose it for the processing
% and transpose the results later back to a column vector...
wasColumn = false;
if (iscolumn(rawData))
    rawData = rawData';
    wasColumn = true;
end

% Check length of rawData...
if (length(rawData) < F_s)
    error('rawData seems to be too short! It must be at least one second long...');
end

% Validate variable arguments
% Get the length of the varargins...
nvarargin = length(varargin);
if (nvarargin > 0)
    vararginCntr = 1;
    while (vararginCntr < nvarargin)
        varargName = varargin{vararginCntr};
        
        if(~ischar(varargName))
            warning('Name-Value pairs for variable arguments must start with a string for the name!');
            vararginCntr = vararginCntr + 2;
            continue;
        end
        
        switch lower(varargName)
            case 'cutoff'
                F_cutoff = varargin{vararginCntr+1};
                vararginCntr = vararginCntr + 2;
                if (~isnumeric(F_cutoff) || (F_cutoff <= 0) || (F_cutoff >= F_s/2))
                    error('Specified cutoff frequency Fc must be a numerical value in the range 0<Fc<Fs/2');
                end
                
            case 'paddingtype'
                PaddingType  = varargin{vararginCntr+1};
                vararginCntr = vararginCntr + 2;
                if (~ischar(PaddingType))
                    error('Specified PaddingType must be a string (char-array)!');
                end
                
            otherwise
                vararginCntr = vararginCntr + 2;
                warning('Unknown argument ''%s''', varargName);
        end
    end
end

%% Prepare reference signals (sine and cosine)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N         = length(rawData);
T_s       = 1/F_s;
t         = [0:1:N-1] * T_s; %#ok<NBRAK>
refData   = sin(2 * pi * F_mod * t);
refData90 = cos(2 * pi * F_mod * t);


%% Check the phase... kinda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Quadrature Demodulation (I/Q-Demodulation)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = rawData .* refData;    % In-phase signal
Q = rawData .* refData90;  % Quadrature signal


%% Apply optional padding a necessary Low-Pass filtering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filter order for Butterworth low-pass (IIR-filter)
n = 5;
% Normalize the cutoff frequency to the Nyquist frequency (half of sampling rate)
Wn = F_cutoff/(F_s/2);
% Calculate the filter coefficients
[b, a] = butter(n, Wn, 'low');
% We might consider using a SOS-structure (secon-order-section) to ensure stability
% -> similar call for filtfilt later
%[sos, g] = tf2sos(b,a);

% Pad the data to suppress transients caused by the initial states of the
% forward-backward filtering
switch(lower(PaddingType))
    case 'none'
        I_padded = I;
        Q_padded = Q;
        startIdx = 1;
        endIdx   = N;
        
    case 'const'
        I_padded                = zeros(1, N+F_s);
        I_padded(F_s+1:F_s+N)   = I;
        I_padded(1:F_s)         = I(F_s)*ones(1:F_s);
        Q_padded                = zeros(1, N+F_s);
        Q_padded(F_s+1:F_s+N)   = Q;
        Q_padded(1:F_s)         = Q(F_s)*ones(1:F_s);
        startIdx = F_s+1;
        endIdx   = F_s+N;
        
    case 'even'
        I_padded                = zeros(1, N+F_s);
        I_padded(F_s+1:F_s+N)   = I;
        I_padded(1:F_s)         = I(F_s:-1:1);
        Q_padded                = zeros(1, N+F_s);
        Q_padded(F_s+1:F_s+N)   = Q;
        Q_padded(1:F_s)         = Q(F_s:-1:1);
        startIdx = F_s+1;
        endIdx   = F_s+N;
        
    case 'odd'
        I_padded                = zeros(1, N+F_s-1);
        I_padded(F_s:F_s+N-1)   = I;
        I_padded(1:F_s-1)       = I(F_s-1:-1:1);
        Q_padded                = zeros(1, N+F_s-1);
        Q_padded(F_s:F_s+N-1)   = Q;
        Q_padded(1:F_s-1)       = Q(F_s-1:-1:1);
        startIdx = F_s;
        endIdx   = F_s+N-1;
        
    case 'rand'
        I_padded                = zeros(1, N+F_s);
        I_padded(F_s+1:F_s+N)   = I;
        I_padded(1:F_s)         = I(randperm(F_s));
        Q_padded                = zeros(1, N+F_s);
        Q_padded(F_s+1:F_s+N)   = Q;
        Q_padded(1:F_s)         = Q(randperm(F_s));
        startIdx = F_s+1;
        endIdx   = F_s+N;
        
        % TO-DO: Implement Gustafsson's method (https://ieeexplore.ieee.org/document/492552)
        %case 'gust'
        
    otherwise
        warning('Unsupported Padding Type! Using ''None'' instead...');
        I_padded = I;
        Q_padded = Q;
        startIdx = 1;
        endIdx   = N;
end



% Filter the demodulated data
I = filtfilt(b, a, I_padded);
Q = filtfilt(b, a, Q_padded);

% Filter the demodulated data with SOS-structure
%M = filtfilt(sos, g, paddedData);

% Take out only the values that correspond to the unpadded data
I = I(startIdx:endIdx);
Q = Q(startIdx:endIdx);


M = (I.^2 + Q.^2).^(1/2);  % Magnitude
P = atan2(Q,I)*180/pi;     % Phase
    
if (wasColumn)
    M = M';
end

end % End fo function