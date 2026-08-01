# Guía paso a paso: publicar tu blog en GitHub Pages

Tu sitio quedará publicado en **https://aarevalosarce.github.io** (la dirección estándar de GitHub Pages para tu cuenta `aarevalosarce`).

Todo el blog ya está integrado en tu proyecto RStudio `alejandro_arevalo` (esta carpeta).

---

## Paso 0 — Preparar R (solo la primera vez)

Abre RStudio y ejecuta en la consola:

```r
install.packages(c("ggplot2", "dplyr", "scales", "knitr", "rmarkdown", "ragg"))
```

## Paso 1 — Renderizar el sitio

1. Abre `alejandro_arevalo.Rproj` (doble clic)
2. En la pestaña **Build** (panel superior derecho), presiona **Render Website**
   — o escribe `quarto render` en la pestaña Terminal
3. Se creará la carpeta `docs/` con el sitio completo; la vista previa se abre sola

## Paso 2 — Crear el repositorio en GitHub

1. Entra a https://github.com/new con tu cuenta **aarevalosarce**
2. En *Repository name* escribe exactamente: `aarevalosarce.github.io`
3. Déjalo **Public**, sin README ni .gitignore (el proyecto ya los trae)
4. Presiona **Create repository**

## Paso 3 — Subir los archivos

**Con Git en la Terminal de RStudio** (pestaña Terminal, en la carpeta del proyecto):

```bash
git init
git add .
git commit -m "Primera versión del blog"
git branch -M main
git remote add origin https://github.com/aarevalosarce/aarevalosarce.github.io.git
git push -u origin main
```

(GitHub te pedirá iniciar sesión la primera vez.)

**Sin Git**: instala [GitHub Desktop](https://desktop.github.com/), agrega esta carpeta como repositorio local (*Add local repository*), haz commit y *Publish repository* con el nombre `aarevalosarce.github.io`.

## Paso 4 — Activar GitHub Pages

1. En el repositorio, ve a **Settings → Pages** (menú lateral izquierdo)
2. En *Build and deployment* → *Source*: elige **Deploy from a branch**
3. En *Branch*: elige `main`, y en la carpeta elige **`/docs`**
4. Presiona **Save**

En 1 a 3 minutos tu sitio estará en línea en **https://aarevalosarce.github.io**

---

## Ciclo de trabajo permanente

```
Editar .qmd  →  Render Website  →  git add . && git commit && git push
```

GitHub Pages actualiza el sitio automáticamente con cada push (1–2 minutos).

---

## Personalizaciones pendientes

1. **Foto de perfil**: reemplaza `profile.jpg` por una foto tuya (idealmente cuadrada, ≥600×600 px), manteniendo el nombre. Se usa en Inicio y como favicon.
2. **Posts de la plantilla**: `posts/welcome/` y `posts/post-with-code/` están marcados como borrador (no se publican). Puedes borrar esas carpetas.
3. **Paper faltante**: el PDF *"Aproximaciones teóricas para una explicación.pdf"* no está en `files/` (su nombre con tildes dio problemas al copiarlo). Si quieres ofrecerlo para descarga: renómbralo sin tildes (ej. `aproximaciones-teoricas-2023.pdf`), cópialo a `files/` y agrega el enlace en `publicaciones.qmd`.
4. **Dominio propio** (opcional): se configura en *Settings → Pages → Custom domain*.

## Solución de problemas

- **El sitio muestra 404**: verifica que el repositorio se llame exactamente `aarevalosarce.github.io` y que Pages apunte a `main` + `/docs`.
- **El sitio se ve sin estilos**: asegúrate de que exista `docs/.nojekyll` y se haya subido.
- **Los gráficos no aparecen tras editar un post**: ejecuta Render Website antes de hacer push — GitHub solo publica lo que está en `docs/`.
- **Error de paquete al renderizar**: revisa el Paso 0.
