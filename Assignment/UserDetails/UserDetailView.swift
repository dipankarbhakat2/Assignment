//
//  UserDetailView.swift
//  Assignment
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import SwiftUI

struct UserDetailView: View {
    let user: Users?
    var body: some View {
        VStack(spacing: 24) {
            AsyncImage(url: URL(string: user?.image ?? "")) { image in
                switch image {
                case .empty:
                    Circle()
                        .foregroundColor(.teal)
                        .frame(width: 120, height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                case .failure:
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 120, height: 120)
                @unknown default:
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 120, height: 120)
                }
            }
            List {
                Text("Name: \(user?.firstName ?? "") \(user?.lastName ?? "")".capitalized)
                Text("Email: \(user?.email ?? "")")
                Text("Gender: \(user?.gender ?? "")".capitalized)
                Text("DOB: \(user?.birthDate ?? "")")
                Text("Phone: \(user?.phone ?? "")")
            }
            .font(.headline)
            .scrollContentBackground(.hidden)
            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
        }
        .navigationTitle("User Details")
        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
    }
}
