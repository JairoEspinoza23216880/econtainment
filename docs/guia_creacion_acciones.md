# Guía para Diseño y Balanceo de Acciones — Econtainment

Este documento explica cómo funciona cada variable de una **Acción** (`.tres`) dentro de **Econtainment**, cómo impacta en la simulación y qué formato usar para redactar nuevas acciones o ajustar las existentes.

---

## 1. Contexto Numérico del Juego (Valores Base Actuales)

Para poder balancear una acción, ten en cuenta estas referencias de la simulación actual:

- **Duración de cada mes (1 Tick):** `10 segundos` a velocidad `1x` (ajustable en juego a `2x` y `3x`).
- **Condición de Victoria:** `Salud Ambiental = 100%` (promedio de limpieza de las 3 zonas) **y** `Confianza Ciudadana > 70%`.
- **Condición de Derrota:** `Salud Ambiental <= 0%` (Colapso) **o** `Confianza Ciudadana <= 0%` (Destitución).
- **Presupuesto Verde:**
  - **Inicial:** `$20`
  - **Ingreso base por mes:** hasta `$10` (escala según Salud y Confianza; mínimo garantizado `$4/mes` antes de mantenimiento).
- **Estados de cada Zona (Polución de `0%` a `100%`):**
  - **Sano (`<= 20%`):** suma `+1.2` de Confianza Ciudadana por mes.
  - **Normal (`21% – 49%`):** no afecta la Confianza.
  - **Contaminado (`>= 50%`):** resta `-1.8` de Confianza Ciudadana por mes **y activa Derrame Crítico** (el `50%` del excedente sobre `50%` se filtra cada mes hacia la Reserva Biológica).
- **Valores iniciales y tasas base por zona:**

| Zona | Polución Inicial | Emisión Base / mes | Mitigación Base | Regeneración Base |
| :--- | :---: | :---: | :---: | :---: |
| **Productiva** (`productive`) | `35%` | `4.5` | `0.0` | `0.0` |
| **Urbana** (`urban`) | `30%` | `3.5` | `0.0` | `0.0` |
| **Reserva Biológica** (`reserve`) | `25%` | `0.0` | `0.0` | `1.5` |

### ¿Cómo cambia la polución cada mes?
En cada zona, el motor calcula:

$$\Delta \text{Polución} = \text{Emisiones} - \text{Mitigación} - \text{Regeneración}$$

- Si $\Delta \text{Polución}$ es **positivo**, la zona se sigue ensuciando.
- Si $\Delta \text{Polución}$ es **negativo**, la zona se va limpiando cada mes hasta llegar a `0%`.

---

## 2. Variables de una Acción (`.tres`)

Cada archivo `.tres` en `resources/actions/` contiene los siguientes campos:

### A. Identidad y Árbol (`Identity & Tree`)
| Variable | Tipo | Qué hace |
| :--- | :--- | :--- |
| `id` | Texto (`snake_case`) | Identificador único interno (en inglés, sin espacios, ej. `waste_separation`). |
| `branch` | Rama (`0`, `1` o `2`) | `0` = **Concientización** (Ciudadanía)<br>`1` = **Legislaciones** (Empresas)<br>`2` = **Acciones Directas** (Gobierno) |
| `title` | Texto | Nombre corto visible en el botón del árbol y en el título del panel de detalle. |
| `description` | Texto largo | Explicación educativa clara de qué es la política y a quién corresponde. |
| `pros_text` | Texto largo | Ventajas principales (se muestra en verde en el juego). |
| `cons_text` | Texto largo | Riesgos o desventajas (se muestra en naranja/rojo en el juego). |
| `prerequisites` | Lista de `id` | Acciones que deben estar **Activas** para poder comprar esta. Si está vacía `[]`, es un **nodo raíz** (disponible desde el inicio). Puedes encadenar tantos niveles como quieras. |

### B. Costos y Tiempos (`Costs & Timing`)
| Variable | Tipo | Qué hace |
| :--- | :--- | :--- |
| `cost_budget` | Entero (`$`) | Costo único al activar la acción (o al reconstruirla si fue destruida). |
| `maintenance_per_tick` | Entero (`$`) | Costo fijo que se descuenta **cada mes** mientras la política siga activa (se detiene si se deroga). |
| `delay_ticks` | Entero (meses) | Meses que tarda en madurar tras pagarla (`0` = entra en vigor de inmediato; `2` = tarda 2 meses en aplicar sus modificadores). |
| `immediate_trust_delta` | Decimal (`%`) | Cambio único e inmediato en Confianza Ciudadana al activarla (ej. `-15.0` en clausuras impopulares, `+5.0` en campañas). |
| `budget_income_penalty` | Entero (`$`) | Reduce el ingreso mensual de Presupuesto Verde mientras esté activa (ej. `2` por conflictos con cámaras de comercio). |

### C. Modificadores por Zona (`Productive / Urban / Reserve Zone Modifiers`)
Cada zona tiene 3 modificadores acumulables mientras la acción esté **Activa**:
- `productive_emission_delta` / `urban_emission_delta` / `reserve_emission_delta`: Suma o resta a la **emisión** de esa zona. *(Usa valores **negativos** para reducir lo que contamina la zona, ej. `-1.5`).*
- `productive_mitigation_delta` / `urban_mitigation_delta` / `reserve_mitigation_delta`: Suma a la **mitigación** (ej. `+2.0` limpia 2 puntos adicionales por mes).
- `productive_regen_delta` / `urban_regen_delta` / `reserve_regen_delta`: Suma a la **regeneración biológica** (ej. `+4.5` en humedales).

*(Nota: si una acción no afecta a una zona, sus 3 valores se dejan en `0.0`).*

### D. Reglas Especiales (`Special Rules`)
| Variable | Tipo | Qué hace |
| :--- | :--- | :--- |
| `requires_positive_budget` | `true` / `false` | Si es `true`, la acción se **Suspende** automáticamente cuando el presupuesto llega a `$0` y se reactiva al recuperar dinero. |
| `vulnerable_to_severe_spill` | `true` / `false` | Si es `true`, un derrame severo hacia la Reserva (`>= 10.0` en un mes) **Destruye** la infraestructura (aunque esté madurando) y obliga a reconstruirla. |
| `grants_early_alert` | `true` / `false` | Marca si la acción otorga detección temprana de focos rojos (reservado para sistema de alertas). |
| `missed_alert_penalty_multiplier` | Decimal | Multiplicador de penalización si una alerta expira sin resolverse (por defecto `1.0`). |

---

## 3. Plantilla para Proponer Nuevas Acciones

Puedes copiar y llenar esta ficha por cada acción que quieras añadir o modificar:

```markdown
### Nombre de la Acción (title)
- **ID sugerido:** `ejemplo_accion`
- **Rama (`branch`):** Concientización (0) / Legislaciones (1) / Acciones Directas (2)
- **Requiere antes (`prerequisites`):** Ninguna (raíz) / `id_accion_previa`
- **Descripción:** ...
- **Ventajas (`pros_text`):** ...
- **Riesgos (`cons_text`):** ...

**Economía y Tiempos:**
- **Costo inicial (`cost_budget`):** $15
- **Mantenimiento mensual (`maintenance_per_tick`):** $1
- **Meses para activarse (`delay_ticks`):** 0
- **Impacto inmediato en Confianza (`immediate_trust_delta`):** +2.0
- **Penalización al ingreso mensual (`budget_income_penalty`):** $0

**Efecto en Zonas (por mes):**
- **Productiva:** Emisión `0.0`, Mitigación `0.0`, Regeneración `0.0`
- **Urbana:** Emisión `-1.2`, Mitigación `0.0`, Regeneración `0.0`
- **Reserva:** Emisión `0.0`, Mitigación `0.0`, Regeneración `0.0`

**Reglas especiales:**
- **¿Se apaga si presupuesto = $0? (`requires_positive_budget`):** No
- **¿Se destruye con derrame severo? (`vulnerable_to_severe_spill`):** No
```
