//
//  launchScreen.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 27/11/20.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State var splashScreenEnded:Bool = false
    
    let viewModel = PixelArtViewModel()
    
    var body: some View {
        VStack {
            if self.splashScreenEnded {
                ContentView().environmentObject(viewModel)
            } else {
                VStack{
                    Image("mascote")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 325 ,height: 325)
                    Image("titulo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190, height: 49, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.splashScreenEnded = true
                }
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
