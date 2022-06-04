//
//  OpenAIResponseHandler.swift
//  Genie
//
//  Created by Aditya Saravana on 6/4/22.
//

import Foundation

//{
//  "id": "cmpl-5FRQ6PFGjPY2FKNOaeGB5Odd6zN4h",
//  "object": "text_completion",
//  "created": 1654362006,
//  "model": "text-davinci-002",
//  "choices": [
//    {
//      "text": " on your way\n\n\nHi there!\n\nJust wanted to grab your attention for a quick sec - would appreciate if you could pick up some milk on your way home!\n\nThanks a lot,\n\n[Your Name]",
//      "index": 0,
//      "logprobs": null,
//      "finish_reason": "stop"
//    }
//  ]
//}

struct OpenAIResponseHandler {
//    func decodeJson(string: String) -> OpenAIResponse {
//        
//    }
}

struct OpenAIResponse: Codable {
    var id: String
    var object: String
    var created: Int
    var model: String
    var choices: [Choice]
}

struct Choice: Codable {
    var text: String
    var index: Int
    var logprobs: String?
    var finish_reason: String
}
