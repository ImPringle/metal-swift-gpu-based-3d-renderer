import Foundation

struct Point2D {
    var x: Float
    var y: Float
}

struct Point3D {
    var x: Float
    var y: Float
    var z: Float
}
			
// Projection
func project(_ p: Point3D) -> Point2D {
    Point2D(x: p.x / p.z, y: p.y / p.z)
}

// Scaling
func ScaleModel(_ p: Point3D, scale: Float) -> Point3D {
    Point3D(x: p.x * scale, y: p.y * scale, z: p.z * scale)
}

// Translation on X
func translateX(_ p: Point3D, _ dx: Float) -> Point3D {
    Point3D(x: p.x + dx, y: p.y, z: p.z)
}

// Translation on Y
func translateY(_ p: Point3D, _ dy: Float) -> Point3D {
    Point3D(x: p.x, y: p.y + dy, z: p.z)
}

// Translation on Z
func translateZ(_ p: Point3D, _ dz: Float) -> Point3D {
    Point3D(x: p.x, y: p.y, z: p.z + dz)
}

// Rotate around X
func rotateX(_ p: Point3D, _ angle: Float) -> Point3D {
    let c = cos(angle)
    let s = sin(angle)
    return Point3D (
        x: p.x,
        y: p.y * c - p.z * s,
        z: p.y * s + p.z * c,
    )
}

// Rotate around Y
func rotateY(_ p: Point3D, _ angle: Float) -> Point3D {
    let c = cos(angle)
    let s = sin(angle)
    return Point3D (
        x: p.x * c - p.z * s,
        y: p.y,
        z: p.x * s + p.z * c
    )
}

// Rotate around Z
func rotateZ(_ p: Point3D, _ angle: Float) -> Point3D {
    let c = cos(angle)
    let s = sin(angle)
    return Point3D(
        x: p.x * c - p.y * s,
        y: p.x * s + p.y * c,
        z: p.z
    )
}

func flippedY(_ p: Point3D) -> Point3D {
    Point3D (x: p.x, y: -p.y, z: p.z)
}

func projectVertices(_ vertices: [Point3D], aX: Float, aY: Float, aZ: Float, dX: Float, dY: Float, dZ: Float, scale: Float, flipY: Bool) -> [Point2D] {
    var out: [Point2D] = []
    out.reserveCapacity(vertices.count)

    for v in vertices {
        var p = v
        if flipY {
            p = flippedY(p)
        }
        
        p = ScaleModel(p, scale: scale)
        p = rotateY(p, aY)
        p = rotateX(p, aX)
        p = rotateZ(p, aZ)
        p = translateX(p, dX)
        p = translateY(p, dY)
        p = translateZ(p, dZ)
        
        out.append(project(p))
    }
    return out
}
