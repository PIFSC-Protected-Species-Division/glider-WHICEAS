function c = getRiskColor(eta, planned)
% GETRISKCOLOR	One-line description here, please
%
%   Syntax:
%       OUTPUT = GETRISKCOLOR(INPUT)
%
%   Description:
%       Detailed description here, please
%
%   Inputs:
%       input   describe, please
%
%	Outputs:
%       output  describe, please
%
%   Examples:
%
%   See also
%
%   Authors:
%       S. Fregosi <selene.fregosi@gmail.com> <https://github.com/sfregosi>
%
%   Updated:   26 February 2026
%
%   Created with MATLAB ver.: 24.2.0.2740171 (R2024b) Update 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% risk color function
% function c = getRiskColor(eta, planned)
delta = days(eta - planned);

if delta <= 0
    c = [0.2 0.7 0.2];      % green
elseif delta <= 3
    c = [0.9 0.7 0.1];      % yellow
else
    c = [0.85 0.2 0.2];     % red
end

end