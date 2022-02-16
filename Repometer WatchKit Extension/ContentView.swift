//
//  ContentView.swift
//  Repometer WatchKit Extension
//
//  Created by Sam Perlmutter on 2/15/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Buzz", action: {
            WKInterfaceDevice.current().play(WKHapticType.click)
        })
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
