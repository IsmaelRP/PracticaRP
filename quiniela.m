function y = quiniela(x)

y = [];

%   Equipos de 1º y 2º división según sus índices
equipos = ["Alaves" "Ath Bilbao" "Ath Madrid" "Barcelona" "Betis" "Cadiz" "Celta" "Elche" "Espanol" "Getafe" "Granada" "Levante" "Mallorca" "Osasuna" "Real Madrid" "Sevilla" "Sociedad" "Vallecano" "Villarreal" "Alcorcon" "Almeria" "Amorebieta" "Burgos" "Cartagena" "Eibar" "Fuenlabrada" "Girona" "Huesca" "Ibiza" "Las Palmas" "Leganes" "Lugo" "Malaga" "Mirandes" "Oviedo" "Ponferradina" "Sociedad B" "Sp Gijon" "Tenerife" "Valladolid" "Zaragoza"];

%   Para simular el input
x = [1 13 6 19 4 12 17 9 21 29 27 32 23 33 11; 14 3 15 2 20 5 8 16 35 25 31 22 28 26 7];

data1 = readtable('./SP1.csv');     %   Cargar la primera división
data2 = readtable('./SP2.csv');     %   Cargar la segunda división

nPartidos = height(data1) + height(data2);
nVariables = 3;     %   Nº de características o patrones que vamos a tener en cuenta
y = zeros(nPartidos, 1);
A = zeros(nPartidos, nVariables);
j = 0;      %   Contador auxiliar para partidos de segunda división

for i=1: (height(data1) + height(data2))

    if i <= height(data1)      %   Partido de primera division
        if strcmp(data1(i,:).FTR, 'H')
            y(i,:) = 1;
        elseif strcmp(data1(i,:).FTR, 'D')
            y(i,:) = 2;
        elseif strcmp(data1(i,:).FTR, 'A')      %   Este if no es necesario, es por claridad
            y(i,:) = 3;
        end

        equipoA = data1(i,:).HomeTeam;
        equipoB = data1(i,:).AwayTeam;

        memberHome = ismember(data1.HomeTeam, equipoA);       % Obtener cuando juega en casa
        memberAway = ismember(data1.AwayTeam, equipoA);       % Obtener cuando juega fuera

        victoriasA = sum(memberHome == 1 & strcmp(data1.FTR, 'H')) + sum(memberAway == 1 & strcmp(data1.FTR, 'A'));

        memberHome = ismember(data1.HomeTeam, equipoB);  % Obtener cuando juega en casa
        memberAway = ismember(data1.AwayTeam, equipoB);  % Obtener cuando juega fuera

        VictoriasB = sum(memberHome == 1 & strcmp(data1.FTR, 'H')) + sum(memberAway == 1 & strcmp(data1.FTR, 'A'));

        A(i,:) = [victoriasA VictoriasB 1];

    else      %   Partido de segunda division
        j = j +1;

        if strcmp(data2(j, :).FTR, 'H')
            y(i, :) = 1;
        elseif strcmp(data2(j, :).FTR, 'D')
            y(i, :) = 2;
        elseif strcmp(data2(j, :).FTR, 'A')      %   Este if no es necesario, es por claridad
            y(i, :) = 3;
        end

        equipoA = data2(j, :).HomeTeam;
        equipoB = data2(j, :).AwayTeam;

        memberHome = ismember(data2.HomeTeam, equipoA);       % Obtener cuando juega en casa
        memberAway = ismember(data2.AwayTeam, equipoA);       % Obtener cuando juega fuera

        victoriasA = sum(memberHome == 1 & strcmp(data2.FTR, 'H')) + sum(memberAway == 1 & strcmp(data2.FTR, 'A'));

        memberHome = ismember(data2.HomeTeam, equipoB);  % Obtener cuando juega en casa
        memberAway = ismember(data2.AwayTeam, equipoB);  % Obtener cuando juega fuera

        VictoriasB = sum(memberHome == 1 & strcmp(data2.FTR, 'H')) + sum(memberAway == 1 & strcmp(data2.FTR, 'A'));

        A(i ,:) = [victoriasA VictoriasB 1];
    end
end

coefs = pinv(A) * y;           %   Obtengo los coeficientes del modelo generado

%   USO REAL

y = [];
for i=1:size(x,2)
    teamA = getTeamNameByIndex(x(1, i));
    teamB = getTeamNameByIndex(x(2, i));

    if x(1, i) <= 20 && x(2, i) <= 20       %   Partido de primera división
        v1 = getTeamVictories(data1, teamA);
        v2 = getTeamVictories(data1, teamB);
    elseif x(1, i) > 20 && x(2, i) > 20       %   Partido de primera división
        v1 = getTeamVictories(data2, teamA);
        v2 = getTeamVictories(data2, teamB);
    else       %   No es posible
        disp("No se pueden producir partidos entre primera y segunda división");
    end

    data = [v1 v2 1];
    chances = data * coefs;
    porcentajes = [0; 0; 0];
    if chances < 2
        porcentajes(2) = chances - 1
        porcentajes(1) = 1 - porcentajes(2);
    elseif chances < 3
        porcentajes(2) = chances - 2;
        porcentajes(3) = 1 - porcentajes(2);
    end
    y(:, i) = porcentajes;


end


end


