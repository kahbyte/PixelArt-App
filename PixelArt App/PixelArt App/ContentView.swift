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
    @State var test: Bool = false
    
    var body: some View {
        if test{
            CustomController().onDisappear{
                test = false
            }
        }else{
            NavigationView {
                TabView (selection: $pixelArtViewModel.nav.tabSelecionada){
                    
                    Home()
                        .tabItem{
                            VStack{
                                Image("home")
                                Text("Home")
                            }
                        }
                        .tag(Tab.home)
                    Galeria()
                        .tabItem{
                            VStack{
                                Image("album")
                                Text("Home")
                            }
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
                                                    Button(action:  {
                                                        test = true
                                                    }) {
                                                        Image(systemName: "plus")
                                                            .font(.title)
                                                    }
    //                            AddButton(destination: CustomController())
                            )
                    }
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

