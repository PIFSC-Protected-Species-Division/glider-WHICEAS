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
        'TimeZone','Pacific/Honolulu');
    % elapsed days and total distance over groun
    tm.missionElapsed(g) = days(ppTmp.diveEndTime(end) - ppTmp.diveStartTime(diveLimits(g)));
    tm.distTot_km(g) = sum(ppTmp.dog_km(diveLimits(g):end), 'omitnan');

    % estimate track distance covered and remaining
    % loop through all targets (expect RECV) to get distances between each
    [targets, ~] = readTargetsFile(fullfile(missionPaths{g}, targetsFiles{g}));
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
        'TimeZone', 'Pacific/Honolulu') + days(tm.missionRem(g)), 'start', 'hour', 'nearest');
    tm.etaRec(g) = dateshift(datetime(ppTmp.diveEndTime(end), 'Format', 'uuuu-MMM-dd HH:mm ZZZZ', ...
        'TimeZone', 'Pacific/Honolulu') + days(tm.missionRemRec(g)), 'start', 'hour', 'nearest');

    % add in planned recovery date
    tm.plannedRecov(g) = datetime(plannedRecov(g), 'Format', 'uuuu-MMM-dd HH:mm ZZZZ', ...
        'TimeZone', 'Pacific/Honolulu');

end

%% plot metrics
figure; hold on

nowT = datetime('now','TimeZone','Pacific/Honolulu');

nG = height(tm);

% Reverse order index (so first glider appears at top)
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

end

% ---- Today line ----
xline(nowT,'k--','Today')

% ---- Axis formatting ----
yticks(1:nG)
yticklabels(tm.glider(plotOrder))

ylim([0.5 nG+0.5])   % <-- padding top and bottom
xlabel('Date (HST)')
title('Glider Mission Schedule Status')
grid on

% ---- Legend (triangles vs circles only) ----
legend([hFull hRec], ...
    {'ETA (Full Mission Avg)','ETA (Last 5 Dives)'}, ...
    'Location','southoutside', ...
    'Orientation','horizontal')

end

%% risk color function
function c = getRiskColor(eta, planned)
delta = days(eta - planned);

if delta <= 0
    c = [0.2 0.7 0.2];      % green
elseif delta <= 3
    c = [0.9 0.7 0.1];      % yellow
else
    c = [0.85 0.2 0.2];     % red
end

end