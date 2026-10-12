//
//  UserModel.swift
//  Assignment
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import Foundation

// User response model
struct UserModel: Codable {
    let users: [Users]?
}
struct Users: Codable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let maidenName: String?
    let age: Int?
    let gender: String?
    let email: String?
    let phone: String?
    let username: String?
    let birthDate: String?
    let image: String?
}
