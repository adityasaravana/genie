//
//  ContentView.swift
//  Genie
//
//  Created by Aditya Saravana on 6/3/22.
//
//
import SwiftUI
import SwiftSpeech
import SwiftUIMailView
import InterceptAPI

struct ContentView: View {
    let openAIConnector = OpenAIConnector()
    
    @State var inteceptorActivated = false
    
    @State var text = ""
    @State var result = ""
    
    @State private var mailData: ComposeMailData = .empty
    @State private var showMailView = false
    var body: some View {
        
        VStack {
            SwiftSpeech.Demos.Basic(localeIdentifier: text).onRecognizeLatest(update: $text)
            
            Text("Debug: text value is \(text)")
            //            SwiftSpeech.RecordButton()
            //                .onRecognizeLatest(update: $text)
            //                .swiftSpeechRecordOnHold(sessionConfiguration: .init(), animation: .default, distanceToCancel: 50)
            
            Text("or").font(.title).bold().foregroundColor(.gray)
            
            TextField("Enter your text here", text: $text).padding(30).background(Color.gray.opacity(0.3).cornerRadius(100).padding(.horizontal))
            
            Button("Submit") {
                if  {
                    result = openAIConnector.processPrompt(prompt: text) ?? "Whoops! An error occured."
                    mailData = ComposeMailData(subject: "", recipients: [""], message: result, attachments: [])
                    showMailView = true
                }
                
                
            }
            .disabled(inteceptorActivated)
            .padding()
            .foregroundColor(.white).background(Color.blue.cornerRadius(100))
            .sheet(isPresented: $showMailView) {
                MailView(data: $mailData) { result in
                    print(result)
                }
            }
            
        }.onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RecordButtonView: View {
    var text: String
    var systemImage: String
    var color: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .foregroundColor(color)
                .padding()
                .frame(height: 100)
            Label(text, systemImage: systemImage)
                .foregroundColor(.white)
                .font(.title2)
        }
    }
}


enum SpeechTranscriberStatus {
    case idle
    case recording
    //    case stopped
}

