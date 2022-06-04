//
//  ContentView.swift
//  Genie
//
//  Created by Aditya Saravana on 6/3/22.
//
//
import SwiftUI
import OpenAI
struct ContentView: View {

    
    @State var text = ""
    @State var result = ""
    var body: some View {
        VStack {
            TextField("Enter your brief text", text: $text)
            Button ("Submit: \(text)") {
                OpenAIConnector().processPrompt(prompt: text)
            }
            
            Text("output: \n \(result)")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
