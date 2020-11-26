//
//  ContentView.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 03/11/20.
//

//
//  ContentView.swift
//  PocNavegacao
//
//  Created by Lucas Claro on 03/11/20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var pixelArtViewModel : PixelArtViewModel
    
    var body: some View {
    
        NavigationView {
            TabView (selection: $pixelArtViewModel.nav.tabSelecionada){
                
                Home()
                    .tabItem{
                        Image(systemName: "house")
                    }
                    .tag(Tab.home)
                Galeria()
                    .tabItem{
                        Image(systemName: "folder")
                    }
                    .tag(Tab.album)
                
            }
                .if(pixelArtViewModel.nav.AlbumAberto != nil) {
                    $0
                        .navigationBarTitle(pixelArtViewModel.nav.AlbumAberto!.name)
                        .navigationBarTitleDisplayMode(.inline)
                        
                        .navigationBarItems(
                            leading:
                                Button(action:  {
                                pixelArtViewModel.exitAlbum()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title)
                            },
                            trailing:
                                Button(action:  {
                                    print("oi")
                                    pixelArtViewModel.createFakeData()
                                }) {
                                    Image(systemName: "plus")
                                        .font(.title)
                                }
                        )
                }
                .if(pixelArtViewModel.nav.AlbumAberto == nil) {
                    $0
                        .navigationBarTitle("")
                        .navigationBarTitleDisplayMode(.automatic)
                        .navigationBarItems(trailing:
                            AddButton(destination: CustomController())
                        )
                }
        }
    
    }

    
    struct AddButton<Destination : View>: View {
        var destination : Destination
        
        var body: some View {
            NavigationLink(destination: self.destination) {
                Image(systemName: "plus").font(.title)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Galeria()
    }
}

