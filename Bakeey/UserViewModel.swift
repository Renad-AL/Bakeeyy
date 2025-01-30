import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [UserRecord] = []
    @Published var isAuthenticated = false
    @Published var currentUserID: String? = nil
    @Published var currentUserName: String = "" // ✅ Store current user's name

    let apiURL = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user"
    let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    /// **Fetch Users from API**
    func fetchUsers() {
        guard let url = URL(string: apiURL) else {
            print("❌ Invalid API URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(UserResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.users = decodedData.records
                        print("✅ Users Fetched: \(self.users.count) users loaded.")

                        // **Auto-set current user's name if logged in**
                        if let userID = self.currentUserID,
                           let user = self.users.first(where: { $0.fields.id == userID }) {
                            self.currentUserName = user.fields.name
                        }
                    }
                } catch {
                    print("❌ Decoding Error:", error)
                }
            } else if let error = error {
                print("❌ API Request Error:", error.localizedDescription)
            }
        }.resume()
    }

    /// **Login User**
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let cleanedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        fetchUsers()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let user = self.users.first(where: {
                $0.fields.email.lowercased() == cleanedEmail &&
                $0.fields.password == cleanedPassword
            }) {
                self.isAuthenticated = true
                self.currentUserID = user.fields.id
                self.currentUserName = user.fields.name // ✅ Set current user's name

                UserDefaults.standard.set(user.fields.id, forKey: "userID")

                completion(true)
            } else {
                self.isAuthenticated = false
                completion(false)
            }
        }
    }

    /// **✅ Update User's Name in API**
    func updateUserName(newName: String) {
        guard let userID = currentUserID else {
            print("❌ No logged-in user found.")
            return
        }

        let updateURL = "\(apiURL)/\(userID)" // ✅ Update user by ID
        guard let url = URL(string: updateURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "fields": ["name": newName]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ Error encoding JSON:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ API Update Error:", error.localizedDescription)
                } else {
                    self.currentUserName = newName
                    print("✅ Name updated successfully to \(newName)")
                }
            }
        }.resume()
    }
}
