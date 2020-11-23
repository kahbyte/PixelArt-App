//
//  ViewController.swift
//  testes grid
//
//  Created by Kauê Sales on 26/10/20.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colorMenu: ColorMenu!
    @IBOutlet weak var colorBttn: UIButton!
    @IBOutlet weak var dropperBttn: UIButton!
    @IBOutlet weak var lastColorBttn0: UIButton!
    @IBOutlet weak var lastColorBttn1: UIButton!
    @IBOutlet weak var lastColorBttn2: UIButton!
    @IBOutlet weak var lastColorBttn3: UIButton!
    @IBOutlet weak var lastColorBttn4: UIButton!
    @IBOutlet weak var lastColorBttn5: UIButton!
    @IBOutlet weak var lastColorBttn6: UIButton!
    @IBOutlet weak var lastColorBttn7: UIButton!
    @IBOutlet weak var lastColorBttn8: UIButton!
    @IBOutlet weak var lastColorBttn9: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.zoomScale = 1
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        
        
        gridView.isUserInteractionEnabled = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return gridView
    }
    
    //MARK: Export Functions
    /*copy the grid's view, remove it's borders, rescale it and then pops up a share sheet to export it*/
    @IBAction func export(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.zoomScale = 1.0
        }
        
        let scaledGridView = scaleViewsToHD(view: gridView.contentView)
        
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
        let newCells: [String: UIView] = gridView.cells
        
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
    
    func refreshLastColors(){
        lastColorBttn0.backgroundColor = colors[0]
        lastColorBttn1.backgroundColor = colors[1]
        lastColorBttn2.backgroundColor = colors[2]
        lastColorBttn3.backgroundColor = colors[3]
        lastColorBttn4.backgroundColor = colors[4]
        lastColorBttn5.backgroundColor = colors[5]
        lastColorBttn6.backgroundColor = colors[6]
        lastColorBttn7.backgroundColor = colors[7]
        lastColorBttn8.backgroundColor = colors[8]
        lastColorBttn9.backgroundColor = colors[9]
        lastColorChanged = false
    }
    
    
    //MARK: IBActions!
    @IBAction func pen(_ sender: Any) {
        tool = .pen
        if lastColorChanged == true{
            refreshLastColors()
        }
        gridView.awakeFromNib()
    }
    
    @IBAction func eraser(_ sender: Any) {
        tool = .eraser
        
        gridView.awakeFromNib()
    }
    
    @IBAction func line(_ sender: Any) {
        tool = .line
        if lastColorChanged == true{
            refreshLastColors()
        }
        gridView.awakeFromNib()
    }
    
    @IBAction func bucket(_ sender: Any) {
        tool = .bucket
        if lastColorChanged == true{
            refreshLastColors()
        }
        gridView.awakeFromNib()
    }
    
    @IBAction func colorBttn(_ sender: Any) {
        
        if colorMenu.isHidden == true{
            colorMenu.isHidden = false
        }
        
        else if colorMenu.isHidden == false{
            colorMenu.changeLastColors(newColor: color)
            colorMenu.isHidden = true
        }
        
        colorMenu.layer.borderColor = color.cgColor
        colorMenu.layer.borderWidth = 0.5
        refreshLastColors()
       
    }
    
    @IBAction func symmetryY(_ sender: Any) {
        tool = .symmetryY
        if lastColorChanged == true{
            refreshLastColors()
        }
        gridView.awakeFromNib()
    }
    
    @IBAction func symmetryX(_ sender: Any) {
        tool = .symmetryX
        if lastColorChanged == true{
            refreshLastColors()
        }
        gridView.awakeFromNib()
    }
    
    @IBAction func symmetryXY(_ sender: Any) {
        tool = .symmetryXY
        if lastColorChanged == true{
            refreshLastColors()
        }
        gridView.awakeFromNib()
        
    }
    @IBAction func undo(_ sender: Any) {
        gridView.undoAction()
    }
    @IBAction func dropperBttn(_ sender: UIButton) {
        tool = .dropper
    }
    @IBAction func redo(_ sender: Any) {
        gridView.redoAction()
    }
    
    @IBAction func lastColorBttn(_ sender: UIButton) {
        color = colors[sender.tag]
    }
}

