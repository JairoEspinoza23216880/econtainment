# **Fichas técnicas de las acciones de Econtainment** 

Configuración de las 36 acciones del árbol de habilidades. Cada ficha incluye los campos para definir un recurso .tres en resources/actions/, con los textos que verá el jugador, los requisitos de desbloqueo y los parámetros de simulación. 

### **Convenciones de la configuración** 

El encabezado de la ficha contiene el campo title. Los códigos CU-01, LP-04 y similares permiten localizar las fichas. El campo prerequisites contiene los ID internos en inglés. Una acción queda disponible cuando todos sus requisitos están activos. La lista [] indica una raíz. 

Un tick equivale a un mes de juego. La confianza cambia una vez al activarse la acción. Los modificadores de zona se aplican por mes mientras esté activa. El valor de penalización al ingreso indica cuánto se descuenta. 

En la tabla de efectos, el prefijo de zona se une al sufijo de la columna. Por ejemplo, urban y _emission_delta forman urban_emission_delta. El decimal 0.0 indica un campo sin efecto. 

Fuentes de diseño. Guía para Crear Acciones.pdf, secciones 2 y 3. Econtainment_Arbol_de_Habilidades.docx. Los antecedentes del caso real se consultan por código en Econtainment_Reporte_de_Casos.docx. 

### **Índice de acciones** 

|**Concientización**|**Legislaciones**|**Acciones Directas**|
|---|---|---|
|CU-01  Separar y donar tapitas|LU-02  Corregir vertidos jabonosos|GU-02  Atender fugas domésticas|
|CU-03  Rodadas vecinales|LU-01  Retirar bolsas de las cajas|GU-01  Descacharrización masiva|
|CU-02  Recolectar aceite usado|LU-03  Verificar trampas de grasa|GU-03  Operar celdas de relleno|
|CU-04  Rescatar alimentos|LU-04  Regular el escombro de obras|GU-04  Modernizar rutas de transporte|
|CP-04  Medir descargas de granjas|LP-02  Asegurar residuos peligrosos|GP-01  Reparar un rastro municipal|
|CP-03  Denuncia popular colectiva|LP-04  Condicionar una ampliación|GP-02  Impulsar hornos ladrilleros|
|CP-01  Reportar emisiones de una<br>calera|LP-01  Exigir reportes a fundidoras|GP-04  Cofinanciar biodigestores|
|CP-02  Solicitar suspensión preventiva|LP-03  Clausurar por reincidencia|GP-03  Tratar aguas industriales|
|CB-04  Participar en la remediación|LB-01  Detener el relleno de un cenote|GB-01  Sanear cenotes prioritarios|
|CB-02  Limpiar un cenote|LB-02  Frenar lotificación en manglar|GB-04  Limpiar la ribera|
|CB-03  Limpiezas vecinales del río|LB-04  Exigir saneamiento tras<br>derrames|GB-03  Interceptar descargas con<br>colectores|
|CB-01  Rehabilitar canales del manglar|LB-03  Suspender descargas sin<br>permiso|GB-02  Operar planta para el río|



Econtainment  ·  1 

**CU-01  ·  Concientización  ·  Urbana** 

## **Separar y donar tapitas** 

### **Identidad y árbol** 

**ID interno** `(id)   sort_bottle_caps` 

**Rama** `(branch)` 0 · Concientización (Ciudadanía) 

**Requiere antes** `(prerequisites)   []` 

**Descripción** `(description)` Una colecta vecinal separa tapitas y las entrega para su aprovechamiento. **Ventajas** `(pros_text)` Reduce poco a poco el plástico acumulado en la zona urbana. 

**Riesgos** `(cons_text)` El alcance se limita a las tapitas recogidas. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`4`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|**`0.4`**|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  2 

**CU-03  ·  Concientización  ·  Urbana** 

## **Rodadas vecinales** 

### **Identidad y árbol** 

**ID interno** `(id)   neighborhood_bike_rides` 

**Rama** `(branch)` 0 · Concientización (Ciudadanía) 

**Requiere antes** `(prerequisites)   ["sort_bottle_caps"]` 

**Descripción** `(description)` Los vecinos organizan rodadas para sustituir algunos viajes cortos en automóvil. 

**Ventajas** `(pros_text)` Reduce las emisiones de los trayectos que pasan a bicicleta. 

**Riesgos** `(cons_text)` El beneficio depende de que se sustituyan viajes de manera habitual. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`5`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|**`-1.1`**|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  3 

**CU-02  ·  Concientización  ·  Urbana** 

## **Recolectar aceite usado** 

### **Identidad y árbol** 

**ID interno** `(id)   collect_used_cooking_oil` **Rama** `(branch)` 0 · Concientización (Ciudadanía) **Requiere antes** `(prerequisites)   ["neighborhood_bike_rides"]` **Descripción** `(description)` Los hogares entregan aceite de cocina usado en puntos de acopio. **Ventajas** `(pros_text)` Disminuye el aceite que llega al drenaje doméstico. **Riesgos** `(cons_text)` La separación requiere puntos de recepción y entregas regulares. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`7`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|**`-0.4`**|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  4 

**CU-04  ·  Concientización  ·  Urbana** 

## **Rescatar alimentos** 

### **Identidad y árbol** 

**ID interno** `(id)   rescue_surplus_food` 

**Rama** `(branch)` 0 · Concientización (Ciudadanía) **Requiere antes** `(prerequisites)   ["collect_used_cooking_oil"]` 

**Descripción** `(description)` Una red recupera alimentos aptos para consumo antes de que se desechen. **Ventajas** `(pros_text)` Disminuye los residuos orgánicos de los establecimientos participantes. **Riesgos** `(cons_text)` La red depende de donantes y del manejo seguro de los alimentos. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`9`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|**`-0.2`**|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  5 

**CP-04  ·  Concientización  ·  Productiva** 

## **Medir descargas de granjas** 

### **Identidad y árbol** 

**ID interno** `(id)   monitor_farm_discharges` **Rama** `(branch)` 0 · Concientización (Ciudadanía) 

**Requiere antes** `(prerequisites)   []` 

**Descripción** `(description)` Un colectivo toma muestras cerca de granjas y publica lo observado. **Ventajas** `(pros_text)` Aporta evidencia y aumenta la confianza por el acceso a información. **Riesgos** `(cons_text)` El muestreo describe sitios concretos y deja pendiente controlar la fuente. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`3`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`2.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  6 

**CP-03  ·  Concientización  ·  Productiva** 

## **Denuncia popular colectiva** 

### **Identidad y árbol** 

**ID interno** `(id)   file_collective_complaint` 

**Rama** `(branch)` 0 · Concientización (Ciudadanía) 

**Requiere antes** `(prerequisites)   ["monitor_farm_discharges"]` 

**Descripción** `(description)` Una comunidad reúne reportes y presenta una denuncia ante las autoridades. **Ventajas** `(pros_text)` Organiza el seguimiento público y suma confianza. 

**Riesgos** `(cons_text)` La reducción de contaminación requiere una intervención posterior. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`4`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`3.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  7 

**CP-01  ·  Concientización  ·  Productiva** 

## **Reportar emisiones de una calera** 

### **Identidad y árbol** 

**ID interno** `(id)   report_lime_kiln` **Rama** `(branch)` 0 · Concientización (Ciudadanía) **Requiere antes** `(prerequisites)   ["file_collective_complaint"]` **Descripción** `(description)` Una denuncia vecinal impulsa la inspección y el cese de una calera. **Ventajas** `(pros_text)` Reduce el aporte de la fuente una vez que se verifica el cese. **Riesgos** `(cons_text)` La inspección y el seguimiento retrasan el efecto. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`7`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|**`-1.1`**|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  8 

**CP-02  ·  Concientización  ·  Productiva** 

## **Solicitar suspensión preventiva** 

### **Identidad y árbol** 

**ID interno** `(id)   seek_preventive_suspension` 

**Rama** `(branch)` 0 · Concientización (Ciudadanía) 

**Requiere antes** `(prerequisites)   ["report_lime_kiln"]` 

**Descripción** `(description)` La comunidad solicita una orden cautelar para detener una actividad de alto riesgo. 

**Ventajas** `(pros_text)` Reduce el aporte de la fuente mientras la acción esté activa. 

**Riesgos** `(cons_text)` La suspensión tarda dos meses en activarse. La acción representa una medida cautelar vigente. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`9`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`2`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|**`-0.7`**|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  9 

**CB-04  ·  Concientización  ·  Reserva biológica** 

## **Participar en la remediación** 

### **Identidad y árbol** 

**ID interno** `(id)   join_river_remediation` 

**Rama** `(branch)` 0 · Concientización (Ciudadanía) 

**Requiere antes** `(prerequisites)   []` 

**Descripción** `(description)` Personas afectadas consiguen participar en las decisiones de remediación de un río. 

**Ventajas** `(pros_text)` Eleva la confianza al incorporar a la comunidad al proceso. 

**Riesgos** `(cons_text)` La recuperación depende de las medidas que se ejecuten después. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`3`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`3.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  10 

**CB-02  ·  Concientización  ·  Reserva biológica** 

## **Limpiar un cenote** 

### **Identidad y árbol** 

**ID interno** `(id)   clean_cenote_with_divers` 

**Rama** `(branch)` 0 · Concientización (Ciudadanía) 

**Requiere antes** `(prerequisites)   ["join_river_remediation"]` 

**Descripción** `(description)` Buzos y vecinos organizan el retiro de residuos en un cenote y sus alrededores. 

**Ventajas** `(pros_text)` La mitigación representa el retiro gradual de sólidos. 

**Riesgos** `(cons_text)` Las labores bajo el agua requieren personal especializado. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`5`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`0.7`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  11 

**CB-03  ·  Concientización  ·  Reserva biológica** 

## **Limpiezas vecinales del río** 

### **Identidad y árbol** 

**ID interno** `(id)   sustain_river_cleanups` **Rama** `(branch)` 0 · Concientización (Ciudadanía) **Requiere antes** `(prerequisites)   ["clean_cenote_with_divers"]` **Descripción** `(description)` Colectivos mantienen jornadas periódicas de limpieza a lo largo de un río. **Ventajas** `(pros_text)` Retiran residuos de varios tramos durante la partida. **Riesgos** `(cons_text)` Su alcance depende de la continuidad de las brigadas. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`8`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`0.9`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  12 

**CB-01  ·  Concientización  ·  Reserva biológica** 

## **Rehabilitar canales del manglar** 

### **Identidad y árbol** 

**ID interno** `(id)   restore_mangrove_channels` **Rama** `(branch)` 0 · Concientización (Ciudadanía) **Requiere antes** `(prerequisites)   ["sustain_river_cleanups"]` **Descripción** `(description)` Una brigada rehabilita canales del manglar para recuperar el flujo de agua. **Ventajas** `(pros_text)` Mejora la regeneración de la reserva a partir de la recuperación del flujo. **Riesgos** `(cons_text)` La respuesta del humedal toma tiempo. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`11`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`2`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|**`1.3`**|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  13 

**LU-02  ·  Legislaciones  ·  Urbana** 

## **Corregir vertidos jabonosos** 

### **Identidad y árbol** 

**ID interno** `(id)   correct_soapy_discharge` 

**Rama** `(branch)` 1 · Legislaciones (Empresas) 

**Requiere antes** `(prerequisites)   ["neighborhood_bike_rides", "file_collective_complaint"]` 

**Descripción** `(description)` La autoridad requiere a un negocio corregir la descarga de aguas jabonosas. **Ventajas** `(pros_text)` Reduce el aporte del establecimiento al drenaje urbano. 

**Riesgos** `(cons_text)` Su alcance se limita al vertido intervenido. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`5`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|**`-0.6`**|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  14 

**LU-01  ·  Legislaciones  ·  Urbana** 

## **Retirar bolsas de las cajas** 

### **Identidad y árbol** 

**ID interno** `(id)   restrict_checkout_bags` **Rama** `(branch)` 1 · Legislaciones (Empresas) **Requiere antes** `(prerequisites)   ["correct_soapy_discharge"]` **Descripción** `(description)` Se restringe la entrega de bolsas desechables en comercios. **Ventajas** `(pros_text)` Reduce la entrada de bolsas de un solo uso al flujo de residuos urbanos. **Riesgos** `(cons_text)` Su efecto depende de la adopción de alternativas reutilizables. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`6`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|**`-0.4`**|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  15 

**LU-03  ·  Legislaciones  ·  Urbana** 

## **Verificar trampas de grasa** 

### **Identidad y árbol** 

**ID interno** `(id)   inspect_grease_traps` **Rama** `(branch)` 1 · Legislaciones (Empresas) **Requiere antes** `(prerequisites)   ["restrict_checkout_bags"]` **Descripción** `(description)` Se verifica que los negocios mantengan trampas de grasa operativas. **Ventajas** `(pros_text)` Disminuye la grasa y los sólidos que llegan al drenaje. **Riesgos** `(cons_text)` El beneficio depende de la limpieza periódica de las trampas. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`8`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|**`-0.2`**|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  16 

**LU-04  ·  Legislaciones  ·  Urbana** 

## **Regular el escombro de obras** 

### **Identidad y árbol** 

**ID interno** `(id)   regulate_construction_debris` **Rama** `(branch)` 1 · Legislaciones (Empresas) **Requiere antes** `(prerequisites)   ["inspect_grease_traps"]` **Descripción** `(description)` Se exige que las obras envíen el escombro a lugares autorizados. **Ventajas** `(pros_text)` Reduce los residuos de construcción que acaban en la zona urbana. **Riesgos** `(cons_text)` El control requiere seguimiento de traslados y destinos. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`10`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|**`-0.1`**|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  17 

**LP-02  ·  Legislaciones  ·  Productiva** 

## **Asegurar residuos peligrosos** 

### **Identidad y árbol** 

**ID interno** `(id)   require_safe_waste_storage` 

**Rama** `(branch)` 1 · Legislaciones (Empresas) 

**Requiere antes** `(prerequisites)   ["neighborhood_bike_rides", "file_collective_complaint"]` 

**Descripción** `(description)` Una orden obliga a almacenar residuos peligrosos en condiciones adecuadas. **Ventajas** `(pros_text)` Reduce las fugas y el aporte contaminante del almacenamiento inseguro. 

**Riesgos** `(cons_text)` El efecto depende del control continuo del almacén. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`5`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|**`-1.1`**|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  18 

**LP-04  ·  Legislaciones  ·  Productiva** 

## **Condicionar una ampliación** 

### **Identidad y árbol** 

**ID interno** `(id)   require_land_use_permit` **Rama** `(branch)` 1 · Legislaciones (Empresas) **Requiere antes** `(prerequisites)   ["require_safe_waste_storage"]` **Descripción** `(description)` La ampliación se condiciona a que la empresa acredite el uso de suelo. **Ventajas** `(pros_text)` Evita una parte del aporte que produciría la expansión prevista. **Riesgos** `(cons_text)` La medida cubre la ampliación evaluada. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`7`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|**`-0.6`**|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  19 

**LP-01  ·  Legislaciones  ·  Productiva** 

## **Exigir reportes a fundidoras** 

### **Identidad y árbol** 

**ID interno** `(id)   require_smelter_reports` **Rama** `(branch)` 1 · Legislaciones (Empresas) **Requiere antes** `(prerequisites)   ["require_land_use_permit"]` **Descripción** `(description)` Se exigen reportes y se suspenden hornos que incumplen la obligación. **Ventajas** `(pros_text)` Reduce emisiones cuando se ejecuta la suspensión de los hornos. **Riesgos** `(cons_text)` Entregar reportes por sí solo deja la fuente en operación. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`9`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|**`-0.2`**|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  20 

**LP-03  ·  Legislaciones  ·  Productiva** 

## **Clausurar por reincidencia** 

### **Identidad y árbol** 

**ID interno** `(id)   close_repeat_offender` **Rama** `(branch)` 1 · Legislaciones (Empresas) **Requiere antes** `(prerequisites)   ["require_smelter_reports"]` **Descripción** `(description)` La autoridad clausura una instalación tras incumplimientos reiterados. **Ventajas** `(pros_text)` Retira el aporte de la instalación mientras siga clausurada. **Riesgos** `(cons_text)` Reduce la confianza al activarse y resta $1 de ingreso mensual. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`12`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`-4.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`1`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|**`-0.4`**|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  21 

**LB-01  ·  Legislaciones  ·  Reserva biológica** 

## **Detener el relleno de un cenote** 

### **Identidad y árbol** 

**ID interno** `(id)   stop_cenote_filling` 

**Rama** `(branch)` 1 · Legislaciones (Empresas) 

**Requiere antes** `(prerequisites)   ["neighborhood_bike_rides", "file_collective_complaint"]` 

**Descripción** `(description)` Se detiene una actividad privada que rellena un cenote sin autorización. **Ventajas** `(pros_text)` Amortigua la entrada de material en la reserva. 

**Riesgos** `(cons_text)` El material que ya entró requiere una intervención posterior. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`5`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`0.4`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  22 

**LB-02  ·  Legislaciones  ·  Reserva biológica** 

## **Frenar lotificación en manglar** 

### **Identidad y árbol** 

**ID interno** `(id)   halt_mangrove_subdivision` 

**Rama** `(branch)` 1 · Legislaciones (Empresas) **Requiere antes** `(prerequisites)   ["stop_cenote_filling"]` **Descripción** `(description)` La inspección detiene el avance de una lotificación sobre el manglar. **Ventajas** `(pros_text)` Disminuye la presión sobre el humedal intervenido. **Riesgos** `(cons_text)` La recuperación del daño previo requiere restauración. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`7`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`0.5`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  23 

**LB-04  ·  Legislaciones  ·  Reserva biológica** 

## **Exigir saneamiento tras derrames** 

### **Identidad y árbol** 

**ID interno** `(id)   enforce_spill_remediation` 

**Rama** `(branch)` 1 · Legislaciones (Empresas) 

**Requiere antes** `(prerequisites)   ["halt_mangrove_subdivision"]` 

**Descripción** `(description)` La empresa ejecuta medidas de contención y retiro tras la orden de la autoridad. 

**Ventajas** `(pros_text)` Representa el retiro gradual mediante saneamiento supervisado. 

**Riesgos** `(cons_text)` El efecto tarda mientras se organizan y ejecutan las medidas. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`9`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`0.7`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  24 

**LB-03  ·  Legislaciones  ·  Reserva biológica** 

## **Suspender descargas sin permiso** 

### **Identidad y árbol** 

**ID interno** `(id)   halt_unauthorized_discharge` **Rama** `(branch)` 1 · Legislaciones (Empresas) **Requiere antes** `(prerequisites)   ["enforce_spill_remediation"]` **Descripción** `(description)` La autoridad suspende una instalación que descarga sin permiso. **Ventajas** `(pros_text)` Interrumpe parte de la carga que alcanza el sistema hídrico. **Riesgos** `(cons_text)` La medida tiene un costo inicial de confianza por el conflicto local. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`11`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`-2.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`0.9`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  25 

**GU-02  ·  Acciones Directas  ·  Urbana** 

## **Atender fugas domésticas** 

### **Identidad y árbol** 

**ID interno** `(id)   repair_household_leaks` 

**Rama** `(branch)` 2 · Acciones Directas (Gobierno) 

**Requiere antes** `(prerequisites)   ["restrict_checkout_bags", "require_land_use_permit"]` 

**Descripción** `(description)` La cuadrilla pública atiende fugas reportadas en la red doméstica. **Ventajas** `(pros_text)` Mejora la confianza al restablecer el servicio en los puntos atendidos. 

**Riesgos** `(cons_text)` La cobertura se limita a los hogares atendidos. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`4`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`4.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  26 

**GU-01  ·  Acciones Directas  ·  Urbana** 

## **Descacharrización masiva** 

### **Identidad y árbol** 

**ID interno** `(id)   collect_bulky_waste` 

**Rama** `(branch)` 2 · Acciones Directas (Gobierno) 

**Requiere antes** `(prerequisites)   ["repair_household_leaks"]` 

**Descripción** `(description)` El municipio recoge cacharros en varias colonias mediante rondas coordinadas. 

**Ventajas** `(pros_text)` Retira residuos urbanos de forma gradual. 

**Riesgos** `(cons_text)` La recolección se limita a los residuos cubiertos por el operativo. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`7`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|**`1.5`**|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  27 

**GU-03  ·  Acciones Directas  ·  Urbana** 

## **Operar celdas de relleno** 

### **Identidad y árbol** 

**ID interno** `(id)   operate_landfill_cells` **Rama** `(branch)` 2 · Acciones Directas (Gobierno) **Requiere antes** `(prerequisites)   ["collect_bulky_waste"]` **Descripción** `(description)` El municipio opera celdas para recibir y confinar residuos urbanos. **Ventajas** `(pros_text)` Amplía la capacidad de mitigación de forma sostenida. 

**Riesgos** `(cons_text)` Requiere operación mensual y se suspende con presupuesto agotado. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`13`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`1`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|**`1.4`**|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`true`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  28 

**GU-04  ·  Acciones Directas  ·  Urbana** 

## **Modernizar rutas de transporte** 

### **Identidad y árbol** 

**ID interno** `(id)   modernize_bus_routes` **Rama** `(branch)` 2 · Acciones Directas (Gobierno) **Requiere antes** `(prerequisites)   ["operate_landfill_cells"]` **Descripción** `(description)` El gobierno renueva la operación de varias rutas de transporte público. **Ventajas** `(pros_text)` Reduce las emisiones de los viajes atendidos por las rutas modernizadas. **Riesgos** `(cons_text)` Requiere puesta en marcha y presupuesto para sostener la operación. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`16`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`1`**|
|Espera para activarse (meses)|`delay_ticks`|**`2`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|**`-1.0`**|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`true`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  29 

**GP-01  ·  Acciones Directas  ·  Productiva** 

## **Reparar un rastro municipal** 

### **Identidad y árbol** 

**ID interno** `(id)   repair_municipal_abattoir` 

**Rama** `(branch)` 2 · Acciones Directas (Gobierno) 

**Requiere antes** `(prerequisites)   ["restrict_checkout_bags", "require_land_use_permit"]` 

**Descripción** `(description)` El municipio repara equipo que presta servicio en el rastro. **Ventajas** `(pros_text)` Aumenta la confianza al recuperar la operación del servicio. 

**Riesgos** `(cons_text)` El alcance se concentra en una instalación pública. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`4`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`3.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  30 

**GP-02  ·  Acciones Directas  ·  Productiva** 

## **Impulsar hornos ladrilleros** 

### **Identidad y árbol** 

**ID interno** `(id)   operate_demo_brick_kilns` 

**Rama** `(branch)` 2 · Acciones Directas (Gobierno) 

**Requiere antes** `(prerequisites)   ["repair_municipal_abattoir"]` 

**Descripción** `(description)` Un programa público demuestra hornos más eficientes y acompaña su adopción. 

**Ventajas** `(pros_text)` Reduce emisiones de los talleres que usan el nuevo equipo. 

**Riesgos** `(cons_text)` El beneficio depende de la adopción efectiva en los talleres. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`8`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|**`-1.5`**|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  31 

**GP-04  ·  Acciones Directas  ·  Productiva** 

## **Cofinanciar biodigestores** 

### **Identidad y árbol** 

**ID interno** `(id)   cofund_biodigesters` **Rama** `(branch)` 2 · Acciones Directas (Gobierno) **Requiere antes** `(prerequisites)   ["operate_demo_brick_kilns"]` **Descripción** `(description)` Un programa público financia biodigestores que entran en operación. **Ventajas** `(pros_text)` Reduce el aporte de residuos orgánicos de las unidades atendidas. **Riesgos** `(cons_text)` Requiere instalación, operación mensual y presupuesto disponible. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`13`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`1`**|
|Espera para activarse (meses)|`delay_ticks`|**`2`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|**`-0.7`**|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`true`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  32 

**GP-03  ·  Acciones Directas  ·  Productiva** 

## **Tratar aguas industriales** 

### **Identidad y árbol** 

**ID interno** `(id)   treat_industrial_wastewater` **Rama** `(branch)` 2 · Acciones Directas (Gobierno) **Requiere antes** `(prerequisites)   ["cofund_biodigesters"]` **Descripción** `(description)` Una instalación pública trata efluentes de las industrias conectadas. **Ventajas** `(pros_text)` Mitiga la carga que se acumula en la zona productiva. 

**Riesgos** `(cons_text)` El tratamiento se limita al caudal admitido y requiere operación mensual. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`16`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`1`**|
|Espera para activarse (meses)|`delay_ticks`|**`2`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|**`1.7`**|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|`0.0`|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`true`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  33 

**GB-01  ·  Acciones Directas  ·  Reserva biológica** 

## **Sanear cenotes prioritarios** 

### **Identidad y árbol** 

**ID interno** `(id)   restore_priority_cenotes` 

**Rama** `(branch)` 2 · Acciones Directas (Gobierno) 

**Requiere antes** `(prerequisites)   ["restrict_checkout_bags", "require_land_use_permit"]` 

**Descripción** `(description)` Un programa público coordina saneamiento y diagnóstico en cenotes prioritarios. 

**Ventajas** `(pros_text)` Retira residuos de forma gradual en los sitios atendidos. 

**Riesgos** `(cons_text)` La cobertura se limita a los cenotes seleccionados por el programa. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`6`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`1.0`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  34 

**GB-04  ·  Acciones Directas  ·  Reserva biológica** 

## **Limpiar la ribera** 

### **Identidad y árbol** 

**ID interno** `(id)   clean_riverbanks` 

**Rama** `(branch)` 2 · Acciones Directas (Gobierno) 

**Requiere antes** `(prerequisites)   ["restore_priority_cenotes"]` 

**Descripción** `(description)` Un operativo público retira residuos sólidos de la ribera mediante rondas de limpieza. 

**Ventajas** `(pros_text)` Acelera el saneamiento de los tramos intervenidos. 

**Riesgos** `(cons_text)` Las descargas al río requieren medidas separadas. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`9`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`0`**|
|Espera para activarse (meses)|`delay_ticks`|**`0`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`1.3`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`false`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  35 

**GB-03  ·  Acciones Directas  ·  Reserva biológica** 

## **Interceptar descargas con colectores** 

### **Identidad y árbol** 

**ID interno** `(id)   intercept_sewer_discharges` 

**Rama** `(branch)` 2 · Acciones Directas (Gobierno) 

**Requiere antes** `(prerequisites)   ["clean_riverbanks"]` 

**Descripción** `(description)` Colectores conectados canalizan descargas hacia tratamiento antes de que lleguen al río. 

**Ventajas** `(pros_text)` Mitiga la carga que llega a la reserva al conducir las descargas a tratamiento. 

**Riesgos** `(cons_text)` La operación requiere presupuesto. La acción representa colectores conectados a una instalación de tratamiento operativa. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`12`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`1`**|
|Espera para activarse (meses)|`delay_ticks`|**`1`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`1.4`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`true`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`false`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  36 

**GB-02  ·  Acciones Directas  ·  Reserva biológica** 

## **Operar planta para el río** 

### **Identidad y árbol** 

**ID interno** `(id)   operate_river_treatment_plant` 

**Rama** `(branch)` 2 · Acciones Directas (Gobierno) 

**Requiere antes** `(prerequisites)   ["intercept_sewer_discharges"]` 

**Descripción** `(description)` Una planta pública trata aguas residuales antes de devolver el agua al río. **Ventajas** `(pros_text)` Aumenta de forma sostenida la mitigación en la reserva. 

**Riesgos** `(cons_text)` Un derrame severo puede destruir la planta. Su operación también depende del presupuesto. 

### **Economía y tiempos** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Costo inicial ($)|`cost_budget`|**`16`**|
|Mantenimiento mensual ($/mes)|`maintenance_per_tick`|**`1`**|
|Espera para activarse (meses)|`delay_ticks`|**`2`**|
|Impacto inmediato en confianza (pts)|`immediate_trust_delta`|**`0.0`**|
|Penalización al ingreso ($/mes)|`budget_income_penalty`|**`0`**|



### **Efecto en zonas por mes** 

|**Zona**|**Emisión**<br>`_emission_delta`|**Mitigación**<br>`_mitigation_delta`|**Regeneración**<br>`_regen_delta`|
|---|---|---|---|
|**Productiva**`productive`|`0.0`|`0.0`|`0.0`|
|**Urbana**`urban`|`0.0`|`0.0`|`0.0`|
|**Reserva biológica**`reserve`|`0.0`|**`2.0`**|`0.0`|



### **Reglas especiales** 

|**Parámetro**|**Campo del recurso**|**Valor**|
|---|---|---|
|Suspensión con presupuesto en $0|`requires_positive_budget`|**`true`**|
|Destrucción por derrame severo|`vulnerable_to_severe_spill`|**`true`**|
|Detección temprana|`grants_early_alert`|**`false`**|
|Multiplicador de alerta expirada|`missed_alert_penalty_multiplier`|**`1.0`**|



Econtainment  ·  37 

