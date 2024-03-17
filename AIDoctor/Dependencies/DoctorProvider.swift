//
//  DoctorService.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import Foundation
import OpenAI
import Alamofire

enum DoctorResponse {
    case questions(Questionary)
    case answer(String)
    
    init(from string: String) throws {
        if let data = string.data(using: .utf8) {
            print("Processing DoctorResponse:", string)
            if string.contains("\"questions\""){
                let decoded = try! JSONDecoder().decode(Questionary.self, from: data)
                self = .questions(decoded)
            } else if string.contains("\"text\"") {
                let decoded = try! JSONDecoder().decode(Answer.self, from: data)
                self = .answer(decoded.text)
            } else {
                throw NSError(domain: "DoctorResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown response format"])
            }
        } else {
            throw NSError(domain: "DoctorResponseError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid string encoding"])
        }
    }
}

class DoctorProvider {
    
    private let baseUrl = "https://6a99-194-8-199-28.ngrok-free.app"
    
    func sendMessage(message: String) async throws -> DoctorResponse {
        try! await sendAnswers(message: message, answers: FilledQuestionary(filledQuestions: [:]))
    }
    
    func sendAnswers(message: String, answers: FilledQuestionary) async throws -> DoctorResponse {
        
        struct DoctorParams: Codable {
            var message: String
            var userCard: [String: String]
            var filledQuestionary: FilledQuestionary
        }
        
        let onboard = OnboardingProvider()
            
        let paramsObject = DoctorParams(
            message: message,
            userCard: onboard.filledOnboarding!.filledQuestions,
            filledQuestionary: answers
        )
//        print(paramsObject)
        let encoder = JSONParameterEncoder.default
        encoder.encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let responseString = try await AF.request(
            baseUrl + "/doctor", 
            method: .post,
            parameters: paramsObject,
            encoder: encoder
        ).serializingString().value
        
//        var request = URLRequest(url: URL(string: baseUrl + "/doctor")!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        let encoder = JSONEncoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        let httpBody = try! encoder.encode(paramsObject)
//        print("HTTP BODY: ", String(data: httpBody, encoding: .utf8)!)
//        request.httpBody = httpBody
//
//        let (data, _) = try! await URLSession.shared.data(for: request)
////        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
//        let responseString = String(data: data, encoding: .utf8)!
        
        print("Response:", responseString)
        
        return try! DoctorResponse(from: responseString)
    }
}

class AIDoctorProvider {
    
    private var openAI: OpenAI
    
    init() {
        openAI = OpenAI(apiToken: "")
    }
    
    func sendMessage(message: String) async throws -> DoctorResponse {
        try! await sendAnswers(message: message, answers: FilledQuestionary(filledQuestions: [:]))
    }
    
    func sendAnswers(message: String, answers: FilledQuestionary) async throws -> DoctorResponse {
        let promptProvider = PromptsProvider()
        let profile = OnboardingProvider().filledOnboarding!
        
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [
            Chat(role: .system, content: promptProvider.homeRole),
            Chat(role: .user, content: promptProvider.profile(profile: profile)),
            Chat(role: .user, content: promptProvider.message(message: message)),
            Chat(role: .user, content: promptProvider.answers(filled: answers)),
        ])
        
        let result = try await openAI.chats(query: query)
        return try! DoctorResponse(from: result.choices[0].message.content ?? "")
    }
}
