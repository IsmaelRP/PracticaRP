%Devuelve una matriz 'x' de tamaño 2xN siendo N el número de partidos totales
%que se juegan. La primera columna son los equipos que juegan en casa y la
%segunda los visitantes. 

%Devuelve también un vector fila 'y' con un valor (1, 2 o 3) indicando si gana el
%equipo de casa, empatan o gana el visitante respectivamente.

function [x, y] = getDatosPrueba()


    equipos = ["Alaves" "Ath Bilbao" "Ath Madrid" "Barcelona" "Betis" "Cadiz" "Celta" "Elche" "Espanol" "Getafe" "Granada" "Levante" "Mallorca" "Osasuna" "Real Madrid" "Sevilla" "Sociedad" "Vallecano" "Villarreal" "Alcorcon" "Almeria" "Amorebieta" "Burgos" "Cartagena" "Eibar" "Fuenlabrada" "Girona" "Huesca" "Ibiza" "Las Palmas" "Leganes" "Lugo" "Malaga" "Mirandes" "Oviedo" "Ponferradina" "Sociedad B" "Sp Gijon" "Tenerife" "Valladolid" "Zaragoza"];
    
    data1 = readtable('./SP1.csv');     %   Cargar la primera división
    data2 = readtable('./SP2.csv');     %   Cargar la segunda división
    
    nPartidos = height(data1) + height(data2);

    equiposHome1 = (data1.HomeTeam);
    equiposAway1 = (data1.AwayTeam);
    resultadosPartido1 = (data1.FTR);

    equiposHome2 = (data2.HomeTeam);
    equiposAway2 = (data2.AwayTeam);
    resultadosPartido2 = (data2.FTR);

    micellX = [equiposHome1, equiposAway1; equiposHome2, equiposAway2]';
    micellY = [resultadosPartido1; resultadosPartido2]';

    
    x = [];
    y = [];
    for i=1:nPartidos
        x(1,i) = getTeamIndexByName(micellX{1,i});
        x(2,i) = getTeamIndexByName(micellX{2,i});
    end

    for i=1:nPartidos

        if micellY{i} == 'H'
            y(i) = 1;
        end

        if micellY{i} == 'D'
            y(i) = 2;
        end

        if micellY{i} == 'A'
            y(i) = 3;
        end

    end

end