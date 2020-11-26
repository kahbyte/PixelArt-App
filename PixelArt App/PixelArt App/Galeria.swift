//
//  Galeria.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 06/11/20.
//

import SwiftUI

struct Galeria: View {
    
    @EnvironmentObject var pixelArtViewModel : PixelArtViewModel
    
    @State var alertTemp : Bool = false
    @State var alertText : String = ""
    
    var body: some View {
        
        if pixelArtViewModel.nav.AlbumAberto != nil {
            AlbumAberto()
        } else {
            
            VStack{
                
                if (pixelArtViewModel.nav.salvandoEmAlbum != nil) {
                    HStack{
                        Image(uiImage: pixelArtViewModel.nav.salvandoEmAlbum?.image ?? UIImage(imageLiteralResourceName: "teste"))
                            .resizable()
                            .frame(width: 60, height: 60, alignment:  .center)
                        Text("Escolha um álbum para esse desenho").font(.callout)
                    }
                    .padding(.top)
                    
                    
                    Divider()
                }
                
                if (pixelArtViewModel.nav.criandoAlbum) {
                    HStack {
                        TextField("Nome: ", text: $pixelArtViewModel.nav.nomeAlbum)
                        Spacer()
                        Button(action: { pixelArtViewModel.newAlbum() }) {
                            Text("Salvar")
                        }
                        Button(action: {
                            withAnimation {
                                pixelArtViewModel.nav.criandoAlbum = false
                                pixelArtViewModel.nav.nomeAlbum = ""
                            }
                        }) {
                            Text("Cancelar")
                                .foregroundColor(Color.red)
                        }
                    }
                        .padding()
                        
                }
                
                //            let data = (1...9).map { "Álbum \($0)" }
                
                let columns = [
                    GridItem(.flexible(minimum: 40), spacing: 0),
                    GridItem(.flexible(minimum: 40))
                ]
                
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 0) {
                        
                        if (pixelArtViewModel.nav.salvandoEmAlbum != nil && !pixelArtViewModel.nav.criandoAlbum) {
                            VStack(alignment: .leading) {
                                Image("novoAlbum").resizable()
                                    .frame(minWidth: 150, idealWidth: 150, maxWidth: 150, minHeight: 150, idealHeight: 150, maxHeight: 150, alignment: .center)
                                Text("Novo Álbum...")
                                
                            }
                                .padding()
                                .onTapGesture {
                                    withAnimation {
                                        pixelArtViewModel.nav.criandoAlbum = true
                                    }
                                }
                           
                        }
                        
                        ForEach(pixelArtViewModel.nav.albuns) { item in
                            
                            VStack(alignment: .leading) {
                                Image(uiImage: item.image ?? UIImage(imageLiteralResourceName: "teste")).resizable()
                                    .frame(minWidth: 150, idealWidth: 150, maxWidth: 150, minHeight: 150, idealHeight: 150, maxHeight: 150, alignment: .center)
//                                Image(uiImage: item.image ?? UIImage(imageLiteralResourceName: "teste")).resizable()
//                                    .frame(width: 150, height: 150, alignment: .center)
                                Text(item.name)
                                
                            }
                            .onTapGesture {
                                pixelArtViewModel.touchAlbum(album: item)
                            }
                            .padding()
                            .contextMenu() {
                                Button(action: { pixelArtViewModel.DeleteAlbum(album: item) }){
                                    HStack{
                                        Text("Excluir Album")
                                        Spacer()
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }
            }
        }//Else
        
        
        
    }
    
    func AlbumAberto() -> some View{
        let columns = [
            GridItem(.flexible(minimum: 40), spacing: 0),
            GridItem(.flexible(minimum: 40), spacing: 0),
            GridItem(.flexible(minimum: 40))
        ]
        
        let data = pixelArtViewModel.nav.pixelArts.filter { item in
            return item.album == pixelArtViewModel.nav.AlbumAberto!.id
        }
        
        return ScrollView{
            LazyVGrid(columns: columns, spacing: 0) {
                
                ForEach(data) { item in
                    Image(uiImage: (item.image ?? UIImage(contentsOfFile: "teste"))!).resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .contextMenu{
                            ContMenu(pixelArt: item)
                        }
                }
                
            }
        }
    }// func AlbumAberto
    
}

struct Galeria_Previews: PreviewProvider {
    static var previews: some View {
        Galeria()
    }
}
