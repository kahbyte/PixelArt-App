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
    
    //TODO: Trocar isso com o Rafa
    var initialPosition = (x: 0, y: 0)
    var finalPosition = (x: 0, y: 0)
    
    @IBOutlet var contentView: UIView!
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    
    var cells = [String: UIView]()
    
    var numViewPerRow = 31
    var paintedByBucket = [[Bool]](repeating: Array(repeating: false, count: 32), count: 32)
    
    struct Action {
        var key: String
        var lastColor: UIColor
        var currentColor: UIColor
        var lastAction: Tool
        var lastState: Bool
        var currentState: Bool
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
        //print(location)
        
        let width = contentView.frame.width / CGFloat(numViewPerRow)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        
        
        calledTool(i: i, j: j)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let local = touch.location(in: contentView)
            let width = contentView.frame.width / CGFloat(numViewPerRow)
            let i = Int(local.x / width)
            let j = Int(local.y / width)
            x1 = i
            y1 = j
            
            if tool == .bucket {
                bucket(i: i, j: j)
            }
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
        
        if tool == .line {
            doLine(x1: x1, x2: x2, y1: y1, y2: y2)
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
            let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .pen, lastState: paintedByBucket[i][j], currentState: false)
            recentActions.append(action)
            
            paintedByBucket[i][j] = false
            
            cellView?.backgroundColor = color
            generator.impactOccurred(intensity: 0.7)
        }
    }
    
    func erase(i: Int, j: Int) {
        let ident = "\(i + 1)|\(j + 1)"
        let cellView = cells[ident]
        
        
        if cellView?.backgroundColor != .clear {
            let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: .clear, lastAction: .eraser, lastState: paintedByBucket[i][j], currentState: false)
            
            paintedByBucket[i][j] = false
            
            cellView?.backgroundColor = .clear
            recentActions.append(action)
        }
    }
    
    func bucket(i: Int, j: Int) {
        let ident = "\(i + 1)|\(j + 1)"
        let cellView = cells[ident]
        
        let action = Action(key: ident, lastColor: (cellView?.backgroundColor)!, currentColor: color, lastAction: .bucket, lastState: paintedByBucket[i][j], currentState: true)
        recentActions.append(action)
        
        corFundo = cellView?.backgroundColor
        fillColor(i: i, j: j)
    }
    
    func doSymmetry(i: Int, j: Int){
        let ident1 = "\(i + 1)|\(j + 1)"
        let ident2 = "\(numViewPerRow - (i))|\(j + 1)"
        let ident3 = "\(i + 1)|\(numViewPerRow - (j))"
        let ident4 = "\(numViewPerRow - (i))|\(numViewPerRow - (j))"
        let cellView1 = cells[ident1]
        let cellView2 = cells[ident2]
        let cellView3 = cells[ident3]
        let cellView4 = cells[ident4]
        
        if i >= 0 && i < numViewPerRow && j >= 0 && j < numViewPerRow{
            switch tool {
            case .symmetryX:
                mirror(cellView1: cellView1, cellView2: cellView2)
                paintedByBucket[i][j] = false
                paintedByBucket[numViewPerRow - (i + 1)][j] = false
                
            case .symmetryY:
                mirror(cellView1: cellView1, cellView2: cellView3)
                paintedByBucket[i][j] = false
                paintedByBucket[i][numViewPerRow - (j + 1)] = false
                
            case .symmetryXY:
                mirror(cellView1: cellView1, cellView2: cellView2)
                mirror(cellView1: cellView1, cellView2: cellView3)
                mirror(cellView1: cellView1, cellView2: cellView4)
                paintedByBucket[i][j] = false
                paintedByBucket[numViewPerRow - (i + 1)][j] = false
                paintedByBucket[i][numViewPerRow - (j + 1)] = false
                paintedByBucket[numViewPerRow - (i + 1)][numViewPerRow - (j + 1)] = false
            default:
                print("F")
            }
        }
        
    }
    
    func mirror(cellView1: UIView?, cellView2: UIView?){
            cellView1?.backgroundColor = color
            cellView2?.backgroundColor = color
    }
    
    func fillColor(i: Int, j: Int){
        let ident = "\(i + 1)|\(j+1)"
        let cell = cells[ident]
        if cell?.backgroundColor == corFundo && cell?.backgroundColor != color && i >= 0 && j >= 0 && i < numViewPerRow && j < numViewPerRow{
            paintedByBucket[i][j] = true
            cell?.backgroundColor = color
            fillColor(i: i + 1, j: j)
            fillColor(i: i - 1, j: j)
            fillColor(i: i, j: j + 1)
            fillColor(i: i, j: j - 1)
        }
    }
    
    func removeColor(i: Int, j: Int, action: Action){
        let ident = "\(i + 1)|\(j + 1)"
        let cell = cells[ident]
        if cell?.backgroundColor == corFundo && cell?.backgroundColor != color && i >= 0 && j >= 0 && i < numViewPerRow && j < numViewPerRow && paintedByBucket[i][j] == true{
            paintedByBucket[i][j] = action.lastState
            cell?.backgroundColor = color
            removeColor(i: i + 1, j: j, action: action)
            removeColor(i: i - 1, j: j, action: action)
            removeColor(i: i, j: j + 1, action: action)
            removeColor(i: i, j: j - 1, action: action)
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
        let dx = x2 - x1
        let dy = y2 - y1
        var ident = "0|0"
        var b: Float
        var y: Int
        for x in f...g{
            let a = x - x1
            b = (Float(a) / Float(dx)) * Float(dy)
            y = lineBreak(x: x, x1: x1, x2: x2, y1: y1, f: f, g: g, dy: dy, b: b)
            
            if h == 0{
                ident = "\(x + 1)|\(y + 1)"
            } else {
                ident = "\(y + 1)|\(x + 1)"
            }

            let cellView = cells[ident]
            cellView?.backgroundColor = color
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
    
    func undoAction() {
        let action = recentActions.popLast()
        let pixel = cells[action!.key]
        let key = action!.key.split(separator: "|")
        
        let i = Int(key[0]) ?? 0
        let j = Int(key[1]) ?? 0
        
        switch action?.lastAction {
        case .pen:
            let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .pen, lastState: paintedByBucket[i][j], currentState: action!.lastState)
            
            pixel?.backgroundColor = action?.lastColor
            
            redoActions.append(redoAction)
            
        case .eraser:
            let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .eraser, lastState: paintedByBucket[i][j], currentState: action!.lastState)
            
            pixel?.backgroundColor = action?.lastColor
            
            redoActions.append(redoAction)
        
        case .bucket:
            let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .bucket, lastState: paintedByBucket[i][j], currentState: action!.lastState)
            
            corFundo = action?.currentColor
            color = action!.lastColor
            removeColor(i: i, j: j, action: action!)
            color = action!.currentColor
            
            redoActions.append(redoAction)
            
        case .line:
            return
            
        case .symmetryX:
            return
            
        case .symmetryY:
            return
            
        case .symmetryXY:
            return
            
        case .none:
            return
        }
    }
    
    func redoAction() {
        let action = redoActions.popLast()
        let pixel = cells[action!.key]
        let key = action!.key.split(separator: "|")
        
        let i = Int(key[0]) ?? 0
        let j = Int(key[1]) ?? 0
        
        switch action?.lastAction {
        case .pen:
            let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .pen, lastState: paintedByBucket[i][j], currentState: action!.lastState)
            
            pixel?.backgroundColor = action?.lastColor
            
            recentActions.append(redoAction)
            
        case .eraser:
            let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .eraser, lastState: paintedByBucket[i][j], currentState: action!.lastState)
            
            pixel?.backgroundColor = action?.lastColor
            
            recentActions.append(redoAction)
        
        case .bucket:
            let redoAction = Action(key: action!.key, lastColor: (action?.currentColor)!, currentColor: action!.lastColor, lastAction: .bucket, lastState: paintedByBucket[i][j], currentState: action!.lastState)
            
            corFundo = action?.currentColor
            color = action!.lastColor
            fillColor(i: i, j: j)
            
            recentActions.append(redoAction)
            
        case .line:
            return
            
        case .symmetryX:
            return
            
        case .symmetryY:
            return
            
        case .symmetryXY:
            return
            
        case .none:
            return
        }
    }
    
    func hapticFeedback(tool: Tool) {
        
    }
    
}
