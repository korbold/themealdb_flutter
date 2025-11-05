# Prueba Técnica - Flutter

Aplicación Flutter que implementa gestión de estado con Cubit, persistencia local con Hive, y consumo de API pública.

## Descripción

Esta aplicación permite:
- Buscar platos de comida desde una API pública (TheMealDB)
- Guardar platos favoritos con nombres personalizados
- Gestionar una lista de gustos guardados localmente
- Ver detalles de cada plato guardado

## Requisitos

- Flutter SDK 3.8.1 o superior
- Dart SDK 3.8.1 o superior
- Conexión a internet (para consumir la API)

## Instalación

1. Clona el repositorio o descarga el proyecto
2. Asegúrate de tener Flutter instalado y configurado
3. Ejecuta el siguiente comando para instalar las dependencias:

```bash
flutter pub get
```

## Ejecución

Para ejecutar la aplicación en modo desarrollo:

```bash
flutter run
```

Para ejecutar en un dispositivo específico:

```bash
flutter run -d <device-id>
```

Para ver los dispositivos disponibles:

```bash
flutter devices
```

## Estructura del Proyecto

El proyecto sigue una arquitectura basada en features (feature-first) con separación de responsabilidades:

```
lib/
├── core/
│   ├── models/              # Modelos de datos (API y local)
│   ├── repositories/        # Repositorios para persistencia local
│   ├── routes/              # Configuración de rutas (go_router)
│   ├── services/            # Servicios para consumo de API
│   └── widgets/             # Widgets reutilizables
├── features/
│   ├── api/                 # Feature de búsqueda de API
│   │   ├── cubit/           # ApiCubit y estados
│   │   └── view/            # Pantallas relacionadas con API
│   └── preferences/         # Feature de preferencias guardadas
│       ├── cubit/           # PreferenceCubit y estados
│       └── view/            # Pantallas de gestión de preferencias
└── main.dart                # Punto de entrada de la aplicación
```

## Características Implementadas

### 1. Clean Code & Buenas Prácticas
- ✅ Código legible y modular
- ✅ Funciones cortas con nombres descriptivos
- ✅ Sin duplicación de lógica
- ✅ Null Safety en todo el proyecto

### 2. Gestión de Estado - Cubit
- ✅ **ApiCubit**: Gestiona la obtención de datos desde la API
  - Estados: `ApiInitial`, `ApiLoading`, `ApiSuccess`, `ApiError`
- ✅ **PreferenceCubit**: Gestiona los ítems locales (CRUD)
  - Estados: `PreferenceInitial`, `PreferenceLoading`, `PreferenceSuccess`, `PreferenceDetailSuccess`, `PreferenceError`

### 3. Persistencia Local
- ✅ Base de datos local con Hive
- ✅ Modelos y adaptadores correctamente definidos
- ✅ Operaciones CRUD completas y persistentes

### 4. Consumo de API Pública
- ✅ API utilizada: TheMealDB (https://www.themealdb.com/api.php)
- ✅ Mapeo JSON a modelos Dart con `fromJson` / `toJson`
- ✅ Estados: loading, success, error
- ✅ Indicador visual de carga (CircularProgressIndicator)
- ✅ Manejo de errores con mensajes descriptivos y opción de reintento

### 5. Interfaz de Usuario (UI)
- ✅ Diseño responsive adaptable a distintos tamaños de pantalla
- ✅ Uso coherente de márgenes, paddings y tamaños relativos

### 6. Navegación
- ✅ Rutas nombradas con go_router
- ✅ Rutas implementadas:
  - `/api-list` → Listado de ítems desde la API
  - `/prefs` → Listado de ítems guardados
  - `/prefs/new` → Crear nuevo gusto
  - `/prefs/:id` → Detalle de un gusto específico

## Pantallas

### 1. Listado de Ítems de la API (/api-list)
- ListView de elementos con búsqueda en tiempo real
- Spinner de carga
- Manejo de error con botón "Reintentar"
- Campo de búsqueda para filtrar platos

### 2. Crear Nuevo elemento en la BD (/prefs/new)
- Selector para elegir ítem de la API
- Campo de texto para nombre personalizado
- Botones "Guardar" y "Cancelar"
- Validación de formulario

### 3. Lista de elementos Guardados (/prefs)
- ListView de ítems guardados (nombre + imagen)
- Opción de eliminar desde la lista
- Estado vacío con mensaje y botón para agregar

### 4. Detalle de elemento (/prefs/:id)
- Muestra nombre personalizado, imagen y datos relevantes
- Botones "Eliminar" y "Volver"
- Información completa del plato

### 5. Pantalla Global de Carga
- Widget centrado con CircularProgressIndicator
- Mensaje opcional de carga

### 6. Pantalla Global de Error
- Mensaje amigable
- Botón "Reintentar"

### 7. Buscador de Ítems
- Campo de texto que permite buscar en la API en tiempo real
- Estados visuales (loading, success, error)
- Integrado en la pantalla `/api-list`

## Dependencias Principales

- `flutter_bloc`: Gestión de estado con Cubit
- `hive` / `hive_flutter`: Persistencia local
- `go_router`: Navegación con rutas nombradas
- `http`: Cliente HTTP para consumo de API
- `equatable`: Comparación de objetos

## API Utilizada

**TheMealDB**: API gratuita de recetas y platos
- Endpoint base: `https://www.themealdb.com/api/json/v1/1`
- Endpoints utilizados:
  - `/search.php?s={query}` - Búsqueda de platos
  - `/random.php` - Plato aleatorio
  - `/lookup.php?i={id}` - Plato por ID

## Documentación

El código está documentado con comentarios en puntos clave:
- Modelos de datos
- Cubits y estados
- Servicios y repositorios
- Widgets principales

## Decisiones técnicas

- **Arquitectura de estado con Cubit (flutter_bloc)**
  - Separación clara entre lógica y UI en `lib/features/**/cubit/`.
  - Estados explícitos para carga/éxito/error facilitan testabilidad y mantenimiento.

- **Estados tipados con Equatable**
  - `PreferenceState` y variantes (`PreferenceInitial`, `PreferenceLoading`, `PreferenceSuccess`, `PreferenceDetailSuccess`, `PreferenceError`) en `lib/features/preferences/cubit/preference_state.dart`.
  - Comparación por valor optimiza renderizados y evita bugs por referencias.

- **Patrón Repositorio**
  - `PreferenceRepository` (usado por los Cubits) aísla la fuente de datos local en `lib/core/repositories/`.
  - Permite mocks y cambios de implementación sin afectar la capa de presentación.

- **Separación Lista vs. Detalle**
  - `PreferenceListCubit` para CRUD de colección y `PreferenceDetailCubit` para lectura por id (`lib/features/preferences/cubit/`).
  - Cubits pequeños y específicos, menor acoplamiento.

- **Inicialización temprana del estado global**
  - `MultiBlocProvider` crea `PreferenceListCubit` con `..init()` y `lazy: false` en `lib/main.dart`.
  - La lista se hidrata al arranque para evitar parpadeos de contenido vacío.

- **Navegación declarativa con go_router**
  - Uso de `MaterialApp.router` y `AppRouter.router` en `lib/main.dart` y `lib/core/routes/`.
  - Deep linking y configuración de rutas más sencilla.

- **Inyección de dependencias simple**
  - Los Cubits aceptan `PreferenceRepository?` con valor por defecto interno (`lib/features/preferences/cubit/*.dart`).
  - Facilita pruebas y reemplazo de implementaciones.

- **Manejo de errores y observabilidad**
  - Estado `PreferenceError` y logging con `ExceptionLogger.writeException` en `lib/features/preferences/view/preference_detail_page.dart`.
  - UX con reintento y trazabilidad en errores.

- **UX robusta ante recursos remotos**
  - `Image.network` con `errorBuilder` y placeholders, confirmación antes de eliminar (`preference_detail_page.dart`).
  - Evita fallos por imágenes rotas y acciones destructivas accidentales.

- **Actualización reactiva tras mutaciones**
  - `create/update/delete` terminan en `loadAllPreferences()` en `preference_list_cubit.dart` y `preference_cubit.dart`.
  - Garantiza consistencia de la lista sin gestionar difs manuales.

- **Modelado de dominio claro**
  - `LocalPreferenceModel.fromApiMeal(...)` desacopla el modelo local de la respuesta de API (`lib/core/models/`).
  - Permite evolucionar el contrato externo sin impactar la UI.

- **Material 3 y theming por esquema**
  - `ThemeData` con `ColorScheme.fromSeed` y `useMaterial3: true` en `lib/main.dart`.
  - Estilo consistente y moderno con personalización sencilla.

## Autor

Desarrollado como prueba técnica implementando todas las características solicitadas.

## Licencia

Este proyecto es una prueba técnica.
