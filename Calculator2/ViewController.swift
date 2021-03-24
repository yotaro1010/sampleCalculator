//
//  ViewController.swift
//  Calculator2
//
//  Created by Yotaro Ito on 2020/10/04.
//

import UIKit

class ViewController: UIViewController {
    enum CalculateStatus {
        case none, plus, minus, multipulication, division
    }
    
    var firstNumber = ""
    var secondNumber = ""
    var calculateStatus: CalculateStatus = .none
    let numbers = [
    ["C", "%", "$", "÷"],
    ["7", "8", "9", "×"],
    ["4", "5", "6", "-"],
    ["1", "2", "3", "+"],
    ["0", ".", "="],
    ]
   
    let celId = "celId"
    
    @IBOutlet weak var calculatorCollection: UICollectionView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var caluculatorHeightConsraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
          
       setUpViews()
        
            }

    func setUpViews(){
        calculatorCollection.delegate = self
        calculatorCollection.dataSource = self
        calculatorCollection.register(CalculatorViewCell.self, forCellWithReuseIdentifier: celId)
        calculatorCollection.backgroundColor = .clear
        calculatorCollection.contentInset = .init(top: 0, left: 14 , bottom: 0, right: 14)
        numberLabel.text = "0"
        
        view.backgroundColor = .black
    }
    
    func clear()   {
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width,  height: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width:CGFloat = 0
         width = ((collectionView.frame.width - 10) - 14 * 5) / 4

        if indexPath.section == 4 && indexPath.row == 0 {
            width = width * 2 + 14 + 9
        }
        return .init(width: width, height: 65)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = calculatorCollection.dequeueReusableCell(withReuseIdentifier: celId, for:indexPath) as! CalculatorViewCell
        
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
       
        numbers[indexPath.section][indexPath.row].forEach{ (numberString) in
            if"0"..."9" ~= numberString || numberString.description == "." {
                cell.numberLabel.backgroundColor = .darkGray
            }else if numberString == "C" || numberString == "%" || numberString ==  "$"{
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
   
        switch calculateStatus {
        case .none:
            handleFirstNumberSelected(number: number)
        case .plus, .minus, .multipulication, .division:
       handleSecondNumberSelected(number: number)
        }
    }
   
    private func handleFirstNumberSelected(number: String){
        switch  number {
    case "0"..."9":
        firstNumber += number
        numberLabel .text = firstNumber
        if firstNumber == "0" {
            firstNumber = ""
        }
    case ".":
        if !confirmIncludeDecimalPoint(numberString: firstNumber){
            firstNumber += number
            numberLabel .text = firstNumber
        }
        if firstNumber == "" {
            firstNumber = "0"
        }
    case "+":
        calculateStatus = .plus
    case "-":
        calculateStatus = .minus
    case "×":
        calculateStatus = .multipulication
    case "÷":
        calculateStatus = .division
    case "C":
       clear()
    default:
        break
    }
    }
    
    private func handleSecondNumberSelected(number: String){
        switch number {
                   case  "0"..."9":
                    secondNumber += number
                    numberLabel.text = secondNumber
                    if firstNumber == "0" {
                        firstNumber = ""
                    }
        case ".":
            if !confirmIncludeDecimalPoint(numberString: secondNumber){
                secondNumber += number
                numberLabel.text = secondNumber
            }
            if secondNumber == "" {
                secondNumber = "0"
            }
        case "=":
            let firstNum = Double(firstNumber) ?? 0
            let secondNum = Double(secondNumber) ?? 0
            
            var resultString: String?
            switch calculateStatus {
            case .plus:
                resultString = String( firstNum + secondNum)
            case .minus:
                resultString = String( firstNum - secondNum)
            case .multipulication:
                resultString = String( firstNum * secondNum)
            case .division:
                resultString = String( firstNum / secondNum)
            default:
                break
            }
            
            if let result = resultString, result.hasSuffix(".0"){
                resultString = result.replacingOccurrences(of: ".0", with: "")
            }
            numberLabel.text = resultString
            firstNumber = ""
            secondNumber = ""
            firstNumber += resultString ?? ""
            calculateStatus = . none
            
        case "C":
            clear()
        default:
            break
        }
    }
    
    private func confirmIncludeDecimalPoint(numberString: String)  -> Bool{
        if numberString.range(of: ".") != nil || numberString.count == 0{
           return true
        }else {
            return false
            
        }
    }
    
}


