# Registro de Cambios — WoWPeru_IntiObjGPS

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [2.0.0-wp] — 2026-10-05
### Gobernanza y Estandarización de Licencias (WoW Perú)
- **Licencia Canónica:** Adición formal de la licencia MIT ([LICENSE](LICENSE)) bajo titularidad de DarckRovert & WoW Perú Team.
- **Higiene Documental:** Creación de `CHANGELOG.md`, `ECOSYSTEM_REGISTRY.md` y `.gitattributes`.
- **Aislamiento de Seguridad:** Documentación estricta de las directivas de filtrado por reino (`"Inti (Pruebas)"`) y requisito de nivel de seguridad GM 3 en el core.

---

## [2.0.0] — 2026-10-04
### Edición Batch y Cola de Objetos
- Motor de edición por lotes de coordenadas de GameObjects y Spawns para pruebas internas.
- Persistencia de cola de cambios pendientes en `IntiObjGPSPending` e historial de auditoría en `IntiObjGPSHistory`.
- Borrador por personaje en `IntiObjGPSDraft`.
