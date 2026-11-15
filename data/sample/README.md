# Muestra sintética de datos

Estos ficheros son ejemplos ficticios para enseñar la estructura Bronze → Silver → Gold sin compartir datos comerciales de la bodega. Los importes, días de apertura y marcas de festivo son sintéticos; no describen la actividad real ni un calendario oficial de la localidad.

## Ficheros

- `raw/RESUMEN CAJA_sintetico.xlsx`: hojas anuales 2022-2025 con meses en columnas y VISA, EFEC y TOT por día, además de una hoja `PLANTILLA`.
- `interim/Ventas Silver_sintetico.xlsx`: una fila por fecha entre 2022 y 2025 con las ocho columnas Silver.
- `processed/ventas_gold_sintetico.csv`: las mismas fechas y ventas, enriquecidas con las variables temporales y de calendario Gold.

Los días sintéticos de cierre tienen importes iguales a cero. Cada día sintético de apertura tiene ventas positivas y `total` es igual a `tarjeta + efectivo`.
