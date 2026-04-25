Descripción del Proyecto: "Viry" - App de Realidad Aumentada (AR) Interactiva para Modelos 3D (Fase iOS)

Requisito Fundamental de Desarrollo:

Idioma: Absolutamente todo lo que se desarrolle para este proyecto (código fuente, nombres de variables, base de datos, documentación técnica, repositorios y la interfaz de usuario final) debe estar estrictamente en Inglés.

Objetivo Principal:
Desarrollar una aplicación móvil nativa para iOS que permita a los usuarios importar modelos 3D personalizados, renderizarlos en el entorno real utilizando la cámara del dispositivo (Realidad Aumentada) y generar una interfaz dinámica de controles para ejecutar animaciones específicas y efectos de sonido asociados al modelo.

Stack Tecnológico Requerido (Fase iOS):

Plataforma: iOS nativo (iOS 16.0+ recomendado).

Lenguaje: Swift.

Framework de Interfaz: SwiftUI.

Motor AR/3D: ARKit (para el seguimiento espacial y entendimiento del entorno) integrado con RealityKit (el motor de renderizado 3D de alto rendimiento de Apple, optimizado para manejar archivos .usdz con animaciones y físicas integradas).

Arquitectura: MVVM (Model-View-ViewModel) para separar la lógica de la UI (SwiftUI) de la sesión de realidad aumentada (ARView).

Características Principales (Core Features):

Carga Dinámica de Modelos 3D (Dynamic 3D Model Loading):

Módulo que utilice UIDocumentPickerViewController para permitir al usuario seleccionar y cargar archivos .usdz o .reality directamente desde la app Archivos (Files) de iOS o iCloud Drive.

Soporte para inspeccionar la entidad (Entity) cargada en RealityKit y extraer las animaciones disponibles (availableAnimations).

Renderizado AR y Posicionamiento (AR Rendering & Positioning):

Uso de ARKit para el seguimiento espacial (World Tracking) y detección de planos horizontales y verticales.

Funcionalidad de anclaje mediante AnchorEntity: el modelo 3D debe anclarse (Raycasting) de forma estable en la coordenada física real donde el usuario toque la pantalla.

Generación de Interfaz de Controles Dinámica (Dynamic Control UI Generation):

Sistema en SwiftUI que permita al usuario crear botones flotantes o paneles de control superpuestos a la vista de la cámara (Camera Overlay).

El usuario debe poder personalizar el texto/nombre de cada botón y vincularlo explícitamente a una de las animaciones detectadas dentro de la entidad 3D.

Ejecución de Animaciones y Sincronización de Audio (Animation Execution & Audio Sync):

Lógica de eventos: al presionar un botón de la UI de SwiftUI, RealityKit debe reproducir la animación correspondiente (playAnimation).

Sistema de audio integrado (usando los componentes de audio espacial de RealityKit o AVFoundation) para vincular y reproducir un efecto de sonido simultáneamente con el inicio de la animación.

Flujo de Usuario (User Flow) Esperado:

El usuario inicia "Viry" y concede los permisos de cámara pertinentes.

Importa un modelo 3D en formato .usdz (por ejemplo, el modelo de un gatito).

La aplicación escanea el entorno, detecta la superficie física, el usuario toca la pantalla y el modelo aparece en el entorno real de forma inmersiva.

El usuario accede al menú de configuración para agregar controles: crea un botón en la interfaz (ej. "Jump") y lo enlaza a la animación detectada en el archivo. Añade un archivo de audio complementario desde su dispositivo.

El usuario vuelve a la vista principal y, al presionar el botón interactivo, el modelo 3D ejecuta la animación fluida de RealityKit junto con el sonido asociado.