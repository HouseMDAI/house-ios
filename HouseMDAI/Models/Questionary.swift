//
//  Questionary.swift
//  HouseMDAI
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

struct Question {
    var text: String
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

extension Question: Codable, Hashable, Identifiable {
    var id: String { text }
}
extension Answer: Codable, Hashable {}
extension Questionary: Codable, Hashable {}
extension FilledQuestionary: Codable, Hashable {}
