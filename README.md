# 🏫 High School Simulator 2024

Un juego completo de simulación escolar para Roblox inspirado en High School Simulator 2018, con sistemas avanzados de clases, socialización, personalización y progresión.

## 📋 Características Principales

### 🎓 Sistema de Clases
- **8 Materias Diferentes**: Matemáticas, Ciencias, Historia, Inglés, Educación Física, Arte, Música, Informática
- **Sistema de Calificaciones**: A+ hasta F con impacto en stats
- **Horarios Automáticos**: Clases programadas con descansos
- **Progresión de Stats**: Cada materia mejora diferentes habilidades

### 👥 Sistema Social
- **Sistema de Amigos**: Añadir y gestionar amistades
- **Stats Sociales**: Popularidad, Inteligencia, Atletismo, Creatividad
- **Interacciones**: Chat y actividades grupales
- **Eventos Sociales**: Actividades especiales del colegio

### 🎨 Personalización Completa
- **Uniformes Variados**: 4 estilos diferentes con precios
- **Tonos de Piel**: 5 opciones realistas
- **Peinados**: Múltiples estilos disponibles
- **Accesorios**: Gafas, mochilas, relojes, auriculares

### 🏢 Mapa Escolar Detallado
- **8 Aulas Temáticas**: Cada una diseñada para su materia
- **Cafetería**: Con mesas y contador de comida
- **Gimnasio**: Cancha de baloncesto completa
- **Biblioteca**: Área de estudio tranquila
- **Pasillos**: Conectan todas las áreas
- **Patio Exterior**: Espacio recreativo con árboles

### 💰 Sistema Económico
- **Dinero Virtual**: Gana dinero completando clases
- **Tienda**: Compra uniformes, accesorios y mejoras
- **Experiencia**: Sistema de niveles y progresión
- **Leaderstats**: Muestra nivel y dinero del jugador

## 🚀 Instalación y Configuración

### Archivo Principal:
**HighSchoolSimulator.lua** - Script completo del servidor (TODO EN UNO)

### Pasos de Instalación:

1. **Crear el Juego en Roblox Studio**
   - Abre Roblox Studio
   - Crea un nuevo lugar/juego

2. **Instalar el Script**
   - Coloca `HighSchoolSimulator.lua` en **ServerScriptService**
   - ¡Eso es todo!

3. **Ejecutar el Juego**
   - Presiona F5 para probar el juego
   - El mapa, GUI y todos los sistemas se crearán automáticamente

## 🎮 Cómo Jugar

### Controles Básicos:
- **WASD** - Movimiento
- **Espacio** - Saltar
- **Mouse** - Mirar alrededor
- **Click** - Interactuar con objetos

### Comandos:
- Haz click en las puertas de las aulas para unirte a clases
- Usa los botones de la GUI para unirte a clases

### Interfaz de Usuario:
- **Pestaña Stats** - Ver tus estadísticas actuales
- **Pestaña Clases** - Unirse a clases disponibles
- **Pestaña Social** - Gestionar amigos
- **Pestaña Tienda** - Comprar items y mejoras

### Progresión:
1. **Únete a Clases** - Haz click en las puertas o usa la GUI
2. **Completa Clases** - Gana experiencia y mejora stats
3. **Gana Dinero** - Recibe recompensas por buen rendimiento
4. **Compra Mejoras** - Usa el dinero en la tienda
5. **Socializa** - Haz amigos para aumentar popularidad

## 🔧 Personalización y Configuración

### Modificar Configuraciones:
En `HighSchoolSimulator.lua`, busca la sección CONFIGURACIÓN:
```lua
local Config = {
    Classes = {"Matemáticas", "Ciencias", "Historia", "Inglés", "Ed. Física", "Arte", "Música", "Informática"},
    ClassDuration = 180,    -- Duración de clases (segundos)
    BreakDuration = 60,     -- Duración de descansos
    StartingMoney = 100     -- Dinero inicial
}
```

### Añadir Nuevas Materias:
Simplemente añade el nombre a la lista de Classes en Config

## 📊 Sistemas Técnicos

### DataStore:
- Guarda automáticamente el progreso del jugador
- Incluye stats, dinero, nivel, amigos, inventario
- Carga datos al unirse y guarda al salir

### Eventos Remotos:
- `UpdatePlayerData` - Actualizar datos del jugador
- `ClassSystem` - Gestión de clases
- `SocialSystem` - Sistema social
- `CustomizationEvents` - Personalización

### Optimización:
- Scripts modulares para fácil mantenimiento
- Sistema de eventos eficiente
- Construcción automática del mapa
- GUI responsiva y optimizada

## 🎯 Características Avanzadas

### Sistema de Clases Inteligente:
- Clases se inician automáticamente
- Múltiples jugadores por clase
- Diferentes profesores por materia
- Sistema de asistencia

### IA Social:
- NPCs estudiantes (expandible)
- Eventos aleatorios del colegio
- Sistema de reputación
- Actividades extracurriculares

### Progresión Compleja:
- Múltiples paths de progresión
- Desbloqueo de contenido por nivel
- Logros y recompensas
- Rankings de estudiantes

## 🛠️ Solución de Problemas

### Problemas Comunes:

1. **El mapa no se carga**
   - Verifica que MapBuilder.lua esté en ServerScriptService
   - Revisa la consola de salida para errores

2. **La GUI no aparece**
   - Asegúrate de que ClientGUI.lua esté en StarterPlayerScripts
   - Verifica que los RemoteEvents se hayan creado

3. **Los datos no se guardan**
   - Habilita API de DataStore en configuraciones del juego
   - Verifica que el juego esté publicado para usar DataStore

4. **Errores de personalización**
   - Revisa que CustomizationSystem.lua esté ejecutándose
   - Verifica los IDs de assets si usas texturas personalizadas

## 🔄 Actualizaciones Futuras

### Próximas Características:
- Sistema de clubes estudiantiles
- Eventos especiales (bailes, competencias)
- Más opciones de personalización
- Sistema de tareas y misiones
- Modo multijugador mejorado
- Sistema de calificaciones más complejo

## 📝 Créditos

Desarrollado como una recreación completa de High School Simulator 2018 con mejoras modernas y sistemas expandidos.

### Tecnologías Utilizadas:
- Roblox Studio
- Lua Programming
- Roblox DataStore API
- Roblox GUI System
- Roblox Lighting Service

---

**¡Disfruta tu experiencia en High School Simulator 2024!** 🎓✨