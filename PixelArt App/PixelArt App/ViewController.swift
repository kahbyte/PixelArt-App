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
    @IBOutlet weak var colorBttn: UIButton!
    let colorPicker = UIColorPickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPicker.delegate = self
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
    
    private func selectColor(){
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = color
        present(colorPicker, animated: true)
    }

    //MARK: IBActions!
    @IBAction func pen(_ sender: Any) {
        tool = .pen
        gridView.awakeFromNib()
    }
    
    @IBAction func eraser(_ sender: Any) {
        tool = .eraser
        
        gridView.awakeFromNib()
    }
    
    @IBAction func line(_ sender: Any) {
        tool = .line
        gridView.awakeFromNib()
    }
    
    @IBAction func bucket(_ sender: Any) {
        tool = .bucket
        gridView.awakeFromNib()
    }
    
    @IBAction func colorBttn(_ sender: UIButton) {
       selectColor()
    }
    
    @IBAction func symmetryY(_ sender: Any) {
        tool = .symmetryY
        gridView.awakeFromNib()
    }
    
    @IBAction func symmetryX(_ sender: Any) {
        tool = .symmetryX
        gridView.awakeFromNib()
    }
    
    @IBAction func symmetryXY(_ sender: Any) {
        tool = .symmetryXY
        gridView.awakeFromNib()
        
    }
    @IBAction func undo(_ sender: Any) {
        gridView.undoAction()
    }

    @IBAction func redo(_ sender: Any) {
        gridView.redoAction()
    }
    
}

extension ViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor
    }
}

