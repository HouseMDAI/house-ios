//
//  ProfileView.swift
//  AIDoctor
//
//  Created by Mark Parker on 16/03/2024.
//

import SwiftUI

struct ProfileView: View {
    
    var profile: FilledQuestionary
    var profileSorted: [(question: Question, answer: String)] {
        profile.filledQuestions
            .sorted { $0.key.text < $1.key.text }
            .map { (question: $0.key, answer: $0.value) }
    }
    
    var body: some View {
        List(profileSorted, id: \.question.id) { item in
            VStack {
                Text(item.question.text)
                Text(item.answer)
            }
            .padding()
        }
    }
}
