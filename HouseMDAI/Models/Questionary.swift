//
//  Questionary.swift
//  HouseMDAI
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

//enum QuestionType {
//    case string
//    case integer
//    case bool
//}

struct Question {
    var id = UUID() // optional in API
    var text: String
//    var type: QuestionType
    
    enum CodingKeys: CodingKey {
        case id, text
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        text = try container.decode(String.self, forKey: .text)
    }
    
    init(text: String) {
        self.text = text
    }
}

struct Answer {
    var text: String
}

struct Questionary {
    var questions: [Question]
}

struct FilledQuestionary {
    var filledQuestions: [String: String]
}

// MARK: - Extensions

extension Questionary: Codable, Hashable {}
extension Question: Codable, Hashable, Identifiable {}
extension Answer: Codable, Hashable {}
extension FilledQuestionary: Codable, Hashable {}

/* JSON Examples:
 
 JSON for Question
 {
   "text": "What is your favorite color?"
 }
 
 JSON for Answer
 
 {
   "text": "Blue"
 }
 
 JSON for Questionary
 {
   "questions": [
     {
       "text": "What is your favorite color?"
     },
     {
       "text": "What is your hobby?"
     }
   ]
 }
 
 JSON for FilledQuestionary
 {
   "filledQuestions": [
     {
       "question": {
         "text": "What is your favorite color?"
       },
       "answer": "Blue"
     },
     {
       "question": {
         "text": "What is your hobby?"
       },
       "answer": "Reading"
     }
   ]
 }
 */
