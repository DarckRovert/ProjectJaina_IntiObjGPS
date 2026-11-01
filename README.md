<p align="center">
  <img src="https://raw.githubusercontent.com/DarckRovert/ProjectJaina_Web/main/images/project_jaina_official_logo.jpg" alt="Project JAIna Official Crest" width="180">
</p>

# ProjectJaina_IntiObjGPS — Editor de Objetos GPS para GM

[![WoW Client](https://img.shields.io/badge/WoW%20Client-3.3.5a%20(Build%2012340)-blue.svg)](https://darckrovert.github.io/ProjectJaina_Web/)
[![Engine](https://img.shields.io/badge/Engine-JainaCore%20C%2B%2B20-blue.svg)](https://github.com/DarckRovert/JainaCore_Server)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FProjectJaina__IntiObjGPS-black?logo=github)](https://github.com/DarckRovert/ProjectJaina_IntiObjGPS)
[![Ecosystem](https://img.shields.io/badge/Project%20JAIna-Sovereign-gold)](https://darckrovert.github.io/ProjectJaina_Web/)


> **Project Jaina Ecosystem** · WotLK 3.3.5a compatible · `Interface: 30300`


Herramienta de **edición por lotes de coordenadas GPS de objetos** para Game Masters en el servidor Inti (entorno de pruebas de Project Jaina). Permite crear, editar y empujar objetos georeferenciados a la base de datos del servidor con precisión quirúrgica.

---

## Características

- **Editor batch de objetos GPS** — Crea y edita coordenadas de múltiples objetos en una sola operación.
- **Historial de edición** — Registro completo de cambios por sesión y por personaje.
- **Borradores por personaje** — Cada GM tiene su espacio de trabajo independiente.
- **Integrado con comandos .npc/.go del servidor Inti**.
- Compatible con WotLK 3.3.5a (Interface 30300).

## Instalación

Solo disponible en cuentas GM del servidor **Inti** (entorno de pruebas).

1. Copia `ProjectJaina_IntiObjGPS` a `Interface/AddOns/`.
2. Requiere cuenta con `.gm on` activo.

## Variables Guardadas

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `ProjectJaina_IntiObjGPSHistory` | Global | Historial de ediciones |
| `ProjectJaina_IntiObjGPSPending` | Global | Cola de cambios pendientes de envío |
| `ProjectJaina_IntiObjGPSDraft` | Por personaje | Borrador del GM activo |

## Créditos y Licencia

- **Autor:** DarckRovert (Elnazzareno) & Antigravity (Mythos 5)
- **Versión:** 2.0.0
- **Acceso:** Solo GM — Servidor Inti (Pruebas)
- **Licencia:** [MIT License](LICENSE)

---

## Documentación del Ecosistema

* [Ficha Técnica Oficial del Ecosistema](ECOSYSTEM_REGISTRY.md)
* [Historial de Cambios](CHANGELOG.md)

---

*Parte del [ecosistema Project Jaina](https://github.com/DarckRovert)*