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

%% SG274

% tracks used:
% targets_rodeo_hourglass_v20260128
% WHICEAS_SG274_1200km_WN_20260209.kml -> targets_WHICEAS_SG274_1200km_WN_20260209
% WHICEAS_SG274_1050km_WN_20260225.kml -> targets_WHICEAS_SG274_1050km_WN_20260225

% saved single track as kml (saved to desktop mission folder)
CONFIG = agate(fullfile(pd, 'sg274_20260128_WHICEAS', ...
    'agate_config_sg274_20260128_WHICEAS.cnf'));

kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_SG274_1050km_WN_20260225.kml');
% first make targets file without spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'WN', ...
    'radius', 2000);
% renamed output file to _mainOnly because otherwise it will get
% overwritten below

% now make with 20 km spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'WN', ...
    'radius', 2000, 'spacing', 20);
% this has 53 waypoints + RECOV, main is 9 points + RECV. Plot to see main points
mapPlannedTrack(CONFIG, targetsOut);
% Used map to create names text file with WN01, WN1a, WN1b, WN02, WN2a,
% WN2b, etc.

% now remake based on names file
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'file', ...
    'radius', 2000, 'spacing', 20, ...
    'wpFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG274_1050km_WN_20260225_withMidpoints_names.txt'));

% renamed this to add _withMidpoints to the name
% plot again for a final check
mapPlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG274_1050km_WN_20260225_withMidpoints'));

% plot bathymap
plotTrackBathyProfile(CONFIG, 'targetsFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG274_1050km_WN_20260225'));
exportgraphics(gca, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG274_1050km_WN_20260225_bathyProfile.png'), ...
    'Resolution', 600);

% create table for the Navy
interpTrack = interpolatePlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG274_1050km_WN_20260225_withMidpoints'), 20);
writetable(interpTrack, fullfile(CONFIG.path.mission, ...
    'sg274_planned_track_20260225_20km.xlsx'))
% then, hand modified to put in known locations for waypoints thus far and
% estimated dates at other waypoints about every 24 hours


%% SG607

% tracks used:
% targets_rodeo_hourglass_v20260128
% WHICEAS_SG607_950km_LN_20260209.kml -> targets_WHICEAS_SG607_950km_LN_20260209
% WHICEAS_SG607_1050km_LN_20260224.kml -> targets_WHICEAS_SG607_1050km_LN_20260224

% saved single track as kml (saved to desktop mission folder)
% renamed to WHICEAS_SG607_950km_LN_20260209.kml (to preserve create date)
CONFIG = agate(fullfile('C:\Users\selene.fregosi\Desktop\', 'sg607_20260128_WHICEAS', ...
    'agate_config_sg607_20260128_WHICEAS.cnf'));

kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_SG607_1050km_LN_20260224.kml');
% first make targets file without spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LN', ...
    'radius', 2000);
% renamed output file to _mainOnly because otherwise it will get
% overwritten below

% now make with 20 km spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LN', ...
    'radius', 2000, 'spacing', 20);
% this has 52 waypoints + RECOV, main is 9 points + RECV. Plot to see main points
mapPlannedTrack(CONFIG, targetsOut);
% Used map to create names text file with LN01, LN1a, LN1b, LN02, LN2a,
% LN2b, etc.

% now remake based on names file
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'file', ...
    'radius', 2000, 'spacing', 20, ...
    'wpFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG607_1050km_LN_20260224_withMidpoints_names.txt'));

% renamed this to add _withMidpoints to the name
% plot again for a final check
mapPlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG607_1050km_LN_20260224_withMidpoints'));

% plot bathymap
plotTrackBathyProfile(CONFIG, 'targetsFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG607_1050km_LN_20260224'));
exportgraphics(gca, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG607_1050km_LN_20260224_bathyProfile.png'), ...
    'Resolution', 600);

% create table for the Navy
interpTrack = interpolatePlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_SG607_1050km_LN_20260224_withMidpoints'), 20);
writetable(interpTrack, fullfile(CONFIG.path.mission, ...
    'sg607_planned_track_20260224_20km.xlsx'))
% then, hand modified to put in known locations for waypoints thus far and
% estimated dates at other waypoints about every 24 hours

%% SG639

% tracks used:
% targets_rodeo_hourglass_v20260128
% WHICEAS_sg639_1200km_LS_20260211.kml -> targets_WHICEAS_sg639_1200km_LS_20260211
% WHICEAS_sg639_1200km_LS_20260224.kml -> targets_WHICEAS_sg639_1200km_LS_20260224

% saved single track as kml (saved to desktop mission folder)
CONFIG = agate(fullfile('C:\Users\selene.fregosi\Desktop\', 'sg639_20260211_WHICEAS', ...
    'agate_config_sg639_20260211_WHICEAS.cnf'));

kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_sg639_1200km_LS_20260224.kml');
% first make targets file without spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LS', ...
    'radius', 2000);
% renamed output file to _mainOnly because otherwise it will get
% overwritten below

% now make with 20 km spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'LS', ...
    'radius', 2000, 'spacing', 20);
% this has 61 waypoints total but main is 11 points + RECV
% so plot to see turn points
mapPlannedTrack(CONFIG, targetsOut);
% Used map to create names text file with LS01, LS1a, LS1b, LS02, LS2a,
% LS2b, etc.

% now remake based on names file
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'file', ...
    'radius', 2000, 'spacing', 20, ...
    'wpFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg639_1200km_LS_20260224_withMidpoints_names.txt'));

% renamed this to add _withMidpoints to the name
% plot again for a final check
mapPlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg639_1200km_LS_20260224_withMidpoints'));

% plot bathymap
plotTrackBathyProfile(CONFIG, 'targetsFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg639_1200km_LS_20260224'));
exportgraphics(gca, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg639_1200km_LS_20260224_bathyProfile.png'), ...
    'Resolution', 600);

% create table for the Navy
interpTrack = interpolatePlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg639_1200km_LS_20260224_withMidpoints'), 20);
writetable(interpTrack, fullfile(CONFIG.path.mission, ...
    'sg639_planned_track_20260224_20km.xlsx'))
% then, hand modified to put in known locations for waypoints thus far and
% estimated dates at other waypoints about every 24 hours

%% SG679

% tracks used:
% targets_sg679_WS_20260204_withMidpoints (had bad RECV location)
% WHICEAS_sg679_1200km_WS_20260211.kml -> targets_WHICEAS_sg679_1200km_WS_20260211

% using draft_track_1200km_M1_WS_alt1
% saved single track as kml (saved to desktop mission folder)
% renamed to WHICEAS_sg679_1200km_WS_20260211.kml (to preserve create date)
CONFIG = agate(fullfile('C:\Users\selene.fregosi\Desktop\', 'sg679_20260205_WHICEAS', ...
    'agate_config_sg679_20260205_WHICEAS.cnf'));

kmlFile = fullfile(CONFIG.path.mission, 'WHICEAS_sg679_1200km_WS_20260211.kml');
% first make targets file without spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'WS', ...
    'radius', 2000);
% renamed output file to _mainOnly because otherwise it will get
% overwritten below

% now make with 20 km spacing
targetsOut = makeTargetsFile(CONFIG, kmlFile, 'method', 'WS', ...
    'radius', 2000, 'spacing', 20);
% this has 61 waypoints total but main is 10 points + RECV
% so plot to see turn points
mapPlannedTrack(CONFIG, targetsOut);
% Used map to create names text file with WS01, WS1a, WS1b, WS02, WS2a,
% WS2b, etc.

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
plotTrackBathyProfile(CONFIG, 'targetsFile', fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg679_1200km_WS_20260211'));
exportgraphics(gca, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg679_1200km_WS_20260211_bathyProfile.png'), ...
    'Resolution', 600);

% create table for the Navy
interpTrack = interpolatePlannedTrack(CONFIG, fullfile(CONFIG.path.mission, ...
    'targets_WHICEAS_sg679_1200km_WS_20260211_withMidpoints'), 20);
writetable(interpTrack, fullfile(CONFIG.path.mission, ...
    'sg679_planned_track_20260225_20km.xlsx'))
% then, hand modified to put in known locations for waypoints thus far and
% estimated dates at other waypoints about every 24 hours
