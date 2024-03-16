//
//  Questionary.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

//enum QuestionType {
//    case string
//    case integer
//    case bool
//}

struct Question: Codable {
    var id = UUID()
    var text: String
//    var type: QuestionType
}

struct Answer: Codable {
    var text: String
}

struct Questionary: Codable {
    var questions: [Question]
}

struct FilledQuestionary: Codable {
    var filledQuestions: [Question: String]
}

// MARK: - Extensions

extension Questionary: Hashable {}
extension Question: Hashable, Identifiable {}
extension Answer: Hashable {}
