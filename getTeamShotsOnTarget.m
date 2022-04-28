function s = getTeamShotsOnTarget(database, team)

    memberHome = ismember(database.HomeTeam, team);       % Obtener cuando juega en casa
    memberAway = ismember(database.AwayTeam, team);       % Obtener cuando juega fuera

    s = sum(database.HST(memberHome)) + sum(database.AST(memberAway));

end

