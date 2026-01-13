# Metal Swift GPU-Based 3D Renderer

A low-level **3D wireframe renderer** built from scratch using **Swift + Metal**, focused on understanding the fundamentals of 3D graphics by manually implementing the rendering pipeline.

This project renders a complex wireframe model (Snoopy) by projecting 3D vertices into 2D screen space and drawing line segments using Metal — **without SceneKit, Model I/O, or high-level abstractions**.

---

## 🚀 Features

### 🧠 Core 3D Engine
- Manual 3D graphics pipeline (no external math libraries)
- CPU-side vertex transformations
- Perspective projection
- Line-based rendering using Metal

### 📐 MathCore Framework (Custom)
This project includes a **custom math framework called `MathCore`**, built from scratch to deeply understand and control all mathematical operations involved in 3D rendering.

**MathCore provides:**
- Vector math (`Point2D`, `Point3D`)
- Linear algebra utilities
- Rotation matrices
- **Quaternion math**
- Quaternion normalization and composition
- **Quaternion → Rotation Matrix conversion**

All transformations (translation, scaling, rotation) are computed using MathCore before being sent to the GPU.

> The goal of MathCore is educational: no hidden abstractions, just raw math used by real graphics engines.

---

## 🔁 Rotation Modes

This renderer supports **two rotation systems**, switchable at runtime:

### Euler Angles
- Classic X / Y / Z rotations
- Easy to visualize and debug
- Susceptible to gimbal lock

### Quaternions
- Smooth, continuous rotations
- Avoid gimbal lock
- Uses quaternion algebra internally
- Converted to rotation matrices via MathCore for rendering

🔑 **Press `M` to toggle between Euler and Quaternion rotation modes at runtime**

---

## 🖱 Controls

### Movement
| Keys | Action |
|------|--------|
| W / S | Move forward / backward (Z) |
| A / D | Move left / right (X) |
| ↑ / ↓ | Move up / down (Y) |

### Rotation
| Keys | Action |
|------|--------|
| I / K | Rotate X axis |
| J / L | Rotate Y axis |
| U / O | Rotate Z axis |
| **M** | Toggle Euler ↔ Quaternion rotation |

### Scale
| Keys | Action |
|------|--------|
| ← / → | Scale up / down |

### System
| Keys | Action |
|------|--------|
| Esc | Quit application |

---

## 🧩 Architecture Overview
SwiftUI
├─ ContentView
│ ├─ MetalView (MTKView)
│ └─ Renderer (MTKViewDelegate)
│ ├─ Input handling
│ ├─ MathCore
│ │ ├─ Vector math
│ │ ├─ Linear algebra
│ │ ├─ Euler rotations
│ │ ├─ Quaternions
│ │ └─ Quaternion → Matrix conversion
│ ├─ Vertex projection
│ ├─ Line list generation
│ └─ Shaders.metal
│ ├─ Vertex shader
│ └─ Fragment shader


---

## 🛠 Tech Stack

- **Language:** Swift
- **Graphics API:** Metal
- **UI:** SwiftUI + MetalKit
- **Shaders:** Metal Shading Language
- **Math:** Custom `MathCore` framework
- **Platform:** macOS

---

## ⚠️ What This Project Does *Not* Use

- SceneKit
- Model I/O
- simd / GLM / third-party math libraries
- Camera abstractions

Everything — including the math — is implemented manually to understand how real-time 3D engines work under the hood.

## 📜 License

MIT License

---

## ❤️ Credits

- **badanon1** — Snoopy 3D model (Sketchfab)
- Tsoding & Pikuma — graphics programming inspiration
- Dr. Michael Gipser - Sent me Quaternions and 3D Transformations slides.
