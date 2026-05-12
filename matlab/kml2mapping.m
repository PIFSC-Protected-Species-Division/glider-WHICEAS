function tracks = kml2mapping(filename)
    % Read KML as a structure
    S = readstruct(filename, 'FileType', 'xml');
    
    % Access the Placemarks (navigating the Folder structure)
    % Based on your KML snippet: Document -> Folder -> Placemark
    allPlacemarks = S.Document.Folder.Placemark;
    numP = numel(allPlacemarks);
    
    tracks = struct('Geometry', 'Line', 'Name', {}, 'Lat', {}, 'Lon', {});
    
    for i = 1:numP
        p = allPlacemarks(i);
        
        % Ensure it has a LineString
        if isfield(p, 'LineString') && isfield(p.LineString, 'coordinates')
            coordStr = p.LineString.coordinates;
            
            % Parse the "Lon,Lat,Alt" string
            raw = textscan(coordStr, '%f,%f,%f', 'Delimiter', {' ', '\n', '\r', '\t'}, 'MultipleDelimsAsOne', true);
            
            lon = raw{1};
            lat = raw{2};
            
            if ~isempty(lat)
                tracks(i).Geometry = 'Line';
                tracks(i).Name = char(string(p.name)); % Handle numeric names
                tracks(i).Lat = lat';
                tracks(i).Lon = lon';
            end
        end
    end
end