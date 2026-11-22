# Diseño de Pantallas
## Menú
`margins` transparentes por los 4 lados
Título Grande, Anclado a Esquina Superior Izquierda (Dentro de los `margins`)
Botones Jugar y Salir Debajo

## Pantalla de Juego
Botón Menú (Renaudar o Salir) en esquina superior derecha
2 Zonas principales: Juego y GUI
Juego
- Zona Superior
- Grande, ocupa la mayoría de la pantalla
- La zona donde se ven la ciudad
GUI
- `Hbox`
- Botón para abrir menú de Acciones a la izquierda
- Derecha, en `VBox` indicadores de nivel de Salud Ambiental y Autoridad 

## Pantalla de Acciones
Mantiene la zona de GUI base de la Pantalla de Juego
La zona de "Juego" es reemplazada por las acciones
Botones en estructura de árbol (raíz abajo) con las decisiones en la mitad izquierda
- Hacerlo automático dependiendo de una lista de instrucciones
- También scrolleable en 2D si tiene muchas deciones
En la mitad derecha, espacio de texto para información de las decisiones
