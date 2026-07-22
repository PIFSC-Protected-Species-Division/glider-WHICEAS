% WORKFLOW_PROCESSWISPR_WHICEAS2026_PICV027.M
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
%	Updated:       19 July 2026
%
%	Created with MATLAB ver.: 24.2.0.2740171 (R2024b) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('Z:\glider_WHICEAS_2026\github\agate'))
path_repo = 'Z:\glider_WHICEAS_2026\github\glider-WHICEAS';

missionStrs = {
    'sg274_20260128_WHICEAS';
    'sg607_20260128_WHICEAS';
    'sg639_20260211_WHICEAS'};

gliderStrs = {
    'sg274';
    'sg607';
    'sg639'};

mtp = 2; % mission to process - UPDATE THIS TO RUN THROUGH EACH GLIDER
sdCard = 1; % two SD cards for each glider, run individually

% % initialize agate
% % make sure configuration file now has updated WISPR Settings section
% % (not required during mission so may not be set yet)
% CONFIG = agate(fullfile(path_repo, 'MATLAB', 'agate_configs_fregosi_pam-ww', ...
%    ['agate_config_' missionStrs{mtp} '_pam-ww.cnf']));

% set up input/output directories
inDir = fullfile('Z:\', 'glider_WHICEAS_2026', 'raw_data_on_GCP', ...
    [gliderStrs{mtp} '_raw_acoustic_data'], ['SD' num2str(sdCard)]);
outDir = fullfile('Z:\', 'glider_WHICEAS_2026', missionStrs{mtp}, 'recordings', 'flac');

% convert!
% will show progress and write to flac as default
% convertWispr('inDir', inDir, 'outDir', outDir);
convertWispr('inDir', inDir, 'outDir', outDir, ...
    'restartDir', '260201');