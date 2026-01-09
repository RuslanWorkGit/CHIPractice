//
//  ChatMessage.swift
//  FoundationModelTest
//
//  Created by user on 02.12.2025.
//

import Foundation

enum ChatRole {
    case user
    case assistant
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let role: ChatRole
    var text: String
}
