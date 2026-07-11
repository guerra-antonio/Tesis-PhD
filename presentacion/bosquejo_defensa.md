# Bosquejo — Defensa de Tesis Doctoral
### *Deep Learning frameworks for quantum-information problems*
**Antonio Guerra — Universidad de Concepción**

> Documento de trabajo para estructurar la presentación de defensa.
> Duración objetivo: **~40–45 min de charla + preguntas**. Ajustable (ver "Variantes de tiempo" al final).

---

## 0. Idea rectora del relato

Un solo hilo conductor une toda la charla y conviene enunciarlo temprano y repetirlo al cerrar:

> **"Incorporar la física conocida directamente en el proceso de aprendizaje (physics-informed) permite extender los métodos computacionales convencionales a problemas de información cuántica cuya complejidad crece exponencialmente con el tamaño del sistema."**

Las dos contribuciones son dos instancias del **mismo patrón**:
- Contribución 1 → a nivel de **dinámica** (operador de evolución unitaria).
- Contribución 2 → a nivel de **estados** (matrices de densidad / marginales).

Repetir este paralelismo hace que la tesis se perciba como una unidad, no como dos papers sueltos.

---

## 1. Estructura general (mapa de la charla)

| # | Bloque | Slides aprox. | Tiempo |
|---|--------|---------------|--------|
| A | Apertura + roadmap | 2 | 1–2 min |
| B | Background (info. cuántica + deep learning) | 6–7 | 8–10 min |
| C | Review: QI + DL (estado del arte) | 2–3 | 3–4 min |
| D | Contribución 1 — Interpolación de unitarias con PINNs | 8 | 11–12 min |
| E | Contribución 2 — QMP con CDAE + MIO | 7–8 | 10–11 min |
| F | Conclusiones + trabajo futuro (+ susceptibilidad) | 3–4 | 4–5 min |
| G | Cierre (publicaciones, agradecimientos) | 1–2 | 1 min |
| — | Backup slides | 5–8 | (solo preguntas) |

**Total ≈ 30–35 slides principales**, ritmo ~1–1.3 min/slide.

---

## A. Apertura (2 slides)

**A1 — Portada**
- Título de la tesis, tu nombre, comisión/guía (Aldo Delgado), afiliación, fecha.
- (Opcional) una figura "teaser": la barrera exponencial `2^N` vs. una red neuronal.

**A2 — Roadmap / hoja de ruta**
- Los 4 bloques: Background → Estado del arte → 2 contribuciones → Conclusiones.
- Enuncia aquí la **idea rectora** (§0). Prometer el hilo conductor desde el inicio.

---

## B. Background (6–7 slides)

> Objetivo: dar *solo* lo mínimo indispensable para que la comisión y el público sigan las dos contribuciones. No es un curso; es un "kit de herramientas". Cada elemento del background debe reaparecer luego en un resultado.

**B1 — Motivación (por qué unir estos dos mundos)**
- Deep learning: tecnología transformadora (visión, lenguaje, ciencia: AlphaFold, materiales, clima).
- Información cuántica: objetos (estados, operadores unitarios) cuya dimensión crece como `2^N` → **barrera exponencial**, tratamiento clásico exacto intratable.
- Punto de encuentro: DL aprende la **estructura latente de baja dimensión** que subyace a problemas cuánticos de alta dimensión.
- Concepto clave que los une: **physics-informed learning** (PINNs, Raissi 2019).

**B2 — Información cuántica esencial (I): estados y evolución**
- Qubit, espacio de Hilbert, dimensión `2^N`.
- Matriz de densidad `ρ`: Hermítica, PSD, traza 1.
- Evolución cerrada: `ρ(t) = U(t) ρ₀ U†(t)`; ecuación de von Neumann.
- Caso dependiente del tiempo → **exponencial ordenada temporalmente** (no hay `e^{-iHt}` cerrado). *(Semilla de la Contribución 1.)*

**B3 — Información cuántica esencial (II): subsistemas y marginales**
- Sistemas compuestos, **traza parcial**, marginal `σ_J = Tr_{J^c}[ρ]`.
- Fidelidad (entre estados y "gate fidelity" entre unitarias) como métrica de calidad. *(Semilla de la Contribución 2 y de la métrica de ambas.)*
- Base de Pauli para operadores de N qubits (se usa en la Contribución 1).

**B4 — Deep learning esencial (I): redes y arquitecturas**
- Red totalmente conectada (fully connected) — usada en Contribución 1.
- CNN / convoluciones + **autoencoder** (encoder–decoder, representación latente) — usada en Contribución 2.
- Función de activación, entrenamiento por backpropagation.
- Figuras disponibles: `images/fully-connected.pdf`, `images/autoencoder` (tex-figure), `images/conv-connected.pdf`, `images/activation-func.pdf`.

**B5 — Deep learning esencial (II): entrenamiento y PINNs**
- Loss function como objetivo a minimizar; optimización por gradiente (Adam/AdamW).
- **PINNs / Physics-Informed:** la clave de la tesis. La física (ecuaciones, restricciones, simetrías) se **incrusta en la loss / arquitectura**, restringiendo el espacio de soluciones a las físicamente admisibles. → data-efficiency + interpretabilidad.
- Enuncia: "en ambas contribuciones la física entra por la loss".

*(B2–B3 se pueden fusionar en 1 slide si vas justo de tiempo; ídem B4–B5.)*

---

## C. Review — Quantum Information + Deep Learning (2–3 slides)

> Objetivo: ubicar tu trabajo en el mapa. Breve, con nombres/áreas, no exhaustivo.

**C1 — El panorama (una figura-mapa)**
Áreas donde ML ya impacta en información cuántica:
- **Quantum State Tomography** (reconstrucción de estados desde medidas) — Carrasquilla, Danaci.
- **Quantum Process Tomography** (caracterización de procesos) — Huang 2025.
- **Neural Quantum States** / problema de muchos cuerpos — Carleo & Troyer 2017, etc.
- **N-representabilidad** en química cuántica — Sager-Smith, Delgado-Granados.
- **Control cuántico** con PINNs — Norambuena 2024.

**C2 — El hilo physics-informed**
- Tendencia común: no usar la red como caja negra, sino **embeber la física**.
- Aquí encajan tus dos contribuciones: una sobre **dinámica** (procesos), otra sobre **estados** (marginales) → mostrar dónde se posicionan en el mapa de C1.
- Gap que atacas: dinámica con Hamiltonianos dependientes del tiempo, y QMP constructivo, ambos con la barrera `2^N`.

---

## D. Contribución 1 — Interpolación de unitarias con Hamiltonianos dependientes del tiempo vía PINNs (8 slides)

> *Submitted to Machine Learning: Science and Technology* — código en GitHub (`PINN_dynamics_estimation`).

**D1 — El problema**
- Hamiltoniano dependiente del tiempo `H(t)` → `U(t)` es exponencial ordenada temporalmente, sin forma cerrada.
- Expansiones (Dyson/Magnus): integrales anidadas, errores que se acumulan; construir/exponenciar `U(t)` escala como `O(2^{3N})`.
- Sin embargo, `H(t)` es central en control cuántico, optimización de compuertas, simulación de muchos cuerpos.

**D2 — La pregunta concreta**
- Dado `U(t_i)` en un conjunto **finito** de tiempos muestreados → interpolar `U(t)` en todo `[0,T]`.
- Entrada: un escalar `t`. Salida: `U(t)`.
- **Clave:** el Hamiltoniano NO se le da al modelo; aprende la dinámica solo de las unitarias muestreadas (rol de datos tipo QPT).
- Un modelo por realización de Hamiltoniano (aclarar el alcance).

**D3 — Sistemas físicos considerados**
- `H_general` (todos los componentes de Pauli) para 2–6 qubits — prueba de principio (caso más expresivo).
- `H_Ising` y `H_XYZ` (vecinos cercanos) para 7–8 qubits — modelos físicamente realizables (iones atrapados, superconductores, D-Wave, spin-qubits en silicio).
- Coeficientes `c(t) = A·sin(ωt+φ)/N_N`, parámetros aleatorios → ensemble diverso.

**D4 — Método: dos arquitecturas**  *(Figura: `images/model-description-1.pdf` y `-2.pdf`)*
- **(a) 2–6 qubits:** la red predice **directamente** `U(t)` (matriz `2^N×2^N`).
- **(b) 7–8 qubits:** la red predice los coeficientes de un **Hamiltoniano efectivo `H_eff(t)`** (~`10³` params), y una **capa de propagación** (Magnus 2º orden / Trotter) reconstruye `U(t)` → **unitaridad garantizada por construcción**.
- Mensaje de diseño: *desacoplar la representación aprendida de la dimensión del operador que genera.*

**D5 — Loss physics-informed**
- Tres términos: (1) evolución correcta de estados `ρ(t)=UρU†`; (2) coincidencia con unitarias conocidas; (3) **penalización de unitaridad** `‖I − U U†‖`.
- Para 7–8 qubits el término (3) es innecesario (Magnus/Trotter ya preservan unitaridad).
- Resultado interesante (backup): el término de unitaridad importa **más** cuando hay pocos datos (`Δt=0.5, 1.0`).

**D6 — Resultados: fidelidad y robustez**  *(Figuras: `fidelity_qubits_2to6-*.pdf`, `fidelity_qubits_7and8-*.pdf`, `fidelity_statistic_plots_*.pdf`)*
- **Fidelidad de compuerta ≈ 0.99** para 2–8 qubits.
- Modelos entrenados con muestreo grueso (`Δt=1.0`) casi igualan a los de grilla fina → **fuerte capacidad de interpolación** → reduce el costo de medición (QPT).
- Análisis estadístico (hasta 100 corridas independientes): desviación estándar baja; sin regiones de falla.
- Trace distance `O(10⁻²)` (backup: `trace_distance_all_N.pdf`).

**D7 — Resultados: ventaja computacional**  *(Figura: `timing_benchmark.pdf`, `timing_benchmark_large.pdf`)*
- Benchmark vs. interpolación geodésica (Schilling 2024), que escala `O(2^{3N})`.
- **Speedups ~8.9×–19.3×** (2–6 qubits); tiempo de inferencia casi constante en `N`.
- 7–8 qubits: Trotter 6.8×–17.8×; Magnus 2×–7.8×.
- Mensaje: se **amortiza** un entrenamiento costoso en una inferencia barata y repetible.

**D8 — Take-home Contribución 1**
- PINN interpola la dinámica sin conocer `H`, con fidelidad ~0.99 y speedup de ~1 orden de magnitud.
- Limitaciones honestas: un modelo por Hamiltoniano/tamaño; `H_eff` reproduce la dinámica pero **no es** el generador verdadero (no-identificabilidad).

---

## E. Contribución 2 — Reconstrucción de matrices de densidad desde marginales cuánticos (CDAE + MIO) (7–8 slides)

> *Published in Machine Learning: Science and Technology* (Uzcategui, Niklitschek, Delgado) — código en GitHub (`Learning-QM`).

**E1 — El problema: Quantum Marginal Problem (QMP)**
- Dado un conjunto de marginales `{σ_J}` (estados reducidos), ¿existe un estado global `ρ` compatible? Y si existe, **reconstruirlo**.
- Versión de consistencia: **QMA-completo** → intratable en general.
- Implicaciones: ground states de Hamiltonianos locales, **N-representabilidad** en química cuántica.

**E2 — El enfoque en una imagen**
- Formulación como SDP; existen solvers, pero escalan mal en memoria/tiempo.
- Herramienta previa: **MIO (Marginal Imposition Operator)** — impone marginales sobre una matriz, pero puede producir salidas **no físicas** (autovalores negativos).
- Idea: usar un **autoencoder denoising convolucional (CDAE)** para "limpiar" esa salida y devolver un estado válido.

**E3 — Matrices de densidad como imágenes**
- `ρ` → tensor de 2 canales (parte real + imaginaria), cada canal `2^N×2^N` → análogo a una imagen RGB.
- Analogía conceptual: la **traza parcial** extrae información de subsistemas como la **convolución** extrae features locales.
- Justifica por qué una CNN/autoencoder es una elección natural.

**E4 — Arquitectura y flujo**  *(Figura: `images/DA_architecture.png`)*
- Entrada: matriz "corrupta" `X̃ = Q_{J_M}∘…∘Q_{J_1}(ρ)` (contiene los marginales, pero con autovalores negativos).
- CDAE: encoder → representación latente → decoder → salida `Z` (estado válido).
- Se prueba matemáticamente que la arquitectura sirve para **cualquier `N>2`** (backup).

**E5 — Loss physics-based + esquema híbrido**
- Loss vía descomposición polar `Z=UP`: fuerza (1) `U≈I` (PSD), (2) `Im(U)≈0`, (3) marginales `Tr_{J^c}[Z]=σ_J`.
- Hermiticidad y normalización se corrigen a posteriori.
- **Esquema híbrido `model1+MIO`:** pasar la salida del CDAE de nuevo por el MIO → "purifica" → en muchos casos **fidelidad perfecta** de marginales.

**E6 — Transfer learning**
- Un modelo entrenado en 3 qubits se adapta hasta 8 qubits con **reentrenamiento limitado** (a menudo solo la última capa del decoder).
- Sugiere que el **encoder internaliza la estructura del problema de compatibilidad**, independiente de la dimensión del Hilbert. → hallazgo conceptual fuerte.

**E7 — Resultados**  *(Figuras: `stdN3k*.png`, `all_cases_extra_mio_*.png`, `success_rate_*.png`, `runtime.png`)*
- Success rate (fracción de salidas PSD válidas): >99–100% para `N>5`.
- `model1` supera ampliamente al "random guessing"; incluir el término de marginales es clave.
- `model1+MIO`: reconstrucciones con **fidelidad perfecta** en muchos casos; reduce autovalores negativos ~1 orden de magnitud.
- **Más rápido que el solver SDP** (CVXPY); resuelve `N8k4` donde el **SDP falla** (~3.38 s).

**E8 — Take-home Contribución 2**
- CDAE+MIO reconstruye estados globales físicamente válidos compatibles con marginales, hasta 8 qubits, más rápido que SDP y con transfer learning.
- Limitación honesta: dificultad cuando los marginales provienen de **estados globales puros** (representación única).

---

## F. Conclusiones + Trabajo futuro (3–4 slides)

**F1 — El patrón común (cierre del hilo conductor)**
- Dos problemas duros (integrar `H(t)` no conmutante / buscar en un espacio exponencial de estados) recastados como **problemas de aprendizaje con restricciones físicas**.
- Las redes no solo ajustan datos: aprenden representaciones que **respetan** unitaridad, positividad y estructura de traza parcial.
- Physics-informed = combinar flexibilidad/escalabilidad del DL con el rigor de las leyes físicas.

**F2 — Hacia deep learning a gran escala en información cuántica**
- Ambos frameworks confrontan la barrera `2^N`:
  - Interpolación: aprender un `H_eff` compacto (`O(10³)` params) + capa física que restaura la estructura exponencial.
  - Marginales: features locales de CNNs + transferibilidad entre tamaños.
- Mensaje: DL no es solo un solver más rápido, es un marco para aprender la **estructura latente de baja dimensión**; el costo caro (entrenamiento) se amortiza en inferencia barata.

**F3 — Trabajo futuro**
- **Contribución 1:** pasar de reproducir la dinámica a **reconstruir el Hamiltonian real** (restricciones de Schrödinger/von Neumann en la loss); extensión a **sistemas abiertos** (CPTP en vez de unitaridad); arquitecturas que generalicen entre familias de Hamiltonianos.
- **Contribución 2:** usar la salida como **warm-start** de solvers SDP; **detección de anomalías** para la versión decisión del QMP (compatible vs. incompatible); explicabilidad de lo que aprende el encoder.

**F4 — (Mención breve) Trabajo actual: susceptibilidad**
- *Mencionar, no presentar.* 1–2 bullets:
  - "Actualmente exploro [susceptibilidad ...] como extensión natural de esta línea physics-informed."
  - Encuadrarlo como continuidad/proyección, no como resultado terminado.
  - ⚠️ **Completar con el detalle real** — no encontré material de susceptibilidad en la tesis; escribe 1 frase concreta de qué es y por qué conecta.

---

## G. Cierre (1–2 slides)

**G1 — Publicaciones y contribuciones**
- Cap. 4 (interpolación): *submitted*, Machine Learning: Science and Technology — `guerra2026interpolation`.
- Cap. 5 (QMP): *published*, Machine Learning: Science and Technology — `uzcategui2025marginals`.
- Repos públicos de reproducibilidad.

**G2 — Gracias / preguntas**
- Agradecimientos (guía, comisión, financiamiento, familia).
- Slide de contacto. Preparar transición a preguntas.

---

## Backup slides (solo si preguntan)

Ten a mano, sin numerar en el flujo principal:
1. Detalle de la loss de interpolación y efecto del término de unitaridad (`fidelity_unitarity_N*.pdf`).
2. Algoritmos Magnus 2º orden y Trotterización (pseudocódigo).
3. Trace distance completo (`trace_distance_all_N.pdf`) y dinámica de poblaciones (`state_dynamics_populations_*.pdf`).
4. Tabla de arquitecturas (model2–model8) y conteo de parámetros (`scaling_num-trainable-parameters.pdf`).
5. Demostración de compatibilidad de tamaños del CDAE (`N>2`).
6. Proporción de autovalores negativos antes/después (`proportion_of_NE_yes.png`).
7. Detalle del benchmark de runtime SDP vs. modelo (`runtime.png`).
8. Definición formal de gate fidelity (Choi–Jamiołkowski).

---

## Consejos para la defensa

- **Regla de oro:** cada slide de background debe "pagar" apareciendo luego en un resultado. Si algo no reaparece, va a backup.
- **Números que debes poder decir de memoria:** fidelidad ~0.99; speedups 8.9×–19.3×; hasta 8 qubits; success rate 100% para `N>5`; SDP falla en `N8k4` (tú resuelves en ~3.38 s).
- **Limitaciones proactivas:** menciónalas tú antes de que las pregunten (un modelo por Hamiltoniano; `H_eff` ≠ generador real; dificultad con estados puros). Demuestra madurez científica.
- **Preguntas típicas a preparar:**
  - ¿Por qué PINN y no un método numérico clásico? (respuesta: amortización + interpolación + no requiere `H`).
  - ¿Qué garantiza que la salida sea física? (capa de propagación / loss + proyección).
  - Escalabilidad real más allá de 8 qubits (honestidad: recursos; pero el diseño `H_eff` apunta ahí).
  - Relación con Hamiltonian learning genuino (no-identificabilidad).
- **Ensaya el timing** con reloj; el bloque de background es donde más se suele exceder.

---

## Variantes de tiempo

- **30 min:** fusiona B2+B3 y B4+B5 (background en 4 slides), C en 1 slide, quita D6/E7 detalles a backup.
- **45 min (holgado):** versión completa de arriba.
- **60 min (seminario):** añade 1 slide de motivación física por cada contribución y sube backups al flujo principal.

---

*Siguiente paso sugerido:* una vez validado este bosquejo, puedo generar el esqueleto real de la presentación en **Beamer (LaTeX, coherente con tu tesis)** o en **PowerPoint (.pptx)**, ya con los `\includegraphics` de las figuras correctas apuntando a `../images/`.
