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
            
            Button(action: {
                print("Tema")
                pixelArtViewModel.createFakeData()
            }){
                HStack{
                    Text("Ver desafio diário")
                        .padding(.horizontal)
                    
                    Image(systemName: "eye")
                        .padding(.horizontal)
                }
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(40)
            }
                .padding()
            
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
                            .alert(isPresented: $pixelArtViewModel.nav.confirmandoDelete) {
                                Alert(title: Text("Deseja mesmo deletar?"), message: Text("Essa operação não poderá ser disfeita"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Confirmar"), action: {
                                        pixelArtViewModel.deletePX(px: item)
                                }))
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
