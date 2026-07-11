//============================================================
// DEMO — Typst + Touying  (sucesor moderno de LaTeX)
// Compilar:  typst compile --root .. demo.typ
// (--root .. permite leer las figuras de ../assets; la primera compilación
//  descarga el paquete touying automáticamente.)
//============================================================
#import "@preview/touying:0.6.1": *
#import themes.metropolis: *

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Deep Learning para problemas de información cuántica],
    subtitle: [Defensa de Tesis Doctoral — #text(style: "italic")[demo Typst + Touying]],
    author: [Antonio Guerra],
    date: datetime.today(),
    institution: [Universidad de Concepción],
  ),
)

// Color de acento (cámbialo por el institucional si quieres)
#let udec = rgb(0, 70, 140)

#title-slide()

== Hoja de ruta

+ *Background* — información cuántica y deep learning
+ *Estado del arte* — combinando ambos mundos
+ *Contribución 1* — interpolación de unitarias (PINNs)
+ *Contribución 2* — reconstrucción desde marginales (CDAE + MIO)
+ *Conclusiones* y trabajo futuro

#v(1em)
#block(
  fill: udec.lighten(85%),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)[
  *Idea rectora.* Incrustar la física conocida en el aprendizaje
  (#text(style: "italic")[physics-informed]) extiende los métodos clásicos a
  problemas cuya complejidad crece como $2^N$.
]

== Background: la barrera exponencial

#grid(
  columns: (1.4fr, 1fr),
  gutter: 1.5em,
  [
    Un estado de $N$ qubits vive en un espacio de dimensión $2^N$:
    $ rho(t) = U(t) rho_0 U^dagger (t), quad i dot(U) = H(t) U. $
    - Construir/exponenciar $U(t)$ escala como $cal(O)(2^(3N))$.
    - Con $H(t)$ dependiente del tiempo no hay $e^(-i H t)$ cerrado.
  ],
  block(fill: udec.lighten(88%), inset: 10pt, radius: 4pt)[
    *Physics-informed learning.* La física entra por la #text(style:"italic")[loss]:
    la red aprende solo soluciones físicamente admisibles (unitaridad,
    positividad, marginales).
  ],
)

== Contribución 1 — Interpolación de unitarias con PINNs

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    Dada $U(t_i)$ en tiempos muestreados, interpolar $U(t)$ en todo $[0,T]$
    *sin conocer el Hamiltoniano*.
    $ F(U, U_theta) = abs(1/d "Tr"[U^dagger U_theta])^2 $
    - Fidelidad $approx 0.99$ (2–8 qubits)
    - Speedups $8.9 times$–$19.3 times$ vs. geodésica
  ],
  align(center + horizon, image("../assets/timing_benchmark.png", width: 100%)),
)

== Contribución 2 — Reconstrucción desde marginales (CDAE + MIO)

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    El #text(style:"italic")[Quantum Marginal Problem] (QMA-completo): dado
    ${sigma_cal(J)}$, reconstruir un estado global $rho$ compatible.
    - Matriz de densidad $arrow$ imagen de 2 canales
    - CDAE + MIO $arrow$ estado físico válido
    - *Transfer learning* de 3 a 8 qubits
    - Más rápido que SDP (resuelve donde SDP falla)
  ],
  align(center + horizon, image("../assets/DA_architecture.png", width: 100%)),
)

== Cierre

#align(center + horizon)[
  #text(size: 1.4em)[
    Dos problemas duros, un mismo patrón:\
    #text(fill: udec, weight: "bold")[la física en la loss] convierte
    lo intratable en aprendible.
  ]
]
