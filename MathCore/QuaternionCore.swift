import Foundation
public struct Quaternion {
    var w: Float
    var x: Float
    var y: Float
    var z: Float
    
    public init(w: Float, x: Float, y: Float, z: Float) {
        self.w = w
        self.x = x
        self.y = y
        self.z = z
    }
    
    public static func identity() -> Quaternion {
        Quaternion(
            w: 1,
            x: 0,
            y: 0,
            z: 0
        )
    }
    
    public static func fromAxisAngle(axis: Point3D, angle: Float) -> Quaternion {
        let a = axis.normalized()
        let half = angle * 0.5
        let s = sin(half)

        return Quaternion(
            w: cos(half),
            x: a.x * s,
            y: a.y * s,
            z: a.z * s
        )
    }
    
    public func multiply(q2: Quaternion) -> Quaternion {
        return Quaternion (
            w: self.w*q2.w-self.x*q2.x-self.y*q2.y-self.z*q2.z,
            x: self.w*q2.x+self.x*q2.w+self.y*q2.z-self.z*q2.y,
            y: self.w*q2.y-self.x*q2.z+self.y*q2.w+self.z*q2.x,
            z: self.w*q2.z+self.x*q2.y-self.y*q2.x+self.z*q2.w
        )
    }
    
    func transform(v: Point3D) -> Point3D {
        let p: Quaternion = Quaternion(w: 0, x: v.x, y: v.y, z: v.z)
        let t = self.multiply(q2: p).multiply(q2: self.inverse())
        return Point3D (
            x: t.x,
            y: t.y,
            z: t.z
        )
    }
    
    func inverse() -> Quaternion {
        let norm_squared: Float = self.w*self.w+self.x*self.x+self.y*self.y+self.z*self.z
        
        return Quaternion (
            w: self.w/norm_squared,
            x: -self.x/norm_squared,
            y: -self.y/norm_squared,
            z: -self.z/norm_squared
        )
    }
    
    public func toRotationMatrix() -> Mat3 {
        let xx = x*x
        let yy = y*y
        let zz = z*z
        let xy = x*y
        let xz = x*z
        let yz = y*z
        let wx = w*x
        let wy = w*y
        let wz = w*z
        
        return Mat3(
            m00: 1 - 2 * (yy + zz),
            m01: 2 * (xy - wz),
            m02: 2 * (xz + wy),
            
            m10: 2 * (xy + wz),
            m11: 1 - 2 * (xx + zz),
            m12: 2 * (yz - wx),
            
            m20: 2 * (xz - wy),
            m21: 2 * (yz + wx),
            m22: 1 - 2 * (xx + yy)
        )
    }
}
