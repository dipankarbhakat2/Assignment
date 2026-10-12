//
//  UserListView.swift
//  Assignment
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import SwiftUI

@available(iOS 17.0, *)
struct UserListView: View {
    @State var viewModel = UserListViewModel()
    @Environment(SecurityManager.self) private var securityManager
    var body: some View {
        NavigationStack {
            // Checking is device jail broken or not
            Group {
                if securityManager.isDeviceJailbroken {
                    // Secure fallback UI: Lock the app out
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.shield.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.red)
                        Text("Security Violation")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("This application cannot run on a jailbroken or compromised device due to security policies.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    ZStack {
                        Color.white.ignoresSafeArea()
                        List(viewModel.users?.users ?? [], id: \.id) { user in
                            NavigationLink {
                                UserDetailView(user: user)
                            } label: {
                                AsyncImage(url: URL(string: user.image ?? "")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(.circle)
                                } placeholder: {
                                    Circle()
                                    foregroundColor(.teal)
                                }
                                .frame(width: 50, height: 50)
                                Text("\(user.firstName ?? "") \(user.lastName ?? "")".capitalized)
                                    .font(.headline)
                            }
                        }
                        .navigationTitle("User List")
                        if viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(2.0, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.getUsers()
        }
        .alert(isPresented: $viewModel.shouldShowError) {
            return Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""))
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        UserListView()
    } else {
        // Fallback on earlier versions
    }
}
