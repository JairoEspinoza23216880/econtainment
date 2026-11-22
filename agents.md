## Convenciones de Desarrollo Godot 4.7.x
### Nomenclatura
- Archivos y Carpetas : snake_case
- Nodos y Clases : PascalCase
- Variables y funciones : snake_case
- Constantes y Enums : UPPER_SNAKE_CASE

### Estructura de Nodos y Escenas
- Preferir Composición sobre herencia
- Usar `@export` fuertemente tipado en lugar de `get_node`
- Comunicar hacia abajo con funciones, hacia arriba con señales

## Directivas de Trabajo
- Mantenerse exclusivamente en la carpeta `time-lapse`
- Recordar siempre que el proyecto está en Godot 4.7.X
- Aprovechar las herramientas MCP de godot-ai (inspección de escenas, crear nodos, verificar el editor) cuando sea necesario
- Documentar siempre el código generado
- No eliminar comentarios ya existentes, a menos que pertenezcan a código que será eliminado
- Código en Inglés, Comentarios en Español
- Filosofía KISS (Keep It Simple Stupid)