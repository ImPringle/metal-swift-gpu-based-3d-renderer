import SwiftUI
import MathCore

struct HUD: View {
    @Binding var HUDctrl: HUDController
    let fontSize: CGFloat = 20
    var body: some View {
        VStack {
            HStack {
                Text("X: \(HUDctrl.renderer?.dX ?? 0)")
                    .foregroundStyle(
                        HUDctrl.renderer?.moveRight ?? false ? .green :
                            HUDctrl.renderer?.moveLeft ?? false ? .red : .white)
                    .font(.system(size: fontSize))
                Text("Y: \((HUDctrl.renderer?.dY ?? 0) * -1)")
                    .foregroundStyle(
                        HUDctrl.renderer?.moveDown ?? false ? .green :
                            HUDctrl.renderer?.moveUp ?? false ? .red : .white)
                    .font(.system(size: fontSize))
                Text("Z: \(HUDctrl.renderer?.dZ ?? 0)")
                    .foregroundStyle(
                        HUDctrl.renderer?.moveForward ?? false ? .green :
                            HUDctrl.renderer?.moveBackward ?? false ? .red : .white)
                    .font(.system(size: fontSize))
                Spacer()
            }
            HStack {
                VStack (alignment: .leading) {
                    Text("Rotating around X: \((radToDeg(wrapRadians(HUDctrl.renderer?.aX ?? 0))))")
                        .foregroundStyle(
                            HUDctrl.renderer?.rXClockwise ?? false ? .green :
                                HUDctrl.renderer?.rXNClockwise ?? false ? .red : .white)
                        .font(.system(size: fontSize))
                    
                    Text("Rotating around Y: \(radToDeg(wrapRadians(HUDctrl.renderer?.aY ?? 0)))")
                        .foregroundStyle(
                            HUDctrl.renderer?.rYClockwise ?? false || HUDctrl.renderer?.SpinXZ ?? false ? .green : 
                                HUDctrl.renderer?.rYNClockwise ?? false ? .red : .white)
                        .font(.system(size: fontSize))
                    
                    Text("Rotating around Z: \(radToDeg(wrapRadians(HUDctrl.renderer?.aZ ?? 0)))")
                        .foregroundStyle(
                            HUDctrl.renderer?.rZClockwise ?? false ? .green :
                                HUDctrl.renderer?.rZNClockwise ?? false ? .red : .white)
                        .font(.system(size: fontSize))
                    
                }
                Spacer()
            }
            Spacer()
            HStack {
                Text("Scale: x\(HUDctrl.renderer?.scale ?? 0)")
                    .foregroundStyle(
                        HUDctrl.renderer?.scalingUp ?? false ? .green :
                            HUDctrl.renderer?.scalingDown ?? false ? .red : .white)
                    .font(.system(size: fontSize))

                Spacer()
            }
            HStack {
                Text("Vertices: \(SnoopyModel.vertices.count)")
                    .foregroundStyle(.white)
                    .font(.system(size: fontSize))

                Spacer()
            }
            HStack {
                Text("Edges: \(SnoopyModel.edges.count)")
                    .foregroundStyle(.white)
                    .font(.system(size: fontSize))

                Spacer()
                Text(HUDctrl.renderer?.useQuaternions ?? false ? "QUATERNION ROTATION" : "EULER ANGLES")
                    .foregroundStyle(.white)
                    .font(.system(size: fontSize))
            }
//            Spacer()
//            HStack {
//                Spacer()
//                Text(HUDctrl.renderer?.useQuaternions ?? false ? "QUATERNION ROTATION" : "EULER ANGLES")
//                    .foregroundStyle(.white)
//                    .font(.system(size: fontSize))
//            }
        }
        .padding()
    }
}
