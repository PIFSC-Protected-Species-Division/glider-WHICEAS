% combined script
addpath(genpath('C:\Users\selene.fregosi\Documents\MATLAB\agate'));
warning off

% addpath('C:\Users\selene.fregosi\Desktop\sg274_20260128_WHICEAS')
% pp274 = workflow_downloadScript_sg274_20260128_WHICEAS(0);
%
% fprintf(1, '\n----------------------------------\n\n');
%
% addpath('C:\Users\selene.fregosi\Desktop\sg607_20260128_WHICEAS')
% pp607 = workflow_downloadScript_sg607_20260128_WHICEAS(1);
%
% fprintf(1, '\n----------------------------------\n\n');
%
% addpath('C:\Users\selene.fregosi\Desktop\sg639_20260211_WHICEAS')
% pp639 = workflow_downloadScript_sg639_20260211_WHICEAS(1);
%
% fprintf(1, '\n----------------------------------\n\n');
%
% addpath('C:\Users\selene.fregosi\Desktop\sg679_20260205_WHICEAS')
% pp679 = workflow_downloadScript_sg679_20260205_WHICEAS(1);


% set glider names
gliders = {'sg274', 'sg607', 'sg639', 'sg679'};

% add paths
missionPaths = {
    'C:\Users\selene.fregosi\Desktop\sg274_20260128_WHICEAS'
    'C:\Users\selene.fregosi\Desktop\sg607_20260128_WHICEAS'
    'C:\Users\selene.fregosi\Desktop\sg639_20260211_WHICEAS'
    'C:\Users\selene.fregosi\Desktop\sg679_20260205_WHICEAS'
    };
cellfun(@(p) addpath(genpath(p)), missionPaths)

% create output structure
pp = struct;

% run each glider
% argument is to preload previous pp (1) or don't preload (0)
pp.sg274 = workflow_downloadScript_sg274_20260128_WHICEAS(1);
pp.sg607 = workflow_downloadScript_sg607_20260128_WHICEAS(0);
pp.sg639 = workflow_downloadScript_sg639_20260211_WHICEAS(1);
pp.sg679 = workflow_downloadScript_sg679_20260205_WHICEAS(1);


%% create combined map

% set colors
col_sg = [...
    1.0 0.4 0.0; ...    % orange
    1.0 1.0 0.0; ...    % yellow
    0.8 0.0 0.2; ...    % red
    0.8 0.2 0.6];       % purple
col_slcm  = [109 192  53]/255; % green
col_tgt = [0 0 0]; % black

targetsFiles = { ...
    'targets_WHICEAS_SG274_1200km_WN_20260209'; ...
    'targets_WHICEAS_SG607_950km_LN_20260209'; ...
    'targets_WHICEAS_sg639_1200km_LS_20260211'; ...
    'targets_WHICEAS_sg679_1200km_WS_20260211'};

% build basemap - use most recent config for bathy
% use 274's cofnig to start
CONFIG = agate('C:\Users\selene.fregosi\Desktop\sg274_20260128_WHICEAS\agate_config_sg274_20260128_WHICEAS.cnf');
% north arrow, scale bar or map limits can be defined in the CONFIG file
% specified above or manually set here
% e.g., to set north arrow location
CONFIG.map.naLat = 23;
CONFIG.map.naLon = -154;
% set scale bar location
CONFIG.map.scalePos = [0.05 0.31];
CONFIG.map.scaleMajor = 100;
CONFIG.map.scaleMinor = 20;

[baseFig] = createBasemap(CONFIG, 'bathy', 1, 'contourOn', 0, 'figNum', 2026);
baseFig.Name = 'WHICEAS 2026';
% baseFig.Position = [20    80    1200    700]; % set position on screen
baseFig.Position = [-1828 267 1200 700];
% simplify axes labels
plabel('PLabelLocation', 1, 'PLabelRound', 0, 'FontSize', 14);
mlabel('MLabelLocation', 1, 'MLabelRound', 0, ...
	'MLabelParallel', 'south', 'FontSize', 14);

% plot gliders
for g = 1:numel(gliders)
    ppTmp = pp.(gliders{g});
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

% add legend
legend(h, 'Location', 'southwest', 'FontSize', 14)
% add title
title('WHICEAS 2026', 'Interpreter', 'none')
% save it
exportgraphics(gca, fullfile('A:\My Drive\Glider Projects\WHICEAS 2026 Gliders', ...
    'combined_map_latest.png'), 'Resolution', 600);

