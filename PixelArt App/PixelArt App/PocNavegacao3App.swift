//
//  PocNavegacao3App.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 03/11/20.
//

import SwiftUI

@main
struct PocNavegacao3App: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = PixelArtViewModel()
            ContentView().environmentObject(viewModel)
        }
    }
}
