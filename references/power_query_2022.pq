// Ejemplo para 2022. Para otro año, cambia el Item de la hoja y el valor asignado a la columna Año pues la estructura es equivalente.
// La RUTA_AL_ARCHIVO.xlsx es la ruta local al libro de Excel ubicado en data/interim/Cierre de caja 2022-2025.xlsx

let
    Origen = Excel.Workbook(File.Contents("RUTA_AL_ARCHIVO.xlsx"), null, true),
    #"2025_Sheet" = Origen{[Item="2022",Kind="Sheet"]}[Data],
    #"Encabezados promovidos" = Table.PromoteHeaders(#"2025_Sheet", [PromoteAllScalars=true]),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Encabezados promovidos",{{"Column1", Int64.Type}, {"ENERO", type any}, {"ENERO_1", type any}, {"ENERO_2", type any}, {"FEBRERO", type any}, {"FEBRERO_3", type any}, {"FEBRERO_4", type any}, {"MARZO", type any}, {"MARZO_5", type any}, {"MARZO_6", type any}, {"ABRIL", type any}, {"ABRIL_7", type any}, {"ABRIL_8", type any}, {"MAYO", type any}, {"MAYO_9", type any}, {"MAYO_10", type any}, {"JUNIO", type any}, {"JUNIO_11", type any}, {"JUNIO_12", type any}, {"JULIO", type any}, {"JULIO_13", type any}, {"JULIO_14", type any}, {"AGOSTO", type any}, {"AGOSTO_15", type any}, {"AGOSTO_16", type any}, {"SEPTIEMBRE", type any}, {"SEPTIEMBRE_17", type any}, {"SEPTIEMBRE_18", type any}, {"OCTUBRE", type any}, {"OCTUBRE_19", type any}, {"OCTUBRE_20", type any}, {"NOVIEMBRE", type any}, {"NOVIEMBRE_21", type any}, {"NOVIEMBRE_22", type any}, {"DICIEMBRE", type any}, {"DICIEMBRE_23", type any}, {"DICIEMBRE_24", type any}}),
    #"Columnas con nombre cambiado" = Table.RenameColumns(#"Tipo cambiado",{{"ENERO", "ENERO_VISA"}, {"FEBRERO", "FEBRERO_VISA"}, {"MARZO", "MARZO_VISA"}, {"ABRIL", "ABRIL_VISA"}, {"MAYO", "MAYO_VISA"}, {"JUNIO", "JUNIO_VISA"}, {"JULIO", "JULIO_VISA"}, {"AGOSTO", "AGOSTO_VISA"}, {"SEPTIEMBRE", "SEPTIEMBRE_VISA"}, {"OCTUBRE", "OCTUBRE_VISA"}, {"NOVIEMBRE", "NOVIEMBRE_VISA"}, {"DICIEMBRE", "DICIEMBRE_VISA"}, {"ENERO_1", "ENERO_EFEC"}, {"FEBRERO_3", "FEBRERO_EFEC"}, {"MARZO_5", "MARZO_EFEC"}, {"ABRIL_7", "ABRIL_EFEC"}, {"MAYO_9", "MAYO_EFEC"}, {"JUNIO_11", "JUNIO_EFEC"}, {"JULIO_13", "JULIO_EFEC"}, {"AGOSTO_15", "AGOSTO_EFEC"}, {"SEPTIEMBRE_17", "SEPTIEMBRE_EFEC"}, {"OCTUBRE_19", "OCTUBRE_EFEC"}, {"NOVIEMBRE_21", "NOVIEMBRE_EFEC"}, {"DICIEMBRE_23", "DICIEMBRE_EFEC"}, {"ENERO_2", "ENERO_TOT"}, {"FEBRERO_4", "FEBRERO_TOT"}, {"MARZO_6", "MARZO_TOT"}, {"ABRIL_8", "ABRIL_TOT"}, {"MAYO_10", "MAYO_TOT"}, {"JUNIO_12", "JUNIO_TOT"}, {"JULIO_14", "JULIO_TOT"}, {"AGOSTO_16", "AGOSTO_TOT"}, {"SEPTIEMBRE_18", "SEPTIEMBRE_TOT"}, {"OCTUBRE_20", "OCTUBRE_TOT"}, {"NOVIEMBRE_22", "NOVIEMBRE_TOT"}, {"DICIEMBRE_24", "DICIEMBRE_TOT"}, {"Column1", "Día"}}),
    #"Filas superiores quitadas" = Table.Skip(#"Columnas con nombre cambiado",1),
    #"Valor reemplazado" = Table.ReplaceValue(#"Filas superiores quitadas",null,0,Replacer.ReplaceValue,{"Día", "ENERO_VISA", "ENERO_EFEC", "ENERO_TOT", "FEBRERO_VISA", "FEBRERO_EFEC", "FEBRERO_TOT", "MARZO_VISA", "MARZO_EFEC", "MARZO_TOT", "ABRIL_VISA", "ABRIL_EFEC", "ABRIL_TOT", "MAYO_VISA", "MAYO_EFEC", "MAYO_TOT", "JUNIO_VISA", "JUNIO_EFEC", "JUNIO_TOT", "JULIO_VISA", "JULIO_EFEC", "JULIO_TOT", "AGOSTO_VISA", "AGOSTO_EFEC", "AGOSTO_TOT", "SEPTIEMBRE_VISA", "SEPTIEMBRE_EFEC", "SEPTIEMBRE_TOT", "OCTUBRE_VISA", "OCTUBRE_EFEC", "OCTUBRE_TOT", "NOVIEMBRE_VISA", "NOVIEMBRE_EFEC", "NOVIEMBRE_TOT", "DICIEMBRE_VISA", "DICIEMBRE_EFEC", "DICIEMBRE_TOT"}),
    #"Tipo cambiado1" = Table.TransformColumnTypes(#"Valor reemplazado",{{"Día", Int64.Type}}),
    #"Personalizada agregada" = Table.AddColumn(#"Tipo cambiado1", "Año", each 2022),
    #"Otras columnas con anulación de dinamización" = Table.UnpivotOtherColumns(#"Personalizada agregada", {"Año", "Día"}, "Atributo", "Valor"),
    #"Dividir columna por delimitador" = Table.SplitColumn(#"Otras columnas con anulación de dinamización", "Atributo", Splitter.SplitTextByDelimiter("_", QuoteStyle.Csv), {"Atributo.1", "Atributo.2"}),
    #"Tipo cambiado2" = Table.TransformColumnTypes(#"Dividir columna por delimitador",{{"Atributo.1", type text}, {"Atributo.2", type text}}),
    #"Columna dinamizada" = Table.Pivot(#"Tipo cambiado2", List.Distinct(#"Tipo cambiado2"[Atributo.2]), "Atributo.2", "Valor", List.Sum),
    #"Columnas con nombre cambiado1" = Table.RenameColumns(#"Columna dinamizada",{{"Atributo.1", "Mes"}}),
    #"Personalizada agregada1" = Table.AddColumn(#"Columnas con nombre cambiado1", "Personalizado", each if [Mes] = "ENERO" then 1
else if [Mes] = "FEBRERO" then 2
else if [Mes] = "MARZO" then 3
else if [Mes] = "ABRIL" then 4
else if [Mes] = "MAYO" then 5
else if [Mes] = "JUNIO" then 6
else if [Mes] = "JULIO" then 7
else if [Mes] = "AGOSTO" then 8
else if [Mes] = "SEPTIEMBRE" then 9
else if [Mes] = "OCTUBRE" then 10
else if [Mes] = "NOVIEMBRE" then 11
else if [Mes] = "DICIEMBRE" then 12
else null),
    #"Columnas con nombre cambiado2" = Table.RenameColumns(#"Personalizada agregada1",{{"Mes", "Nombre Mes"}, {"Personalizado", "Mes"}}),
    #"Columnas reordenadas" = Table.ReorderColumns(#"Columnas con nombre cambiado2",{"Día", "Mes", "Año", "Nombre Mes", "VISA", "EFEC", "TOT"}),
    #"Personalizada agregada2" = Table.AddColumn(#"Columnas reordenadas", "Fecha", each #date([Año],[Mes],[Día])),
    #"Columnas reordenadas1" = Table.ReorderColumns(#"Personalizada agregada2",{"Día", "Mes", "Año", "Nombre Mes", "Fecha", "VISA", "EFEC", "TOT"}),
    #"Filas filtradas" = Table.SelectRows(#"Columnas reordenadas1", each true),
    #"Errores quitados" = Table.RemoveRowsWithErrors(#"Filas filtradas", {"Fecha"}),
    #"Tipo cambiado3" = Table.TransformColumnTypes(#"Errores quitados",{{"Fecha", type date}}),
    #"Filas ordenadas" = Table.Sort(#"Tipo cambiado3",{{"Mes", Order.Ascending}, {"Día", Order.Ascending}, {"Fecha", Order.Ascending}}),
    #"Columnas reordenadas2" = Table.ReorderColumns(#"Filas ordenadas",{"Fecha", "VISA", "EFEC", "TOT", "Día", "Mes", "Año", "Nombre Mes"}),
    #"Columnas con nombre cambiado3" = Table.TransformColumns(
    #"Columnas reordenadas2",
    {{"Nombre Mes", Text.Proper, type text}}
)
in
    #"Columnas con nombre cambiado3"