clear;

%   Este script es para pruebas y no tener que trabajar con funciones
%   Calculo de errores mediante LOU de "quiniela.m", PARA GLM DE:
%       VICTORIAA, VICTORIAB, TIROSA, TIROSB, FALTASA, FALTASB

%   Equipos de 1º y 2º división según sus índices
equipos = ["Alaves" "Ath Bilbao" "Ath Madrid" "Barcelona" "Betis" "Cadiz" "Celta" "Elche" "Espanol" "Getafe" "Granada" "Levante" "Mallorca" "Osasuna" "Real Madrid" "Sevilla" "Sociedad" "Vallecano" "Villarreal" "Alcorcon" "Almeria" "Amorebieta" "Burgos" "Cartagena" "Eibar" "Fuenlabrada" "Girona" "Huesca" "Ibiza" "Las Palmas" "Leganes" "Lugo" "Malaga" "Mirandes" "Oviedo" "Ponferradina" "Sociedad B" "Sp Gijon" "Tenerife" "Valladolid" "Zaragoza"];

%   Para simular el input
%x = [1 13 6 19 4 12 17 9 21 29 27 32 23 33 11; 14 3 15 2 20 5 8 16 35 25 31 22 28 26 7];

data1 = readtable('./SP1.csv');     %   Cargar la primera división
data2 = readtable('./SP2.csv');     %   Cargar la segunda división

nPartidos = height(data1) + height(data2);

nVariables = 7;     %   Nº de características o patrones que vamos a tener en cuenta, contando los 1 del final
y = zeros(nPartidos, 1);
A = zeros(nPartidos, nVariables);
j = 0;      %   Contador auxiliar para partidos de segunda división

for i=1: (height(data1) + height(data2))

    if i <= height(data1)      %   Partido de primera division

        %   El resultado será cual de los dos equipos ganó, osea las "y"
        if strcmp(data1(i,:).FTR, 'H')
            y(i,:) = 1;
        elseif strcmp(data1(i,:).FTR, 'D')
            y(i,:) = 2;
        elseif strcmp(data1(i,:).FTR, 'A')      %   Este if no es necesario, es por claridad
            y(i,:) = 3;
        end

        equipoA = data1(i,:).HomeTeam;
        equipoB = data1(i,:).AwayTeam;

        victoriasA = getTeamVictories(data1, equipoA);
        victoriasB = getTeamVictories(data1, equipoB);

        tirospuertaA = getTeamShotsOnTarget(data1, equipoA);
        tirospuertaB = getTeamShotsOnTarget(data1, equipoB);

        faltasA = getTeamFoulsCommited(data1, equipoA);
        faltasB = getTeamFoulsCommited(data1, equipoB);

        A(i,:) = [victoriasA victoriasB tirospuertaA tirospuertaB faltasA faltasB 1];

    else      %   Partido de segunda division
        j = j +1;

        %   El resultado será cual de los dos equipos ganó, osea las "y"
        if strcmp(data2(j, :).FTR, 'H')
            y(i, :) = 1;
        elseif strcmp(data2(j, :).FTR, 'D')
            y(i, :) = 2;
        elseif strcmp(data2(j, :).FTR, 'A')      %   Este if no es necesario, es por claridad
            y(i, :) = 3;
        end

        equipoA = data2(j,:).HomeTeam;
        equipoB = data2(j,:).AwayTeam;

        victoriasA = getTeamVictories(data2, equipoA);
        victoriasB = getTeamVictories(data2, equipoB);

        tirospuertaA = getTeamShotsOnTarget(data2, equipoA);
        tirospuertaB = getTeamShotsOnTarget(data2, equipoB);

        faltasA = getTeamFoulsCommited(data2, equipoA);
        faltasB = getTeamFoulsCommited(data2, equipoB);

        A(i,:) = [victoriasA victoriasB tirospuertaA tirospuertaB faltasA faltasB 1];

    end
end

%coefs = pinv(A) * y;           %   Obtengo los coeficientes del modelo generado
mediaErrores = 0;
K = length(y);

for i = 1:K             %   ESTIMACIÓN DE ERRORES MEDIANTE LOU (K = Y)
    [xtrn, xtst, ytrn, ytst] = crossval(A', y', K, i);
    coefs = pinv(xtrn') * ytrn';
    yest = xtst' * coefs;
    error = (ytst - yest');
    mediaErrores = mediaErrores + (abs(error) / size(ytst, 2));
end

mediaErrores = mediaErrores / K;
disp("Errores medio: " + mediaErrores);
