//
//  ViewController.swift
//  Reto 3
//
//  Created by Laurent castañeda ramirez on 9/10/19.
//  Copyright © 2019 Laurent castañeda ramirez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button_0: ButtonStyle!
    @IBOutlet var button_1: ButtonStyle!
    @IBOutlet var button_2: ButtonStyle!
    @IBOutlet var button_3: ButtonStyle!
    @IBOutlet var button_4: ButtonStyle!
    @IBOutlet var button_5: ButtonStyle!
    @IBOutlet var button_6: ButtonStyle!
    @IBOutlet var button_7: ButtonStyle!
    @IBOutlet var button_8: ButtonStyle!
    
    @IBOutlet var message: UILabel!
    @IBOutlet var pointMessage: UILabel!
    
    var humanPoint: Int = 0
    var iOSPoint: Int = 0
    
    
    
    var array: [Play] = []
    var arrayPlay: [[Int]] = []
    var plays: Int = 0
    
    var arrayUI: [[ButtonStyle]] = []
    
    
    override func viewDidLoad() {
        
        arrayPlay.append([0, 0, 0])
        arrayPlay.append([0, 0, 0])
        arrayPlay.append([0, 0, 0])
        
        arrayUI.append([button_0, button_1, button_2])
        arrayUI.append([button_3, button_4, button_5])
        arrayUI.append([button_6, button_7, button_8])
        
        for _ in 0...8{
            array.append(Play(state: 0))
        }
        print(self.array)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func newGame(_ sender: Any) {
        self.message.text = "Tú Turno"
        for row in 0...2{
            for column in 0...2{
                arrayUI[row][column].isEnabled = true
                arrayUI[row][column].setImage(nil, for: .normal)
                arrayPlay[row][column] = 0
            }
        }
    }
    
    @IBAction func ResetPoint(_ sender: Any) {
        self.humanPoint = 0
        self.iOSPoint = 0
        self.setPointMessage()
    }
    
    
    
    @IBAction func userEvent(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        self.Human(button: button)
        self.statusButton(status: false)
        let humanWinning: Bool = self.CheckForWinning(player: 1)
        
        if(humanWinning){
            self.message.text = "Tu ganaste"
            self.humanPoint += 1
            self.setPointMessage()
        }
        
        
        
        if(!humanWinning){
            if(self.GameOver()){
                self.message.text = "Turno de iOS"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.Machine()
                    if(self.CheckForWinning(player: 2)){
                        self.message.text = "iOS ganó"
                        self.iOSPoint += 1
                        self.setPointMessage()
                    }else{
                        self.statusButton(status: true)
                        self.message.text = "Tú Turno"
                    }
                }
            }else{
                self.message.text = "Partida Terminada - Empate"
            }
        }
        
    }
    
    func Human(button: UIButton){
        let image = UIImage(named: "cross") as UIImage?
        switch button.tag {
        case 0:
            if(self.arrayPlay[0][0] == 0){
                self.button_0.setImage(image, for: .normal)
                self.arrayPlay[0][0] = 1
            }
        case 1:
            if(self.arrayPlay[0][1] == 0){
                self.button_1.setImage(image, for: .normal)
                self.arrayPlay[0][1] = 1
            }
        case 2:
            if(self.arrayPlay[0][2] == 0){
                self.button_2.setImage(image, for: .normal)
                self.arrayPlay[0][2] = 1
            }
            
        case 3:
            if(self.arrayPlay[1][0] == 0){
                self.button_3.setImage(image, for: .normal)
                self.arrayPlay[1][0] = 1
            }
            
        case 4:
            if(self.arrayPlay[1][1] == 0){
                self.button_4.setImage(image, for: .normal)
                self.arrayPlay[1][1] = 1
            }
            
        case 5:
            if(self.arrayPlay[1][2] == 0){
                self.button_5.setImage(image, for: .normal)
                self.arrayPlay[1][2] = 1
            }
            
        case 6:
            if(self.arrayPlay[2][0] == 0){
                self.button_6.setImage(image, for: .normal)
                self.arrayPlay[2][0] = 1
            }
            
        case 7:
            if(self.arrayPlay[2][1] == 0){
                self.button_7.setImage(image, for: .normal)
                self.arrayPlay[2][1] = 1
            }
            
        case 8:
            if(self.arrayPlay[2][2] == 0){
                self.button_8.setImage(image, for: .normal)
                self.arrayPlay[2][2] = 1
            }
            
        default:
            print(button.tag)
        }
    }
    
    func Machine(){
        var therePlays: [String] = []
        let machineWinning = self.canTheMachineWinning()
        var humanMightWinning: Bool = false
        
        if(!machineWinning){
            humanMightWinning = self.HumanMighttWining()
        }
        
        if (!machineWinning && !humanMightWinning){
            for i in 0...2{
                for j in 0...2{
                    if (arrayPlay[i][j] == 0){
                        therePlays.append(String(i) + ";" + String(j))
                    }
                }
            }
            
            if(therePlays.count > 0){
                let image = UIImage(named: "circle") as UIImage?
                let count = therePlays.count
                let number = Int.random(in: 0..<count)
                
                let array = therePlays[number].split(separator: ";")
                
                let row = Int(array[0])
                let column = Int(array[1])
                self.arrayPlay[row!][column!] = 2
                
                self.arrayUI[row!][column!].setImage(image, for: .normal)
            }
        }
    }
    
    
    func CheckForWinning(player: Int) -> Bool{
        var winning: Bool = false
        var isWinning: Int = 0
        
        for row in 0...2{
            for column in 0...2{
                if(arrayPlay[row][column] == player){
                    isWinning+=1
                }
            }
            if(isWinning == 3){
                winning = true
                break
            }else{
                isWinning = 0
            }
        }
        
        if(!winning){
            isWinning = 0
            
            for column in 0...2{
                for row in 0...2{
                    if(arrayPlay[row][column] == player){
                        isWinning+=1
                    }
                }
                if(isWinning == 3){
                    winning = true
                    break
                }else{
                    isWinning = 0
                }
            }
        }
        
        
        if(!winning && arrayPlay[0][0] == player && arrayPlay[1][1] == player && arrayPlay[2][2] == player ){
            winning = true
        }
        
        if(!winning && arrayPlay[0][2] == player && arrayPlay[1][1] == player && arrayPlay[2][0] == player ){
            winning = true
        }
        
        return winning
        
    }
    
    func statusButton(status: Bool){
        for row in 0...2{
            for column in 0...2{
                arrayUI[row][column].isEnabled = status
            }
        }
    }
    
    func canTheMachineWinning() -> Bool{
        var canWin: Int = 0
        let image = UIImage(named: "circle") as UIImage?
        
        //First see if there's a move O can make to win
        for row in 0...2{
            for column in 0...2{
                if (arrayPlay[row][column] == 2 || arrayPlay[row][column] == 0){
                    if (arrayPlay[row][column] == 2){
                        canWin += 1
                    }
                }else{
                    canWin -= 1
                }
            }
            if(canWin == 2){
                for column in 0...2{
                    arrayPlay[row][column] = 2
                    self.arrayUI[row][column].setImage(image, for: .normal)
                }
                break;
            }else{
                canWin = 0
            }
        }
        
        if (canWin != 2){
            for column in 0...2{
                for row in 0...2{
                    if (arrayPlay[row][column] == 2 || arrayPlay[row][column] == 0){
                        if (arrayPlay[row][column] == 2){
                            canWin += 1
                        }
                    }
                    else{
                        canWin -= 1
                    }
                }
                if(canWin == 2){
                    for row in 0...2{
                        arrayPlay[row][column] = 2
                        self.arrayUI[row][column].setImage(image, for: .normal)
                    }
                    break;
                }else{
                    canWin = 0
                }
            }
        }
        
        //Diagonal
        
        if (canWin != 2){
            for row in 0...2{
                if (arrayPlay[row][row] == 2 || arrayPlay[row][row] == 0){
                    if(arrayPlay[row][row] == 2){
                        canWin += 1
                    }
                }
                else{
                    canWin -= 1
                }
            }
            if(canWin == 2){
                for row in 0...2{
                    arrayPlay[row][row] = 2
                    self.arrayUI[row][row].setImage(image, for: .normal)
                }
                
            }else{
                canWin = 0
            }
        }
        
        if (canWin != 2){
            var column = 0
            for row in (0...2).reversed(){
                if (arrayPlay[row][column] == 2 || arrayPlay[row][column] == 0){
                    if(arrayPlay[row][column] == 2){
                        canWin += 1
                    }
                }
                else{
                    canWin -= 1
                }
                 column += 1
            }
            if(canWin == 2){
                var column = 0
                for row in (0...2).reversed(){
                    arrayPlay[row][column] = 2
                    self.arrayUI[row][row].setImage(image, for: .normal)
                    column += 1
                }
            }
        }
        
        if(canWin == 2){
            return true
        }else{
            return false
        }
    }
    
    func HumanMighttWining() -> Bool{
        var canWin: Int = 0
        let image = UIImage(named: "circle") as UIImage?
        
        //First see if there's a move O can make to win
        for row in 0...2{
            for column in 0...2{
                if (arrayPlay[row][column] == 1 || arrayPlay[row][column] == 0){
                    if (arrayPlay[row][column] == 1){
                        canWin += 1
                    }
                }
                else{
                    canWin -= 1
                }
            }
            if(canWin == 2){
                for column in 0...2{
                    if(arrayPlay[row][column] == 0){
                        arrayPlay[row][column] = 2
                        self.arrayUI[row][column].setImage(image, for: .normal)
                    }
                }
                break;
            }else{
                canWin = 0
            }
        }
        
        if (canWin != 2){
            for column in 0...2{
                for row in 0...2{
                    let xx = arrayPlay[row][column]
                    if (arrayPlay[row][column] == 1 || arrayPlay[row][column] == 0){
                        if (arrayPlay[row][column] == 1){
                            canWin += 1
                        }
                    }else{
                        canWin -= 1
                    }
                }
                if(canWin == 2){
                    for row in 0...2{
                        if(arrayPlay[row][column] == 0){
                            arrayPlay[row][column] = 2
                            self.arrayUI[row][column].setImage(image, for: .normal)
                        }
                    }
                    break;
                }else{
                    canWin = 0
                }
            }
        }
        //Diagonal
        if (canWin != 2){
            for row in 0...2{
                if (arrayPlay[row][row] == 1){
                    canWin += 1
                }
                if (arrayPlay[row][row] == 2){
                    canWin -= 1
                }
            }
            if(canWin == 2){
                for row in 0...2{
                    if(arrayPlay[row][row] == 0){
                        arrayPlay[row][row] = 2
                        self.arrayUI[row][row].setImage(image, for: .normal)
                    }
                }
                
            }else{
                canWin = 0
            }
        }
        
        if (canWin != 2){
            var column = 0
            for row in (0...2).reversed(){
                if (arrayPlay[row][column] == 1){
                    canWin += 1
                }
                if(arrayPlay[row][column] == 2){
                    canWin -= 1
                }
                column += 1
            }
            if(canWin == 2){
                column = 0
                for row in (0...2).reversed(){
                    if(arrayPlay[row][column] == 0){
                        arrayPlay[row][column] = 2
                        self.arrayUI[row][column].setImage(image, for: .normal)
                    }
                    column += 1
                }
                
            }else{
                canWin = 0
            }
        }
        
        if(canWin == 2){
            return true
        }else{
            return false
        }
    }
    
    func setPointMessage(){
        self.pointMessage.text = "Humano " + String(self.humanPoint) + " | Partida " + String(self.humanPoint + self.iOSPoint) + " | iOS " + String(self.iOSPoint)
    }
    
    func GameOver()-> Bool{
        var isEnd: Bool = true
        for row in 0...2{
            for column in 0...2{
                if(arrayPlay[row][column] == 0){
                    isEnd = false
                }
            }
        }
        if(isEnd){
            for row in 0...2{
                for column in 0...2{
                    arrayUI[row][column].isEnabled = false
                }
            }
        }
        return !isEnd
    }
    
}

