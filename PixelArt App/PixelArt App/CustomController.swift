//
//  CustonController.swift
//  PocNavegacao3
//
//  Created by Lucas Claro on 23/11/20.
//

import SwiftUI

struct CustomController : UIViewControllerRepresentable {
//    @Binding var estouaparecendo: Bool 
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomController>) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "Home")
//        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CustomController>) {

    }
    
    class Coordinator {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
