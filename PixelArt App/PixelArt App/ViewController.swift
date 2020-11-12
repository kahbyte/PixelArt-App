//
//  ViewController.swift
//  testes grid
//
//  Created by Kauê Sales on 26/10/20.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var hexTxtField: UITextField!
    @IBOutlet weak var testView: testView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    @IBOutlet var okBttn: UIButton!
    
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
    
    
    @IBAction func Lapis(_ sender: Any) {
        apaga = 0
        balde = 0
        linha = 0
        simetria = 0
        testView.awakeFromNib()
    }
    
    @IBAction func Borracha(_ sender: Any) {
        apaga = 1
        balde = 0
        linha = 0
        simetria = 0
        testView.awakeFromNib()
    }
    
    @IBAction func Linha(_ sender: Any) {
        apaga = 0
        balde = 0
        linha = 1
        simetria = 0
        testView.awakeFromNib()
    }
    
    @IBAction func Balde(_ sender: Any) {
        balde = 1
        apaga = 0
        linha = 0
        simetria = 0
        testView.awakeFromNib()
    }
    
    @IBAction func SimetriaV(_ sender: Any) {
        apaga = 0
        balde = 0
        linha = 0
        simetria = 1
        testView.awakeFromNib()
    }
    
    @IBAction func SimetriaH(_ sender: Any) {
        apaga = 0
        balde = 0
        linha = 0
        simetria = 2
        testView.awakeFromNib()
    }
    
    @IBAction func SimetriaGeral(_ sender: Any) {
        apaga = 0
        balde = 0
        linha = 0
        simetria = 3
        testView.awakeFromNib()
    }
    
    @IBAction func colorSlider(_ sender: UISlider) {
        
        if sender.tag == 0{
            
            red = CGFloat(sender.value)
            
            var Value1: Int!
            var Value2: Int!
            let Value  = Int(red * 255)
            
            Value1 = (Value / 16)
            Value2 = (Value % 16)
            
            if green == nil{
                green = 0.0
            }
            if blue == nil{
                blue = 0.0
            }
            
            switch Value1 {
            
            case 10:
                hexStrings[0] = "A"
            case 11:
                hexStrings[0] = "B"
            case 12:
                hexStrings[0] = "C"
            case 13:
                hexStrings[0] = "D"
            case 14:
                hexStrings[0] = "E"
            case 15:
                hexStrings[0] = "F"
            default:
                hexStrings[0] = String(Value1)
            }
            switch Value2 {
            
            case 10:
                hexStrings[1] = "A"
            case 11:
                hexStrings[1] = "B"
            case 12:
                hexStrings[1] = "C"
            case 13:
                hexStrings[1] = "D"
            case 14:
                hexStrings[1] = "E"
            case 15:
                hexStrings[1] = "F"
            default:
                hexStrings[1] = String(Value2)
            }
            hexCode = hexStrings.joined(separator: "")
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            hexTxtField.placeholder = hexCode
            
        }
        else if sender.tag == 1{
            green = CGFloat(sender.value)
            
            var Value1: Int!
            var Value2: Int!
            let Value  = Int(green * 255)
            
            Value1 = (Value / 16)
            Value2 = (Value % 16)
            
            if red == nil{
                red = 0.0
            }
            if blue == nil{
                blue = 0.0
            }
            
            switch Value1 {
            
            case 10:
                hexStrings[2] = "A"
            case 11:
                hexStrings[2] = "B"
            case 12:
                hexStrings[2] = "C"
            case 13:
                hexStrings[2] = "D"
            case 14:
                hexStrings[2] = "E"
            case 15:
                hexStrings[2] = "F"
            default:
                hexStrings[2] = String(Value1)
            }
            switch Value2 {
            
            case 10:
                hexStrings[3] = "A"
            case 11:
                hexStrings[3] = "B"
            case 12:
                hexStrings[3] = "C"
            case 13:
                hexStrings[3] = "D"
            case 14:
                hexStrings[3] = "E"
            case 15:
                hexStrings[3] = "F"
            default:
                hexStrings[3] = String(Value2)
            }
            
            hexCode = hexStrings.joined(separator: "")
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            hexTxtField.placeholder = hexCode
        }
        else if sender.tag == 2{
            
            blue = CGFloat(sender.value)
            
            var Value1: Int!
            var Value2: Int!
            let Value  = Int(blue * 255)
            
            Value1 = (Value / 16)
            Value2 = (Value % 16)
            
            if red == nil{
                red = 0.0
            }
            if green == nil{
                green = 0.0
            }
            
            switch Value1 {
            
            case 10:
                hexStrings[4] = "A"
            case 11:
                hexStrings[4] = "B"
            case 12:
                hexStrings[4] = "C"
            case 13:
                hexStrings[4] = "D"
            case 14:
                hexStrings[4] = "E"
            case 15:
                hexStrings[4] = "F"
            default:
                hexStrings[4] = String(Value1)
            }
            switch Value2 {
            
            case 10:
                hexStrings[5] = "A"
            case 11:
                hexStrings[5] = "B"
            case 12:
                hexStrings[5] = "C"
            case 13:
                hexStrings[5] = "D"
            case 14:
                hexStrings[5] = "E"
            case 15:
                hexStrings[5] = "F"
            default:
                hexStrings[5] = String(Value2)
            }
            hexCode = hexStrings.joined(separator: "")
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            
            hexTxtField.placeholder = hexCode
        }
    }
    @IBAction func okBttn(_ sender: Any) {
        var value1 = 0
        var value2 = 0
        var redValue = Float()
        var greenValue = Float()
        var blueValue = Float()
        
        if hexTxtField.text == nil{
            return
        }
        else{
            var i = 0
            hexCode = hexTxtField.text!
            for char in hexCode{
                hexStrings[i] = String(char)
                i += 1
            }
            for j in 0...5{
                
                switch hexStrings[j] {
                case "A":
                    hexStrings[j] = "10"
                case "B":
                    hexStrings[j] = "11"
                case "C":
                    hexStrings[j] = "12"
                case "D":
                    hexStrings[j] = "13"
                case "E":
                    hexStrings[j] = "14"
                case "F":
                    hexStrings[j] = "15"
                default:
                    hexStrings[j] = hexStrings[j]
                }
            }
            for k in 0...5 {
                if k%2 == 0{
                    value1 = Int(hexStrings[k])!
                    value1 = value1 * (Int(pow(Double(16), Double (1))))
                    
                }else if k%2 != 0{
                    value2 = Int(hexStrings[k])!
                    value2 = value2 * (Int(pow(Double(16), Double(0))))
                }
                if k == 1{
                    redValue = Float(value1 + value2)
                    redValue = redValue / 255
                }
                else if k == 3{
                    greenValue = Float(value1 + value2)
                    greenValue = greenValue / 255
                }
                else if k == 5{
                    blueValue = Float(value1 + value2)
                    blueValue = blueValue / 255
                }
            }
            redSlider.value = redValue
            greenSlider.value = greenValue
            blueSlider.value = blueValue
            red = CGFloat(redValue)
            green = CGFloat(greenValue)
            blue = CGFloat(blueValue)
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        hexCode = hexStrings.joined(separator: "")
        hexTxtField.placeholder = hexCode
        
        okBttn.layer.cornerRadius = 0.5
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

