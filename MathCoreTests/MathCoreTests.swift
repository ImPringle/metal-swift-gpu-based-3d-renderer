//
//  MathCoreTests.swift
//  MathCoreTests
//
//  Created by Mario Zuniga on 12/01/26.
//
import XCTest
import Testing
@testable import MathCore

struct MathCoreTests {

    @Test func testRotation() async throws {
        var q = Quaternion(w: 1, x: 0, y: 0, z: 0)
        
        let iHat = Point3D(x: 1, y: 0, z: 0)
        let jHat = Point3D(x: 0, y: 1, z: 0)
        let kHat = Point3D(x: 0, y: 0, z: 1)
        
        XCTAssertEqual(q.transform(v: iHat), Point3D(x: 1, y: 0, z: 0))
        XCTAssertEqual(q.transform(v: jHat), Point3D(x: 0, y: 1, z: 0))
        XCTAssertEqual(q.transform(v: kHat), Point3D(x: 0, y: 0, z: 1))
        
        let a = Quaternion.fromAxisAngle(axis: Point3D(x: 1, y: 0, z: 0), angle: Float.pi / 2)
        let b = Quaternion.fromAxisAngle(axis: Point3D(x: 1, y: 1, z: 1), angle: -2 * Float.pi / 3)
        
        q = a.multiply(q2: q)
        
        XCTAssertEqual(q.transform(v: iHat), Point3D(x: 1, y: 0, z: 0))
        XCTAssertEqual(q.transform(v: jHat), Point3D(x: 0, y: 0, z: 1))
        XCTAssertEqual(q.transform(v: kHat), Point3D(x: 0, y: -1, z: 0))
        
        q = b.multiply(q2: q)
        
        XCTAssertEqual(q.transform(v: iHat), Point3D(x: 0, y: 0, z: 1))
        XCTAssertEqual(q.transform(v: jHat), Point3D(x: 0, y: 1, z: 0))
        XCTAssertEqual(q.transform(v: kHat), Point3D(x: -1, y: 0, z: 0))
    }
    
    @Test func testRotationOtherWay() async throws {
        var q = Quaternion(w: 1, x: 0, y: 0, z: 0)
        
        let iHat = Point3D(x: 1, y: 0, z: 0)
        let jHat = Point3D(x: 0, y: 1, z: 0)
        let kHat = Point3D(x: 0, y: 0, z: 1)
        
        XCTAssertEqual(q.transform(v: iHat), Point3D(x: 1, y: 0, z: 0))
        XCTAssertEqual(q.transform(v: jHat), Point3D(x: 0, y: 1, z: 0))
        XCTAssertEqual(q.transform(v: kHat), Point3D(x: 0, y: 0, z: 1))
        
        let a = Quaternion.fromAxisAngle(axis: Point3D(x: 1, y: 0, z: 0), angle: Float.pi / 2)
        let b = Quaternion.fromAxisAngle(axis: Point3D(x: 1, y: 1, z: 1), angle: -2 * Float.pi / 3)
        
        q = b.multiply(q2: q)
        
        XCTAssertEqual(q.transform(v: iHat), Point3D(x: 0, y: 0, z: 1))
        XCTAssertEqual(q.transform(v: jHat), Point3D(x: 1, y: 0, z: 1))
        XCTAssertEqual(q.transform(v: kHat), Point3D(x: 0, y: 1, z: 0))
        
        q = a.multiply(q2: q)
        
        XCTAssertEqual(q.transform(v: iHat), Point3D(x: 0, y: -1, z: 0))
        XCTAssertEqual(q.transform(v: jHat), Point3D(x: 1, y: 0, z: 0))
        XCTAssertEqual(q.transform(v: kHat), Point3D(x: 0, y: 0, z: -1))
    }
}
