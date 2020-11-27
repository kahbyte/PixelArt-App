//
//  Home.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 06/11/20.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var pixelArtViewModel : PixelArtViewModel
    
    var body: some View{
        
        VStack{
            
//            let data = (1...25).map { "Item \($0)" }
            
            let columns = [
                GridItem(.flexible(minimum: 40), spacing: 0),
                GridItem(.flexible(minimum: 40), spacing: 0),
                GridItem(.flexible(minimum: 40))
            ]
            
            ScrollView{
                LazyVGrid(columns: columns, spacing: 0) {
                    
                    ForEach(pixelArtViewModel.nav.pixelArts) { item in
                        Image(uiImage: item.image!).resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .contextMenu{
                                ContMenu(pixelArt: item)
                            }
                    }
                    
                }
            }
            
        }
        
    } // body
    
} // struct

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//      Home()
//    }
//}
