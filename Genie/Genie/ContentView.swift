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


struct ContentView: View {
    let openAIConnector = OpenAIConnector()
    
    @State var inteceptorActivated = false
    
    @State var text = ""
    @State var result = ""
    
    @State private var mailData: ComposeMailData = .empty
    @State private var showMailView = false
    
    @State var overrideStorage: ComposeMailData = .empty
    @State var interceptorActivationExplanation: [String] = []
    
    @State var isLoading = false
    var body: some View {
        
        VStack {
            SwiftSpeech.Demos.Basic(localeIdentifier: text).onRecognizeLatest(update: $text).padding(50)
            
            
            Text("or").font(.title).bold().foregroundColor(.gray)
            
            TextField("Enter your text here", text: $text).padding(30).background(Color.gray.opacity(0.3).cornerRadius(100).padding(.horizontal))
            Spacer()
            Button("Submit") {
                isLoading = true
                if ContentFilterManager().check(text).isEmpty {
                    
                    result = openAIConnector.processPrompt(prompt: text) ?? "Whoops! An error occured."
                    mailData = ComposeMailData(subject: "", recipients: [""], message: result, attachments: [])
                    isLoading = false
                    showMailView = true
                } else {
                    inteceptorActivated = true
                    interceptorActivationExplanation = ContentFilterManager().check(text)
                    result = openAIConnector.processPrompt(prompt: text) ?? "Whoops! An error occured."
                    isLoading = false
                    overrideStorage = ComposeMailData(subject: "", recipients: [""], message: result, attachments: [])
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
            
            if inteceptorActivated {
            Text("Our content filter detected some edgy language. (\(ContentFilterManager().check(text)[0])) This is a warning. Maybe reword the sentence?").bold().multilineTextAlignment(.center).foregroundColor(.red)
            Button("If you think that this suggestion is wrong, you can override it.") {
                inteceptorActivated = false
                mailData = overrideStorage
                showMailView = true
            }.font(.caption)
            }
        }.onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
        .padding()
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

