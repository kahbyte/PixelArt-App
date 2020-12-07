//
//  ContextMenu.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 10/11/20.
//

import SwiftUI

struct ContMenu: View {
    
    @EnvironmentObject var pixelArtViewModel : PixelArtViewModel
    
    var pixelArt: PixelArt
    
    var body: some View {
        Group{
            Button(action: { pixelArtViewModel.saveOrRemoveFromAlbum(pixelArt: pixelArt) }) {
                HStack{
                    if (pixelArtViewModel.nav.tabSelecionada == Tab.home) {
                        if pixelArt.album == nil {
                            Text("Add to Album")
                        } else {
                            Text("Open in Album")
                        }
                        Spacer()
                        Image(systemName: "folder")

                    } else {
                        Text("Remove from Album")
                        Spacer()
                        Image(systemName: "clear")
                    }
                    
                }
            }
            
            Button(action: {}) {
                HStack{
                    Text("Share")
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            Button(action: {}) {
                HStack{
                    Text("Edit")
                    Spacer()
                    Image(systemName: "pencil")
                }
            }
            
            Button(action: {
                pixelArtViewModel.deletePX(px: pixelArt)
                
            }) {
                HStack{
                    Text("Delete")
                    Spacer()
                    Image(systemName: "trash")
                }
            }

        }
    }
}

//struct ContextMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        ContMenu(texto: "Teste")
//    }
//}
