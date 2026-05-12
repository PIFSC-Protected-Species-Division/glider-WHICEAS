% WORKFLOW_MISSIONFINALMAPS.M
%	Create various final maps of WHICEAS glider mission 
%
%	Description:
%       May include ships, DASBRs, sperm whales, etc. 
%       (1) Gliders single color + ship tracks white
%
%	Notes
%
%	See also
%
%	Authors:
%		S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%
%	Updated:   2026 May 11
%
%	Created with MATLAB ver.: 25.1.0.2973910 (R2025a) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add agate to the path
addpath(genpath('C:\Users\pam_user\Documents\MATLAB\agate'))
addpath(genpath('C:\Users\pam_user\Documents\MATLAB\myUtils'))
path_repo = 'C:\Users\pam_user\Documents\GitHub\glider-WHICEAS';

%% some global things

% set colors
col_sg = [...
    1.0 0.4 0.0; ...    % orange
    1.0 1.0 0.0; ...    % yellow
    0.8 0.0 0.2; ...    % red
    0.8 0.2 0.6];       % purple
col_slcm  = [0.2 0.6 0.2]; % green
col_tgt = [0 0 0]; % black
col_ship = [1 1 1]; % white


%% (1) Gliders single color + ship tracks white

% load any config file to get started.
cnfFile = fullfile(path_repo, 'matlab', 'agate_configs_fregosi_pam-ww', ...
    'agate_config_sg274_20260128_WHICEAS_pam-ww.cnf');
CONFIG = agate(cnfFile);

% create basemap plot
[baseFigAll] = createBasemap(CONFIG, 'bathy', 1, 'contourOn', 1, 'figNum', 28);
mapFigPosition = [60   60   1200    1200];
baseFigAll.Position = mapFigPosition;
% north arrow, map limits can be defined in the CONFIG file specified above or manually set here
% e.g., to set north arrow location
CONFIG.map.naLat = 23;
CONFIG.map.naLon = -154;

% % add newport label
% scatterm(44.64, -124.05, 200, 'white', 'p', 'filled', 'MarkerEdgeColor', 'black');
% textm(44.48, -124.05, 'Newport, OR', 'FontSize', 10, 'Color', 'white');
% % add Eureka label
% scatterm(40.8, -124.16, 300, 'white', 'p', 'filled', 'MarkerEdgeColor', 'black');
% textm(40.8, -124.02, 'Eureka, CA', 'FontSize', 10, 'Color', 'white');

% add ship tracks
ship1 = kml2mapping('Q:\glider\WHICEAS_2026\SE2601_OnEffort_trackline_leg1.kml');
ship2 = kml2mapping('Q:\glider\WHICEAS_2026\SE2601_OnEffort_trackline_leg2.kml');
ship = [ship1, ship2];

allLat = [];
allLon = [];

for i = 1:numel(ship)
    % Append Lat/Lon and follow with a NaN to "lift the pen"
    allLat = [allLat, ship(i).Lat, NaN];
    allLon = [allLon, ship(i).Lon, NaN];
end

plotm(allLat, allLon, 'Color', col_ship, 'LineWidth', 2, 'HandleVisibility', 'off')

% plot last one with legend name
h(1) = plotm(ship(numel(ship)).Lat, ship(numel(ship)).Lon, ...
    'Color', col_ship,  'LineWidth', 2, 'DisplayName', 'Ship');


% sg274
CONFIG = agate(fullfile(path_repo, 'matlab', 'agate_configs_fregosi_pam-ww', ...
    'agate_config_sg274_20260128_WHICEAS_pam-ww.cnf'));
[targets, ~] = readTargetsFile(CONFIG, ...
    fullfile(CONFIG.path.mission, 'tracks_targets', 'targets_WHICEAS_SG274_1050km_WN_20260409_recoveryMod'));
plotm(targets.lat, targets.lon, 'Marker', 'o', 'MarkerSize', 4, ...
    'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'Color', [0 0 0], ...
    'HandleVisibility', 'off');
textm(targets.lat+0.1, targets.lon-0.1, targets.name, 'FontSize', 6)

load(fullfile(CONFIG.path.mission, 'profiles', [CONFIG.gmStr '_gpsSurfaceTable.mat']));
h(2) = plotm(gpsSurfT.startLatitude, gpsSurfT.startLongitude, ...
	'Color', col_sg(1,:), 'LineWidth', 3, 'DisplayName', 'SG274');

% sg607
CONFIG = agate(fullfile(path_repo, 'matlab', 'agate_configs_fregosi_pam-ww', ...
    'agate_config_sg607_20260128_WHICEAS_pam-ww.cnf'));
[targets, ~] = readTargetsFile(CONFIG, ...
    fullfile(CONFIG.path.mission, 'tracks_targets', 'targets_WHICEAS_SG607_1050km_LN_20260401'));
plotm(targets.lat, targets.lon, 'Marker', 'o', 'MarkerSize', 4, ...
    'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'Color', [0 0 0], ...
    'HandleVisibility', 'off');
textm(targets.lat+0.1, targets.lon-0.1, targets.name, 'FontSize', 6)

load(fullfile(CONFIG.path.mission, 'profiles', [CONFIG.gmStr '_gpsSurfaceTable.mat']));
h(3) = plotm(gpsSurfT.startLatitude, gpsSurfT.startLongitude, ...
	'Color', col_sg(2,:), 'LineWidth', 3, 'DisplayName', 'SG607');

% sg639
CONFIG = agate(fullfile(path_repo, 'matlab', 'agate_configs_fregosi_pam-ww', ...
    'agate_config_sg639_20260211_WHICEAS_pam-ww.cnf'));
[targets, ~] = readTargetsFile(CONFIG, ...
    fullfile(CONFIG.path.mission, 'tracks_targets', 'targets_WHICEAS_sg639_1260km_LS_20260402'));
plotm(targets.lat, targets.lon, 'Marker', 'o', 'MarkerSize', 4, ...
    'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'Color', [0 0 0], ...
    'HandleVisibility', 'off');
textm(targets.lat+0.1, targets.lon-0.1, targets.name, 'FontSize', 6)

load(fullfile(CONFIG.path.mission, 'profiles', [CONFIG.gmStr '_gpsSurfaceTable.mat']));
h(4) = plotm(gpsSurfT.startLatitude, gpsSurfT.startLongitude, ...
	'Color', col_sg(3,:), 'LineWidth', 3, 'DisplayName', 'SG639');

% sg679
CONFIG = agate(fullfile(path_repo, 'matlab', 'agate_configs_fregosi_pam-ww', ...
    'agate_config_sg679_20260205_WHICEAS_pam-ww.cnf'));
[targets, ~] = readTargetsFile(CONFIG, ...
    fullfile(CONFIG.path.mission, 'tracks_targets', 'targets_WHICEAS_sg679_1120km_WS_20260309'));
plotm(targets.lat, targets.lon, 'Marker', 'o', 'MarkerSize', 4, ...
    'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0], 'Color', [0 0 0], ...
    'HandleVisibility', 'off');
textm(targets.lat+0.1, targets.lon-0.1, targets.name, 'FontSize', 6)

load(fullfile(CONFIG.path.mission, 'profiles', [CONFIG.gmStr '_gpsSurfaceTable.mat']));
h(5) = plotm(gpsSurfT.startLatitude, gpsSurfT.startLongitude, ...
	'Color', col_sg(4,:), 'LineWidth', 3, 'DisplayName', 'SG679');

% add slocum
sl = readtable(fullfile(path_repo, 'data', 'stenella_rodeo_2026_surfacings.csv'));
sl.lat_decdeg = ddmm2decdeg(sl.lat);
sl.lon_decdeg = ddmm2decdeg(sl.lon);
h(6) = plotm(sl.lat_decdeg, sl.lon_decdeg, 'Color', col_slcm, ...
    'LineWidth', 3, 'DisplayName', 'Slocum');


hLeg = legend(h, 'Location', 'southwest', 'FontSize', 12, 'Color', 'w', ...
    'TextColor', 'k', 'EdgeColor', 'k', 'BackgroundAlpha', 0);


addScaleBar('Length', 200, 'Major', 100, 'Minor', 20, ...
    'AnchorLat', 17.3, 'AnchorLon', -155.3)


exportgraphics(gcf, fullfile(path_repo, 'outputs', 'allGliders_withShip_white.png'), ...
    'Resolution', 600);

