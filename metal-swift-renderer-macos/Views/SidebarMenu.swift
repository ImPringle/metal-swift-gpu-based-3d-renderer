//
//  SidebarMenu.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 21/07/26.
//

import SwiftUI

struct SidebarMenu: View {
    @StateObject var worldController: WorldController
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Camera Settings")
                Spacer()
            }
            .padding(.vertical, 5)
            
            VStack {
                Text("Position")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                HStack {
                    HStack {
                        Text("x:")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        TextField("x", value: $worldController.cameraPosX, format: .number)
                    }
                    HStack {
                        Text("y:")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        TextField("y", value: $worldController.cameraPosY, format: .number)
                    }
                    HStack {
                        Text("z:")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        TextField("z", value: $worldController.cameraPosZ, format: .number)
                    }
                }
            }
            .padding(.bottom)
            
            CustomSlider(range: $worldController.fovRange, value: $worldController.fov, title: "Fov")
            CustomSlider(range: $worldController.znearRange, value: $worldController.znear, title: "Z-Near")
            CustomSlider(range: $worldController.zfarRange, value: $worldController.zfar, title: "Z-Far")
            HStack {
                Text("Light Settings")
                Spacer()
            }
            .padding(.vertical, 5)
            VStack {
                CustomSlider(range: $worldController.lightPositionRange, value: $worldController.lightPosition.x, title: "X-Light Position")
                CustomSlider(range: $worldController.lightPositionRange, value: $worldController.lightPosition.y, title: "Y-Light Position")
                CustomSlider(range: $worldController.lightPositionRange, value: $worldController.lightPosition.z, title: "Z-Light Position")

            }
            Spacer()
        }
        .padding()
    }
}
