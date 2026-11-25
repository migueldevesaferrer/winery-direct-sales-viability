# Winery Direct Sales Viability

Proyecto académico de análisis y previsión de la venta directa diaria de una bodega.
El objetivo de modelado es estimar la facturación de los días previstos de apertura
para apoyar la planificación comercial. Sin información de costes, márgenes u otros
canales, las predicciones no permiten determinar por sí solas la rentabilidad ni
decidir el cierre del canal.

## Datos y confidencialidad

El histórico real cubre 2022–2025 y se prepara siguiendo las capas Bronze, Silver y
Gold. Los datos comerciales reales, el informe Power BI y los resultados sensibles
se mantienen privados. Los índices, gráficos y métricas calculados a partir de datos
reales también pueden revelar información comercial.

El repositorio incluye una [muestra sintética](data/sample/README.md) con la misma
estructura, pero con ventas, aperturas y festivos ficticios:

- `data/sample/raw/RESUMEN CAJA_sintetico.xlsx`: ejemplo Bronze.
- `data/sample/interim/Ventas Silver_sintetico.xlsx`: ejemplo Silver.
- `data/sample/processed/ventas_gold_sintetico.csv`: ejemplo Gold.

La muestra sirve para ilustrar el formato; sus resultados no describen la bodega.
El detalle de la preparación está en [Datos y preparación](docs/entregas/02_datos_y_preparación.md).

## Preparación del entorno

El proyecto utiliza `uv` y Python 3.13.14:

```powershell
uv sync
uv run jupyter lab
```

Los notebooks de modelado requieren el Gold real local
`data/processed/ventas_gold.csv`; no se distribuye con el repositorio. El notebook
de EDA también permite usar la muestra sintética configurando `EDA_DATASET` antes de
iniciar Jupyter desde la raíz:

```powershell
$env:EDA_DATASET = "data\sample\processed\ventas_gold_sintetico.csv"
uv run jupyter lab
```

La variable de entorno anterior afecta al EDA, no a los notebooks de modelado.

## Exploración realizada

Los notebooks están ordenados por fase:

1. [EDA](notebooks/01_eda.ipynb): calidad, actividad, evolución y estacionalidad.
2. [Baselines](notebooks/02_pruebas_baseline.ipynb): mediana por día semanal y otras referencias.
3. [SARIMAX](notebooks/03_pruebas_SARIMAX.ipynb): configuraciones, interacción y ventanas.
4. [Prophet](notebooks/04_pruebas_Prophet.ipynb): configuraciones, ventanas y horizontes.
5. [LightGBM](notebooks/05_pruebas_LightGBM.ipynb): configuraciones, ventanas y horizontes.
6. [Comparación por día y mes](notebooks/06_comparacion_dias_y_mes.ipynb): errores de las configuraciones ya probadas.

El objetivo es el índice de facturación diaria, con base 100 en la venta media de
los días abiertos de 2022. Los cierres no se consideran ventas cero al entrenar o
evaluar. Se utilizan cortes temporales en 2023–2024 y una comparación retrospectiva
del año 2025, entrenando hasta 2024; se evalúan los días que realmente abrieron.
Como 2025 ya se exploró, esa comparación no es completamente ciega.

Las métricas incluyen WAPE, MAPE y sesgo. Los intervalos son orientativos y no
garantizan cobertura futura. La comparación por día y mes describe lo ocurrido en
2025, pero no demuestra que elegir un modelo distinto para cada grupo mejore el
resultado futuro.

## Flujo MLOps planificado

MLflow y los siguientes pasos **aún no están implementados**:

- Crear un snapshot privado del Gold, identificado mediante un hash y un catálogo.
- Construir las variables y ejecutar los experimentos con cortes temporales.
- Registrar parámetros, métricas y referencia al snapshot en los runs de MLflow.
- Evaluar y registrar en Model Registry las versiones seleccionadas como
  `champion` y `challenger`; la mediana semanal y SARIMAX inicial son candidatos
  provisionales.
- Reentrenar las versiones seleccionadas con el histórico disponible hasta 2025 y
  generar una demostración de previsión para días previstos de apertura.

Los resultados de 2025 corresponden a modelos entrenados hasta 2024; no son una
evaluación independiente de las versiones reentrenadas. El calendario de apertura
futuro debe conocerse o indicarse como hipótesis. Los snapshots, artefactos y
resultados reales deberán almacenarse de forma privada.

## Organización

```text
data/sample/                     Datos sintéticos de las tres capas
docs/entregas/                   Documentación académica
notebooks/                       EDA, experimentos y comparación de modelos
references/                      Consultas Power Query de preparación
tests/                           Pruebas existentes
winery_direct_sales_viability/   Código fuente y plantillas de modelado
pyproject.toml y uv.lock         Dependencias y entorno reproducible
```
