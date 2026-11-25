# Sistema de Economía y Presupuesto — Econtainment

Este documento describe cómo se calcula el **Presupuesto Verde** mensual (por tick) en **Econtainment**, combinando una **Rampa Fiscal Progresiva** con un **Multiplicador ligado exclusivamente a la Confianza Ciudadana**.

---

## 1. Propósito de Diseño

1. **Evitar exceso de dinero al inicio:** El presupuesto inicial y el ingreso de los primeros meses son acotados para que el jugador elija con cuidado sus primeras políticas.
2. **Sostener políticas avanzadas (Tier 2 y Tier 3):** Conforme avanzan los meses, la rampa fiscal aumenta gradualmente el techo de recaudación para poder cubrir el mantenimiento mensual acumulado.
3. **Dar peso real a la Confianza Ciudadana:** La recaudación depende de la Confianza (gobernabilidad), **no** de la Salud Ambiental. Sacrificar Confianza con medidas impopulares recorta ingresos futuros; mantenerla alta (con *Concientización* y burbujas de Zona Urbana) potencia el presupuesto.

---

## 2. Parámetros en `GameBalance`

Definidos en [game_balance.gd](file:///D:/Proyectos/econtainment/scripts/data/game_balance.gd):

| Constante | Valor | Descripción |
| :--- | :---: | :--- |
| `INITIAL_BUDGET` | `12` | Presupuesto inicial al comenzar la partida. |
| `BASE_BUDGET_INCOME_PER_TICK` | `10` | Ingreso base mensual antes de rampa y multiplicador. |
| `MIN_BUDGET_INCOME_PER_TICK` | `4` | Piso mínimo garantizado de ingreso efectivo (antes de mantenimiento). |
| `FISCAL_RAMP_STEP_TICKS` | `3` | Cada cuántos meses (ticks) aumenta la rampa fiscal. |
| `FISCAL_RAMP_BONUS_PER_STEP` | `1` | Cuánto aumenta el techo base por cada escalón de rampa. |
| `FISCAL_RAMP_MAX_BONUS` | `6` | Bono máximo acumulable por rampa (alcanzado en el Mes 18). |
| `TRUST_INCOME_MIN_MULTIPLIER` | `0.45` | Multiplicador de recaudación con `0%` de Confianza. |
| `TRUST_INCOME_MAX_MULTIPLIER` | `1.15` | Multiplicador de recaudación con `100%` de Confianza. |
| `BUBBLE_BUDGET_REWARD` | `4` | Dinero extra inmediato por burbuja de Zona Productiva. |

---

## 3. Algoritmo Paso a Paso (`SimulationEngine`)

En cada tick (`step_tick()`), el motor ejecuta:

1. **Bono de Rampa Fiscal (`get_fiscal_ramp_bonus()`):**
   $$\text{ramp\_bonus} = \min\left(\left\lfloor \frac{\text{tick\_count}}{\text{FISCAL\_RAMP\_STEP\_TICKS}} \right\rfloor \times \text{FISCAL\_RAMP\_BONUS\_PER\_STEP},\ \text{FISCAL\_RAMP\_MAX\_BONUS}\right)$$
   $$\text{fiscal\_base} = \text{BASE\_BUDGET\_INCOME\_PER\_TICK} + \text{ramp\_bonus}$$

2. **Multiplicador por Confianza Ciudadana (`get_trust_income_multiplier()`):**
   $$\text{trust\_multiplier} = 0.45 + (1.15 - 0.45) \times \frac{\text{trust}}{100.0}$$

3. **Ingreso Bruto (`calculate_gross_budget_income()`):**
   $$\text{ingreso\_bruto} = \text{round}(\text{fiscal\_base} \times \text{trust\_multiplier})$$

4. **Ingreso Efectivo (`calculate_budget_income()`):**
   $$\text{ingreso\_efectivo} = \max(\text{ingreso\_bruto} - \text{budget\_income\_penalty},\ \text{MIN\_BUDGET\_INCOME\_PER\_TICK})$$

5. **Balance tras Mantenimiento:**
   $$\text{presupuesto\_nuevo} = \max(0,\ \text{presupuesto\_actual} + \text{ingreso\_efectivo} - \text{maintenance\_cost\_per\_tick})$$
   *(Si llega a `$0`, las acciones con `requires_positive_budget = true` se suspenden hasta que el presupuesto vuelva a ser `> 0`).*

---

## 4. Tabla de Referencia (Ingreso Bruto por Mes y Confianza)

| Momento | `fiscal_base` | CC `40%` (`0.73x`) | CC `60%` (`0.87x`) | CC `85%` (`1.045x`) |
| :--- | :---: | :---: | :---: | :---: |
| **Mes 0–2** | `$10` | `$7` | `$9` | `$10` |
| **Mes 6–8** | `$12` | `$9` | `$10` | `$13` |
| **Mes 12–14** | `$14` | `$10` | `$12` | `$15` |
| **Mes 18+** | `$16` | `$12` | `$14` | `$17` *(hasta `$18` con `100%` CC)* |
