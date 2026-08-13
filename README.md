# Metal Swift GPU-Based 3D Renderer

A from-scratch 3D graphics renderer written in Swift and Metal. The project is educational in focus: it implements core real-time rendering concepts directly—meshes, transforms, projection, depth testing, and lighting—without relying on SceneKit, RealityKit, or Model I/O.

## Overview

The macOS application hosts a MetalKit view inside a SwiftUI shell. Each frame, the renderer builds model-view-projection (MVP) matrices, uploads per-draw uniforms, and issues indexed triangle draws for meshes in the scene. Lighting is evaluated in the fragment shader using per-vertex normals and a configurable point light.

Shared math and data types live in the `CGMath` framework. Asset and utility code lives in `CGUtilities`. An iOS target exists with a device-adaptive SwiftUI shell; the macOS target is currently the primary rendering path.

## Features

- GPU-side vertex transformation and fragment lighting via Metal Shading Language
- Indexed triangle mesh rendering with depth buffering
- Perspective projection with configurable FOV, near plane, and far plane
- Ambient and diffuse lighting driven by light position and color uniforms
- Procedural mesh generation (cubes, grid)
- Scene composed of thousands of independently colored and positioned cubes
- SwiftUI sidebar for live camera and light parameter editing
- Custom math utilities: vectors, Euler rotations, quaternions, and `simd` matrix helpers
- Dual platform targets: macOS and iOS

## Architecture

```
metal-swift-renderer.xcodeproj
├── metal-swift-renderer-macos   # Primary Metal + SwiftUI application
├── metal-swift-renderer-ios     # iOS shell (menus / controllers)
├── CGMath                       # Graphics math, vertices, uniforms
├── CGUtilities                  # Shared utilities (OBJ loader stub)
├── CGMathTests
└── CGUtilitiesTests
```

### Rendering pipeline (macOS)

1. `MainApp` creates shared controllers and presents `ContentView`.
2. `MetalView` (`NSViewRepresentable`) creates an `MTKView`, depth attachment, and `Renderer`.
3. `Renderer` (`MTKViewDelegate`) owns the command queue, render pipeline, and depth-stencil state.
4. Each draw call:
   - Builds the view matrix from camera position
   - Builds the projection matrix from FOV / aspect / clip planes
   - For each `Mesh`, computes MVP and a normal matrix
   - Binds vertex/index buffers and `CGUniforms`
   - Draws indexed primitives

### Key types

| Type | Role |
|------|------|
| `Renderer` | Frame loop, Metal pipeline, draw submission |
| `RenderScene` | Mesh list and view matrix |
| `Mesh` | Protocol for vertex/index buffers and model transform |
| `Cube` / `Grid` | Concrete mesh implementations |
| `WorldController` | Camera, projection, and light parameters (Observable) |
| `CGVertex` | Position, normal, color layout for Metal attributes |
| `CGUniforms` | MVP, model, normal matrix, and light data for shaders |
| `Quaternion` | Axis-angle construction, composition, and rotation matrices |

### Shaders

Located under `metal-swift-renderer-macos/Shaders/`:

- `ParticleRender.metal` — vertex/fragment pair (`vertex_main` / `fragment_main`) with ambient + diffuse lighting
- `SimulationCompute.metal` — compute kernel stub for future GPU simulation work

### Frameworks

**CGMath**

- `Point2D` / `Point3D` and basic transforms (scale, translate, rotate)
- Quaternion algebra and quaternion-to-matrix conversion
- `simd_float4x4` helpers (identity, translation, perspective)
- `CGVertex` and `CGUniforms` shared between CPU and GPU

**CGUtilities**

- Placeholder `OBJLoader` for future mesh import from Wavefront OBJ files

## Controls and UI

The macOS app uses a `NavigationSplitView` with a sidebar (`SidebarMenu`) and a full-bleed Metal viewport.

### Camera

- Position: X / Y / Z text fields
- Field of view slider
- Near and far plane sliders

### Lighting

- Light position X / Y / Z sliders
- Light color via world controller state (shader uniform)

Default camera starts near `(0, 10, -20)` looking toward the origin-centered cube field.

## Requirements

- macOS (primary) or iOS
- Xcode with Metal and SwiftUI support
- A Metal-capable Apple GPU

Deployment targets in the Xcode project are currently set to macOS / iOS 26.0. Adjust as needed for your local SDK.

## Getting started

1. Clone the repository.
2. Open `metal-swift-renderer.xcodeproj` in Xcode.
3. Select the `metal-swift-renderer-macos` scheme.
4. Build and run (Cmd-R).

The scene initializes with a large set of randomly colored cubes distributed in space. Use the sidebar to adjust camera and light parameters while the Metal view updates in real time.

## Project status

Active development. Current work includes expanding GPU compute simulation (`SimulationCompute.metal`), particle rendering paths, and mesh import via `CGUtilities`. Legacy wireframe / CPU-projection paths and the bundled Snoopy vertex data remain in the tree from earlier iterations but are not the primary draw path.

## What this project intentionally avoids

- SceneKit / RealityKit scene graphs
- Model I/O for mesh loading (custom loader planned)
- Third-party math libraries (math is either handwritten or thin `simd` wrappers)

## License

MIT License

## Credits

- Snoopy 3D model reference data: [badanon1](https://sketchfab.com) (Sketchfab)
- Graphics programming references: Pikuma
