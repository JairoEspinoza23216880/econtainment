Leyendo todas las soluciones creo que las mejores opciones sinérgicas son las siguientes
- Una partida inicia pausada y con un pop up que explica muy resumidamente el funcionamiento del juego, sin `TICK_DURATION_SECONDS` configurable, aumentándolo en el `game_balance.gd` a 10s
- Forzar la pausa en la `ActionsScreen` y desactivar los controles de tiempo mientras estás en ella
- Reducir la cantidad inicial de presupuesto y añadiendo el coste de mantenimiento a las acciones, me parece la forma más justificada dentro del contexto, el endgame se balancea solo, más acciones es igual a más rapidez para avanzar, pero a su vez esto hace que tengas menos dinero sobrante por ronda para activar otras acciones, y malas decisiones llevan a tener que derrogar acciones, aunque creo que debería ser más explícito el juego con el tema de las finanzas, tal vez añadiendo un pop up que resume la economía del juego, balancear también el coste inicial de las acciones, el coste de mantenimiento y el presupuesto mensual asignado
- Confianza Ciudadana que decrece en contaminación y aumenta en Sanidad

Y algunas mejorar QoL y extras:
- Un indicador de "+X.00" 0 "-X.00" con colores verde y rojo para que el jugador entienda que está recibiendo dinero
- Indicaciones similares a las de cambio de dinero, pero para Salud Ambiental y Confianza Ciudadana
- Añadir la opción de x3 para que al final el jugador no tenga que esperar mucho, especialmente al aumentar el tiempo por mes a 10s