function y = quiniela(x)
    
    y = [];

    %   Equipos de 1º y 2º división según sus índices
    equipos = ["Alaves" "Ath Bilbao" "Ath Madrid" "Barcelona" "Betis" "Cadiz" "Celta" "Elche" "Espanol" "Getafe" "Granada" "Levante" "Mallorca" "Osasuna" "Real Madrid" "Sevilla" "Sociedad" "Vallecano" "Villarreal" "Alcorcon" "Almeria" "Amorebieta" "Burgos" "Cartagena" "Eibar" "Fuenlabrada" "Girona" "Huesca" "Ibiza" "Las Palmas" "Leganes" "Lugo" "Malaga" "Mirandes" "Oviedo" "Ponferradina" "Sociedad B" "Sp Gijon" "Tenerife" "Valladolid" "Zaragoza"];

    %   Para simular el input
    %   x = [1 13 6 19 4 12 17 9 21 29 27 32 23 33 11; 14 3 15 2 20 5 8 16 35 25 31 22 28 26 7];

    data1 = readtable('./SP1.csv');     %   Cargar la primera división
    data2 = readtable('./SP2.csv');     %   Cargar la segunda división
    
    for i=1:length(x)
        if x(1,i) <= 20      %   Partido de primera division
            memberHome = ismember(data1.HomeTeam, equipos(1));       % Obtener si juega en casa
            memberAway = ismember(data1.AwayTeam, equipos(x(1,i)));  % Obtener si juega fuera
            nPartidosA = sum(memberAway) + sum(memberHome);          % Obtener el número de partidos que juega el primer equipo

            victoriasA = sum(memberHome == 1 & strcmp(data1.FTR, 'H')) + sum(memberAway == 1 & strcmp(data1.FTR, 'A'));

            memberHome = ismember(data1.HomeTeam, equipos(x(2,i)));  % Obtener si juega en casa
            memberAway = ismember(data1.AwayTeam, equipos(x(2,i)));  % Obtener si juega fuera
            nPartidosB = sum(memberAway) + sum(memberHome);          % Obtener el número de partidos que juega el segundo equipo

            victoriasB = sum(memberHome == 1 & strcmp(data1.FTR, 'H')) + sum(memberAway == 1 & strcmp(data1.FTR, 'A'));

            partidosMedia = round((nPartidosA + nPartidosB) / 2);

            porcentajes = [victoriasA/partidosMedia; 1 - (victoriasA/partidosMedia + victoriasB/partidosMedia);victoriasB/partidosMedia];
        
        else      %   Partido de segunda division
            memberHome = ismember(data2.HomeTeam, equipos(1));       % Obtener si juega en casa
            memberAway = ismember(data2.AwayTeam, equipos(x(1,i)));  % Obtener si juega fuera
            nPartidosA = sum(memberAway) + sum(memberHome);          % Obtener el número de partidos que juega el primer equipo

            victoriasA = sum(memberHome == 1 & strcmp(data2.FTR, 'H')) + sum(memberAway == 1 & strcmp(data2.FTR, 'A'));

            memberHome = ismember(data2.HomeTeam, equipos(x(2,i)));  % Obtener si juega en casa
            memberAway = ismember(data2.AwayTeam, equipos(x(2,i)));  % Obtener si juega fuera
            nPartidosB = sum(memberAway) + sum(memberHome);          % Obtener el número de partidos que juega el segundo equipo

            victoriasB = sum(memberHome == 1 & strcmp(data2.FTR, 'H')) + sum(memberAway == 1 & strcmp(data2.FTR, 'A'));

            partidosMedia = round((nPartidosA + nPartidosB) / 2);

            porcentajes = [victoriasA/partidosMedia; 1 - (victoriasA/partidosMedia + victoriasB/partidosMedia); victoriasB/partidosMedia];
        end

        y = [y porcentajes];
    end
    
    
end

