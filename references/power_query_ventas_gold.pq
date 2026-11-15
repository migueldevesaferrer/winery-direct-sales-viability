let
    Origen = Table.Combine({#"2022", #"2023", #"2024", #"2025"}),
    #"Tipo cambiado con configuración regional" = Table.TransformColumnTypes(Origen, {{"VISA", type number}}, "es-ES"),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Tipo cambiado con configuración regional",{{"VISA", Currency.Type}, {"EFEC", Currency.Type}, {"TOT", Currency.Type}, {"Día", Int64.Type}, {"Mes", Int64.Type}, {"Año", Int64.Type}}),
    #"Columnas con nombre cambiado" = Table.RenameColumns(#"Tipo cambiado",{{"VISA", "Tarjeta"}, {"EFEC", "Efectivo"}, {"TOT", "Total"}}),
    #"Consultas combinadas" = Table.NestedJoin(#"Columnas con nombre cambiado", {"Fecha"}, #"Calendario Festivos", {"Fecha"}, "Calendario Festivos", JoinKind.LeftOuter),
    #"Se expandió Calendario Festivos" = Table.ExpandTableColumn(#"Consultas combinadas", "Calendario Festivos", {"Festividad"}, {"Calendario Festivos.Festividad"}),
    #"Personalizada agregada" = Table.AddColumn(#"Se expandió Calendario Festivos", "Es Festivo", each if [Calendario Festivos.Festividad] = null then 0 else 1),
    #"Columnas con nombre cambiado1" = Table.RenameColumns(#"Personalizada agregada",{{"Calendario Festivos.Festividad", "Festividad"}}),
    #"Personalizada agregada1" = Table.AddColumn(#"Columnas con nombre cambiado1", "Dia Semana", each Date.DayOfWeekName([Fecha], "es-ES")),
    #"Personalizada agregada2" = Table.AddColumn(#"Personalizada agregada1", "Es Fin De Semana", each if Date.DayOfWeek([Fecha], Day.Monday) >= 5
then 1
else 0),
    #"Personalizada agregada3" = Table.AddColumn(#"Personalizada agregada2", "Año Mes", each Date.ToText([Fecha], "yyyy-MM")),
    #"Personalizada agregada4" = Table.AddColumn(#"Personalizada agregada3", "Número Dia Semana", each Date.DayOfWeek([Fecha], Day.Monday)+1),
    #"Filas ordenadas" = Table.Sort(#"Personalizada agregada4",{{"Fecha", Order.Ascending}}),
    #"Tipo cambiado1" = Table.TransformColumnTypes(#"Filas ordenadas",{{"Es Festivo", Int64.Type}, {"Dia Semana", type text}, {"Es Fin De Semana", Int64.Type}, {"Año Mes", type date}, {"Número Dia Semana", Int64.Type}}),
    #"Personalizada agregada5" = Table.AddColumn(#"Tipo cambiado1", "Validar Diferencia", each if Number.Abs([Tarjeta] + [Efectivo] - [Total]) < 0.01
then "OK"
else "ERROR"),
    #"Filas filtradas" = Table.SelectRows(#"Personalizada agregada5", each true)
in
    #"Filas filtradas"