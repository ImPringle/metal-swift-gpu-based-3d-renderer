# Metal Wireframe Renderer (Swift)

A low-level 3D wireframe renderer built from scratch using **Swift + Metal**, focused on understanding the fundamentals of 3D graphics by manually implementing the rendering pipeline.

This project renders a complex wireframe model (Snoopy) by projecting 3D vertices into 2D screen space and drawing line segments using Metal — without SceneKit, Model I/O, or high-level abstractions.

---

## Features

- Manual 3D math pipeline
  - Scaling
  - Translation (X / Y / Z)
  - Rotation around X, Y, Z axes
  - Perspective projection (`x / z`, `y / z`)
- CPU-side vertex transformation (no matrix libraries)
- Wireframe rendering using Metal line primitives
- Real-time keyboard input
- HUD overlay displaying:
  - Translation values
  - Rotation angles
  - Scale
  - Vertex and edge counts
- Time-based animation loop (delta time)
- Native macOS app using SwiftUI + MetalKit

---

## Project Goal

This project is intentionally **low-level and educational**.

The goal is to understand how 3D rendering works under the hood by:
- Rebuilding the graphics pipeline manually
- Connecting CPU-side math with GPU rendering
- Avoiding high-level graphics frameworks
- Preparing for more advanced graphics and engine development

---

## Architecture Overview

SwiftUI
├─ ContentView
│ ├─ MetalView (MTKView wrapper)
│ └─ HUD (overlay)
│
├─ Renderer (MTKViewDelegate)
│ ├─ Input handling
│ ├─ Time-based updates
│ ├─ Vertex projection
│ └─ Line list rebuild
│
├─ Math.swift
│ ├─ Point2D / Point3D
│ ├─ Translation
│ ├─ Rotation functions
│ └─ Perspective projection
│
├─ SnoopyModel.swift
│ ├─ Vertices
│ └─ Edge indices
│
└─ Shaders.metal
├─ Vertex shader
└─ Fragment shader


---

## Rendering Pipeline

1. Original 3D vertices
2. Optional Y-axis flip
3. Scaling
4. Rotation (Y → X → Z)
5. Translation
6. Perspective projection
7. Edge expansion into line segments
8. Upload to GPU
9. Draw using Metal line primitives

All transformations are explicit and implemented in code.

---

## Controls

### Movement
| Key | Action |
|---|---|
| W / S | Move forward / backward (Z) |
| A / D | Move left / right (X) |
| ↑ / ↓ | Move up / down (Y) |

### Rotation
| Key | Action |
|---|---|
| I / K | Rotate X axis |
| J / L | Rotate Y axis |
| U / O | Rotate Z axis |
| R | Toggle continuous Y rotation |

### Scale
| Key | Action |
|---|---|
| ← / → | Scale up / down |

### System
| Key | Action |
|---|---|
| Esc | Quit application |

---

## Tech Stack

- Language: Swift
- Graphics API: Metal
- UI: SwiftUI + MetalKit
- Platform: macOS
- Shaders: Metal Shading Language

---

## What This Project Does NOT Use

- SceneKit
- Model I/O
- SIMD matrix helpers
- Camera abstractions
- External 3D loaders

Everything is implemented manually for learning purposes.

---

## Future Improvements

- Matrix-based transformations
- Camera system
- Depth clipping
- Triangle rasterization
- GPU-side transforms
- Back-face culling

---

## Credits
**badanon1** for the snoopy 3d model I used in this experiment https://sketchfab.com/3d-models/snoopy-72116d2e288f4c45a11f323d76142a6c

**Tsoding** and **Pikuma** for graphics fundamental content on youtube

## License

MIT License
