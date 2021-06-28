//
//  Calculator.swift
//  Calculator
//
//  Created by tae hoon park on 2021/06/25.
//

import Foundation

enum Operator: String {
    case plus = "+"
    case minus = "-"
    case multiplication = "*"
    case division = "/"
    
    var priority: Int {
        switch self {
        case .plus, .minus:
            return OperatorPriority.low.rawValue
        case .multiplication, .division:
            return OperatorPriority.high.rawValue
        }
    }
    
    static func < (lhs: Operator, rhs: Operator) -> Bool {
        lhs.priority < rhs.priority
    }
}

enum OperatorPriority: Int {
    case low = 0
    case high = 1
}

enum CalculatorError: Error {
    case unknown
    case dividedByZero
}

class Calculator {
    private var infixArray = [String]()
    private var stack = Stack<String>()
    private var postfixArray = [String]()
    
    func putInto(_ value: [String]) {
        infixArray.append(contentsOf: value)
    }
    
    func converToPostfixNotation() -> [String] {
        for item in infixArray {
            if let _ = Double(item) {
                postfixArray.append(item)
            } else {
                if stack.isEmpty {
                    stack.push(element: item)
                } else {
                    guard let topOfStack = stack.top else { return ["Error"] }
                    
                    if topOfStack >= item {
                        guard let poppedValue = stack.pop() else { return ["Error"] }
                        postfixArray.append(poppedValue)
                        stack.push(element: item)
                    } else {
                        stack.push(element: item)
                    }
                }
            }
        }
        while stack.isEmpty == false {
            guard let topOfStack = stack.pop() else {
                return ["Error"]
            }
            postfixArray.append(topOfStack)
        }
        return postfixArray
    }
    
    func checkOperator(_ input: String) throws -> Operator {
        guard let `operator` = Operator(rawValue: input) else {
            throw CalculatorError.unknown
        }
        return `operator`
    }
    
    func calculatePostfix() throws -> Double {
        for item in postfixArray {
            if let _ = Double(item) {
                stack.push(element: item)
            } else {
                guard let firstElement = stack.pop(), let secondElement = stack.pop() else { return 0.0 }
                guard let firstNumber = Double(firstElement),
                      let secondNumber = Double(secondElement) else { return 0.0 }
                
                let `operator` = try? checkOperator(item)
                
                switch `operator` {
                case .plus:
                    stack.push(element: String(add(firstNumber, secondNumber)))
                case .minus:
                    stack.push(element: String(substract(secondNumber, firstNumber)))
                case .multiplication:
                    stack.push(element: String(multiply(firstNumber, secondNumber)))
                case .division:
                    let result = try divide(secondNumber, firstNumber)
                    stack.push(element: String(result))
                default:
                    break
                }
            }
        }
        guard let lastElement = stack.pop(), let result = Double(lastElement) else {
            throw CalculatorError.unknown
        }
        return result
    }
}

extension Calculator: Calculatable {
    func add(_ firstNumber: Double, _ secondNumber: Double) -> Double {
        return firstNumber + secondNumber
    }
    
    func substract(_ firstNumber: Double, _ secondNumber: Double) -> Double {
        return firstNumber - secondNumber
    }
    
    func multiply(_ firstNumber: Double, _ secondNumber: Double) -> Double {
        return firstNumber * secondNumber
    }
    
    func divide(_ firstNumber: Double, _ secondNumber: Double) throws -> Double {
        if secondNumber == 0 {
            throw CalculatorError.dividedByZero
        }
        return firstNumber / secondNumber
    }
}

extension Calculator {
    func formattingNumber(value: Double) -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 5
        numberFormatter.roundingMode = .halfUp
        guard let result = numberFormatter.string(for: value), let doubleValue = Double(result) else {
            return 0.0
        }
        return doubleValue
    }
}

// MARK: - Calculator Unit Test 함수
extension Calculator {
    func calculate(with str: [String]) -> Result<Double, CalculatorError> {
        putInto(str)
        converToPostfixNotation()
        guard var result = try? calculatePostfix() else {
            return .failure(.unknown)
        }
        return .success(formattingNumber(value:result))
    }
}

//MARK: - 테스트를 위한 메인함수
//func main() {
//    let c = Calculator()
//    c.putInto(["1.0", Operator.division.rawValue, "2.0", Operator.division.rawValue, "3.0"])
//    let a = c.converToPostfixNotation()
//    do {
//        let d = try? c.calculatePostfix()
//        print(d)
//    }
//    print(a)
//}
