%La matriz x recibe una matriz 2xN siendo la primera fila los equipos en
%casa y la segunda los visitantes.
function yEstim = erroresClasificacion(x)


%   Equipos de 1º y 2º división según sus índices
equipos = ["Alaves" "Ath Bilbao" "Ath Madrid" "Barcelona" "Betis" "Cadiz" "Celta" "Elche" "Espanol" "Getafe" "Granada" "Levante" "Mallorca" "Osasuna" "Real Madrid" "Sevilla" "Sociedad" "Vallecano" "Villarreal" "Alcorcon" "Almeria" "Amorebieta" "Burgos" "Cartagena" "Eibar" "Fuenlabrada" "Girona" "Huesca" "Ibiza" "Las Palmas" "Leganes" "Lugo" "Malaga" "Mirandes" "Oviedo" "Ponferradina" "Sociedad B" "Sp Gijon" "Tenerife" "Valladolid" "Zaragoza"];

%   Para simular el input
x = [1 13 6 19 4 12 17 9 21 29 27 32 23 33 11; 14 3 15 2 20 5 8 16 35 25 31 22 28 26 7];

data1 = readtable('./SP1.csv');     %   Cargar la primera división
data2 = readtable('./SP2.csv');     %   Cargar la segunda división

nPartidos = height(data1) + height(data2);
%   Variables a tener en cuenta:
%               NOTA, NO SE HAN AÑADIDO ESTADÍSTICAS
%               ADICIONALES DE OTRAS WEBS COMO BET365, QUE SE PUEDEN AÑADIR
%   VictoriasA, victoriasB, tirosapuertaA, tirosapuertaB, faltasA, faltasB
nVariables = 6;     %   Nº de características o patrones que vamos a tener en cuenta
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

        A(i,:) = [victoriasA victoriasB tirospuertaA tirospuertaB faltasA faltasB];

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

        A(i,:) = [victoriasA victoriasB tirospuertaA tirospuertaB faltasA faltasB];

    end
end

%coefs = pinv(A) * y;           %   Obtengo los coeficientes del modelo generado


A = A';
y = y';

%A partir de aquí empieza la clasificación



%   USO REAL


erroresK = [];
erroresKporent = [];

[pruebasX, pruebasY] = getDatosPrueba();
x = pruebasX;
for K=1:size(x,2)
    disp("iter: " + K);
yEstim = [];
nErrores = 0;
porcent = 0;
    for i=1:size(x,2)
        teamA = getTeamNameByIndex(x(1, i));
        teamB = getTeamNameByIndex(x(2, i));
    
        if x(1, i) <= 20 && x(2, i) <= 20       %   Partido de primera división
            v1 = getTeamVictories(data1, teamA);
            v2 = getTeamVictories(data1, teamB);
            s1 = getTeamShotsOnTarget(data1, teamA);
            s2 = getTeamShotsOnTarget(data1, teamB);
            f1 = getTeamFoulsCommited(data1, teamA);
            f2 = getTeamFoulsCommited(data1, teamB);
        elseif x(1, i) > 20 && x(2, i) > 20       %   Partido de primera división
            v1 = getTeamVictories(data2, teamA);
            v2 = getTeamVictories(data2, teamB);
            s1 = getTeamShotsOnTarget(data2, teamA);
            s2 = getTeamShotsOnTarget(data2, teamB);
            f1 = getTeamFoulsCommited(data2, teamA);
            f2 = getTeamFoulsCommited(data2, teamB);
        else       %   No es posible
            disp("No se pueden producir partidos entre primera y segunda división");
        end
    
        %K = 10;%Número de vecinos cercanos
        dato = [v1 v2 s1 s2 f1 f2]';
    
          d               = d_euclid(A,dato);%distancias de todos los xTrn al dato
          [~,pos]         = sort(d); %Ordenados por distancia
          clases_cercanas = y(pos(2:K));%No se cuenta a si mismo
          yEstim(i) = mode(clases_cercanas);

          %porcentajes = [];
          %porcentajes(1,1) = length(find(clases_cercanas == 1));
          %porcentajes(2,1) = length(find(clases_cercanas == 2));
          %porcentajes(3,1) = length(find(clases_cercanas == 3));
    
          %porcentajes = porcentajes./length(clases_cercanas);
    
        %yEstim(:, i) = porcentajes;

    end


    result = [pruebasY; yEstim];

    nErrores = length(find(pruebasY ~= yEstim));%
    porcent = nErrores / length(yEstim);%
    
    erroresK = [erroresK, nErrores];
    erroresKporent = [erroresKporent, porcent];
end
erroresK
erroresKporent
save('./archivosPruebas/ErroresClasifV1_sin_contarse_a_si_mismo.mat', 'erroresK', 'erroresKporent')
plot(erroresK,'b'); hold on;


end


