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
    var numResult: Int = 0
    var totalTime: Int = 0
    
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
    
    
    @IBOutlet weak var labelNumber1: UILabel!
    
    @IBOutlet weak var labelNumber2: UILabel!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBAction func actionButtonResult1(_ sender: Any) {
        let value = Int((button1.titleLabel?.text)!)
        self.reRenderData(inputNumResult: value!)
    }
    
    @IBAction func actionButtonResult2(_ sender: Any) {
        let value = Int((button2.titleLabel?.text)!)
        self.reRenderData(inputNumResult: value!)
    }
    
    @IBAction func actionButtonResult3(_ sender: Any) {
        let value = Int((button3.titleLabel?.text)!)
        self.reRenderData(inputNumResult: value!)
    }
    
    func reRenderData(inputNumResult: Int){
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
        let lottoMaker = UniqueRandomGenerator(ceiling: 100)
        
        let results = Array(lottoMaker.prefix(2))
        
        let randomNum1: UInt32 = UInt32(results[0])
        labelNumber1.text = String(randomNum1)
        let randomNum2: UInt32 = UInt32(results[1])
        labelNumber2.text = String(randomNum2)
        
        numResult = Int(randomNum1 + randomNum2)
        
        var arrayRandomNumber = Array(lottoMaker.prefix(3))
        
        //dat ket qua o vi tri ngau nhien
        let lottoMaker2 = UniqueRandomGenerator(ceiling: 3)
        let indexRandom = Array(lottoMaker2.prefix(1))[0]
        arrayRandomNumber[indexRandom] = numResult
        
        button1.setTitle(String(arrayRandomNumber[0]), for: .normal)
        button2.setTitle(String(arrayRandomNumber[1]), for: .normal)
        button3.setTitle(String(arrayRandomNumber[2]), for: .normal)
        
    }
    
    func updateTime(){
        totalTime = totalTime + 1
        let totalTimeString: String = String(totalTime)
        labelTimer.text = totalTimeString
    }
    
    public struct UniqueRandomGenerator: Sequence, IteratorProtocol {
        
        private let ceiling: Int
        private var _existing: Set<Int>
        
        /// ceiling is the highest number that can be drawn
        init(ceiling: Int) {
            self.ceiling = ceiling
            self._existing = Set<Int>()
        }
        
        // generate random number between 0..<ceiling
        private var randomPick: Int {
            return Int(arc4random_uniform(UInt32(ceiling)))
        }
        
        public mutating func next() -> Int? {
            // if we have a ceiling of 10, then it's impossible to
            // more than 10 unique numbers
            guard _existing.count < ceiling else {
                return nil
            }
            
            // continue getting a random pick until we find one
            // that hasn't been picked yet
            var pick: Int
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

