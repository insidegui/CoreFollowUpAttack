//
//  LoginFlow.swift
//  CoreFollowUpPoC
//
//  Created by Guilherme Rambo on 3/14/22.
//

import SwiftUI

@objc final class LoginFlowWindowController: NSWindowController {
    
    private let viewModel = LoginViewModel()
    
    convenience init() {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 600, height: 180), styleMask: [.titled], backing: .buffered, defer: false)
        
        self.init(window: window)
        
        contentViewController = NSHostingController(rootView: LoginView().environmentObject(viewModel))
        window.title = "Apple ID Verification"
    }
    
    @objc class func instantiate() -> LoginFlowWindowController {
        LoginFlowWindowController()
    }
    
}

final class LoginViewModel: ObservableObject {
    
    enum State: Hashable {
        case email
        case password
        case loading
        case alert
    }
    
    @Published var state = State.email
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        state = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.state = .alert
        }
    }
    
}

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                logo
                
                VStack(alignment: .leading) {
                    Text("Your Apple ID lets you access your music, photos, contacts, calendars, and more on your devices, automatically.")
                        .font(.system(size: 13, weight: .medium))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    form
                }
            }
        }
        .padding()
        .frame(minWidth: 600, maxWidth: 600)
        .alert(isPresented: .constant(viewModel.state == .alert), content: {
            Alert(title: Text("You've been pwned"), message: Text("Apple ID: \(viewModel.email)\nPassword:\(viewModel.password)"), dismissButton: .cancel(Text("¯\\_(ツ)_/¯")))
        })
    }
    
    private var logo: some View {
        VStack {
            Image("SystemPreferences2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
            Text("Apple ID")
                .bold()
        }
    }
    
    private var form: some View {
        VStack(alignment: .trailing) {
            HStack(spacing: 0) {
                Text("Apple ID:")
                    .frame(width: 80)
                    .multilineTextAlignment(.trailing)
                    .offset(x: 1, y: 0)

                TextField("Apple ID", text: $viewModel.email, onCommit: {
                    viewModel.state = .password
                })
            }
            
            if viewModel.state != .email {
                HStack(spacing: 0) {
                    Text("Password:")
                        .frame(width: 80)
                        .multilineTextAlignment(.trailing)

                    SecureField("Password", text: $viewModel.password, onCommit: {
                        viewModel.signIn()
                    })
                }
            }
            
            Button(buttonTitle) {
                viewModel.signIn()
            }
            .disabled(viewModel.state == .loading)
        }
        .padding()
        .disabled(viewModel.state == .loading)
    }
    
    private var buttonTitle: String {
        switch viewModel.state {
        case .email:
            return "Next"
        case .password:
            return "Sign In"
        case .loading:
            return "Please Wait…"
        case .alert:
            return "pwned"
        }
    }
}

struct LoginFlow_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}
