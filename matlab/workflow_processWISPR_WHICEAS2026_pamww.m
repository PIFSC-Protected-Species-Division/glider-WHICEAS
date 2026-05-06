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
%	Updated:       6 May 2026
%
%	Created with MATLAB ver.: 24.2.0.2740171 (R2024b) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('T:\fregosi\github\agate'))
% addpath(genpath('C:\Users\selene.fregosi\Documents\MATLAB\wispr3'))
path_repo = 'T:\fregosi\github\glider-CalCurCEAS';

missionStrs = {'sg639_CalCurCEAS_Sep2024';
	'sg679_CalCurCEAS_Aug2024';
    'sg680_CalCurCEAS_Sep2024'};

mtpNum = 3; % mission to process - UPDATE THIS TO RUN THROUGH EACH GLIDER

% initialize agate
% make sure configuration file now has updated WISPR Settings section
% (not required during mission so may not be set yet)
CONFIG = agate(fullfile(path_repo, 'MATLAB', 'fregosi_config_files', ...
   'server', ['agate_config_server_' missionStrs{mtpNum} '.cnf']));


% convert!
convertWispr(CONFIG, 'showProgress', true, 'outExt', '.flac');
% convertWispr(CONFIG, 'showProgress', true, 'outExt', '.flac', ...
%     'restartDir', '240901');