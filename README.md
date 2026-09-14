# Evaluación de factores ambientales asociados a la distribución geográfica del aguará guazú (*Chrysocyon brachyurus*) en la provincia de Santa Fe

Este repositorio reúne los scripts de procesamiento, análisis espacial y modelado empleados en la Tesis de Grado titulada:

> **"Evaluación de factores ambientales asociados a la distribución geográfica del aguará guazú (*Chrysocyon brachyurus*) en la provincia de Santa Fe"**

Asimismo, incluye el código utilizado para la publicación derivada:

- **Publicación:** *Spatial distribution of environmental suitability for the maned wolf in central Argentina*\
- **DOI:** [10.1007/s42991-024-00407-5](https://doi.org/10.1007/s42991-024-00407-5)

------------------------------------------------------------------------

## 📁 Estructura del Repositorio

El repositorio se organiza en los siguientes módulos principales según las etapas del flujo de trabajo:  
├── Generales/  
├── Variables_Ambientales/  
├── Estadisticas/  
├── Filtrados/  
└── Maxent/  

### 1. `Generales/`

Scripts de procesamiento general, preparación de insumos raster y análisis complementarios:

- **Flujos iniciales:** Código correspondiente a las primeras etapas de exploración y desarrollo de la tesina.

- **Procesamiento raster:** Sincronización espacial, reproyección plana y conversión de formatos (`HDF` $\rightarrow$ `TIF` y `TIF` $\rightarrow$ `ASCII`).

- **Análisis complementarios:** Scripts aplicados al seguimiento y trabajo con liberaciones de individuos de aguará guazú.

### 2. `Variables_Ambientales/`

Procesamiento y generación de covariables ambientales utilizadas tanto en la tesina como en el artículo científico:

- **Cálculo de métricas:** Generación de capas de distancia euclidiana y proporciones de cobertura.

- **Tratamiento de imágenes MODIS:** Conversión, filtrado y transformación de productos crudos MODIS hacia las covariables finales.

### 3. `Estadisticas/`

Contiene los análisis exploratorios, pruebas de señal filogenética/espacial y selección de covariables:

- **Análisis exploratorios:** Visualizaciones iniciales (histogramas) y Análisis de Componentes Principales (PCA).

- **Prueba K:** Script para el cálculo de la prueba **K de Ripley**, para analizar el **patrón espacial de puntos**..

- **Correlación y multicolinealidad:** Evaluación de correlaciones de Pearson y Factor de Inflación de la Varianza (VIF) para la selección de variables ambientales (actualizados para el manuscrito de 2023).

- **Métricas de evaluación (Índice de Boyce):**

  - Script tutorial de implementación.

  - Evaluación de las dos opciones de modelos planteados en la tesina.

  - Evaluación de las dos alternativas de modelos utilizadas en la publicación.

### 4. `Filtrados/`

Scripts dedicados al tratamiento de los registros de presencia:

- **Filtrado espacial:** Algoritmos para mitigar el sesgo muestral y la autocorrelación espacial de las presencias.

- **Reproyección:** Transformación a un sistema de coordenadas proyectadas (planas) para cada set de datos filtrado.

### 5. `Maxent/`

Modelado de Distribución de Especies (SDM) para la estimación de la idoneidad ambiental del aguará guazú (*Chrysocyon brachyurus*):

- **Tutoriales:** Guía de ejecución del algoritmo Maxent.

- **Modelos de Tesina:** Scripts de configuración y corrida para las dos alternativas de modelo de la tesina de grado.

- **Modelos de Publicación:** Scripts de corrida ajustados para las dos alternativas finales publicadas en el paper.

## 🛠️ Requisitos e Instalación

Para ejecutar estos scripts se requiere contar con **R** (versión recomendada $\ge$ 4.0.0) y los siguientes paquetes principales:

- **Geoprocesamiento y Raster:** `terra`, `raster`, `sf`, `sp`

- **Modelado y Evaluación:** `dismo`, `ecospat` (para el Índice de Boyce)

- **Estadística y Exploratorios:** `usdm` (para VIF), `spatstat` (para K de Ripley), `ggplot2`

## ✉️ Contacto y Citas

Si utilizas o te basas en el código de este repositorio, por favor cita la publicación correspondiente:

> Ulibarrie, A. A., et al. (2024). *Spatial distribution of environmental suitability for the maned wolf in central Argentina*. Mammalian Biology. DOI: [10.1007/s42991-024-00407-5](https://doi.org/10.1007/s42991-024-00407-5).
