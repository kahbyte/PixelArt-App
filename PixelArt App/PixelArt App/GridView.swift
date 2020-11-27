//
//  testView.swift
//  testes grid
//
//  Created by Kauê Sales on 26/10/20.
//

import UIKit

//MARK: Global Variables
//TODO: Conversar com o Denys sobre essas variaves globais de cor
var color: UIColor = .black
var corFundo: UIColor! = .clear

var red: CGFloat!
var green: CGFloat!
var blue: CGFloat!

var hexCode = String()
var hexStrings = ["", "", ""]

var isPanGestureRecognizerActive: Bool?

enum Tool {
    case pen
    case eraser
    case bucket
    case line
    case symmetryY
    case symmetryX
    case symmetryXY
}

var tool: Tool = .pen

class GridView: UIView, UIGestureRecognizerDelegate {
    var x1 = 0
    var x2 = 0
    var y1 = 0
    var y2 = 0
    var counter: Int = 0
    
    //TODO: Trocar isso com o Rafa
    var initialPosition = (x: 0, y: 0)
    var finalPosition = (x: 0, y: 0)
    
    @IBOutlet var contentView: UIView!
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    
    var cells = [String: UIView]()
    
    var numViewPerRow = 31
    
    struct Action {
        var key: String
        var lastColor: UIColor
        var currentColor: UIColor
        var lastAction: Tool
        var bitsInAction: Int
    }
    
    var recentActions: [Action] = []
    var redoActions: [Action] = []
    
    //MARK: Initialization functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    /*Is called after the xib is loaded, should not be abused.*/
    override func awakeFromNib() {
        contentView.isUserInteractionEnabled = true
        
        if tool == .line {
            for recognizer in contentView.gestureRecognizers ?? [] {
                contentView.removeGestureRecognizer(recognizer)
            }
            
        } else {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTouch))
            contentView.addGestureRecognizer(panGestureRecognizer)
            
            panGestureRecognizer.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //TODO: This function should be better written and called
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
    
    //MARK: Touch Functions
    
    @objc func handleTouch(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: contentView)
        
        
        let width = contentView.frame.width / CGFloat(numViewPerRow)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        
        if tool != .bucket {
            calledTool(i: i, j: j)
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
        counter = 0
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var i: Int = 0
        var j: Int = 0
        for touch in touches{
            let local = touch.location(in: contentView)
            let width = contentView.frame.width / CGFloat(numViewPerRow)
            i = Int(local.x / width)
            j = Int(local.y / width)
            x2 = i
            y2 = j
            
        }
        
        calledTool(i: x2, j: y2)
        
        if tool == .line{
            let ident = "\(i + 1)|\(j + 1)"
            let cellView = cells[ident]
            let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .line, bitsInAction: counter)
            recentActions.append(action)
        }

    }
    
    func calledTool(i: Int, j: Int) {
        switch tool {
        case .pen:
            draw(i: i, j: j)

        case .eraser:
            erase(i: i, j: j)

        case .bucket:
            bucket(i: i, j: j)
        return

        case .line:
            doLine(x1: x1, x2: x2, y1: y1, y2: y2)

        case .symmetryX:
            doSymmetry(i: i, j: j)

        case .symmetryY:
            doSymmetry(i: i, j: j)

        case .symmetryXY:
            doSymmetry(i: i, j: j)
        }
    }
    

    //MARK: Grid functions
    func draw(i: Int, j: Int) {
        let ident = "\(i + 1)|\(j + 1)"
        let cellView = cells[ident]
        
        if cellView?.backgroundColor != color {
            let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .pen, bitsInAction: 0)
            recentActions.append(action)
            
            cellView?.backgroundColor = color
            generator.impactOccurred(intensity: 0.7)
        }
    }
    
    func erase(i: Int, j: Int) {
        let ident = "\(i + 1)|\(j + 1)"
        let cellView = cells[ident]
        
        
        if cellView?.backgroundColor != .clear {
            let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: .clear, lastAction: .eraser, bitsInAction: 0)
            
            cellView?.backgroundColor = .clear
            recentActions.append(action)
        }
    }
    
    func bucket(i: Int, j: Int) {
        let ident = "\(i + 1)|\(j + 1)"
        let cellView = cells[ident]
        
        corFundo = cellView?.backgroundColor
        fillColor(i: i, j: j)
        let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .bucket, bitsInAction: counter)
        recentActions.append(action)
        counter = 0
    }
    
    func doSymmetry(i: Int, j: Int){
        let i1 = i + 1
        let j1 = j + 1
        let i2 = numViewPerRow - (i)
        let j2 = j + 1
        let i3 = i + 1
        let j3 = numViewPerRow - (j)
        let i4 = numViewPerRow - (i)
        let j4 = numViewPerRow - (j)
        let ident1 = "\(i1)|\(j1)"
        let cellView1 = cells[ident1]
        let ident2 = "\(i2)|\(j2)"
        let cellView2 = cells[ident2]
        let ident3 = "\(i3)|\(j3)"
        let cellView3 = cells[ident3]
        let ident4 = "\(i4)|\(j4)"
        let cellView4 = cells[ident4]
        
        if i >= 0 && i < numViewPerRow && j >= 0 && j < numViewPerRow{
            switch tool {
            case .symmetryX:
                if color != cellView1?.backgroundColor || color != cellView2?.backgroundColor{
                    mirror(i1: i1, j1: j1, i2: i2, j2: j2)
                    SymmetryAction(i: i1, j: j1)
                    counter = 0
                }
                
            case .symmetryY:
                if color != cellView1?.backgroundColor || color != cellView3?.backgroundColor{
                    mirror(i1: i1, j1: j1, i2: i3, j2: j3)
                    SymmetryAction(i: i1, j: j1)
                    counter = 0
                }
                
            case .symmetryXY:
                if color != cellView1?.backgroundColor || color != cellView2?.backgroundColor || color != cellView3?.backgroundColor || color != cellView4?.backgroundColor{
                    
                    mirror(i1: i1, j1: j1, i2: i2, j2: j2)
                    mirror(i1: i3, j1: j3, i2: i4, j2: j4)
                    SymmetryAction(i: i1, j: j1)
                    counter = 0
                }
                
            default:
                print("F")
            }
        }
    }
    
    func mirror(i1: Int, j1: Int, i2: Int, j2: Int){
        let ident1 = "\(i1)|\(j1)"
        let cellView1 = cells[ident1]
        let ident2 = "\(i2)|\(j2)"
        let cellView2 = cells[ident2]
        if color != cellView1?.backgroundColor {
            let action = Action(key: ident1, lastColor: (cellView1?.backgroundColor)!, currentColor: color, lastAction: .pen, bitsInAction: 0)
            recentActions.append(action)
            cellView1?.backgroundColor = color
            counter += 1
        }
        
        if color != cellView2?.backgroundColor {
            let action2 = Action(key: ident2, lastColor: (cellView2?.backgroundColor)!, currentColor: color, lastAction: .pen, bitsInAction: 0)
            recentActions.append(action2)
            cellView2?.backgroundColor = color
            counter += 1
        }
    }
    
    func SymmetryAction(i: Int, j: Int){
        let ident = "\(i)|\(j)"
        let cellView = cells[ident]
        switch tool {
        case .symmetryX:
            let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .symmetryX, bitsInAction: counter)
                recentActions.append(action)
            
        case .symmetryY:
            let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .symmetryY, bitsInAction: counter)
                recentActions.append(action)
            
        case .symmetryXY:
            let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .symmetryXY, bitsInAction: counter)
                recentActions.append(action)
        default:
            print("F")
        }
    }
    
    func fillColor(i: Int, j: Int){
        let ident = "\(i + 1)|\(j+1)"
        let cell = cells[ident]
        if cell?.backgroundColor == corFundo && cell?.backgroundColor != color && i >= 0 && j >= 0 && i < numViewPerRow && j < numViewPerRow{
            let action = Action(key: ident, lastColor: (cell?.backgroundColor)!, currentColor: color, lastAction: .pen, bitsInAction: 0)
            recentActions.append(action)
            cell?.backgroundColor = color
            counter += 1
            fillColor(i: i + 1, j: j)
            fillColor(i: i - 1, j: j)
            fillColor(i: i, j: j + 1)
            fillColor(i: i, j: j - 1)
        }
    }
    
    func doLine(x1: Int, x2: Int, y1: Int, y2: Int){
        let dx = x2 - x1
        let dy = y2 - y1
        
        if x1 == x2 && y1 == y2{
            let ident = "\(x1 + 1)|\(y1 + 1)"
            let cellView = cells[ident]
            cellView?.backgroundColor = color
        }else if x1 == x2 || abs(dy) > abs(dx){
            if y1 < y2{
                lineEquation(x1: y1, x2: y2, y1: x1, y2: x2, f: y1, g: y2, h: 1)
            }else{
                lineEquation(x1: y1, x2: y2, y1: x1, y2: x2, f: y2, g: y1, h: 1)
            }
        }else{
            if x1 < x2{
                lineEquation(x1: x1, x2: x2, y1: y1, y2: y2, f: x1, g: x2, h: 0)
            }else{
                lineEquation(x1: x1, x2: x2, y1: y1, y2: y2, f: x2, g: x1, h: 0)
            }
        }
        
    }
    
    func lineEquation(x1: Int, x2: Int, y1: Int, y2: Int, f: Int, g: Int, h: Int){
        var i: Int = 0
        var j: Int = 0
        let dx = x2 - x1
        let dy = y2 - y1
        var b: Float
        var y: Int
        for x in f...g{
            let a = x - x1
            b = (Float(a) / Float(dx)) * Float(dy)
            y = lineBreak(x: x, x1: x1, x2: x2, y1: y1, f: f, g: g, dy: dy, b: b)
            
            if h == 0{
                i = x + 1
                j = y + 1
            } else {
                i = y + 1
                j = x + 1
            }
            actionsInLine(i: i, j: j)
        }
    }
    
    func lineBreak(x: Int, x1: Int, x2: Int, y1: Int, f: Int, g: Int, dy: Int, b: Float) -> Int{
        var y: Int
        if abs(dy) == 1 && ((x2 > x1 && x > (((g - f)/2) + f)) || (x1 > x2 && x < (((f - g)/2) + g))){
            if dy < 0{
                y = y1 - 1
            } else {
                y = y1 + 1
            }
        } else {
            y = y1 + Int(b)
        }
        
        return y
    }
    
    func actionsInLine(i: Int, j: Int){
        let ident = "\(i)|\(j)"
        let cellView = cells[ident]
        
        let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .pen, bitsInAction: 0)
        recentActions.append(action)
    
        cellView?.backgroundColor = color
        counter += 1
    }
    
    func undoAction() {
        if recentActions.count != 0 {
            let action = recentActions.popLast()
            let pixel = cells[action!.key]
            
            switch action?.lastAction {
            case .pen:
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .pen, bitsInAction: 0)
                pixel?.backgroundColor = action?.lastColor
                redoActions.append(redoAction)
                
            case .eraser:
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .eraser, bitsInAction: 0)
                
                pixel?.backgroundColor = action?.lastColor
                
                redoActions.append(redoAction)
                
            case .bucket:
                for _ in 1...action!.bitsInAction {
                    undoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .bucket, bitsInAction: action!.bitsInAction)
                redoActions.append(redoAction)
                
            case .line:
                for _ in 1...action!.bitsInAction {
                    undoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .line, bitsInAction: action!.bitsInAction)
                redoActions.append(redoAction)
                
            case .symmetryX:
                for _ in 1...action!.bitsInAction {
                    undoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .symmetryX, bitsInAction: action!.bitsInAction)
                redoActions.append(redoAction)
                
            case .symmetryY:
                for _ in 1...action!.bitsInAction {
                    undoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .symmetryY, bitsInAction: action!.bitsInAction)
                redoActions.append(redoAction)
            case .symmetryXY:
                for _ in 1...action!.bitsInAction {
                    undoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .symmetryXY, bitsInAction: action!.bitsInAction)
                redoActions.append(redoAction)
                
            case .none:
                return
            }
        }
    }
    
    func redoAction() {
        if redoActions.count != 0 {
            let action = redoActions.popLast()
            let pixel = cells[action!.key]
            
            switch action?.lastAction {
            case .pen:
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .pen, bitsInAction: 0)
                
                pixel?.backgroundColor = action?.lastColor
                
                recentActions.append(redoAction)
                
            case .eraser:
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .eraser, bitsInAction: 0)
                
                pixel?.backgroundColor = action?.lastColor
                
                recentActions.append(redoAction)
                
            case .bucket:
                for _ in 1...action!.bitsInAction {
                    redoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .line, bitsInAction: action!.bitsInAction)
                recentActions.append(redoAction)
                
            case .line:
                for _ in 1...action!.bitsInAction {
                    redoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .line, bitsInAction: action!.bitsInAction)
                recentActions.append(redoAction)
                
            case .symmetryX:
                for _ in 1...action!.bitsInAction {
                    redoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .symmetryX, bitsInAction: action!.bitsInAction)
                recentActions.append(redoAction)
                
            case .symmetryY:
                for _ in 1...action!.bitsInAction {
                    redoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .symmetryY, bitsInAction: action!.bitsInAction)
                recentActions.append(redoAction)
                
            case .symmetryXY:
                for _ in 1...action!.bitsInAction {
                    redoAction()
                }
                let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .symmetryXY, bitsInAction: action!.bitsInAction)
                recentActions.append(redoAction)
                
            case .none:
                return
            }
        }
    }
    
    func hapticFeedback(tool: Tool) {
        
    }
    
}
