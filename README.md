# IntiObjGPS — Editor de Objetos GPS para GM

[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FWoWPeru_IntiObjGPS-black?logo=github)](https://github.com/DarckRovert/WoWPeru_IntiObjGPS)

> **WoW Perú Ecosystem** · WotLK 3.3.5a compatible · `Interface: 30300`

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Herramienta de **edición por lotes de coordenadas GPS de objetos** para Game Masters en el servidor Inti (entorno de pruebas de WoW Perú). Permite crear, editar y empujar objetos georeferenciados a la base de datos del servidor con precisión quirúrgica.

---

## Características

- **Editor batch de objetos GPS** — Crea y edita coordenadas de múltiples objetos en una sola operación.
- **Historial de edición** — Registro completo de cambios por sesión y por personaje.
- **Borradores por personaje** — Cada GM tiene su espacio de trabajo independiente.
- **Integrado con comandos .npc/.go del servidor Inti**.
- Compatible con WotLK 3.3.5a (Interface 30300).

## Instalación

Solo disponible en cuentas GM del servidor **Inti** (entorno de pruebas).

1. Copia `IntiObjGPS` a `Interface/AddOns/`.
2. Requiere cuenta con `.gm on` activo.

## Variables Guardadas

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `IntiObjGPSHistory` | Global | Historial de ediciones |
| `IntiObjGPSPending` | Global | Cola de cambios pendientes de envío |
| `IntiObjGPSDraft` | Por personaje | Borrador del GM activo |

## Créditos y Licencia

- **Autor:** DarckRovert (Elnazzareno) & WoW Perú Team
- **Versión:** 2.0.0
- **Acceso:** Solo GM — Servidor Inti (Pruebas)
- **Licencia:** [MIT License](LICENSE)

---

## Documentación del Ecosistema

* [Ficha Técnica Oficial del Ecosistema](ECOSYSTEM_REGISTRY.md)
* [Historial de Cambios](CHANGELOG.md)

---

*Parte del [ecosistema WoW Perú](https://github.com/DarckRovert)*
