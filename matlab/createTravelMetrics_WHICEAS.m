function tm = createTravelMetrics_WHICEAS(ppStruct, gliders, missionPaths, targetsFiles, diveLimits, plannedRecov)
% CREATETRAVELMETRICS_WHICEAS	Create a travel metrics table for all WHICEAS gliders
%
%   Syntax:
%       TM = CREATETRAVELMETRICS_WHICEAS(PP, GLIDERS, MISSIONPATHS, TARGETSFILES, DIVELIMITS, PLANNEDRECOV)
%
%   Description:
%       Detailed description here, please
%
%   Inputs:
%       ppStruct      [struct] piloting parameters structure with
%                     fieldnames for each glider containing a pp table
%       gliders       [cell array] glider names as strings
%       missionpaths  [cell array] mission paths for each glider
%       targetsFiles  [cell array] names of each gliders targets file (to
%                     be found in each mission folder
%       diveLimits    [numeric] dive number to start calculations at (after
%                     rodeo)
%       plannedRecov  [datetime array] planned recovery date in HST
%
%	Outputs:
%       tm            [table] with summary stats on glider travel metrics
%
%   Examples:
%
%   See also
%
%   Authors:
%       S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%
%   Updated:   24 February 2026
%
%   Created with MATLAB ver.: 24.2.0.2740171 (R2024b) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% create output table
tm = table;

for g = 1:numel(gliders)
    ppTmp = ppStruct.(gliders{g});
    tm.glider(g) = gliders(g);
    tm.deploy(g) = datetime(ppTmp.diveStartTime(diveLimits(g)), ...
        'Format', 'uuuu-MMM-dd HH:mm ZZZZ', 'TimeZone','UTC');
    % elapsed days and total distance over groun
    tm.missionElapsed(g) = days(ppTmp.diveEndTime(end) - ppTmp.diveStartTime(diveLimits(g)));
    tm.distTot_km(g) = sum(ppTmp.dog_km(diveLimits(g):end), 'omitnan');

    % estimate track distance covered and remaining
    % loop through all targets (expect RECV) to get distances between each
    [targets, ~] = readTargetsFile(fullfile(missionPaths{g}, targetsFiles{g}));
    % strip any empty rows
    targets(isnan(targets.lat),:) = [];
    % calc distances between targets
    for f = 1:height(targets) - 1
        [targets.distToNext_km(f), ~] = lldistkm([targets.lat(f+1) targets.lon(f+1)], ...
            [targets.lat(f) targets.lon(f)]);
    end
    % get current waypoint to calculate distance covered and remaining
    currTgt = ppTmp.tgtName{end};
    ctIdx = find(strcmp(targets.name, currTgt));
    % sum dists between all waypoints before current waypoint, then subtract
    % remaining distance to currant waypoint to get total trackline covered
    dist_covEst = sum(targets.distToNext_km(1:ctIdx-1));
    tm.distCov_km(g) = dist_covEst - ppTmp.distTGT_km(end);
    % sum dist between all remaining waypoints + the remaining dist to current
    % target to get total trackline remaining
    dist_remEst = sum(targets.distToNext_km(ctIdx:end));
    tm.distRem_km(g) = dist_remEst + ppTmp.distTGT_km(end);

    % speeds
    tm.avgSpd_km_day(g) = tm.distTot_km(g)/tm.missionElapsed(g);
    tm.avgTrkSpd_km_day(g) = tm.distCov_km(g)/tm.missionElapsed(g);
    % last 5 dives only (typically 20-30 hours)
    if height(ppTmp) >=5
        tm.avgSpdRec_km_day(g) = sum(ppTmp.dog_km(end-4:end))/...
            days(ppTmp.diveEndTime(end) - ppTmp.diveStartTime(end-4));
    else % use all dives
        tm.avgSpdRec_km_day(g) = sum(ppTmp.dog_km)/...
            days(ppTmp.diveEndTime(end) - ppTmp.diveStartTime(1));
    end

    % remaining days
    tm.missionRem(g) = tm.distRem_km(g)/tm.avgTrkSpd_km_day(g);
    tm.missionRemRec(g) = tm.distRem_km(g)/tm.avgSpdRec_km_day(g);

    % eta to recovery
    tm.eta(g) = dateshift(datetime(ppTmp.diveEndTime(end), 'Format', 'uuuu-MMM-dd HH:mm ZZZZ', ...
        'TimeZone', 'UTC') + days(tm.missionRem(g)), 'start', 'hour', 'nearest');
    tm.etaRec(g) = dateshift(datetime(ppTmp.diveEndTime(end), 'Format', 'uuuu-MMM-dd HH:mm ZZZZ', ...
        'TimeZone', 'UTC') + days(tm.missionRemRec(g)), 'start', 'hour', 'nearest');
    
    % update timezone to HST
    tm.eta.TimeZone = 'Pacific/Honolulu';
    tm.etaRec.TimeZone = 'Pacific/Honolulu';

    % add in planned recovery date
    tm.plannedRecov(g) = datetime(plannedRecov(g), 'Format', 'uuuu-MMM-dd HH:mm ZZZZ', ...
        'TimeZone', 'Pacific/Honolulu');

end

%% plot metrics

figure(2027); 
clf; 
% set(gcf, 'Position', [2590 -204 800 560])
set(gcf, 'Position', [2580 -4 800 560])
hold on;

% get limits
nowT = datetime('now','TimeZone','Pacific/Honolulu');
minDeploy = min(tm.deploy);
maxDate   = max([tm.plannedRecov; tm.eta; tm.etaRec]);

leftPad  = days(4);
rightPad = days(2);

xLeft  = minDeploy - leftPad;
xRight = maxDate + rightPad;

% plot in reverse order so numeric top to bottom
nG = height(tm);
plotOrder = nG:-1:1;

for i = 1:nG
    g = plotOrder(i);   % actual row in table
    y = i;              % plotting row position

    % ---- Mission baseline (gray) ----
    plot([tm.deploy(g) tm.plannedRecov(g)], ...
        [y y], 'Color',[0.8 0.8 0.8],'LineWidth',8)

    % ---- Progress shading (blue) ----
    progEnd = min(nowT, tm.plannedRecov(g));
    plot([tm.deploy(g) progEnd], ...
        [y y], 'Color',[0.2 0.4 0.8],'LineWidth',8)

    % ---- Risk coloring ----
    riskColor_full = getRiskColor(tm.eta(g), tm.plannedRecov(g));
    riskColor_rec  = getRiskColor(tm.etaRec(g), tm.plannedRecov(g));

    % ---- ETA markers ----
    hFull = plot(tm.eta(g), y, 'o', ...
        'MarkerFaceColor', riskColor_full, ...
        'MarkerEdgeColor','k', 'MarkerSize',9);

    hRec = plot(tm.etaRec(g), y, '^', ...
        'MarkerFaceColor', riskColor_rec, ...
        'MarkerEdgeColor','k', 'MarkerSize',9);

    % ---- Numeric labels (days offset) ----
    delta_full = days(tm.eta(g) - tm.plannedRecov(g));
    delta_rec  = days(tm.etaRec(g) - tm.plannedRecov(g));

    text(tm.eta(g) + days(0.2), y+0.1, ...
        sprintf('%+.1f d', delta_full), ...
        'FontSize',8)

    text(tm.etaRec(g) + days(0.2), y-0.15, ...
        sprintf('%+.1f d', delta_rec), ...
        'FontSize',8)

% ---- Remaining distance label (aligned left) ----
distStr = sprintf('%.0f km remaining', tm.distRem_km(g));

text(xLeft + days(0.5), y - 0.25, ...
    distStr, ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','top', ...
    'FontSize',9)
end

% ---- Today line ----
xline(nowT,'k--','Today')

% ---- Axis formatting ----
yticks(1:nG)
yticklabels(tm.glider(plotOrder))

ylim([0.5 nG+0.5])   % <-- padding top and bottom
% xlim([min(tm.deploy) - days(3), ...
%       max([tm.plannedRecov; tm.eta; tm.etaRec]) + days(2)])
xlim([xLeft xRight])
xlabel('Date (HST)')
title('WHICEAS 2026 Recovery Planner')
grid on

% ---- Legend (triangles vs circles only) ----
legend([hFull hRec], ...
    {'ETA (Full Mission Avg)','ETA (Last 5 Dives)'}, ...
    'Location','southoutside', ...
    'Orientation','horizontal')

hold off;



plotTrkSpdOverTime(ppStruct, gliders, diveLimits, 1)
end

%% nested function
function plotTrkSpdOverTime(ppStruct, gliders, diveLimits, nWin)
% PLOTTRKSPDOVERTIME  Plot rolling avg trackline speed per glider over dive number
%
%   Syntax:
%       PLOTTRKSPDOVERTIME(ppStruct, gliders, diveLimits, nWin)
%
%   Description:
%       For each glider, computes a rolling n-dive average trackline speed
%       (km/day) using dog_km and dive durations, then plots each glider
%       as a separate subplot over dive number. Mirrors the avgSpdRec
%       approach in createTravelMetrics_WHICEAS.
%
%   Inputs:
%       ppStruct    [struct]     piloting parameters structure
%       gliders     [cell array] glider names as strings
%       diveLimits  [numeric]    dive number to start calculations at
%       nWin        [numeric]    number of dives to average over (use 1
%                                for single-dive, no averaging)
%
%   Authors:
%       S. Fregosi <selene.fregosi@gmail.com>
%
%   Updated: 29 March 2026

% default to single-dive if not specified
if nargin < 4 || isempty(nWin)
    nWin = 1;
end

col_sg = [...
    1.0 0.4 0.0; ...    % orange
    1.0 1.0 0.0; ...    % yellow
    0.8 0.0 0.2; ...    % red
    0.8 0.2 0.6];       % purple

nG = numel(gliders);

figure(2028);
clf;
set(gcf, 'Position', [1380 70 640 180*nG]);

% % fleet mean for reference line - compute once before subplot loop
% allMeans = arrayfun(@(g) ...
%     sum(ppStruct.(gliders{g}).dog_km(diveLimits(g):end), 'omitnan') / ...
%     days(ppStruct.(gliders{g}).diveEndTime(end) - ...
%          ppStruct.(gliders{g}).diveStartTime(diveLimits(g))), ...
%     1:nG);
% fleetMean = mean(allMeans, 'omitnan');

for g = 1:nG
    ppTmp = ppStruct.(gliders{g});

    startIdx = diveLimits(g);
    nDives   = height(ppTmp);

    subplot(nG, 1, g);
    hold on;

    if nDives < startIdx
        warning('Glider %s has fewer dives than diveLimits(%d). Skipping.', ...
            gliders{g}, g);
        continue
    end

    nValid     = nDives - startIdx + 1;
    diveNums   = (startIdx:nDives)';
    rollingSpd = NaN(nValid, 1);

    for d = startIdx:nDives
        idx      = d - startIdx + 1;
        winStart = max(startIdx, d - (nWin - 1));

        winDog_km  = sum(ppTmp.dog_km(winStart:d), 'omitnan');
        winElapsed = days(ppTmp.diveEndTime(d) - ppTmp.diveStartTime(winStart));

        if winElapsed > 0
            rollingSpd(idx) = winDog_km / winElapsed;
        end
    end

    % per-glider mission mean
    gliderMean = sum(ppTmp.dog_km(startIdx:end), 'omitnan') / ...
        days(ppTmp.diveEndTime(end) - ppTmp.diveStartTime(startIdx));

    plot(diveNums, rollingSpd, '-o', ...
        'Color',           col_sg(g,:), ...
        'MarkerFaceColor', col_sg(g,:), ...
        'MarkerSize',      4);

    % yline(fleetMean, 'k--', 'Fleet Mean', ...
    %     'LabelHorizontalAlignment', 'left');
        yline(gliderMean, '--', sprintf('Mission Mean: %.1f km/day', gliderMean), ...
        'Color',                    'black', ...
        'LabelHorizontalAlignment', 'left', 'HandleVisibility','off');

    ylabel('km/day');
    title(gliders{g});
    grid on;
    hold off;
end

xlabel('Dive Number');

if nWin == 1
    sgtitle('WHICEAS 2026 — Per-Dive Trackline Speed');
else
    sgtitle(sprintf('WHICEAS 2026 — Rolling %d-Dive Avg Trackline Speed', nWin));
end

end