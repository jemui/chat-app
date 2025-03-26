//
//  String+Extensions.swift
//  ChatApp
//
//  Created by Jeanette on 2/9/25.
//  

extension String {
    func extractUsername(from email: String) -> String? {
        let components = email.split(separator: "@")
        return components.first.map { String($0) }
    }
}
