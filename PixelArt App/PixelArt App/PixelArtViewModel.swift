//
//  PixelArtViewModel.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 04/11/20.
//

import SwiftUI

public enum Tab: Hashable{
    case home, album
}

struct Navegacao {
    
    var pixelArts = [PixelArt]()
    
    var albuns = [Album]()
    
    private var selectedTab: Tab = .home
    var tabSelecionada: Tab {
        get {
            return selectedTab
        }
        set {
            PXSalvando = nil
            AlbumAberto = nil
            selectedTab = newValue
        }
    }
    
    private var AlAberto: Album?
    var AlbumAberto: Album? {
        set{
            selectedTab = .album
            AlAberto = newValue
        }
        get{
            return AlAberto
        }
    }
    
    
    private var PXSalvando : PixelArt?
    var salvandoEmAlbum: PixelArt? {
        set{
            selectedTab = .album
            PXSalvando = newValue
        }
        get{
            return PXSalvando
        }
    }
    
    var criandoAlbum : Bool = false
    var nomeAlbum : String = ""
    var confirmandoDelete : Bool = false
    
}

class PixelArtViewModel : ObservableObject {
    
    @Published var nav = Navegacao()
    

    init() {
        fetch()
    }
    
    func fetch() {
        
        DispatchQueue.main.async {
            
            self.nav.pixelArts = []
            self.nav.albuns = []
         
            var draws = [String]()
            var drawAls = [String]()
            var albs = [String]()
            
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }

            let enumerator = FileManager.default.enumerator(atPath: directory.path!)

            while let filename = enumerator?.nextObject() as? String {
                print(filename)
                if filename.hasPrefix("alb_") && filename.hasSuffix(".png") {
                    albs.append(filename)
                }
                else if filename.hasPrefix("draw_") && filename.hasSuffix(".png") {
                    draws.append(filename)
                }
                else if filename.hasPrefix("drawAl_") && filename.hasSuffix(".png") {
                    drawAls.append(filename)
                }
            }
            
            for alb in albs {
                var str = alb
                var range = str.startIndex..<str.index(str.startIndex, offsetBy: 4)
                str.removeSubrange(range)//remove o alb_
                range = str.index(str.endIndex, offsetBy: -4)..<str.endIndex
                str.removeSubrange(range)//remove o .png
                
                var id = str
                range = id.startIndex..<str.index(id.firstIndex(of: "_")!, offsetBy: 1)
                id.removeSubrange(range)
                
                var nome = str
                range = nome.index(str.firstIndex(of: "_")!, offsetBy: 0)..<nome.endIndex
                nome .removeSubrange(range)
                
                let al = Album(id: UUID(uuidString: id) ?? UUID(), name: nome, imageName: str, image: self.fetchImage(named: alb))
                self.nav.albuns.append(al)
            }
            
            for drawAl in drawAls {
                var str = drawAl
                
                var range = str.startIndex..<str.index(str.startIndex, offsetBy: 7)
                str.removeSubrange(range)//remove o albAl_
                range = str.index(str.endIndex, offsetBy: -4)..<str.endIndex
                str.removeSubrange(range)//remove o .png
                
                var album = str
                range = album.startIndex..<album.index(album.firstIndex(of: "_")!, offsetBy: 1)
                album.removeSubrange(range)
                
                var id = str
                range = id.index(id.firstIndex(of: "_")!, offsetBy: 0)..<id.endIndex
                id.removeSubrange(range)
                
                let draw = PixelArt(id: UUID(uuidString: id) ?? UUID(), imageName: drawAl, image: self.fetchImage(named: drawAl), album: UUID(uuidString: album))
                self.nav.pixelArts.append(draw)
            }
            
            for draw in draws {
                var str = draw
                var range = str.startIndex..<str.index(str.startIndex, offsetBy: 5)
                str.removeSubrange(range)
                range = str.index(str.endIndex, offsetBy: -4)..<str.endIndex
                str.removeSubrange(range)
//                print(str)
                let px = PixelArt(id: UUID(uuidString: str) ?? UUID(), imageName: draw, image: self.fetchImage(named: draw), album: nil)
//                print(px)
                self.nav.pixelArts.append(px)
            }
            
        }
    }
    
    func fetchImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    

    
    //MARK: Intents
    
    func createFakeData(){
        fetch()
    }
    
    func exitAlbum() {
        nav.AlbumAberto = nil
    }
    
    func saveOrRemoveFromAlbum(pixelArt: PixelArt) {
        if nav.tabSelecionada == .home {
            
            if pixelArt.album == nil{
                //Caso esteja na home e a PX n tenha um álbum, leva pra tela de escolha do álbum
                nav.salvandoEmAlbum = pixelArt
                
            } else {
                
                //Caso esteja na home e a PX já tenha um álbum, leva até esse álbum
                guard let index = nav.albuns.firstIndex(where: { $0.id == pixelArt.album }) else { return }
                nav.AlbumAberto = nav.albuns[index]
            }
            
        } else {
            
            // Senão, remove o álbum da pixelArt selecionada
            
            do {
                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                    return
                }
                
                let teste = pixelArt.imageName
                let originPath = directory.appendingPathComponent(teste)
                
                var str = pixelArt.imageName
                var range = str.startIndex..<str.index(str.startIndex, offsetBy: 7)
                str.removeSubrange(range)//remove o albAl_
                range = str.index(str.endIndex, offsetBy: -4)..<str.endIndex
                str.removeSubrange(range)//remove o .png
                
                range = str.index(str.firstIndex(of: "_")!, offsetBy: 0)..<str.endIndex
                str.removeSubrange(range)
                
                str.append(".png")
                str = "draw_\(str)"
                
                
                let destinationPath = directory.appendingPathComponent(str)
                try FileManager.default.moveItem(at: originPath!, to: destinationPath!)
            } catch {
                print(error)
            }
        }
        
        fetch()
    }
    
    func newAlbum() -> Void {
        if nav.nomeAlbum != "" {
            let al = Album(name: nav.nomeAlbum, imageName: nav.salvandoEmAlbum!.imageName, image: nav.salvandoEmAlbum?.image)
            
            let img = nav.salvandoEmAlbum?.image
            
            saveImageAlbum(image: img!, album: al)
            salvarPxNoAlbum(album: al)
            
            nav.AlbumAberto = al
            nav.salvandoEmAlbum = nil
            nav.criandoAlbum = false
            nav.nomeAlbum = ""
        }
        
        fetch()
    }
    
    func touchAlbum(album: Album) {
        if nav.salvandoEmAlbum != nil {
            
            salvarPxNoAlbum(album: album)
        }
        
        nav.salvandoEmAlbum = nil
        nav.criandoAlbum = false
        nav.AlbumAberto = album
        fetch()
    }
    
    private func salvarPxNoAlbum(album: Album){
        do {
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            
            let teste = self.nav.salvandoEmAlbum!.imageName
            let originPath = directory.appendingPathComponent(teste)
            
            var str = self.nav.salvandoEmAlbum!.imageName
            var range = str.index(str.endIndex, offsetBy: -4)..<str.endIndex
            str.removeSubrange(range)//remove o .png
            range = str.startIndex..<str.index(str.startIndex, offsetBy: 4)
            str.removeSubrange(range)
            
            str.append("_\(album.id).png")
            str = "drawAl\(str)"
            
            
            let destinationPath = directory.appendingPathComponent(str)
            try FileManager.default.moveItem(at: originPath!, to: destinationPath!)
        } catch {
            print(error)
        }
    }
    
    func DeleteAlbum(album : Album) {
        
        do{
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            
            try FileManager.default.removeItem(at: directory.appendingPathComponent("alb_\(album.imageName).png")!)
        }
        catch {
            print(error)
        }
        
        
        fetch()
    }
    
    func deletePX(px : PixelArt){
        do{
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            
            try FileManager.default.removeItem(at: directory.appendingPathComponent(px.imageName)!)
        }
        catch {
            print(error)
        }
        
        fetch()
    }
    
    private func saveImageAlbum(image: UIImage, album: Album){
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }

        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }

        do {
            let str = "alb_\(album.name)_\(album.id)"
            try data.write(to: directory.appendingPathComponent("\(str).png")!)
            return
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}
