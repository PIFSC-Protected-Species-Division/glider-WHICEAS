% WORKFLOW_CREATE_TARGETS_FILES.M
%	One-line description here, please
%
%	Description:
%		Detailed description here, please
%
%	Notes
%
%	See also
%
%
%	Authors:
%		S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%
%	Updated:   2026 February 09
%
%	Created with MATLAB ver.: 24.2.0.2740171 (R2024b) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set desktop path (to save space below)
pd = 'C:\Users\selene.fregosi\Desktop\';

%% SG679
% using draft_track_1200km_M1_WS_alt1
% saved single track as kml (saved to desktop mission folder)
% renamed to WHICEAS_sg679_1200km_WS_20260211.kml (to preserve create date)
CONFIG = agate(fullfile('C:\Users\selene.fregosi\Desktop\', 'sg679_20260205_WHICEAS', ...
    'agate_config_sg679_20260205_WHICEAS.cnf'));

kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_sg679_1200km_WS_20260211.kml');
% first make targets file without spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LS', ...
    'radius', 2000);
% renamed output file to _mainOnly because otherwise it will get
% overwritten below

% now make with 20 km spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LN', ...
    'radius', 2000, 'spacing', 20);
% this has 61 waypoints total but main is 10 points + RECV
% so plot to see turn points
mapPlannedTrack(CONFIG, targetsOut);
% Used map to create names text file with LS01, LS1a, LS1b, LS02, LS2a,
% LS2b, etc.

% now remake based on names file
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'file', ...
    'radius', 2000, 'spacing', 20, ...
    'wpFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg679_1200km_WS_20260211_withMidpoints_names.txt'));

% renamed this to add _withMidpoints to the name
% plot again for a final check
mapPlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg679_1200km_WS_20260211_withMidpoints'));

% plot bathymap
plotTrackBathyProfile(CONFIG, 'targetsFile', targetsFile);
%% SG274

% using draft_track_03_1200km_SG274
% saved single track as kml (saved to desktop mission folder)
% renamed to WHICEAS_SG274_1200km_WN_20260209.kml (to preserve create date)
CONFIG = agate(fullfile(pd, 'sg274_20260128_WHICEAS', ...
    'agate_config_sg274_20260128_WHICEAS.cnf'));

kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_SG274_1200km_WN_20260209.kml');
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'WN', ...
    'radius', 2000, 'spacing', 20);

% the above just named everything WN01 to WN61 and RECV but want to change
% to have letters between major end points so plot first
mapPlannedTrack(CONFIG, targetsOut);
% then looked at map and found which numbers were end points. Copied list
% of WN01 to WN62 and manually edited to be WN01, WN1a, WN1b, WN02, WNa,
% etc. and saved as text file

% now remake based on names file
kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_SG274_1200km_WN_20260209.kml');
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'file', ...
    'radius', 2000, 'spacing', 20);

% made a copy of this and just deleted all the intermediate names

%% SG607

% using draft_track_03_1200km_SG274
% saved single track as kml (saved to desktop mission folder)
% renamed to WHICEAS_SG607_950km_LN_20260209.kml (to preserve create date)
CONFIG = agate(fullfile('C:\Users\selene.fregosi\Desktop\', 'sg607_20260128_WHICEAS', ...
    'agate_config_sg607_20260128_WHICEAS.cnf'));

kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_SG607_950km_LN_20260209.kml');
% first make targets file without spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LN', ...
    'radius', 2000);
% renamed output file to _mainOnly because otherwise it will get
% overwritten below

% now make with 20 km spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LN', ...
    'radius', 2000, 'spacing', 20);
% this has 48 waypoints + RECOV but should be 9 points + RECV
% so plot to see turn points
mapPlannedTrack(CONFIG, targetsOut);
% Used map to create names text file with LN01, LN1a, LN1b, LN02, LN2a,
% LN2b, etc.

% now remake based on names file
kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_SG607_950km_LN_20260209.kml');
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'file', ...
    'radius', 2000, 'spacing', 20, ...
    'wpFile', fullfile(CONFIG.path.mission, 'targets_WHICEAS_SG607_950km_LN_20260209_names.txt'));

% renamed this to add _withMidpoints to the name
% plot again for a final check
mapPlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG607_950km_LN_20260209_withMidpoints'));

%% SG639

% using draft_track_02_1200km
% saved single track as kml (saved to desktop mission folder)
CONFIG = agate(fullfile('C:\Users\selene.fregosi\Desktop\', 'sg639_20260211_WHICEAS', ...
    'agate_config_sg639_20260211_WHICEAS.cnf'));

kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_sg639_1200km_LS_20260211.kml');
% first make targets file without spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LS', ...
    'radius', 2000);
% renamed output file to _mainOnly because otherwise it will get
% overwritten below

% now make with 20 km spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LS', ...
    'radius', 2000, 'spacing', 20);
% this has 62 waypoints total but main is 11 points + RECV
% so plot to see turn points
mapPlannedTrack(CONFIG, targetsOut);
% Used map to create names text file with LS01, LS1a, LS1b, LS02, LS2a,
% LS2b, etc.

% now remake based on names file
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'file', ...
    'radius', 2000, 'spacing', 20, ...
    'wpFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg639_1200km_LS_20260211_withMidpoints_names.txt'));

% renamed this to add _withMidpoints to the name
% plot again for a final check
mapPlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg639_1200km_LS_20260211_withMidpoints'));