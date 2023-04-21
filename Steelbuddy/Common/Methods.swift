//
//  Methods.swift

import Foundation

//MARK: - Global Methods.....


// DELAY
func RUN_AFTER_DELAY(_ delay: TimeInterval, block: @escaping ()->()) {
    let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: time, execute: block)
}

func TO_STRING(_ obj : Any?) -> String {
    if obj == nil {
        return ""
    }
    else if obj is String {
        return (obj as! String)
    }
    else if obj is NSString {
        return obj as! String
    }
    else if obj is NSNumber {
        return obj as! String
    }
    return ""
}

func TO_INT(_ obj : Any?) -> Int {
    if obj == nil {
        return 0
    }
    else if let answer = obj as? Int {
        return answer
    }
    else if let answer = obj as? NSNumber {
        return answer.intValue
    }
    else if let answer = obj as? String {
        return (answer as NSString).integerValue
    }
    return 0
}

func TO_DOUBLE(_ obj : Any?) -> Double {
    if obj == nil {
        return 0.0
    }
    else if let answer = obj as? Double {
        return answer
    }
    else if let answer = obj as? NSNumber {
        return Double(answer.doubleValue)
    }
    else if let answer = obj as? String {
        return (answer as NSString).doubleValue
    }
    return 0.0
}

func TO_BOOL(_ obj : Any?) -> Bool {
    if obj == nil {
        return false
    }
    else if let answer = obj as? Int, answer == 1 {
        return true
    }
    else if let answer = obj as? NSNumber, answer == 1 {
        return true
    }
    
    return false
}



