//
//  ctxtMenu.swift
//  PixelArt App
//
//  Created by Denys Roger on 12/11/20.
//

import UIKit

var colors = [UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear, UIColor.clear]
var lastColorChanged = false

class ColorMenu: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var colorView: UIView!
    
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
        setSlider(slider: redSlider, minColor: UIColor.black, maxColor: UIColor.red)
        setSlider(slider: greenSlider, minColor: UIColor.black, maxColor: UIColor.green)
        setSlider(slider: blueSlider, minColor: UIColor.black, maxColor: UIColor.blue)
        colorView.backgroundColor = color
        colorView.layer.borderWidth = 0.7
       
        
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
            textField.placeholder = hexCode
            colorView.backgroundColor = color
            setSlider(slider: redSlider,
                      minColor: UIColor(red: 0.0, green: green, blue: blue, alpha: 1.0),
                      maxColor: UIColor(red: 1.0, green: green, blue: blue, alpha: 1.0))
            setSlider(slider: greenSlider,
                      minColor: UIColor(red: red, green: 0.0, blue: blue, alpha: 1.0),
                      maxColor: UIColor(red: red, green: 1.0, blue: blue, alpha: 1.0))
            setSlider(slider: blueSlider,
                      minColor: UIColor(red: red, green: green, blue: 0.0, alpha: 1.0),
                      maxColor: UIColor(red: red, green: green, blue: 1.0, alpha: 1.0))
            
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
            textField.placeholder = hexCode
            colorView.backgroundColor = color
            setSlider(slider: redSlider,
                      minColor: UIColor(red: 0.0, green: green, blue: blue, alpha: 1.0),
                      maxColor: UIColor(red: 1.0, green: green, blue: blue, alpha: 1.0))
            setSlider(slider: greenSlider,
                      minColor: UIColor(red: red, green: 0.0, blue: blue, alpha: 1.0),
                      maxColor: UIColor(red: red, green: 1.0, blue: blue, alpha: 1.0))
            setSlider(slider: blueSlider,
                      minColor: UIColor(red: red, green: green, blue: 0.0, alpha: 1.0),
                      maxColor: UIColor(red: red, green: green, blue: 1.0, alpha: 1.0))
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
            textField.placeholder = hexCode
            colorView.backgroundColor = color
            setSlider(slider: redSlider,
                      minColor: UIColor(red: 0.0, green: green, blue: blue, alpha: 1.0),
                      maxColor: UIColor(red: 1.0, green: green, blue: blue, alpha: 1.0))
            setSlider(slider: greenSlider,
                      minColor: UIColor(red: red, green: 0.0, blue: blue, alpha: 1.0),
                      maxColor: UIColor(red: red, green: 1.0, blue: blue, alpha: 1.0))
            setSlider(slider: blueSlider,
                      minColor: UIColor(red: red, green: green, blue: 0.0, alpha: 1.0),
                      maxColor: UIColor(red: red, green: green, blue: 1.0, alpha: 1.0))
        }
        
    }
    @IBAction func okBttn(_ sender: Any) {
          
        var value = 0
        hexStrings = ["", "", ""]
        
        if textField.text == ""{
            return
        }
        else{
            
            hexUsed = true
            var i = 0
            var j = 1
            hexCode = textField.text!
            
            for char in hexCode{
               hexStrings[i] = hexStrings[i] + String(char)
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
            setSlider(slider: redSlider,
                      minColor: UIColor(red: 0.0, green: green, blue: blue, alpha: 1.0),
                      maxColor: UIColor(red: 1.0, green: green, blue: blue, alpha: 1.0))
            setSlider(slider: greenSlider,
                      minColor: UIColor(red: red, green: 0.0, blue: blue, alpha: 1.0),
                      maxColor: UIColor(red: red, green: 1.0, blue: blue, alpha: 1.0))
            setSlider(slider: blueSlider,
                      minColor: UIColor(red: red, green: green, blue: 0.0, alpha: 1.0),
                      maxColor: UIColor(red: red, green: green, blue: 1.0, alpha: 1.0))
            redSlider.value = Float(red)
            greenSlider.value = Float(green)
            blueSlider.value = Float(blue)
            color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            colorView.backgroundColor = color
        }
    }
    func changeLastColors(newColor: UIColor){
        if newColor != colors[0] {
            
            for i in -9...(-1){
                colors[i*(-1)] = colors[(i*(-1)) - 1]
            }
            colors[0] = newColor
            lastColorChanged = true
        }
    }
    func setSlider(slider: UISlider, minColor: UIColor, maxColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        let frame = CGRect.init(x:0, y:0, width:slider.frame.size.width, height:5)
        
        gradientLayer.frame = frame
        gradientLayer.colors = [minColor.cgColor, maxColor.cgColor]
        gradientLayer.startPoint = CGPoint.init(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint.init(x:1.0, y:0.5)
        gradientLayer.borderWidth = 0.1
        gradientLayer.borderColor = UIColor.black.cgColor

        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, gradientLayer.isOpaque, 0.0);
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()

            image.resizableImage(withCapInsets: UIEdgeInsets.zero)
            slider.setMinimumTrackImage(image, for: .normal)
            slider.setMaximumTrackImage(image, for: .normal)
        }
    }
   
}
