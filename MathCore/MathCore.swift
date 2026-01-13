import Foundation

public func radToDeg(_ radians: Float) -> Float {
    return radians * 180 / .pi
}

public func degToRad(_ degrees: Float) -> Float {
    return degrees * .pi / 180
}

public func wrapRadians(_ r: Float) -> Float {
    let twoPi = 2 * Float.pi
    return r.truncatingRemainder(dividingBy: twoPi)
}

public func roundTo(_ value: Float, decimals: Int) -> Float {
    let factor = pow(10, Float(decimals))
    return (value * factor).rounded() / factor
}

public struct Mat3 {
    public let m00, m01, m02: Float
    public let m10, m11, m12: Float
    public let m20, m21, m22: Float
    
    public init(
        m00: Float, m01: Float, m02: Float,
        m10: Float, m11: Float, m12: Float,
        m20: Float, m21: Float, m22: Float
    ) {
        self.m00 = m00; self.m01 = m01; self.m02 = m02
        self.m10 = m10; self.m11 = m11; self.m12 = m12
        self.m20 = m20; self.m21 = m21; self.m22 = m22
    }
    
    public func matTransform(p: Point3D) -> Point3D {
        Point3D(
            x: m00 * p.x + m01 * p.y + m02 * p.z,
            y: m10 * p.x + m11 * p.y + m12 * p.z,
            z: m20 * p.x + m21 * p.y + m22 * p.z
        )
    }
}

public struct Point2D {
    public var x: Float
    public var y: Float
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}

public struct Point3D: Equatable {
    public var x: Float
    public var y: Float
    public var z: Float
    
    public func length() -> Float {
        sqrt(x*x + y*y + z*z)
    }
    
    public func normalized() -> Point3D {
        let len = length()
        precondition(len > 0)
        return Point3D(
            x: x / len,
            y: y / len,
            z: z / len
        )
    }
    
    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}
            
// Projection
public func project(_ p: Point3D) -> Point2D {
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

public func projectVertices(_ vertices: [Point3D], aX: Float, aY: Float, aZ: Float, dX: Float, dY: Float, dZ: Float, rotation: Mat3, scale: Float, flipY: Bool, useQuats: Bool) -> [Point2D] {
    
    var out: [Point2D] = []
    out.reserveCapacity(vertices.count)
    
    for v in vertices {
        var p = v
        if flipY {
            p = flippedY(p)
        }
        
        p = ScaleModel(p, scale: scale)
        if (useQuats) {
            p = rotation.matTransform(p: p)
        } else {
            p = rotateX(rotateY(rotateZ(p, aZ), aY), aX)
        }
        p = translateX(p, dX)
        p = translateY(p, dY)
        p = translateZ(p, dZ)
        
        out.append(project(p))
    }
    return out
}
