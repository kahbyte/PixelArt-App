//
//  testView.swift
//  testes grid
//
//  Created by Kauê Sales on 26/10/20.
//

import UIKit

var apaga = 0
var balde = 0
var linha = 0

class testView: UIView, UIGestureRecognizerDelegate {
    var x1 = 0
    var x2 = 0
    var y1 = 0
    var y2 = 0
    
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
        if linha == 1{
            for recognizer in contentView.gestureRecognizers ?? [] {
                contentView.removeGestureRecognizer(recognizer)
            }
        }else{
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTouch))
        contentView.addGestureRecognizer(panGestureRecognizer)
        
            panGestureRecognizer.delegate = self
        }
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
        //print(location)
        
        let width = contentView.frame.width / CGFloat(numViewPerRow)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        
        DispatchQueue.main.async {
            self.draw(i: i, j: j)
        }
    }
    
    func draw(i: Int, j: Int) {
        let ident = "\(i + 1)|\(j + 1)"
        let cellView = cells[ident]
        
        if apaga == 1{
            cellView?.backgroundColor = .clear
        }else if balde == 1{
            colorir(i: i, j: j)
        }else{
            if cellView?.backgroundColor != .black {
                cellView?.backgroundColor = .black
                generator.impactOccurred(intensity: 0.7)
            }
        }
    }
    
    func colorir(i: Int, j: Int){
        let ident = "\(i + 1)|\(j+1)"
        let cell = cells[ident]
        if cell?.backgroundColor != .black && i >= 0 && j >= 0 && i < numViewPerRow && j < numViewPerRow{
            cell?.backgroundColor = .black
            colorir(i: i + 1, j: j)
            colorir(i: i - 1, j: j)
            colorir(i: i, j: j + 1)
            colorir(i: i, j: j - 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let local = touch.location(in: contentView)
            let width = contentView.frame.width / CGFloat(numViewPerRow)
            let i = Int(local.x / width)
            let j = Int(local.y / width)
            x1 = i
            y1 = j
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let local = touch.location(in: contentView)
            let width = contentView.frame.width / CGFloat(numViewPerRow)
            let i = Int(local.x / width)
            let j = Int(local.y / width)
            x2 = i
            y2 = j
            
            draw(i: i, j: j)
        }
        if linha == 1{
            fazLinha(x1: x1, x2: x2, y1: y1, y2: y2)
        }
    }
    
    func fazLinha(x1: Int, x2: Int, y1: Int, y2: Int){
        let dx = x2 - x1
        let dy = y2 - y1
        if x1 == x2 && y1 == y2{
            let ident = "\(x1 + 1)|\(y1 + 1)"
            let cellView = cells[ident]
            cellView?.backgroundColor = .black
        }else if x1 == x2 || abs(dy) > abs(dx){
            if y1 < y2{
                equacaodaReta(x1: y1, x2: y2, y1: x1, y2: x2, f: y1, g: y2, h: 1)
            }else{
                equacaodaReta(x1: y1, x2: y2, y1: x1, y2: x2, f: y2, g: y1, h: 1)
            }
        }else{
            if x1 < x2{
                equacaodaReta(x1: x1, x2: x2, y1: y1, y2: y2, f: x1, g: x2, h: 0)
            }else{
                equacaodaReta(x1: x1, x2: x2, y1: y1, y2: y2, f: x2, g: x1, h: 0)
            }
        }
        
    }
    
    func equacaodaReta(x1: Int, x2: Int, y1: Int, y2: Int, f: Int, g: Int, h: Int){
        let dx = x2 - x1
        let dy = y2 - y1
        var ident = "0|0"
        var b: Float
        var y: Int
        for x in f...g{
            let a = x - x1
            b = (Float(a) / Float(dx)) * Float(dy)
            y = quebradeLinha(x: x, x1: x1, x2: x2, y1: y1, f: f, g: g, dy: dy, b: b)
            if h == 0{
                ident = "\(x + 1)|\(y + 1)"
            }else{
                ident = "\(y + 1)|\(x + 1)"
            }
            
            let cellView = cells[ident]
            cellView?.backgroundColor = .black
        }
    }
    
    func quebradeLinha(x: Int, x1: Int, x2: Int, y1: Int, f: Int, g: Int, dy: Int, b: Float) -> Int{
        var y: Int
        if abs(dy) == 1 && ((x2 > x1 && x > (((g - f)/2) + f)) || (x1 > x2 && x < (((f - g)/2) + g))){
            if dy < 0{
                y = y1 - 1
            }else{
                y = y1 + 1
            }
        }else{
            y = y1 + Int(b)
        }
        
        return y
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
