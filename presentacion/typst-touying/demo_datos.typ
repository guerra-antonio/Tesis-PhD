//============================================================
// DEMO — El lado "programable" de Typst
// Compilar:  typst compile --root .. demo_datos.typ
// (o  typst watch --root .. demo_datos.typ  para verlo en vivo)
//
// Muestra 3 cosas que en Beamer son dolorosas:
//   1) Generar una tabla leyendo un CSV (con formato condicional)
//   2) Calcular estadísticas del CSV EN VIVO dentro del documento
//   3) Generar varias slides con un bucle for
//============================================================
#import "@preview/touying:0.6.1": *
#import themes.metropolis: *

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [El lado programable de Typst],
    subtitle: [Datos → tabla → slides, automáticamente],
    author: [Antonio Guerra],
    date: datetime.today(),
    institution: [Universidad de Concepción],
  ),
)

#let udec = rgb(0, 70, 140)

// ---- Cargar los datos una sola vez ----
#let raw = csv("data/resultados_timing.csv")
#let filas = raw.slice(1)                       // descartar la cabecera
#let speeds = filas.map(f => float(f.at(2)))    // columna de speedup como números

#title-slide()

// ============================================================
// (1) TABLA GENERADA DESDE EL CSV, con formato condicional
// ============================================================
== Tabla generada desde un CSV

Los números salen del archivo `data/resultados_timing.csv`.
Si edito el CSV, la tabla se actualiza sola. Verde = speedup $>= 10times$.

#align(center)[
  #table(
    columns: 4,
    align: (center, center, center, center),
    stroke: 0.5pt + gray,
    fill: (_, row) => if row == 0 { udec.lighten(75%) },
    table.header(
      [*Qubits*], [*Método*], [*Speedup*], [*Fidelidad*],
    ),
    ..filas.map(f => {
      let s = float(f.at(2))
      (
        [#f.at(0)],
        [#f.at(1)],
        text(fill: if s >= 10 { rgb(0, 140, 0) } else { rgb(200, 100, 0) }, weight: "bold")[#s#sym.times],
        [#f.at(3)],
      )
    }).flatten()
  )
]

// ============================================================
// (2) ESTADÍSTICAS CALCULADAS EN VIVO desde el CSV
// ============================================================
== Estadísticas calculadas en vivo

Typst hace los cálculos dentro del documento (nada escrito a mano):

#let n = filas.len()
#let maxs = calc.max(..speeds)
#let mins = calc.min(..speeds)
#let prom = speeds.sum() / n

#grid(
  columns: 3,
  gutter: 1.5em,
  ..(
    ("Casos medidos", str(n)),
    ("Speedup máximo", str(calc.round(maxs, digits: 1)) + "×"),
    ("Speedup promedio", str(calc.round(prom, digits: 1)) + "×"),
  ).map(par => block(
    fill: udec.lighten(88%), inset: 14pt, radius: 6pt, width: 100%,
  )[
    #text(size: 1.6em, fill: udec, weight: "bold")[#par.at(1)] \
    #text(size: 0.8em)[#par.at(0)]
  ])
)

#v(1em)
El mejor caso es *#str(calc.round(maxs, digits: 1))×* y el promedio
*#str(calc.round(prom, digits: 1))×*: si mañana re-corro el benchmark,
solo reemplazo el CSV y estas frases y la tabla cambian solas.

// ============================================================
// (3) VARIAS SLIDES GENERADAS CON UN BUCLE
// ============================================================
#let contribuciones = (
  (
    n: 1,
    titulo: "Interpolación de unitarias (PINNs)",
    idea: "Interpolar U(t) sin conocer el Hamiltoniano",
    puntos: (
      "Fidelidad ≈ 0.99 (2–8 qubits)",
      "Unitaridad impuesta en la loss / capa de propagación",
      "Speedups de ~1 orden de magnitud vs. geodésica",
    ),
  ),
  (
    n: 2,
    titulo: "Reconstrucción desde marginales (CDAE + MIO)",
    idea: "Estado global compatible con marginales dados (QMP)",
    puntos: (
      "Matriz de densidad tratada como imagen de 2 canales",
      "Transfer learning de 3 a 8 qubits",
      "Más rápido que SDP; resuelve donde SDP falla",
    ),
  ),
)

// Un slide por cada contribución, con el mismo molde:
#for c in contribuciones {
  slide[
    == Contribución #c.n — #c.titulo

    #block(fill: udec.lighten(88%), inset: 10pt, radius: 4pt, width: 100%)[
      *Idea.* #c.idea
    ]
    #v(0.5em)
    #for p in c.puntos [
      - #p
    ]
  ]
}

== ¿Por qué importa esto?

- La tabla, las estadísticas y las dos slides anteriores se generaron *solas*
  desde datos y un molde.
- Cambiar un número = cambiar el CSV; agregar una contribución = agregar un
  elemento a la lista.
- En Beamer esto exige paquetes (`datatool`, `pgffor`) y bastante dolor;
  aquí es el lenguaje base.
