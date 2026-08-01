# Blog profesional — Alejandro Arévalo Sarce

Sitio web personal construido con [Quarto](https://quarto.org) y [R](https://www.r-project.org) en RStudio, publicado con GitHub Pages en **https://aarevalosarce.github.io**.

## Estructura

```
├── alejandro_arevalo.Rproj   # Proyecto RStudio (abrir con doble clic)
├── _quarto.yml               # Configuración del sitio (navegación, tema)
├── index.qmd                 # Inicio / Sobre mí
├── analisis.qmd              # Listado de posts del blog de análisis
├── posts/                    # Un subdirectorio por post
│   ├── _metadata.yml         #   opciones comunes de los posts
│   └── 2026-07-31-poblacion-penal/
├── publicaciones.qmd         # Libros, artículos e investigaciones
├── presentaciones.qmd        # Ponencias y presentaciones
├── cv.qmd                    # Curriculum vitae
├── files/                    # PDFs descargables (CV, papers, presentaciones)
├── profile.jpg               # Foto de perfil (reemplazar por foto real)
├── theme.scss                # Tema visual (académico sobrio)
└── docs/                     # ← Sitio renderizado (lo que publica GitHub Pages)
```

## Flujo de trabajo en RStudio

1. Abrir `alejandro_arevalo.Rproj`
2. Editar o crear contenido (`.qmd`)
3. En la pestaña **Build**, presionar **Render Website** (o ejecutar `quarto render` en la Terminal)
4. Hacer commit y push a GitHub: Pages publica automáticamente la carpeta `docs/`

## Cómo agregar un nuevo post

1. Crear una carpeta `posts/AAAA-MM-DD-nombre-corto/`
2. Dentro, crear un `index.qmd` con encabezado YAML (título, descripción, fecha, categorías) y el contenido con bloques de código R
3. Render Website → commit → push

Los posts de la plantilla (`posts/welcome/` y `posts/post-with-code/`) están marcados como borrador y no se publican; se pueden eliminar.

## Paquetes R necesarios

```r
install.packages(c("ggplot2", "dplyr", "scales", "knitr", "rmarkdown", "ragg"))
```

Ver la guía completa de publicación en **GUIA_PUBLICACION.md**.
