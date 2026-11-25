extends Node
## Bus global de señales para desacoplar la simulación de la interfaz de usuario.

# Señales del ciclo de simulación por ticks
@warning_ignore("unused_signal")
signal tick_started(tick_number: int)
@warning_ignore("unused_signal")
signal tick_completed(tick_number: int)
@warning_ignore("unused_signal")
signal time_scale_changed(is_paused: bool, speed_multiplier: float)

# Señales de estado de métricas y zonas
@warning_ignore("unused_signal")
signal game_state_updated(
	health: float,
	trust: float,
	budget: int,
	health_delta: float,
	trust_delta: float,
	budget_delta: int
)
@warning_ignore("unused_signal")
signal zone_updated(zone_id: int, pollution: float)
@warning_ignore("unused_signal")
signal spillover_occurred(from_zone_id: int, amount: float)

# Señales de acciones y alertas
@warning_ignore("unused_signal")
signal action_unlocked(action_id: StringName)
@warning_ignore("unused_signal")
signal action_activated(action_id: StringName)
@warning_ignore("unused_signal")
signal action_repealed(action_id: StringName)
@warning_ignore("unused_signal")
signal action_destroyed(action_id: StringName)
@warning_ignore("unused_signal")
signal budget_depleted()
@warning_ignore("unused_signal")
signal alert_triggered(zone_id: int, alert_id: StringName)
@warning_ignore("unused_signal")
signal alert_resolved(zone_id: int, alert_id: StringName)
@warning_ignore("unused_signal")
signal bubble_spawned(zone_id: int)
@warning_ignore("unused_signal")
signal bubble_collected(zone_id: int)

# Señal de fin de partida (usa GameBalance.GameResult)
@warning_ignore("unused_signal")
signal game_ended(result: int)
