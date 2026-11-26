class_name GameBalance
extends RefCounted
## Tabla centralizada de parámetros de balance y constantes de simulación para Econtainment.

# Identificadores de las tres zonas del tablero
enum ZoneId {
	PRODUCTIVE,
	URBAN,
	RESERVE,
}

# Ramas del árbol de gestión
enum BranchType {
	AWARENESS,
	LEGISLATION,
	DIRECT_ACTION,
}

# Posibles resultados de la partida
enum GameResult {
	NONE,
	VICTORY,
	DEFEAT_COLLAPSE,
	DEFEAT_DISMISSAL,
}

# --- Configuración de tiempo (Ticks) ---
## Duración base de un tick (1 mes simulado) en segundos a velocidad 1x
const TICK_DURATION_SECONDS: float = 5.0
const SPEED_MULTIPLIER_SLOW: float = 0.5
const SPEED_MULTIPLIER_NORMAL: float = 1.0
const SPEED_MULTIPLIER_FAST: float = 1.5

# --- Condiciones de fin de partida ---
const VICTORY_HEALTH_THRESHOLD: float = 100.0
const VICTORY_TRUST_THRESHOLD: float = 70.0
const DEFEAT_THRESHOLD: float = 0.0

# --- Estado inicial del jugador y las zonas ---
const INITIAL_TRUST: float = 60.0
const INITIAL_BUDGET: int = 12
const INITIAL_PRODUCTIVE_POLLUTION: float = 35.0
const INITIAL_URBAN_POLLUTION: float = 30.0
const INITIAL_RESERVE_POLLUTION: float = 25.0

# --- Reglas de simulación por tick ---
## Emisión base de contaminantes por tick en cada zona
const BASE_EMISSION_PRODUCTIVE: float = 4.5
const BASE_EMISSION_URBAN: float = 3.5
const BASE_EMISSION_RESERVE: float = 0.0

## Regeneración natural base (solo la Reserva Biológica regenera por defecto)
const BASE_REGEN_RESERVE: float = 1.5

## Umbral de contaminación a partir del cual una zona derrama excedente a la Reserva
const SPILLOVER_POLLUTION_THRESHOLD: float = 50.0
## Proporción del excedente sobre el umbral que se filtra por tick hacia la Reserva
const SPILLOVER_TRANSFER_RATIO: float = 0.5
## Cantidad de derrame en un tick considerada severa (destruye humedales en maduración)
const SEVERE_SPILLOVER_THRESHOLD: float = 10.0

## Cambio pasivo de Confianza Ciudadana por tick según el estado de cada zona
const TRUST_GAIN_PER_HEALTHY_ZONE: float = 1.0
const TRUST_LOSS_PER_POLLUTED_ZONE: float = 1.8

## Ingreso base de Presupuesto Verde y rampa fiscal progresiva
const BASE_BUDGET_INCOME_PER_TICK: int = 10
const MIN_BUDGET_INCOME_PER_TICK: int = 4
const FISCAL_RAMP_STEP_TICKS: int = 3
const FISCAL_RAMP_BONUS_PER_STEP: int = 1
const FISCAL_RAMP_MAX_BONUS: int = 6

## Multiplicador de recaudación ligado exclusivamente a la Confianza Ciudadana
const TRUST_INCOME_MIN_MULTIPLIER: float = 0.45
const TRUST_INCOME_MAX_MULTIPLIER: float = 1.15

## Parámetros del sistema de burbujas interactivas (3 tipos por zona)
const BUBBLE_BUDGET_REWARD: int = 4
const BUBBLE_TRUST_REWARD: float = 2.0
const BUBBLE_RESERVE_POLLUTION_REDUCTION: float = 2.5
const BUBBLE_LIFETIME_SECONDS: float = 7.0
const BUBBLE_BASE_SPAWN_CHANCE: float = 0.35 #0.35
const BUBBLE_TRUST_SPAWN_BONUS: float = 0.45 #0.45
const BUBBLE_WATCH_MULTIPLIER: float = 1.45 #1.45
const BUBBLE_MAX_DRY_TICKS: int = 2

## Penalización base por alerta (foco rojo) ignorada; se duplica con Vigilancia Digital
const BASE_ALERT_TRUST_PENALTY: float = 5.0

# --- Balance inicial de las 9 acciones del MVP ---
## Diccionario maestro de parámetros por ID de acción para facilitar ajustes rápidos
const ACTION_PARAMS: Dictionary = {
	# Rama 1: Concientización
	&"waste_separation": {
		"cost": 10,
		"maintenance": 0,
		"delay_ticks": 0,
		"trust_delta": 5.0,
		"urban_emission_delta": -1.2,
	},
	&"neighborhood_watch": {
		"cost": 18,
		"maintenance": 1,
		"delay_ticks": 0,
		"trust_delta": 2.0,
		"early_alert": true,
		"missed_alert_multiplier": 2.0,
	},
	&"selective_boycott": {
		"cost": 15,
		"maintenance": 0,
		"delay_ticks": 0,
		"trust_delta": 4.0,
		"urban_emission_delta": -1.5,
		"budget_income_penalty": 3,
	},
	# Rama 2: Legislaciones
	&"emission_standards": {
		"cost": 12,
		"maintenance": 0,
		"delay_ticks": 0,
		"trust_delta": 0.0,
		"productive_emission_delta": -1.5,
	},
	&"punitive_closures": {
		"cost": 20,
		"maintenance": 0,
		"delay_ticks": 0,
		"trust_delta": -15.0,
		"productive_emission_delta": -3.0,
		"productive_mitigation_delta": 1.5,
	},
	&"circular_incentives": {
		"cost": 35,
		"maintenance": 0,
		"delay_ticks": 2,
		"trust_delta": 3.0,
		"productive_emission_delta": -2.5,
		"productive_mitigation_delta": 2.0,
	},
	# Rama 3: Acciones Directas
	&"emergency_crews": {
		"cost": 14,
		"maintenance": 1,
		"delay_ticks": 0,
		"trust_delta": 2.0,
		"urban_mitigation_delta": 1.5,
		"productive_mitigation_delta": 1.0,
	},
	&"grey_infrastructure": {
		"cost": 32,
		"maintenance": 4,
		"delay_ticks": 0,
		"trust_delta": 3.0,
		"urban_mitigation_delta": 3.0,
		"productive_mitigation_delta": 3.0,
	},
	&"bio_remediation": {
		"cost": 28,
		"maintenance": 0,
		"delay_ticks": 2,
		"trust_delta": 6.0,
		"reserve_regen_delta": 4.5,
		"vulnerable_to_spill": true,
	},
}
