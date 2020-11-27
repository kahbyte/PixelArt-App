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
                            Text("Adicionar à um Álbum")
                        } else {
                            Text("Ver no Álbum")
                        }
                        Spacer()
                        Image(systemName: "folder")

                    } else {
                        Text("Remover do Álbum")
                        Spacer()
                        Image(systemName: "clear")
                    }
                    
                }
            }
            
            Button(action: {}) {
                HStack{
                    Text("Compartilhar")
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            Button(action: {}) {
                HStack{
                    Text("Editar")
                    Spacer()
                    Image(systemName: "pencil")
                }
            }
            
            Button(action: {
                pixelArtViewModel.nav.confirmandoDelete = true
                
            }) {
                HStack{
                    Text("Excluir")
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
