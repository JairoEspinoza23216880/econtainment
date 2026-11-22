class_name ActionData
extends Resource
## Recurso configurable que define una acción o política del árbol de gestión.

@export_group("Identity & Tree")
@export var id: StringName = &""
@export var branch: GameBalance.BranchType = GameBalance.BranchType.AWARENESS
@export var title: String = ""
@export_multiline var description: String = ""
@export_multiline var pros_text: String = ""
@export_multiline var cons_text: String = ""
## Lista de IDs de acciones prerrequisito; vacía indica nodo raíz de la rama
@export var prerequisites: Array[StringName] = []
@export var icon: Texture2D

@export_group("Costs & Timing")
@export var cost_budget: int = 10
@export var maintenance_per_tick: int = 0
## Ticks necesarios para que la acción madure y entre en vigor (0 = inmediato)
@export var delay_ticks: int = 0
## Cambio inmediato en la Confianza Ciudadana al activar (negativo = impopular)
@export var immediate_trust_delta: float = 0.0
## Reducción al ingreso de Presupuesto Verde por tick mientras esté activa
@export var budget_income_penalty: int = 0

@export_group("Productive Zone Modifiers")
@export var productive_emission_delta: float = 0.0
@export var productive_mitigation_delta: float = 0.0
@export var productive_regen_delta: float = 0.0

@export_group("Urban Zone Modifiers")
@export var urban_emission_delta: float = 0.0
@export var urban_mitigation_delta: float = 0.0
@export var urban_regen_delta: float = 0.0

@export_group("Reserve Zone Modifiers")
@export var reserve_emission_delta: float = 0.0
@export var reserve_mitigation_delta: float = 0.0
@export var reserve_regen_delta: float = 0.0

@export_group("Special Rules")
## Revela alertas con 1 tick de anticipación
@export var grants_early_alert: bool = false
## Multiplicador de penalización si una alerta expira sin resolverse
@export var missed_alert_penalty_multiplier: float = 1.0
## Si es true, la acción se suspende automáticamente cuando el presupuesto llega a 0
@export var requires_positive_budget: bool = false
## Si es true, un derrame severo destruye la infraestructura y obliga a reconstruirla
@export var vulnerable_to_severe_spill: bool = false
