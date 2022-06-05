//
//  ContentFilterManagers.swift
//  Genie
//
//  Created by Aditya Saravana on 6/4/22.
//

import Foundation
import CoreML
import NaturalLanguage

public struct ContentFilterManager {
    public init() {
    }
    
    
    public func check(_ string: String) -> [String] {
        var output: [String] = []
        let prediction = ContentFilterML.sharedInstance.predict(text: string)
        
        if prediction != "acceptable" {
            if prediction == "malignant" {
                output.append("Contains malignant text")
            } else if prediction == "rude" {
                output.append("Contains rude text")
            } else if prediction == "threat" {
                output.append("Contains threats")
            } else if prediction == "abuse" {
                output.append("Contains abusive text")
            } else if prediction == "loathe" {
                output.append("Contains loathing")
            } else {
                output.append("An error occured [TextChecker - ML Analyzation]. Please create an issue in Interceptor's Github repo.")
            }
        }
        
        return output
        /// Some features to come soon!
        //        for i in 0..<library.count {
        //            if document.text.contains(library[i]) {
        //                document.acceptable = false
        //
        //                document.unacceptableExplanation.append(Explanation(title: "Use of bad word: \(library[i])", systemName: "ear.trianglebadge.exclamationmark", cbLevel: CBLevel.medium.string))
        //            }
        //        }
    }
}

class ContentFilterML {
    var mlModel: MLModel? = nil
    var sentimentPredictor: NLModel? = nil
    func initialize() {
        do {
            
            let mlModel = try! ContentFilter(configuration: MLModelConfiguration()).model
            sentimentPredictor = try NLModel(mlModel: mlModel)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func predict(text: String) -> String {
        initialize()
        
        return sentimentPredictor!.predictedLabel(for: text)!
    }
    
    class var sharedInstance: ContentFilterML {
        struct Singleton {
            static let instance = ContentFilterML()
        }
        return Singleton.instance
    }
}
