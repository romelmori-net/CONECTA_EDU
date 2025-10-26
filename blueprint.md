# Blueprint: ConectaEDU - Flutter Firebase App

## 1. Visión General del Proyecto

**ConectaEDU** es una aplicación móvil diseñada para revolucionar la experiencia educativa, conectando a estudiantes y tutores en un entorno de aprendizaje colaborativo y de apoyo. La aplicación se enfoca en el bienestar integral del estudiante, abordando no solo sus necesidades académicas, sino también su estado emocional y sus conexiones sociales.

## 2. Funcionalidades Clave Implementadas

Esta sección documenta las características actuales de la aplicación, desde la versión inicial hasta la más reciente.

### v1.0: Fundación y Onboarding Inteligente

*   **Flujo de Autenticación Completo y Seguro:**
    *   **Registro y Login:** Los usuarios pueden crear cuentas o iniciar sesión usando correo y contraseña a través de Firebase Authentication.
    *   **Persistencia de Sesión:** La app recuerda al usuario, evitando la necesidad de iniciar sesión repetidamente.

*   **Proceso de Onboarding Inteligente y Multi-paso:**
    *   Tras el primer registro, el usuario es guiado a través de un proceso de onboarding obligatorio de tres etapas: **Académico, Social y Emocional**.
    *   Toda la información recopilada se guarda de forma segura y estructurada en el perfil del usuario en Firestore.
    *   El flujo está diseñado para ser robusto, con manejo de errores y timeouts para garantizar una experiencia sin fallos.

*   **Dashboard Inicial:**
    *   Una vez completado el onboarding, el usuario es dirigido a una pantalla principal de bienvenida (Dashboard), que servirá como punto de partida para futuras funcionalidades.

## 3. Arquitectura Técnica

*   **Framework:** Flutter
*   **Backend & Base de Datos:** Firebase (Authentication, Cloud Firestore)
*   **Gestión de Estado:** StatefulWidgets (local) y StreamBuilder/FutureBuilder para la interacción con Firebase.
*   **Navegación:** Navigator 2.0 (MaterialPageRoute, pushReplacement)
*   **Estilo y UI:** Google Fonts, diseño centrado en Material Design 3.

## 4. Estructura de la Base de Datos (Cloud Firestore)

Esta sección define la estructura de nuestra base de datos. Es la **única fuente de verdad** para la organización de los datos.

*   **Colección: `users`**
    *   **Documento:** `[user_id]` (ID único proporcionado por Firebase Auth).
        *   `email`: (String) Correo electrónico del usuario.
        *   `fullName`: (String) Nombre completo del usuario.
        *   `createdAt`: (Timestamp) Fecha y hora de creación de la cuenta.
        *   `hasCompletedOnboarding`: (Boolean) **Crucial**. Se establece en `true` solo al finalizar el último paso del onboarding. El sistema depende de este campo para decidir si mostrar el Dashboard o el Onboarding.
        *   **`onboarding`**: (Map) Un objeto que anida toda la información recopilada durante el proceso de bienvenida.
            *   **`academic`**: (Map)
                *   `interests`: (List<String>)
                *   `courses`: (List<String>)
                *   `difficulties`: (List<String>)
                *   `objectives`: (List<String>)
            *   **`social`**: (Map)
                *   `hobbies`: (String)
            *   **`emotional`**: (Map)
                *   `stressManagement`: (String)

## 5. Plan para la Solicitud Actual

*   **Objetivo:** Mostrar los datos del usuario en el Dashboard.
*   **Pasos:**
    1.  **Leer Datos del Usuario:** Modificar `dashboard_screen.dart` para realizar una lectura de Firestore del documento del usuario actual.
    2.  **Extraer Nombre:** Obtener el campo `fullName` del documento.
    3.  **Extraer Grupos/Intereses:** Obtener los datos del objeto anidado `onboarding.academic.interests`.
    4.  **Diseñar UI del Dashboard:** Crear una interfaz de usuario atractiva que muestre un saludo personalizado (e.g., "Hola, [fullName]!") y una sección que liste los intereses o grupos seleccionados.
    5.  **Manejo de Estados:** Utilizar un `FutureBuilder` para manejar los estados de carga, error y éxito durante la lectura de los datos.
