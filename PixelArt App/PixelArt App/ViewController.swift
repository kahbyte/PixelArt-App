//
//  ViewController.swift
//  testes grid
//
//  Created by Kauê Sales on 26/10/20.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pen: UIButton!
    @IBOutlet weak var eraser: UIButton!
    @IBOutlet weak var bucket: UIButton!
    @IBOutlet weak var line: UIButton!
    @IBOutlet weak var symmetryX: UIButton!
    @IBOutlet weak var symmetryY: UIButton!
    @IBOutlet weak var symmetryXY: UIButton!
    
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
        highlightSelected()
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
        
        _ = saveImage(image: image)
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(share, animated: true, completion: nil)
        
        scaledGridView.removeFromSuperview()
    }
    
    /*Scales the view and everything in it*/
    func scaleViewsToHD(view: UIView) -> UIView {
        let newCells: [String: UIView] = gridView.cells
        
        let hdView = UIView()
        let watermark = UIImageView()
        
        hdView.frame.size = CGSize(width: 1080, height: 1080)
        
        hdView.layer.borderWidth = 0.0
        
        let scaleMultiplier = 1080 / view.bounds.width
        let width = hdView.frame.width / 31
        print("scaleMultiplier: \(scaleMultiplier)")
        
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
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        
        do {
            let str = "draw_\(UUID())"
            try data.write(to: directory.appendingPathComponent("\(str).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
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
        highlightSelected()
    }
    
    @IBAction func eraser(_ sender: Any) {
        tool = .eraser
        
        gridView.awakeFromNib()
        highlightSelected()
    }
    
    @IBAction func line(_ sender: Any) {
        tool = .line
        gridView.awakeFromNib()
        highlightSelected()
    }
    
    @IBAction func bucket(_ sender: Any) {
        tool = .bucket
        gridView.awakeFromNib()
        highlightSelected()
    }
    
    @IBAction func colorBttn(_ sender: UIButton) {
       selectColor()
    }
    
    @IBAction func symmetryY(_ sender: Any) {
        tool = .symmetryY
        gridView.awakeFromNib()
        highlightSelected()
    }
    
    @IBAction func symmetryX(_ sender: Any) {
        tool = .symmetryX
        gridView.awakeFromNib()
        highlightSelected()
    }
    
    @IBAction func symmetryXY(_ sender: Any) {
        tool = .symmetryXY
        gridView.awakeFromNib()
        highlightSelected()
        
    }
    @IBAction func undo(_ sender: Any) {
        gridView.undoAction()
    }

    @IBAction func redo(_ sender: Any) {
        gridView.redoAction()
    }
    
    @IBAction func Volta(_ sender: Any) {
        dismiss(animated: true, completion: .none)
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    
    func highlightSelected() {
        switch tool {
        case .pen:
            pen.isSelected = true
            eraser.isSelected = false
            bucket.isSelected = false
            line.isSelected = false
            symmetryX.isSelected = false
            symmetryY.isSelected = false
            symmetryXY.isSelected = false
        case .eraser:
            pen.isSelected = false
            eraser.isSelected = true
            bucket.isSelected = false
            line.isSelected = false
            symmetryX.isSelected = false
            symmetryY.isSelected = false
            symmetryXY.isSelected = false
        case .bucket:
            pen.isSelected = false
            eraser.isSelected = false
            bucket.isSelected = true
            line.isSelected = false
            symmetryX.isSelected = false
            symmetryY.isSelected = false
            symmetryXY.isSelected = false
        case .line:
            pen.isSelected = false
            eraser.isSelected = false
            bucket.isSelected = false
            line.isSelected = true
            symmetryX.isSelected = false
            symmetryY.isSelected = false
            symmetryXY.isSelected = false
        case .symmetryY:
            pen.isSelected = false
            eraser.isSelected = false
            bucket.isSelected = false
            line.isSelected = false
            symmetryX.isSelected = false
            symmetryY.isSelected = true
            symmetryXY.isSelected = false
        case .symmetryX:
            pen.isSelected = false
            eraser.isSelected = false
            bucket.isSelected = false
            line.isSelected = false
            symmetryX.isSelected = true
            symmetryY.isSelected = false
            symmetryXY.isSelected = false
        case .symmetryXY:
            pen.isSelected = false
            eraser.isSelected = false
            bucket.isSelected = false
            line.isSelected = false
            symmetryX.isSelected = false
            symmetryY.isSelected = false
            symmetryXY.isSelected = true
        }
    }
    
}

extension ViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor
    }
}

