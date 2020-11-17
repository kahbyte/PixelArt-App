//
//  ctxtMenu.swift
//  PixelArt App
//
//  Created by Denys Roger on 12/11/20.
//

import UIKit

var colors = [UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white, UIColor.white]

class ColorMenu: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    @IBOutlet var textField: UITextField!
    
    var hexUsed = false
    var red: CGFloat!
    var green: CGFloat!
    var blue: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("contextMenu", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        hexCode = hexStrings.joined(separator: "")
        textField.placeholder = hexCode
    }
    
    @IBAction func colorSlider(_ sender: UISlider) {
        
        textField.text = nil
        textField.placeholder = hexCode
        var hexValue: String
        var value: Int
        
        if hexUsed == true{
            hexStrings = ["00","00","00"]
        }
        
        if sender.tag == 0{
            
            hexUsed = false
            red = CGFloat(sender.value)
            
            if green == nil{
                green = 0.0
                greenSlider.value = Float(green)
            }
            if blue == nil{
                blue = 0.0
                blueSlider.value = Float(blue)
            }
            
            value  = Int(red * 255)
            hexValue = String(value, radix: 16)
            hexStrings[0] = (hexValue)
           
            hexCode = hexStrings.joined(separator: "")
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            self.layer.borderColor = color.cgColor
            textField.placeholder = hexCode
            
        }
        else if sender.tag == 1{
            
            hexUsed = false
            green = CGFloat(sender.value)
            
           
            if red == nil{
                red = 0.0
            }
            if blue == nil{
                blue = 0.0
            }
            
           value = Int(green * 255)
            hexValue = String(value, radix: 16)
            hexStrings[1] = (hexValue)
            
            hexCode = hexStrings.joined(separator: "")
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            self.layer.borderColor = color.cgColor
            textField.placeholder = hexCode
        }
        else if sender.tag == 2{
            
            hexUsed = false
            blue = CGFloat(sender.value)
            
            if red == nil{
                red = 0.0
            }
            if green == nil{
                green = 0.0
            }
            
            value = Int(blue *  255)
            hexValue = String(value, radix: 16)
            hexStrings[2] = (hexValue)
            
            hexCode = hexStrings.joined(separator: "")
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            self.layer.borderColor = color.cgColor
            textField.placeholder = hexCode
        }
        
    }
    @IBAction func okBttn(_ sender: Any) {
          
        var value = 0
        hexStrings = ["", "", ""]
        
        if textField.text == nil{
            return
        }
        else{
            
            hexUsed = true
            var i = 0
            var j = 1
            hexCode = textField.text!
            
            for char in hexCode{
               hexStrings[i] = hexStrings[i] + String(char)
                print(hexStrings)
                if j % 2 == 0{
                    i += 1
                }
                j += 1
            }

            for k in 0...2 {
                switch k {
                case 0:
                    value = Int(hexStrings[k], radix: 16)!
                    red = CGFloat(Float(value) / 255)
                case 1:
                    value = Int(hexStrings[k], radix: 16)!
                    green = CGFloat(Float(value) / 255)
                case 2:
                    value = Int(hexStrings[k], radix: 16)!
                    blue = CGFloat(Float(value) / 255)
                default:
                    print("Couldn't find value in scope")
                    
                }
            }
            
            textField.placeholder = hexCode
            redSlider.value = Float(red)
            greenSlider.value = Float(green)
            blueSlider.value = Float(blue)
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            self.layer.borderColor = color.cgColor
        }
    }
    func changeLastColors(color: UIColor){
        if color != colors[0] {
            
            for i in -9...(-1){
                colors[i*(-1)] = colors[(i*(-1)) - 1]
            }
            
            colors[0] = color
        }
    }
}
