function v = getTeamVictories(database, team)

    memberHome = ismember(database.HomeTeam, team);       % Obtener cuando juega en casa
    memberAway = ismember(database.AwayTeam, team);       % Obtener cuando juega fuera

    v = sum(memberHome == 1 & strcmp(database.FTR, 'H')) + sum(memberAway == 1 & strcmp(database.FTR, 'A'));

end

