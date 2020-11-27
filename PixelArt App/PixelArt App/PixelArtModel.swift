//
//  PixelArt.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 04/11/20.
//

import SwiftUI

struct PixelArt: Identifiable{
    
    var id = UUID()
    //var name: String
    //var size: Int
    //var matriz = [[CGFloat]]()
    var imageName: String
    var image: UIImage?

    
    var album: Album.ID?

}

struct Album : Identifiable{
    var id = UUID()
    var name: String
    var imageName: String
    var image: UIImage?
}
