clear;
clc;

%   Este script es para pruebas y no tener que trabajar con funciones

data = readtable('./SP1.csv');     %   Cargar la base de datos en 'data'

%data(:, 4);        Equipo que juega en casa
%data(:, 5);        Equipo que juega de visitante
%data(:, 8);        Resultado final del partido [H = Gana en casa, A = Gana el visitante, D = Empate]

%   Se puede acceder a las columnas por su nombre con: data.FTR (para el caso de la columna 8)
v = ismember(data.FTR, 'H')
i = find(v)

memberCadizHome = ismember(data.HomeTeam, "Barcelona");%Obtener si cadiz juega en casa
memberCadizAway = ismember(data.AwayTeam, 'Barcelona');%Obtener si cadiz juega fuera
memberCadiz = memberCadizAway + memberCadizHome;%Obtener si juega cadiz

partidosCadizIdx = find(memberCadiz);%Obtener los indices de los partidos en los que juega cadiz

partidosCadiz = data(partidosCadizIdx,4:5)%Obtener la lista de partidos en los que juega cadiz

totalPartidosCadiz = height(partidosCadiz)

victoriasCasaCadiz = sum(memberCadizHome == 1 & strcmp(data.FTR, 'H'))
victoriasVisitanteCadiz = sum(memberCadizAway == 1 & strcmp(data.FTR, 'A'))
victoriasCadiz = victoriasCasaCadiz + victoriasVisitanteCadiz;

derrotasCasaCadiz = sum(memberCadizHome == 1 & strcmp(data.FTR, 'A'))
derrotasVisitanteCadiz = sum(memberCadizAway == 1 & strcmp(data.FTR, 'H'))
derrotasCadiz = derrotasCasaCadiz + derrotasVisitanteCadiz;

empatesCadiz = sum(memberCadiz == 1 & strcmp(data.FTR, 'D'))


