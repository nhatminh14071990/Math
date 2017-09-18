//
//  ViewController.swift
//  Math
//
//  Created by Van Ho Si on 9/15/17.
//  Copyright © 2017 Van Ho Si. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var totalRight: Int = 0
    var totalWrong: Int = 0
    var numResult: Float = 0.0
    var totalTime: Int = 0
    var arrayRandomExits: [Float] = []
    let calculation = ["+", "-", "*", "/"]
    let configCeiling: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.generaNumber()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet weak var labelTotalRight: UILabel!
    
    @IBOutlet weak var labelTimer: UILabel!
    
    @IBOutlet weak var labelTotalWrong: UILabel!
    
    @IBOutlet weak var labelCalculation: UILabel!
    
    @IBOutlet weak var labelNumber1: UILabel!
    
    @IBOutlet weak var labelNumber2: UILabel!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button1: UIButton!
    
    
    @IBAction func actionButtonResult(_ sender: UIButton) {
        
        if let buttonTitle = sender.title(for: .normal) {
            //print(buttonTitle)
            
            self.reRenderData(inputNumResult: Float(buttonTitle)!)
        }
        
    }
    
    func reRenderData(inputNumResult: Float){
//        print("numResult: \(numResult)")
//        print("inputNumResult: \(inputNumResult)")
        if(numResult == inputNumResult){
            self.updateRight()
        }else{
            self.updateWrong()
        }
        
        self.generaNumber()
    }
    
    func updateRight(){
        totalRight = totalRight + 1
        let totalRightString: String = String(totalRight)
        labelTotalRight.text = totalRightString
    }
    
    func updateWrong(){
        totalWrong = totalWrong + 1
        let totalWrongString: String = String(totalWrong)
        labelTotalWrong.text = totalWrongString
    }
    
    func generaNumber(){
        //gan ngau nhien phep tinh
        let indexCalculationCurrent = arc4random_uniform(UInt32(calculation.count))
        let calculationCurrent = calculation[Int(indexCalculationCurrent)]
        //let calculationCurrent = "/"
        labelCalculation.text = calculationCurrent
        
        var lottoMaker = UniqueRandomGenerator(ceiling: configCeiling)
        var results = Array(lottoMaker.prefix(2))
        var randomNum1: Float32 = Float32(results[0])
        var randomNum2: Float32 = Float32(results[1])
        
        
        if(calculationCurrent == "-"){//neu la phep tru: num1 >= num2
            
            repeat{
                
                lottoMaker = UniqueRandomGenerator(ceiling: configCeiling)
                
                results = Array(lottoMaker.prefix(2))
                
                randomNum1 = Float32(results[0])
                
                randomNum2 = Float32(results[1])
            }while(randomNum1 < randomNum2)
            
        }else if(calculationCurrent == "/"){//neu la phep chia: num2 != 0
            
            repeat{
                
                lottoMaker = UniqueRandomGenerator(ceiling: configCeiling)
                
                results = Array(lottoMaker.prefix(2))
                
                randomNum1 = Float32(results[0])
                
                randomNum2 = Float32(results[1])
            }while(randomNum2 == 0)
            
        }
        
        labelNumber1.text = self.formatNumber(inputNumber: Double(randomNum1))
        labelNumber2.text = self.formatNumber(inputNumber: Double(randomNum2))
        
        let mathExpression = NSExpression(format: "\(randomNum1) \(calculationCurrent) \(randomNum2)")
        numResult = (mathExpression.expressionValue(with: nil, context: nil) as? Float)!
        
        //hien thi ngau nhien 3 ket qua
        var lottoMaker2 = UniqueRandomGenerator(ceiling: 100)
        var arrayRandomNumber = Array(lottoMaker2.prefix(3))
        repeat{
            lottoMaker2 = UniqueRandomGenerator(ceiling: 100)
            arrayRandomNumber = Array(lottoMaker2.prefix(3))
        }while(arrayRandomNumber.contains(numResult))
        
        //dat ket qua o vi tri ngau nhien
        let lottoMaker3 = UniqueRandomGenerator(ceiling: 3)
        let indexRandom = Array(lottoMaker3.prefix(1))[0]
        arrayRandomNumber[Int(indexRandom)] = numResult
        
        button1.setTitle(self.formatNumber(inputNumber: Double(arrayRandomNumber[0])), for: .normal)
        button2.setTitle(self.formatNumber(inputNumber: Double(arrayRandomNumber[1])), for: .normal)
        button3.setTitle(self.formatNumber(inputNumber: Double(arrayRandomNumber[2])), for: .normal)
        
    }
    
    func updateTime(){
        totalTime = totalTime + 1
        let totalTimeString: String = String(totalTime)
        labelTimer.text = totalTimeString
    }
    
    func formatNumber(inputNumber: Double) -> String{
        if(self.numberHasDecimal(inputNumber: inputNumber)){
            return String(inputNumber)
        }
        return String(Int(inputNumber))
    }
    
    func numberHasDecimal(inputNumber: Double) -> Bool{
        let isInteger = floor(inputNumber) == inputNumber
        return !isInteger
    }
    
    public struct UniqueRandomGenerator: Sequence, IteratorProtocol {
        
        private let ceiling: Int
        private var _existing: Set<Float>
        
        /// ceiling is the highest number that can be drawn
        init(ceiling: Int) {
            self.ceiling = ceiling
            self._existing = Set<Float>()
        }
        
        // generate random number between 0..<ceiling
        private var randomPick: Float {
            return Float(arc4random_uniform(UInt32(ceiling)))
        }
        
        public mutating func next() -> Float? {
            // if we have a ceiling of 10, then it's impossible to
            // more than 10 unique numbers
            guard _existing.count < ceiling else {
                return nil
            }
            
            // continue getting a random pick until we find one
            // that hasn't been picked yet
            var pick: Float
            repeat {
                pick = randomPick
            } while _existing.contains(pick)
            
            // insert into existing picks so it won't be picked again
            _existing.insert(pick)
            
            // return unique pick
            return pick
        }
    }
}

