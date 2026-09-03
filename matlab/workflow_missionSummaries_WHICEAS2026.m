% WORKFLOW_MISSIONSUMMARIES_WHICEAS2026.M
%	Basic mission summary table for WHICEAS 2026 (distances, days, etc.).
%	Note there are three total summaries - the full mission, and separated
%	by the rodeo dates and non-rodeo dates
%
%	Description:
%		Generate glider performance/operational summary outputs.
%
%       (1) General Summary. Read in gpsSurfT tables for each glider,
%       extract start/end dates, calculate number of days deployed,
%       distance over ground covered, number of dives, and save as summary
%       table/csv.
%       (2) Load in PAM effort tables and also summarize total
%       recording duration and the percent of possible hours with
%       recordings
%
%	See also
%
%
%	Authors:
%		S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%
%	Updated:   2026 August 30
%
%	Created with MATLAB ver.: 25.1.0.2973910 (R2025a) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('C:\Users\pam_user\Documents\MATLAB\agate'))
path_repo = 'C:\Users\pam_user\Documents\GitHub\glider-WHICEAS';
path_out = fullfile(path_repo, 'outputs');
path_data = fullfile('P:\glider');
path_working = fullfile('Q:\glider\WHICEAS_2026');

missionStrs = {
    'sg274_20260128_WHICEAS';
    'sg607_20260128_WHICEAS';
    'sg639_20260211_WHICEAS'};

%% (1) General summary

out_vars = [{'glider', 'string'}; ...
    {'startDateTime', 'datetime'}; ...
    {'endDateTime', 'datetime'}; ...
    {'numDives', 'double'}; ...
    {'durDays', 'double'}; ...
    {'dist_km', 'double'}];

out = table('size', [length(missionStrs), size(out_vars,1)], ...
    'VariableNames', out_vars(:,1), 'VariableTypes', out_vars(:,2));

for m = 1:length(missionStrs)
    missionStr = missionStrs{m};
    % pull year from string
    yrStr = missionStr(end-3:end);

    % define path to 'profiles' folder with processed tables
    path_profiles = fullfile('P:\glider\', missionStr, 'piloting', 'profiles');

    % load locCalcT and gpsSurfaceTable
    % these were created with agate, using workflow_processPositionalData e.g.,
    load(fullfile(path_profiles, [missionStr '_gpsSurfaceTable.mat']))
    % don't need locCalcT yet...
    % load(fullfile(path_profiles, [missionStr '_locCalcT.mat']));

    % calculate mission summary stats
    out.glider{m} = missionStr(1:5);
    out.startDateTime(m) = gpsSurfT.startDateTime(1);
    out.endDateTime(m) = gpsSurfT.endDateTime(end);
    out.numDives(m) = max(gpsSurfT.dive);
    out.durDays(m) = round(days(out.endDateTime(m)-out.startDateTime(m)));
    out.dist_km(m) = round(sum(gpsSurfT.distance_km, 'omitnan'), 1);
end

writetable(out, fullfile(path_out, 'missionSummaryTable.csv'));

%% (2) Include PAM summary

out_vars = [{'recDur_hr', 'double'}; ...
    % 	{'possHrs', 'double'}; ...
    {'recPercent', 'string'}; ...
    % {'recDays', 'string'} ...
    ];

% append to existing table
out_pam = table('size', [length(missionStrs), size(out_vars,1)], ...
    'VariableNames', out_vars(:,1), 'VariableTypes', out_vars(:,2));
out = [out out_pam];

for m = 1:length(missionStrs)
    missionStr = missionStrs{m};

    % define path to 'profiles' folder with processed tables
    path_profiles = fullfile('C:\Users\selene.fregosi\Desktop', ...
        missionStr, 'profiles');
    % load pam effort tables
    load(fullfile(path_profiles, [missionStr '_pamEffort.mat']));

    % pam summary stats
    out.recDur_hr(m) = round(sum(pamMinPerHour.pam, 'omitnan')/60, 1);
    out.recPercent{m} = sprintf('%i%%', ...
        round(out.recDur_hr(m)/ ...
        (hours(out.endDateTime(m) - out.startDateTime(m)))*100));
    % out.recDays{m} = sprintf('%.1f of %i days', ...
    %     sum(pamMinPerDay.pam, 'omitnan')/(60*24), ...
    %     sum(~isnan(pamMinPerDay.pam)));
end

writetable(out, fullfile(path_out, 'missionSummaryTable_PAM.csv'));