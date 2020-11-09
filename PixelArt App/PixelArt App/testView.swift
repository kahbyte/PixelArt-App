//
//  testView.swift
//  testes grid
//
//  Created by Kauê Sales on 26/10/20.
//

import UIKit

class testView: UIView, UIGestureRecognizerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var cells = [String: UIView]()
    
    var numViewPerRow = 31
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func awakeFromNib() {
        contentView.isUserInteractionEnabled = true
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTouch))
        contentView.addGestureRecognizer(panGestureRecognizer)
        
        panGestureRecognizer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("grid", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.borderWidth = 0.4
        contentView.layer.borderColor = UIColor.black.cgColor
        
        
        initGrid()
    }
    
    private func initGrid() {
        let width = contentView.frame.width / CGFloat(numViewPerRow)
        
            for j in 1 ... numViewPerRow {
            for i in 1 ... numViewPerRow {
                let cell = UIView()
                
  
                cell.backgroundColor = .clear
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.layer.borderWidth = 0.3
                
                cell.frame = CGRect(x: width * CGFloat(i-1), y: width * CGFloat(j-1), width: width, height: width)
                
                contentView.addSubview(cell)
                
                let key = "\(i)|\(j)"
                cells[key] = cell
            }
        }
    }
    
    @objc func handleTouch(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: contentView)
        print(location)
        
        let width = contentView.frame.width / CGFloat(numViewPerRow)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        
        let key = "\(i+1)|\(j+1)"
        
        
        
        DispatchQueue.main.async {
            self.draw(key: key)
        }
    }
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let width = contentView.frame.width / CGFloat(numViewPerRow)

            
            let i = Int(location.x / width)
            let j = Int(location.y / width)
            
            let key = "\(i+1)|\(j+1)"
            
            DispatchQueue.main.async {
                self.draw(key: key)
            }
        }
    }*/
    
    /*
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let width = contentView.frame.width / CGFloat(numViewPerRow)

            
            let i = Int(location.x / width)
            let j = Int(location.y / width)
            
            let key = "\(i+1)|\(j+1)"
            
            DispatchQueue.main.async {
                self.draw(key: key)
            }
        }
    }*/
    
    /*override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            let width = contentView.frame.width / CGFloat(numViewPerRow)

            
            let i = Int(location.x / width)
            let j = Int(location.y / width)
            
            let key = "\(i+1)|\(j+1)"
            
            DispatchQueue.main.async {
                self.draw(key: key)
            }
        }
    }*/
    
    func draw(key: String) {
        
        let cellView = cells[key]
        
        if cellView?.backgroundColor != .black {
            cellView?.backgroundColor = .black
            generator.impactOccurred(intensity: 0.7)
        }
    }
    
    fileprivate func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func removerBordas() {
        
        for (key, _) in self.cells {
            UIView.animate(withDuration: 1.0) {
                self.cells[key]!.layer.borderWidth = 0.0
            }
        }
    
        
        contentView.layer.borderWidth = 0.0
    }
    
    func adicionarBordas() {
        
        UIView.animate(withDuration: 0.5) {
            for(key, _) in self.cells {
                self.cells[key]!.layer.borderWidth = 0.3
            }
            
            self.contentView.layer.borderWidth = 0.4
        }
    }

}
