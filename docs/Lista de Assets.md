# Lista de Cosas Necesarias por Obtener

Pantallas
- Menú Principal
- Pantalla del Juego
- Menú/s de Acciones
	- Acciones Directas
	- Legislaciones
	- Concientización
- Submenú de información de las acciones

Assets Necesarios por Pantalla
- Menú Principal
	- Logo
	- Fondo
- Pantalla del Juego
	- Reserva
		- Árboles
		- Plantas
		- *3 Estilos, Normal, Contaminado y Sano*
	- Zona Habitacional
		- Al menos 5 diseños de casas distintos
		- *3 Estilos, Normal, Contaminante y Sustentable*
	- Zona Industrial
		- Al menos 3 diseños de fábricas distintos
		- *3 Estilos, Normal, Contaminante y Sustentable*
	- Río/Riviera
		- *3 Estilos, Normal, Contaminado y Sano*
	- Fondo
		- Pasto y Cielo (*3 Estilos, Normal, Contaminado y Sano*)
	- Carreteras
	- Otros
		- Autos (*3 Estilos, Normal, Contaminante y Sustentable*)
		- Personas
		- *Estos podríamos no usarlos, mínima prioridad*
	- Botones
		- Si sobra tiempo planeamos botones más bonitos
- Menú/s de Acciones
	- Acciones Directas
		- Base de Maceta (Acción Inicial)
		- Ramas de arbolito (Conexiones)
		- Zonas de Hojas (Otras Acciones)
	- Legislaciones
		- Portafolio (Acción Inicial)
		- Montones de Hojas (Conexiones)
		- Papeles (Otras Acciones)
	- Concientización
		- Cartel Base (Acción Inicial)
		- Palitos (Conexiones)
		- Carteles (Otras Acciones)

# Bucle del Juego Base

- Cada Tick (5 segundos por ejemplo)

1. Se asigna el Presupuesto para Acciones
	- Más o menos dependiendo de la Autoridad y Salud Ambiental
2. El juego reajusta la Autoridad y la Salud Ambiental según las acciones activas$$\Delta \text{Contaminación} = \text{Emisiones} - \text{Mitigación} - \text{Regeneración Activa}$$
3. Se usa el presupuesto en Acciones
	- Cada acción tiene un costo fijo en el presupuesto
	- Afecta 2 posibles frentes
		- Autoridad
		- Tasa de Contaminación/Sanación