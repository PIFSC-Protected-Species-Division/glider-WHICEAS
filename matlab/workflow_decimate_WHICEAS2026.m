% WORKFLOW_DECIMATE_WHICEAS2026.M
%	Decimate 2026 WHICEAS glider data
%
%	Description:
%		All gliders had WISPRs and recorded at 200 kHz
%
%	Notes
%
%	See also
%
%
%	Authors:
%		S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%
%	Updated:   2026 August 10
%
%	Created with MATLAB ver.: 24.2.0.3212159 (R2024b) Update 9
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('C:\Users\pam_user\Documents\MATLAB\agate'))
% path_repo = 'C:\Users\pam_user\Documents\GitHub\glider-WHICEAS';

missionStrs = {
    'sg274_20260128_WHICEAS';
    'sg607_20260128_WHICEAS';
    'sg639_20260211_WHICEAS'};

mtp = 1; % mission to process - UPDATE THIS TO RUN THROUGH EACH GLIDER

% set original and desired sample rates (numeric and as string)
fs0 = 200000; % original sample rate
fs1 = 10000;	fs1Str = '10kHz';
fs2 = 1000;		fs2Str = '1kHz';

% set input and output paths
inDir = fullfile('P:\', 'glider', missionStrs{mtp}, 'recordings', 'flac');
% these match the default nameing scheme if outDir was left blank
outDir1 = fullfile('P:\', 'glider', missionStrs{mtp}, 'recordings', ...
    ['flac_decimated_' fs1Str]);
outDir2 = fullfile('P:\', 'glider', missionStrs{mtp}, 'recordings', ...
    ['flac_decimated_' fs2Str]);


% run decimation
decimateDir([10000 1000], inDir, {outDir1, outDir2});