# 🔌 Especificación Técnica y API — ProjectJaina_ProjectJaina_IntiObjGPS

[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FProjectJaina_ProjectJaina_IntiObjGPS-black?logo=github)](https://github.com/DarckRovert/ProjectJaina_ProjectJaina_IntiObjGPS)
[![Ecosistema](https://img.shields.io/badge/Ecosistema-WoW%20Per%C3%BA%203.3.5a-gold.svg)](https://darckrovert.github.io/ProjectJaina_Web/)

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
- *(Este addon no utiliza mensajes AddonMessage de red; opera en espacio local del cliente)*.

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
