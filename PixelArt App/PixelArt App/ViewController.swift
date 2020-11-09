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
    
    @IBAction func export(_ sender: Any) {
        
        testView.removerBordas()
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.zoomScale = 1.0
        }
        
        let renderer = UIGraphicsImageRenderer(size: testView.bounds.size)
        
        
        let image = renderer.image { ctx in
            testView.drawHierarchy(in: testView.bounds, afterScreenUpdates: true)
        }
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        share.completionWithItemsHandler = { activity, success, items, error in
            self.testView.adicionarBordas()
        }
        
        present(share, animated: true, completion: nil)
        
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
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

