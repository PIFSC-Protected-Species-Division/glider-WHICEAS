% WORKFLOW_STENELLA_STATS.M
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
%	Updated:   2026 March 13
%
%	Created with MATLAB ver.: 24.2.0.2740171 (R2024b) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_repo = 'C:\Users\selene.fregosi\Documents\GitHub\glider-WHICEAS';

% read in slocum surfacings
sl = readtable(fullfile(path_repo, 'data', 'stenella_rodeo_2026_surfacings.csv'));
sl.lat_decdeg = ddmm2decdeg(sl.lat);
sl.lon_decdeg = ddmm2decdeg(sl.lon);

% convert time 
sl.datetime = datetime(sl.time, 'ConvertFrom', 'posixtime');

% calculate total distance covered
% rodeo ended Feb 10 0600 UTC (index 442)
% transit to 1st survey waypoint WISPR off until ~11 Feb 0442 UTC 
% (idx 475 = last of transit, idx 476 = WISPR on)
% survey with WISPR on until ~22 Feb 0353 UTC (idx 690)
for s = 2:height(sl)
    sl.dist(s) = lldistkm([sl.lat_decdeg(s-1) sl.lon_decdeg(s-1)], ...
        [sl.lat_decdeg(s) sl.lon_decdeg(s)]);
end
% total distance = 805 km
sum(sl.dist)
days(sl.datetime(end) - sl.datetime(1))

% total rodeo
sum(sl.dist(1:442))
days(sl.datetime(442) - sl.datetime(1))

% total WISPR survey
sum(sl.dist(476:690))
days(sl.datetime(690) - sl.datetime(442))

% total return
sum(sl.dist(691:end))
days(sl.datetime(end) - sl.datetime(691))