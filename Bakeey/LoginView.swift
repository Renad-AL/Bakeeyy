import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode // ✅ Close sheet after login
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var isPasswordVisible = false // ✅ Password toggle
    
    var body: some View {
        VStack(spacing: 16) {
            // ✅ Drag Indicator
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 10)

            // ✅ Title
            Text("Sign in")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 12) {
                // ✅ Email Input
                Text("Email")
                    .font(.headline)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 5)

                // ✅ Password Input with Eye Icon
                Text("Password")
                    .font(.headline)
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())

                // ✅ Error Message
                if showError {
                    Text("Invalid email or password")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding(.horizontal)

            // ✅ Sign-In Button
            Button(action: {
                userViewModel.login(email: email, password: password) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss() // ✅ Close bottom sheet after login
                    } else {
                        showError = true
                    }
                }
            }) {
                Text("Sign in")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brown)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground)) // ✅ White background
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 16)
    }
}
