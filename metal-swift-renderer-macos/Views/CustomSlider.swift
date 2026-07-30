//
//  CustomSlider.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 21/07/26.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var range: ClosedRange<Float>
    @Binding var value: Float
    var title: String
    
    var body: some View {
        VStack {
            HStack {
                Text(String(format:"%.0f",range.lowerBound))
                    .font(.footnote)
                    .foregroundStyle(.gray)
                Spacer()
                Text("\(title): \(String(format: "%.0f" ,value))")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                Spacer()
                Text(String(format:"%.0f",range.upperBound))
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            #if os(iOS)
            Slider(value: $value, in: range)
            #elseif os(macOS)
            Slider(value: $value, in: range)
                .pointerStyle(.grabActive)
            #endif
        }
    }
}
