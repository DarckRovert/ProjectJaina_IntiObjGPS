# 🔌 Especificación Técnica y API — ProjectJaina_IntiObjGPS

[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FProjectJaina_IntiObjGPS-black?logo=github)](https://github.com/DarckRovert/ProjectJaina_IntiObjGPS)
[![Ecosistema](https://img.shields.io/badge/Ecosistema-Project%20Jaina%203.3.5a-gold.svg)](https://darckrovert.github.io/ProjectJaina_Web/)

## 📌 Resumen Arquitectónico
Herramienta de precisión para Game Masters que permite capturar coordenadas exactas (x, y, z, orientacion, mapId) para spawns masivos y colocación de GameObjects en el mundo.

- **Rol en el Ecosistema:** Módulo Oficial #8 — GPS y Colocación de Objetos GM
- **Archivo Principal TOC:** `ProjectJaina_IntiObjGPS.toc`
- **Compatibilidad del Motor:** World of Warcraft 3.3.5a (Build 12340)

---

## ⌨️ Comandos de Consola (Slash Commands)
- `/objgps`: Acceso principal o comando del addon.

---

## 📡 Protocolo de Red y Eventos
- **Prefijo AddonMessage:** `INTIGPS1` (Canal Whisper bidireccional entre cliente GM y `87_IntiObjGPS_Engine.lua`).
- **Comando de Arranque:** `.objgpsbatch <token> <operación>` (interceptado silenciosamente en Eluna sin eco en chat).
- **Tramas del Protocolo:**
  - Cliente -> Servidor: `begin <n>`, `row <i> <entry> <map> <x> <y> <z> <o> <scale>`, `run`, `cancel`.
  - Servidor -> Cliente: `<token>|BEGIN|<n>`, `<token>|ROW|<i>`, `<token>|READY|<n>`, `<token>|RUNNING`, `<token>|PLACED|<i> <guid> <entry> <scale>`, `<token>|DONE|<n>`, `<token>|ERROR|<detalle>`, `<token>|STOP|<detalle>`.

### Eventos del Motor 3.3.5a Gestionados
- `PLAYER_LOGIN` / `ADDON_LOADED`: Inicialización atómica de tablas de configuración y hooks.
- `PLAYER_ENTERING_WORLD`: Sincronización de estado tras transiciones de pantalla o mapa.
- `PLAYER_LOGOUT`: Guardado seguro en disco de las variables locales.

---

## 💾 Persistencia de Datos (SavedVariables)
- `ProjectJaina_IntiObjGPSDraft`: Almacenamiento estructurado de configuración y estado persistente.
- `ProjectJaina_IntiObjGPSHistory`: Almacenamiento estructurado de configuración y estado persistente.
- `ProjectJaina_IntiObjGPSPending`: Almacenamiento estructurado de configuración y estado persistente.

---

## 🛠️ Buenas Prácticas de Integración
1. Toda invocación a funciones públicas debe verificar previamente la existencia del espacio de nombres en `_G`.
2. Las tablas de configuración deben consultarse en modo lectura sin sobreescribir valores por omisión no validados.
3. El intercambio de datos con otros addons debe efectuarse a través del bus oficial `ProjectJaina_Companion` o hooks de eventos estándar.
