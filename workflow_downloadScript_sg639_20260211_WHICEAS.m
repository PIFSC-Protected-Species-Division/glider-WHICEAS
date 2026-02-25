function pp = workflow_downloadScript_sg639_20260211_WHICEAS(preload)
% WORKFLOW_DOWNLOADSCRIPT.M
%	Download basestation files and generate piloting/monitoring plots
%
%	Description:
%		This script provides a workflow that may be useful during an active
%		mission to assist with piloting. The idea is that the entire script
%		can be run after a glider surfacing to automate the process of
%		checking on the glider status
%
%       It has the following sections:
%       (1) any new basestation files to the local computer. This currently
%       includes .nc, .log, .dat, .eng files and WISPR (ws*) files. PMAR
%       files (pm*) are untested and cmdfiles/pdoscmds.bat files are not
%       updated since the switch to basestation3.
%       (2) extracts useful data from local basestation .nc and .log files
%       and compiles into a summary table, variable 'pp', and saves to a
%       .xlsx and .mat
%       (3) generates several piloting monitoring plots and saves as .pngs
%       (4) prints out calculated mission speeds and estimates of total
%       duration
%
%       It requires an agate configuration file during agate initialization
%       that includes the basestation configuration section, the acoustic
%       configuration section (if running an acoustic system), and the
%       plotting configuration section.
%
%	Notes
%
%	See also
%
%
%	Authors:
%		S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%	Created with MATLAB ver.: 9.13.0.2166757 (R2022b) Update 4
%
%	Updated:      11 February 2026
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SG274

% initialize agate
CONFIG = agate('C:\Users\selene.fregosi\Desktop\sg639_20260211_WHICEAS\agate_config_sg639_20260211_WHICEAS.cnf');

% specify the local piloting folder for this trip in CONFIG.path.mission
% set up nested folders for basestation files and piloting outputs
path_status = fullfile(CONFIG.path.mission, 'flightStatus'); % where to store output plots/tables
path_bsLocal = fullfile(CONFIG.path.mission, 'basestationFiles'); % local copy of basestation files
% this also can be set as CONFIG.path.bsLocal in the mission cnf file

% make the dirs if they don't exist
if ~isfolder(path_status); mkdir(path_status); end
if ~isfolder(path_bsLocal); mkdir(path_bsLocal); end

%% (1) download files from the basestation
downloadBasestationFiles(CONFIG)

% In MATLAB 2024b onward/with seaglider.pub (not sure which change is
% responsible) the SFTP connection can timeout or be throttled resulting in
% an FTP error 0 that interupts a download. This error will print but the
% loop will continue. If those errors are present, just re-run
% downloadBasestationFiles until no more files/errors occur. 

% To plot Seaglider Piloting Tools plots at this point, run DiveData below
% DiveData

%% (2) extract piloting parameters

% create piloting parameters (pp) table from downloaded basestation files
pp = extractPilotingParams(CONFIG, CONFIG.path.bsLocal, path_status, preload);
% change last argument from 0 to 1 to load existing data and append new dives/rows

% save it to the default location as .mat and .xlsx
save(fullfile(CONFIG.path.mission, 'flightStatus', ['diveTracking_' ...
	CONFIG.glider '.mat']), 'pp');
writetable(pp, fullfile(path_status, ['diveTracking_' CONFIG.glider '.xlsx']));


%% (3) generate and save plots

% print map **SLOWISH** - figNumList(1)
targetsFile = fullfile(CONFIG.path.mission, 'targets'); 
mapMissionPath(CONFIG, pp, 'targetsFile', targetsFile);

% save it as a .fig (for zooming)
savefig(fullfile(path_status, [CONFIG.glider '_map.fig']))
% and as a .png (for quick/easy view)
exportgraphics(gca, fullfile(path_status, [CONFIG.glider '_map.png']), ...
    'Resolution', 300)

%% (4) print mission summary

% print errors reported on most recent dive
% **below does not work for latest SGX firmware**
% printErrors(CONFIG, size(pp,1), pp)

% print avg speed and rough estimate of total mission duration
% tm = printTravelMetrics(CONFIG, pp, fullfile(CONFIG.path.mission, ...
	% 'targets'), 1);
% 
% % specify planned recovery date and time
% recovery = '2026-02-10 10:00:00';
% recTZ = '-10:00';
% tm = printRecoveryMetrics(CONFIG, pp, fullfile(CONFIG.path.mission, ...
% 	'targets'), recovery, recTZ, 1);
% 
end