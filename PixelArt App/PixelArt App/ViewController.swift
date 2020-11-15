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
    @IBOutlet var colorMenu: ctxtMenu!
    @IBOutlet var colorBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.zoomScale = 1
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        
        testView.isUserInteractionEnabled = true
    }
    
    //MARK: Export Functions
    /*copy the grid's view, remove it's borders, rescale it and then pops up a share sheet to export it*/
    @IBAction func export(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.zoomScale = 1.0
        }
        
        let scaledGridView = scaleViewsToHD(view: testView.contentView)
        
        let renderer = UIGraphicsImageRenderer(size: scaledGridView.bounds.size)
        
        
        let image = renderer.image { ctx in
            scaledGridView.drawHierarchy(in: scaledGridView.bounds, afterScreenUpdates: true)
        }
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        present(share, animated: true, completion: nil)
        
        scaledGridView.removeFromSuperview()
    }
    
    /*Scales the view and everything in it*/
    func scaleViewsToHD(view: UIView) -> UIView {
        let newCells: [String: UIView] = testView.cells
        
        let hdView = UIView()
        
        hdView.frame.size = CGSize(width: 1080, height: 1080)
        
        hdView.layer.borderWidth = 0.0
        
        let scaleMultiplier = 1080 / view.bounds.width
        let width = hdView.frame.width / 31
        print("scaleMultiplier: \(scaleMultiplier)")
        
        /*scalling everything
         I've been through hell*/
        for j in 1 ... 31 {
            for i in 1 ... 31 {
                let key = "\(i)|\(j)"
                let cell = newCells[key]?.copyView()
                cell?.layer.borderWidth = 0.0
                cell!.frame = CGRect(x: width * CGFloat(i-1), y: width * CGFloat(j-1), width: width, height: width)
                hdView.addSubview(cell!)
            }
        }
        
        return hdView
    }
    
    

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return testView
    }
    
    //MARK: IBActions!
    @IBAction func Lapis(_ sender: Any) {
        tool = .pen
        
        testView.awakeFromNib()
    }
    
    @IBAction func Borracha(_ sender: Any) {
        tool = .eraser
        
        testView.awakeFromNib()
    }
    
    @IBAction func Linha(_ sender: Any) {
        tool = .line
        
        testView.awakeFromNib()
    }
    
    @IBAction func Balde(_ sender: Any) {
        tool = .bucket
        
        testView.awakeFromNib()
    }

    @IBAction func colorBttn(_ sender: Any) {
        if color == nil{
            color = .black
        }
        
        colorMenu.isHidden = false
        colorMenu.layer.borderColor = color.cgColor
        colorMenu.layer.borderWidth = 5.0
    }
    
    @IBAction func SimetriaV(_ sender: Any) {
        tool = .symmetryY
        
        testView.awakeFromNib()
    }
    
    @IBAction func SimetriaH(_ sender: Any) {
        tool = .symmetryX
        
        testView.awakeFromNib()
    }
    
    @IBAction func SimetriaGeral(_ sender: Any) {
        tool = .symmetryXY
        
        testView.awakeFromNib()
    
    }
}

