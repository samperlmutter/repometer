//
//  ProgressCounter.swift
//  Repometer
//
//  Created by Sam Perlmutter on 12/11/23.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

struct ProgressCounter: View {
    @Environment(\.scenePhase) private var scenePhase
    @Binding var value: Double
    @State private var lineate = true
    @State private var dimmed = false
    let total: Int
    let primaryColor: Color
    let secondaryColor: Color
    let textColor: Color

    private let strokeScale = 0.09
    private let calcLineWidth = { (g: GeometryProxy, scale: Double) -> Double in
        return min(g.size.width, g.size.height) * scale
    }

    var body: some View {
        GeometryReader{ g in
            ZStack {
                Circle()
                    .strokeBorder(secondaryColor, lineWidth: calcLineWidth(g, strokeScale))
                Circle()
                    .inset(by: calcLineWidth(g, strokeScale / 2))
                    .trim(from: 0, to: Double(value) / Double(total))
                    .stroke(
                        primaryColor,
                        style: StrokeStyle(lineWidth: calcLineWidth(g, strokeScale), lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(lineate && Int(value) != total ? .linear : .easeInOut(duration: 0.30), value: value)
                    .hidden(dimmed)
                    .onChange(of: scenePhase) {
                        withAnimation {
                            dimmed = scenePhase != .active
                        }
                    }
                Text("\(value == 1 && total == 1 ? 0 : value, specifier: "%.0f")")
                    .font(.system(size: calcLineWidth(g, 0.4)))
                    .foregroundStyle(textColor)
                    .contentTransition(.numericText(value: Double(value)))
            }
            .frame(width: g.size.width, height: g.size.height)
        }
    }
}

struct ProgressCounter_Previews: PreviewProvider {
    static var previews: some View {
        @State var value = 3.0
        return ProgressCounter(value: $value,
                               total: 10,
                               primaryColor: Color("bluePrimaryColor"),
                               secondaryColor: Color("blueSecondaryColor"),
                               textColor: Color("orangePrimaryColor"))
    }
}
