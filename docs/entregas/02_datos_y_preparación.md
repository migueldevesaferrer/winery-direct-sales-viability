# Entrega 2 - Datos y preparación: 

## 1. Qué datos necesita el producto

### Objetivo funcional

El objetivo de la solución es analizar la evolución histórica del canal de venta directa de una bodega para evaluar si los datos respaldan la potencial decisión de cerrar este canal comercial.

A partir del histórico de facturación diaria se estudiarán tendencias, patrones estacionales y cambios en la actividad que permitan aportar evidencia objetiva al proceso de toma de decisiones.

La solución utilizará el histórico de cierres diarios de caja para analizar el volumen y la evolución de las ventas del canal directo, e identificar sus patrones de comportamiento. Los resultados permitirán evaluar si los datos respaldan la percepción empresarial de pérdida de actividad en este canal y aportar evidencia a la decisión de la bodega. Como no se dispone de la facturación total ni de los datos de otros canales, el análisis no cuantificará el peso relativo de la venta directa dentro del conjunto de la actividad comercial ni determinará por sí solo si debe cerrarse.

### Qué representa una observación

Cada registro del dataset representa la actividad comercial de una fecha de la tienda física de la bodega. Según la operativa de la bodega, las fechas sin ventas registradas corresponden a días en que estuvo cerrada: todos los días de apertura hubo al menos alguna venta. Por tanto, esas fechas no se interpretarán como jornadas abiertas con ventas cero ni como datos perdidos.

### Datos imprescindibles

- Fecha.
- Importe diario cobrado mediante tarjeta.
- Importe diario cobrado en efectivo.
- Facturación total diaria.

### Datos deseables

- Número de operaciones realizadas.
- Ticket medio.
- Productos vendidos por día.
- Calendario laboral y festivos.
- Información sobre eventos o actividades de la bodega.

### Granularidad e histórico

La información se analizará a nivel diario.

Se utilizará el histórico completo disponible entre el 1 de enero de 2022 y el 31 de diciembre de 2025.

---

## 2. Fuentes reales y viabilidad

| Fuente | Tipo | Acceso | Cobertura | Actualización | Estabilidad | Alternativa |
|----------|----------|----------|----------|----------|----------|----------|
| Histórico de cierres de caja de la bodega | Datos propios | Archivo Excel proporcionado por la bodega | Del 01/01/2022 al 31/12/2025 | Dataset histórico estático | Alta | Extracción directa desde TPV si estuviera disponible |
| Calendario laboral y festivos de la localidad | Open Data | CSV propio elaborado a partir de calendarios oficiales | Del 01/01/2022 al 31/12/2025 | Dataset histórico estático | Muy alta |  |

### Viabilidad

La fuente principal consiste en los registros históricos de cierre de caja de la tienda física de la bodega.

Los datos están disponibles en formato Excel e incluyen los importes diarios cobrados mediante tarjeta, efectivo y la facturación total del día.

La cobertura abarca la totalidad del periodo comprendido entre el 1 de enero de 2022 y el 31 de diciembre de 2025. Se trata de un conjunto histórico cerrado que no requiere actualizaciones periódicas.

Aunque no se dispone de información detallada sobre productos, tickets o clientes, la información disponible permite analizar la evolución temporal y los patrones estacionales de las ventas del canal directo, y aportar evidencia para que la bodega evalúe su posible cierre. El análisis se limita a la actividad facturada de este canal y no permite medir su rentabilidad ni su peso relativo frente al resto del negocio.

Como fuente complementaria se utilizará un calendario de festivos nacionales, autonómicos y locales. Dado que no se ha identificado una API pública estable para este propósito, se construirá un fichero CSV reproducible a partir de calendarios oficiales publicados para cada año. El calendario real se conserva localmente y no se incluye en el repositorio, ya que puede revelar la localidad de la bodega. Las marcas de festivo del Gold sintético son ficticias y no representan un calendario oficial.

Como alternativa al Excel consolidado podría explorarse una extracción directa desde el TPV si el sistema lo permite. Sin embargo, actualmente la bodega no dispone de una integración automatizada. Por este motivo, el Excel consolidado constituye la única fuente operativa disponible.

---

## 3. Uso, privacidad y datos personales

### Licencia y uso

Los datos proceden de registros internos de la bodega y se utilizarán exclusivamente con fines académicos dentro del proyecto del máster.

El acceso a los datos estará restringido a los miembros del proyecto y no se publicará información comercial sensible.

### Datos personales

Aunque el conjunto de datos no contiene información personal, sí incorpora información económica interna de carácter sensible. Por motivos de confidencialidad y protección de intereses comerciales, la identidad de la bodega no se hará pública.

---

## 4. Del dato bruto al dato utilizable

### Arquitectura Bronze → Silver → Gold

Para mostrar el flujo sin compartir información comercial confidencial, el repositorio incluye ejemplos sintéticos en `data/sample/`. Mantienen la estructura de los archivos originales, pero sus fechas de apertura e importes son ficticios y no representan la actividad real de la bodega. Los ficheros originales y los resultados reales se conservan localmente y no se versionan.

### Bronze / Raw

El dato original es un libro Excel que incluye cuatro hojas independientes correspondientes a los años 2022, 2023, 2024 y 2025. Cada hoja muestra las ventas diarias por tarjeta, en efectivo y el total de ese año. Este archivo presenta una estructura orientada a consulta manual, con los meses distribuidos en columnas y los días en filas. 

**Ejemplo:**

```text
data/sample/raw/
└── RESUMEN CAJA_sintetico.xlsx
```

### Silver

Las transformaciones descritas en esta capa se han implementado mediante Power Query dentro de Power BI Desktop, permitiendo un proceso reproducible de limpieza, normalización y validación de los datos.

El informe PBIX de trabajo se conserva localmente y no se incluye en el repositorio, ya que contiene datos reales de ventas.

**Transformaciones aplicadas:**

- Importación de las cuatro hojas correspondientes a los años 2022, 2023, 2024 y 2025.
- Eliminación de elementos auxiliares del Excel original que no forman parte de los datos analíticos.
- Estandarización de la estructura de las hojas anuales para garantizar un formato homogéneo.
- Transformación de la estructura matricial original (meses en columnas y días en filas) a formato tabular.
- Separación de la información temporal y del tipo de venta (tarjeta, efectivo y total).
- Conversión de los nombres de los meses a formato numérico.
- Generación de una columna de fecha a partir de los campos año, mes y día.
- Eliminación automática de fechas inválidas derivadas de la estructura original del fichero (por ejemplo, 31 de abril o 30 de febrero).
- Unificación de los cuatro años en un único dataset.
- Conversión de tipos de datos:
  - Fecha → Fecha
  - Tarjeta → Moneda
  - Efectivo → Moneda
  - Total → Moneda
- Validación de consistencia para verificar que Tarjeta + Efectivo = Total.

Las variables resultantes son: Fecha, Tarjeta, Efectivo, Total, Día, Mes, Año y Nombre Mes.

**Ejemplo:**

```text
data/sample/interim/
└── Ventas Silver_sintetico.xlsx
```

### Gold

En esta fase el objetivo es enriquecer el dataset Silver mediante variables temporales y de calendario que permitan realizar análisis exploratorio y futuros modelos de predicción sobre la evolución del canal de venta directa.

Partiendo del dataset Silver, se realizaron las siguientes transformaciones:

- Creación de una tabla de festivos para el periodo 2022-2025 a partir de calendarios oficiales.
- Integración de la tabla de festivos mediante la columna fecha.
- Generación de las variables binarias es_festivo y es_fin_de_semana.
- Generación de las variables temporales dia_semana, numero_dia_semana, anio_mes.

En los ficheros Gold de muestra, las marcas de festivo son ficticias; no deben utilizarse como calendario real.

Por motivos de confidencialidad, únicamente se conserva la información necesaria para el análisis y no se almacena el nombre específico de cada festividad.

#### Variables principales

| Columna | Descripción |
|----------|----------|
| fecha | Fecha completa |
| tarjeta | Ventas mediante tarjeta |
| efectivo | Ventas en efectivo |
| total | Facturación total diaria |
| dia | Día del mes |
| mes | Número de mes |
| año | Año |
| dia_semana | Día de la semana |
| numero_dia_semana | Número del día de la semana (1-7) |
| nombre_mes | Nombre del mes |
| año_mes | Agrupación temporal YYYY-MM |
| es_festivo | Indicador binario de festivo |
| es_fin_de_semana | Indicador binario de fin de semana |

#### Uso previsto

Este dataset se utilizará para:

- Analizar la evolución histórica del canal de venta directa.
- Identificar tendencias de crecimiento o decrecimiento.
- Detectar patrones estacionales.
- Estudiar el efecto de festivos y fines de semana sobre las ventas.
- Comparar la evolución entre años.
- Detectar anomalías o comportamientos atípicos.
- Generar indicadores que permitan respaldar o cuestionar la decisión empresarial de cierre.
- Realizar estimaciones de ventas futuras como apoyo a la toma de decisiones.

#### Flujo resumido

**Ejemplo:**

```text
data/sample/processed/
└── ventas_gold_sintetico.csv
```
---

## 5. Riesgos y limitaciones

La principal limitación del proyecto es que los datos disponibles corresponden únicamente a cierres diarios agregados y no incluyen información sobre productos vendidos, número de operaciones o clientes.

Esta limitación impide realizar análisis más detallados sobre comportamiento de compra, ticket medio o rentabilidad por producto.

Además, no se dispone de información sobre costes ni sobre la facturación de otros canales. Por ello, este análisis no calculará la rentabilidad global de la venta directa ni su contribución porcentual a la actividad total de la bodega; esos aspectos quedan fuera del alcance de los datos y del análisis de esta entrega.

También puede existir sesgo derivado de factores externos no registrados en la base de datos, como campañas comerciales, cambios operativos, eventos especiales o circunstancias económicas.

Otra limitación relevante es la disponibilidad de únicamente cuatro años de histórico (2022-2025). Este conjunto de datos fue consolidado manualmente dentro de la organización y actualmente no existe un proceso equivalente que permita ampliar fácilmente el histórico disponible.

Asimismo, se desconoce si el TPV utilizado permite exportaciones históricas más detalladas o si existe un sistema ERP que centralice esta información, lo que limita las posibilidades de enriquecimiento futuro del dataset.

Si la fuente principal dejara de estar disponible, sería necesario reconstruir el histórico a partir de nuevas exportaciones del TPV, siempre que el sistema permitiera dicho acceso.

---