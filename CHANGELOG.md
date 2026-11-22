# 📋 Registro de Cambios — ProjectJaina_IntiObjGPS

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [2.0.1] — 2026-11-22
### Registro de Prefijo IPC y Persistencia Real de GameObjects (Hito #386)
- **Canal `CHAT_MSG_ADDON` (`UI.lua`):**
  - Añadido `RegisterAddonMessagePrefix(M.prefix)` al inicializar `PLAYER_ENTERING_WORLD` (condicional seguro con fallback 3.3.5a).
- **Persistencia en Base de Datos (`87_IntiObjGPS_Engine.lua`):**
  - Sustituida invocación efímera `player:SummonGameObject` (`m_spawnId = 0`) por `PerformIngameSpawn(2, r.entry, r.map, instanceId, r.x, r.y, r.z, r.o, true, 0, phaseMask)` en `op == "run"`, resolución correcta de GUID con `go:GetSpawnId()`, escala mediante `go:SetScale(r.scale)`, validación de mapa/distancia (`<= 500y`) y verificación previa en `gameobject_template`.

---

## [2.0.0] — 2026-10-10
### Estabilización de Ecosistema y Gobernanza Oficial (Project Jaina)
- **Normalización de UI y Gráficos:** Optimización del ciclo OnUpdate a 30 Hz para preservar ciclos de CPU en máquinas de cabina, soporte multirresolución y corrección de rotación de aguja 3D.
- **Homologación Documental:** Incorporación y actualización formal de `GOVERNANCE.md`, `LICENSE`, `NOTICE.md` y `SECURITY.md`.
- **Licencia Canónica:** Consolidación de licencia MIT 2026 bajo titularidad de DarckRovert & Project Jaina Team.
- **Validación de Runtime:** Verificado al 100% con compilador sintáctico `lua52_compiler.exe -p` con 0 errores y 0 warnings.

---

## [1.0.0] — 2026-10-04
### Lanzamiento Inicial — Ecosistema Project Jaina WotLK 3.3.5a
- Implementación de la arquitectura base para Project Jaina IntiObj GPS.
- Registro de comandos slash: `/gps, /intigps`.
- Persistencia de configuración en `IntiObjGPSDB`.
- Compatibilidad certificada con cliente WotLK 3.3.5a (Build 12340) y directiva `Interface: 30300`.
