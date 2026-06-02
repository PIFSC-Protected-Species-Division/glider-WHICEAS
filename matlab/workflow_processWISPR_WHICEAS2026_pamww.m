% WORKFLOW_PROCESSWISPR_WHICEAS2026_PAMWW.M
%	Workflow for processing raw WISPR data into .flac, WHICEAS 2026
%
%	Description:
%		Script to process raw WISPR DAT files into readable FLAC files, set
%		up for the WHICEAS 2026 gliders and to run on a pam windows
%		workstation
%
%	Notes
%
%	See also
%
%
%	Authors:
%		S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%
%	Updated:       7 May 2026
%
%	Created with MATLAB ver.: 24.2.0.2740171 (R2024b) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('C:\Users\pam_user\Documents\MATLAB\agate'))
path_repo = 'C:\Users\pam_user\Documents\GitHub\glider-WHICEAS';

missionStrs = {
    'sg274_20260128_WHICEAS';
    'sg607_20260128_WHICEAS';
    'sg639_20260211_WHICEAS'};

mtp = 3; % mission to process - UPDATE THIS TO RUN THROUGH EACH GLIDER
sdCard = 1; % two SD cards for each glider, run individually

% set up input/output directories
inDir = fullfile('P:\', 'glider', missionStrs{mtp}, 'recordings', ...
    'raw_acoustic_data', ['SD' num2str(sdCard)]);
outDir = fullfile('P:\', 'glider', missionStrs{mtp}, 'recordings', 'flac');

% convert!
% will show progress and write to flac as default
convertWispr('inDir', inDir, 'outDir', outDir);

% below is old approach to restarting. This DOES NOT work on GCPs because
% logs do not save as they go. Will need to resolve log writting issue
% before this could be used
% convertWispr(CONFIG, 'showProgress', true, 'outExt', '.flac', ...
%     'restartDir', '240901');