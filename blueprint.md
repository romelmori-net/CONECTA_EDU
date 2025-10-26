# Blueprint: ConectaEDU - App de Bienestar Estudiantil

## Visión General

ConectaEDU es una aplicación móvil diseñada para ser un pilar de apoyo para estudiantes, ofreciendo un ecosistema integral para su bienestar académico, emocional y social. La aplicación proporciona herramientas personalizadas y recursos para ayudar a los estudiantes a navegar los desafíos de su vida académica, fomentando un desarrollo equilibrado y saludable.

---

## Funcionalidades Implementadas

A la fecha, la aplicación cuenta con una base sólida y funcional que incluye:

1.  **Flujo de Autenticación Completo y Seguro:**
    *   **Registro y Login:** Los usuarios pueden crear cuentas o iniciar sesión usando correo y contraseña a través de Firebase Authentication.
    *   **Selección de Rol:** Al registrarse, los usuarios eligen su rol (Estudiante, Tutor, etc.), lo que permite una experiencia personalizada.
    *   **Persistencia de Sesión:** La app recuerda al usuario, evitando la necesidad de iniciar sesión repetidamente.

2.  **Proceso de Onboarding Inteligente y Multi-paso:**
    *   Tras el primer registro, el usuario pasa por un proceso de onboarding de tres etapas: **Académico, Emocional y Social**.
    *   Toda la información recopilada se guarda de forma segura en el perfil del usuario en Firestore.

3.  **Gestión de Estado y Redirección Automática:**
    *   La app detecta automáticamente el estado de autenticación del usuario.
    *   Verifica si el usuario ha completado el onboarding y lo redirige a la pantalla correspondiente (`WelcomeScreen`, `OnboardingScreen`, o `HomeScreen`).

4.  **Pantalla Principal (Home) con Navegación Intuitiva:**
    *   Una pantalla principal (`HomeScreen`) actúa como el centro de la aplicación.
    *   Incluye una barra de navegación inferior con 5 secciones: **Inicio (Dashboard), Académico, Emocional, Social y Perfil**.
    *   La estructura de archivos de las pantallas ha sido refactorizada para máxima escalabilidad y orden.

5.  **Diseño Moderno y Atractivo:**
    *   La interfaz incorpora elementos de diseño modernos como **Glassmorphism** y **Neomorphism** para una experiencia de usuario única y agradable.
    *   Uso de `google_fonts` para una tipografía limpia y legible.

---

## Plan de Desarrollo Actual

Nuestra prioridad ahora es construir sobre la base sólida que hemos creado.

1.  **Implementar la Funcionalidad "Chat con Tutor":**
    *   **Paso 1:** Crear la interfaz de usuario para la pantalla de chat (`chat_screen.dart`).
    *   **Paso 2:** Conectar el `FloatingActionButton` de la pantalla principal para que navegue a la pantalla de chat.
    *   **Paso 3 (Futuro):** Integrar un backend de chat en tiempo real utilizando Firestore para permitir la comunicación bidireccional.

2.  **Desarrollar las Pantallas de Contenido:**
    *   Poblar las secciones **Académico, Emocional, Social y Perfil** con widgets y funcionalidades específicas que aporten valor al usuario según su perfil.

---

## Estructura de la Base de Datos (Firestore)

La arquitectura de datos se centra en la colección `users`.

*   **Colección: `users`**
    *   **Documento:** `[user_id]` (ID único proporcionado por Firebase Auth).
        *   `email`: (String) Correo del usuario.
        *   `username`: (String) Nombre de usuario.
        *   `role`: (String) Rol seleccionado (e.g., "Estudiante").
        *   `createdAt`: (Timestamp) Fecha de creación de la cuenta.
        *   `hasCompletedOnboarding`: (Boolean) `true` si el usuario ha finalizado el onboarding, `false` si no.
        *   `interests`, `courses`, `difficulties`, etc.: (List<String>) Todos los datos recopilados durante el onboarding, fusionados en el documento del usuario.
