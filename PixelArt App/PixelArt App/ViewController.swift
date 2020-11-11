//
//  ViewController.swift
//  testes grid
//
//  Created by Kauê Sales on 26/10/20.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var testView: testView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /*copy the grid's view, remove it's borders, rescale it and then pops up a share sheet to export it*/
    @IBAction func export(_ sender: Any) {
        testView.removerBordas()
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.zoomScale = 1.0
        }
        
        //let scaledGridView = scaleViewsToHD(view: testView.contentView)
        
        let renderer = UIGraphicsImageRenderer(size: testView.bounds.size)
        
        
        let image = renderer.image { ctx in
            testView.drawHierarchy(in: testView.bounds, afterScreenUpdates: true)
        }
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        share.completionWithItemsHandler = { activity, success, items, error in
            self.testView.adicionarBordas()
        }
        
        present(share, animated: true, completion: nil)
        
        //scaledGridView.removeFromSuperview()
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    /*Scales the view and everything in it*/
    func scaleViewsToHD(view: UIView) -> UIView {
        
        let hdView = view.copyView()
        
        hdView.frame.size = CGSize(width: 1080, height: 1080)
        
        hdView.layer.borderWidth = 0.0
        
        let scaleMultiplier = 1080 / view.bounds.width
        let width = hdView.frame.width / 31
        print("scaleMultiplier: \(scaleMultiplier)")
        
        /*scalling everything
         I've been through hell*/
        
        for subview in hdView.subviews {
            subview.frame.size = CGSize(width: subview.frame.width * scaleMultiplier, height: subview.frame.height * scaleMultiplier)
            subview.layer.borderWidth = 0.8
        }
        return hdView
    }
    
    
    @IBAction func Lapis(_ sender: Any) {
        apaga = 0
        balde = 0
        linha = 0
        testView.awakeFromNib()
    }
    
    @IBAction func Borracha(_ sender: Any) {
        apaga = 1
        balde = 0
        linha = 0
        testView.awakeFromNib()
    }
    
    @IBAction func Linha(_ sender: Any) {
        apaga = 0
        balde = 0
        linha = 1
        testView.awakeFromNib()
    }
    
    @IBAction func Balde(_ sender: Any) {
        balde = 1
        apaga = 0
        linha = 0
        testView.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.zoomScale = 1
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        
        testView.isUserInteractionEnabled = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return testView
    }
}

