# Demo de Econtainment

# Documento de Diseño de Juego (Mini GDD)

**Proyecto:** *Econtainment*
**Empresa / Iniciativa:** ARDIXA Interactive Software
**Plataforma Objetivo:** Dispositivos móviles (Android / WebGL responsivo)
**Género:** Estrategia y gestión de crisis por turnos (Inspirado en *Plague Inc: The Cure*)
**Duración por Partida:** 3 a 5 minutos
**Target:** Estudiantes de nivel medio superior y universitario

---
## 1. Visión y Propósito

El jugador asume el rol del titular de la comisión ambiental metropolitana con el objetivo de evitar el colapso ecológico de una ciudad en crisis.

El juego transforma regulaciones, inspecciones y modelos de economía circular en un sistema de cartas tácticas y árboles de gestión, eliminando textos densos y enseñando de forma intuitiva qué responsabilidades competen al gobierno, a las empresas y a la ciudadanía.

---
## 2. Métricas y Condiciones de Fin de Juego

### Variables Principales

1. **Salud Ambiental (0% – 100%):** Promedio de limpieza ecológica de las zonas. Aumenta con regeneración activa y baja con la polución acumulada. 
2. **Confianza Ciudadana (0% – 100%):** Nivel de gobernabilidad y aprobación social. Cae pasivamente si la contaminación es alta (inacción percibida) o por aplicar medidas impopulares.
3. **Presupuesto Verde:** Recurso disponible para ejecutar acciones. Se renueva al inicio de cada turno.

### Condiciones de Fin de Partida

* **Victoria:** Alcanzar el 100% de Salud Ambiental manteniendo la Confianza Ciudadana por encima del 70% (ciudad sustentable regenerada).
* **Derrota A (Colapso Ecológico):** La Salud Ambiental llega a 0%.
* **Derrota B (Destitución):** La Confianza Ciudadana llega a 0% (el jugador es revocado por protestas populares).

---
## 3. El Tablero: Sistema de 3 Zonas

El mapa representa una ciudad condensada en 3 nodos interconectados:

```
┌───────────────────────────────┐     ┌───────────────────────────────┐
│        ZONA PRODUCTIVA        │     │          ZONA URBANA          │
│     (Fábricas y Comercio)     │     │     (Hogares y Tránsito)      │
│  - Chimeneas y calderas       │     │  - Parque vehicular obsoleto  │
│  - Descargas clandestinas     │     │  - Basura en calles           │
│  - Embalajes y lodos tóxicos  │     │  - Drenaje saturado           │
└───────────────┬───────────────┘     └───────────────┬───────────────┘
                │                                     │
                │        Derrame / Infiltración       │
                └──────────────────┬──────────────────┘
                                   ▼
                ┌─────────────────────────────────────┐
                │          RESERVA BIOLÓGICA          │
                │       (Río y Manto Freático)        │
                │  - No genera contaminación propia   │
                │  - Absorbe derrames de las 2 zonas  │
                │  - Única zona de regeneración neta  │
                └─────────────────────────────────────┘

```

* **Derrame Crítico:** Si la contaminación en la Zona Productiva o Urbana supera el 50%, el excedente drena directamente hacia la Reserva Biológica, acelerando el colapso general.

---
## 4. Bucle Central de Juego (Core Loop)

Cada turno representa 1 mes de gestión metropolitana:

```
[1. INICIO DE TURNO]
 ├─ +X Presupuesto Verde.
 └─ Detección de Focos Rojos (Alertas activas en zonas).
          │
          ▼
[2. FASE DE DECISIÓN DEL JUGADOR]
 ├─ Seleccionar acciones del árbol (Concientización / Legislación / Acción Directa).
 └─ Pagar coste y aplicar políticas inmediatas o impopulares.
          │
          ▼
[3. TICK DE SIMULACIÓN]
 ├─ Emisión de contaminantes vs. Mitigación aplicada.
 ├─ Regeneración neta activa (reduce contaminación acumulada).
 ├─ Cálculo de derrames hacia la Reserva Biológica.
 ├─ Desgaste de Confianza por contaminación existente.
 └─ Verificación de Victoria o Derrota.

```

---
## 5. Árbol de Acciones (Estructura y Ramificaciones)

Las políticas no son un incremento lineal numérico; ofrecen opciones estratégicas con pros, contras y efectos colaterales en la Confianza Ciudadana.

```
                              ÁRBOL DE GESTIÓN
                                     │
     ┌───────────────────────────────┼───────────────────────────────┐
     ▼                               ▼                               ▼
[CONCIENTIZACIÓN]              [LEGISLACIONES]              [ACCIONES DIRECTAS]
(Vía Ciudadana)                (Vía Empresas)               (Vía Gobierno)
     │                               │                               │
  [Raíz]                          [Raíz]                          [Raíz]
Separación Casera               Norma de Emisiones              Limpieza de Choque
     │                               │                               │
  ┌──┴──┐                         ┌──┴──┐                         ┌──┴──┐
  ▼     ▼                         ▼     ▼                         ▼     ▼
Vigil. Boicot                  Castigo Fomento                 Obra     Bio
Vecinal Selectivo             Punitivo Circular                 Gris     Filtros

```

### 1. Rama Concientización (Educación y Sociedad)
* **Nodo Raíz:** *Campaña de Separación de Residuos.* (Bajo coste; reduce generación doméstica; sube levemente la Confianza).

* **Bifurcación 1A (Vigilancia Digital Vecinal):** App municipal para geolocalizar tiraderos y fugas.
	* *Ventaja:* Revela alertas con 1 turno de anticipación y potencia las inspecciones.
	* *Riesgo:* Si la alerta no se atiende en el mismo turno, penaliza el doble de Confianza.

* **Bifurcación 1B (Consumo Crítico y Boicot):** Organización de redes universitarias contra marcas no sustentables.
	* *Ventaja:* Las empresas de Zona Urbana reducen plásticos sin inversión de fondos públicos.
	* *Riesgo:* Conflictos con cámaras de comercio; reduce temporalmente la recaudación de presupuesto.

### 2. Rama Legislaciones (Marco Regulatorio a Empresas)

* **Nodo Raíz:** *Norma de Descargas y Emisiones.* (Establece topes legales a las fábricas).
* **Bifurcación 2A (Régimen Punitivo y Clausuras):** Inspecciones con sellos de cierre y multas severas.
	* *Ventaja:* Corta de inmediato descargas tóxicas industriales.
	* *Riesgo (Acción Impopular):* Paros patronales y despidos; resta 15% de Confianza de golpe.

* **Bifurcación 2B (Fomento y Economía Circular):** Deducciones fiscales a industrias que traten su propia agua y reciclen insumos.
	* *Ventaja:* Cero costo de Confianza; solución permanente y estable.
	* *Riesgo:* Alto coste de presupuesto público inicial; tarda 2 turnos en activarse.

### 3. Rama Acciones Directas (Infraestructura del Estado)
* **Nodo Raíz:** *Cuadrillas de Emergencia Municipal.* (Mantenimiento básico de drenajes y recolección).
* **Bifurcación 3A (Macro-Infraestructura Gris):** Planta de Tratamiento de Aguas y Centro de Reciclaje.
	* *Ventaja:* Mitigación pasiva continua muy alta sobre la Zona Urbana e Industrial.
	* *Riesgo:* Requiere mantenimiento económico cada turno; si el presupuesto llega a 0, se apaga.
* **Bifurcación 3B (Remediación Biológica / Basada en la Naturaleza):** Reforestación y humedales en la Reserva Biológica.
	* *Ventaja:* **Desbloquea la tasa más alta de regeneración neta negativa**, limpiando el agua automáticamente. Aumenta la Confianza.
	* *Riesgo:* Vulnerable durante su maduración; si hay un derrame industrial severo, el humedal muere y debe reconstruirse.
---
## 6. Lógica de "Contaminación Negativa" y el Factor Impopular

* **Regeneración Neta:** Para pasar de un estado de equilibrio a ganar la partida, el juego calcula:
$$\Delta \text{Contaminación} = \text{Emisiones} - \text{Mitigación} - \text{Regeneración Activa}$$
Cuando la mitigación supera a las emisiones, el valor es negativo, reduciendo la polución acumulada y permitiendo alcanzar el 100% de Salud Ambiental.
* **El Dilema Político:** El jugador debe decidir cuándo pagar el coste social de una acción impopular (ej. restricción vehicular obligatoria o clausura industrial) para salvar un indicador ecológico crítico, compensando después esa pérdida de Confianza con campañas ciudadanas o infraestructura limpia.
---
## 7. Plan de Producción del MVP (6 Semanas)

| Semana | Hito Técnico / Entregable                                                                                                                                                     |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **S1** | **Diseño y Balance en Tabla:** Ajuste de números en hoja de cálculo (costos, valores de daño, mitigación y tasas de regeneración).                                            |
| **S2** | **Lógica Core (Godot / GDScript):** Variables de estado, ciclo de turnos (1 a 12), cálculo de simulación y triggers de victoria/derrota sobre una interfaz plana.             |
| **S3** | **Integración de Acciones:** Programación del árbol de 3 ramas y sus bifurcaciones. Sistema de deducción de presupuesto y aplicación de efectos.                              |
| **S4** | **Arte 2D Funcional:** Ilustración estática del mapa con las 3 zonas interactivas, íconos para cada acción y barras de progreso visuales.                                     |
| **S5** | **Alertas y Sistema de Derrames:** Lógica de focos rojos sobre las zonas y cálculo de filtración hacia la Reserva Biológica si se rebasan umbrales.                           |
| **S6** | **Pruebas y Exportación Móvil:** Compilación a Android (APK) / WebGL, ajustes de dificultad y validación con usuarios para confirmar que los roles se entienden sin manuales. |
