# 🌐 Registro de Ecosistema — WoWPeru_IntiObjGPS

Ficha técnica oficial de registro en la infraestructura multi-addon de **WoW Perú - Reino Andino**.

---

## 1. Identidad del Addon

| Campo | Valor |
|---|---|
| **Nombre Técnico** | `WoWPeru_IntiObjGPS` |
| **Título en Cliente** | `Inti - Objetos GPS` |
| **Versión** | `2.0.0` |
| **Tipo de Sistema** | Editor Batch de Coordenadas de Objetos para GM (Privado / Pruebas) |
| **Repositorio GitHub** | [DarckRovert/WoWPeru_IntiObjGPS](https://github.com/DarckRovert/WoWPeru_IntiObjGPS) |
| **Directorio de Instalación** | `Interface\AddOns\IntiObjGPS\` |

---

## 2. Red y Mensajería de Addon

| Propiedad | Valor |
|---|---|
| **Prefijo Oficial** | Ninguno (Comandos locales de consola / chat de desarrollo) |
| **Canales de Red** | N/A |
| **OpCodes Manejados** | N/A |
| **Restricción de Reino** | Solo ejecutable en reinos identificados como `"Inti (Pruebas)"` con rango GM |

---

## 3. Persistencia de Datos

| Variable Global | Tipo | Ámbito | Propósito |
|---|---|---|---|
| `IntiObjGPSHistory` | Tabla Lua (`SavedVariables`) | Por Cuenta | Historial de operaciones de edición y colocación de coordenadas. |
| `IntiObjGPSPending` | Tabla Lua (`SavedVariables`) | Por Cuenta | Cola transaccional de comandos pendientes de inyección. |
| `IntiObjGPSDraft` | Tabla Lua (`SavedVariablesPerCharacter`) | Por Personaje | Espacio de trabajo y borrador temporal del Game Master activo. |

---

## 4. Matriz de Integración del Ecosistema

| Sistema Coexistente | Modo de Interacción | Flujo de Datos |
|---|---|---|
| **AzerothCore Worldserver** | Inyección de Comandos | Genera secuencias de comandos `.gob spawn` y `.gob move` hacia el core. |
| **`WoWPeru_GMGenie`** | Coexistencia GM | Complementa el módulo de Spawns con precisión milimétrica de coordenadas X/Y/Z/O. |

---

## 5. Garantías de Rendimiento

- **Tiempo de Cuadro:** < 0.02 ms por frame.
- **Memoria en Tiempo de Ejecución:** ~ 180 KB de memoria Lua.
- **Compatibilidad de Hardware:** 100% verificado para estaciones de desarrollo.
