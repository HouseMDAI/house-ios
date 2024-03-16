//
//  PromptsProvider.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation

class PromptsProvider {
    
    private(set) public var homeRole = ""
    
    func message(message: String) -> String {
        return message
    }
    
    func profile(profile: FilledQuestionary) -> String {
        return try! jsonify(object: profile)
    }
    
    func answers(filled: FilledQuestionary) -> String {
        return try! jsonify(object: filled)
    }
    
    private func jsonify(object: Encodable) throws -> String {
        let coder = JSONEncoder()
        return String(data: try coder.encode(object), encoding: .utf8) ?? ""
    }
}
