function f = getTeamFoulsCommited(database, team)

    memberHome = ismember(database.HomeTeam, team);       % Obtener cuando juega en casa
    memberAway = ismember(database.AwayTeam, team);       % Obtener cuando juega fuera

    f = sum(database.HF(memberHome)) + sum(database.AF(memberAway));
end

