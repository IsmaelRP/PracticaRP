
%   Este script es para pruebas y no tener que trabajar con funciones

data = readtable('./SP1.csv');     %   Cargar la base de datos en 'data'

%data(:, 4);        Equipo que juega en casa
%data(:, 5);        Equipo que juega de visitante
%data(:, 8);        Resultado final del partido [H = Gana en casa, A = Gana el visitante, D = Empate]

%   Se puede acceder a las columnas por su nombre con: data.FTR (para el caso de la columna 8)
v = ismember(data.FTR, 'H')



