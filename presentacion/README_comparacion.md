# Comparación de herramientas para la presentación

Tres mini-demos con **el mismo contenido** (6 slides: portada, roadmap, background,
Contribución 1, Contribución 2, cierre) para decidir con qué herramienta seguimos.

## Cómo ver / compilar cada una

| Herramienta | Carpeta | Comando / uso | Salida |
|---|---|---|---|
| **Beamer + metropolis** | `beamer-metropolis/` | `xelatex demo.tex` (2 veces, para el nº de slide) | `demo.pdf` |
| **Typst + Touying** | `typst-touying/` | `typst compile --root .. demo.typ` | `demo.pdf` |
| **reveal.js** | `revealjs/` | abrir `demo.html` en el navegador | web/HTML |

> Las tres ya están compiladas: puedes abrir directamente los `demo.pdf` y el `demo.html`.
> Las figuras en PNG (para Typst y reveal.js) están en `assets/`.

## Qué evaluar en cada una

### A. Beamer + metropolis  (LaTeX, lo que ya conoces)
- ✅ Cero curva de aprendizaje; misma sintaxis LaTeX de tu tesis.
- ✅ Matemática impecable; usa tus figuras `.pdf` directamente (sin convertir).
- ✅ Tema limpio y moderno (adiós a las cajas azules noventeras).
- ⚠️ Compilación lenta; sintaxis verbosa.

### B. Typst + Touying  (el "LaTeX moderno")
- ✅ **Compila en milisegundos** — se agradece muchísimo al iterar 40 slides.
- ✅ Sintaxis mucho más limpia y legible que LaTeX.
- ✅ Matemática excelente; temas modernos incluidos.
- ⚠️ Herramienta nueva que aprender; ecosistema más chico que LaTeX.
- ⚠️ Figuras: mejor en PNG/SVG (por eso convertimos a `assets/`).

### C. reveal.js  (HTML/web, lo más visual para el público)
- ✅ Lo más vistoso: transiciones, fragmentos, se abre en cualquier navegador/proyector.
- ✅ Ideal si algún día quieres **compartir la charla como link web**.
- ✅ Matemática vía MathJax; permite animaciones e interactividad.
- ⚠️ Se edita en HTML/CSS (no LaTeX); para máximo pulido conviene Quarto/Slidev encima.
- ⚠️ Depende de CDN (internet) salvo que descargues reveal.js localmente.

## Recomendación rápida

- **Defensa ya, sin riesgo:** Beamer + metropolis.
- **Estrenar algo moderno y ágil, seguir escribiendo en texto:** Typst + Touying.
- **Charlas futuras muy visuales / divulgación / web:** reveal.js (o Quarto).

## Notas
- El `.claude/launch.json` de la raíz sirve solo para previsualizar el reveal.js con un
  servidor local (`python3 -m http.server 8123`). Puedes borrarlo si no lo necesitas.
- Para reveal.js sin internet: descargar `reveal.js` y servir localmente, o usar Quarto.
