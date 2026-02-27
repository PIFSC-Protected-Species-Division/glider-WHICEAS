% WHICEAS_glider_downloads.m
%	Main script to download basestation data and make maps for all gliders
%
%	Description:
%		Runs four "downloadScript" functions - one for each Seaglider in
%		WHICEAS - to get latest basestation files, generate a zoomable
%		bathy map, and create the piloting parameters table. Creates a
%		combined travel metrics table with distances covered and remaining
%		and a combined map showing all four gliders. The travel metrics
%		table and combined map both get saved to Google Drive and to the
%		glider-WHICEAS GitHub repository
%
%	Authors:
%		S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%
%	Updated:   2026 February 24
%
%	Created with MATLAB ver.: 24.2.0.2740171 (R2024b) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% combined script

% add agate/repo to path
path_agate = 'C:\Users\selene.fregosi\Documents\MATLAB\agate';
path_repo = 'C:\Users\selene.fregosi\Documents\GitHub\glider-WHICEAS';
addpath(genpath(path_agate));
addpath(genpath(path_repo));
warning off

% set glider names
gliders = {'sg274', 'sg607', 'sg639', 'sg679'};

% set paths to glider mission olders and add to path
missionPaths = {
    'C:\Users\selene.fregosi\Desktop\sg274_20260128_WHICEAS'
    'C:\Users\selene.fregosi\Desktop\sg607_20260128_WHICEAS'
    'C:\Users\selene.fregosi\Desktop\sg639_20260211_WHICEAS'
    'C:\Users\selene.fregosi\Desktop\sg679_20260205_WHICEAS'
    };
% cellfun(@(p) addpath(genpath(p)), missionPaths)

%% Run each glider
% this can be a little slow because of SSH and downloads

% create output structure
ppStruct = struct;

% argument is to preload previous pp (1) or don't preload (0)
ppStruct.sg274 = workflow_downloadScript_sg274_20260128_WHICEAS(1);
ppStruct.sg607 = workflow_downloadScript_sg607_20260128_WHICEAS(0); % don't preload because of comms issues
ppStruct.sg639 = workflow_downloadScript_sg639_20260211_WHICEAS(1);
ppStruct.sg679 = workflow_downloadScript_sg679_20260205_WHICEAS(1);

%% create a travel metrics/status table and plot

% define targets - with midpoints for calculations
targetsMidpointsFiles = { ...
    % 'targets_WHICEAS_SG274_1200km_WN_20260209_withMidpoints'; ...
    'targets_WHICEAS_SG274_1050km_WN_20260225_withMidpoints'; ...
    % 'targets_WHICEAS_SG607_950km_LN_20260209_withMidpoints'; ...
    'targets_WHICEAS_SG607_1050km_LN_20260224_withMidpoints'; ...
    % 'targets_WHICEAS_sg639_1200km_LS_20260211_withMidpoints'; ...
    'targets_WHICEAS_sg639_1200km_LS_20260224_withMidpoints'; ...
    'targets_WHICEAS_sg679_1200km_WS_20260211_withMidpoints'};

% define dive limits (to exclude rodeo)
diveLimits = [92; 66; 1; 1];
% SG274 rodeo dates/dives: deployed 01/29 0033 UTC, rodeo ended end of
% Dive 70 2/10 0816 UTC (296 hours or 12.4 days). WISPR off for Dives 71-91
% (4 days), WISPR back on Dive 92 2/14 0957 UTC
% SG607 rodeo dates/dives: deployed 01/28 2220 UTC, rodeo ended end of
% Dive 65 2/10 1058 UTC

% planned recovery dates
plannedRecov = datetime({ ...
    '2026-04-09 9:00'; ...
    '2026-04-08 9:00'; ...
    '2026-04-14 9:00'; ...
    '2026-04-14 9:00' ...
    });
plannedRecov.TimeZone = 'Pacific/Honolulu';

% make the table and plot
tm = createTravelMetrics_WHICEAS(ppStruct, gliders, missionPaths, ...
    targetsMidpointsFiles, diveLimits, plannedRecov);
% move the figure

% save it
writetable(tm, fullfile(path_repo, 'outputs', 'travelMetrics_all.csv'));
writetable(tm, fullfile('A:\My Drive\Glider Projects\2026 WHICEAS Gliders', ...
    'travelMetrics_all.csv'));
exportgraphics(gca, fullfile('A:\My Drive\Glider Projects\2026 WHICEAS Gliders', ...
    'recovery_planner.png'), 'Resolution', 600);
exportgraphics(gca, fullfile(path_repo, 'outputs', ...
    'recovery_planner.png'), 'Resolution', 600);

%% create combined map

% set colors
col_sg = [...
    1.0 0.4 0.0; ...    % orange
    1.0 1.0 0.0; ...    % yellow
    0.8 0.0 0.2; ...    % red
    0.8 0.2 0.6];       % purple
col_slcm  = [109 192  53]/255; % green
col_tgt = [0 0 0]; % black

% define targets - simple for mapping
targetsFiles = { ...
    % 'targets_WHICEAS_SG274_1200km_WN_20260209'; ...
    'targets_WHICEAS_SG274_1050km_WN_20260225'; ...
    % 'targets_WHICEAS_SG607_950km_LN_20260209'; ...
    'targets_WHICEAS_SG607_1050km_LN_20260224'; ...
    % 'targets_WHICEAS_sg639_1200km_LS_20260211; ...
    'targets_WHICEAS_sg639_1200km_LS_20260224'; ...
    'targets_WHICEAS_sg679_1200km_WS_20260211'};

% build basemap - use most recent config for bathy
% use 274's cofnig to start
CONFIG = agate('C:\Users\selene.fregosi\Desktop\sg274_20260128_WHICEAS\agate_config_sg274_20260128_WHICEAS.cnf');
% north arrow, map limits can be defined in the CONFIG file specified above or manually set here
% e.g., to set north arrow location
CONFIG.map.naLat = 23;
CONFIG.map.naLon = -154;

[baseFig] = createBasemap(CONFIG, 'bathy', 1, 'contourOn', 0, 'figNum', 2026);
baseFig.Name = 'WHICEAS 2026';
% baseFig.Position = [20    80    1200    700]; % set position on screen
% baseFig.Position = [2730 4 900 700]; % Newport office
baseFig.Position = [3160 2 900 700]; % Home office
% simplify axes labels
plabel('PLabelLocation', 1, 'PLabelRound', 0, 'FontSize', 14);
mlabel('MLabelLocation', 1, 'MLabelRound', 0, ...
    'MLabelParallel', 'south', 'FontSize', 14);

% plot gliders
for g = 1:numel(gliders)
    ppTmp = ppStruct.(gliders{g});
    % plot simple targets
    [targets, ~] = readTargetsFile(fullfile(missionPaths{g}, targetsFiles{g}));
    plotm(targets.lat, targets.lon, 'Marker', 'o', 'MarkerSize', 2, ...
        'MarkerEdgeColor', col_tgt, 'MarkerFaceColor', col_tgt, 'Color', col_tgt, ...
        'HandleVisibility', 'off');
    % % may need to adjust offset of target labels depending on zoom level
    % text(targets.lon-0.1, targets.lat+0.1, targets.name, 'FontSize', 6)
    % plot track
    h(g) = plotm(ppTmp.startLatitude, ppTmp.startLongitude, ...
        'Color', col_sg(g,:),'LineWidth', 3, 'DisplayName', gliders{g});
end

addScaleBar('Length', 200, 'Major', 100, 'Minor', 20, ...
    'AnchorLat', 17.3, 'AnchorLon', -155.3)

% add legend
legend(h, 'Location', 'southwest', 'FontSize', 14)
% add title
title('WHICEAS 2026', 'Interpreter', 'none')
% save it
exportgraphics(gca, fullfile('A:\My Drive\Glider Projects\2026 WHICEAS Gliders', ...
    'combined_map_latest.png'), 'Resolution', 600);
exportgraphics(gca, fullfile(path_repo, 'outputs', ...
    'combined_map_latest.png'), 'Resolution', 600);

