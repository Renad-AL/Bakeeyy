import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [UserRecord] = []
    @Published var isAuthenticated = false
    @Published var currentUserID: String? = nil // ✅ Store logged-in user ID

    let apiURL = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user"
    let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    /// **Fetch Users from API**
    func fetchUsers(completion: @escaping () -> Void = {}) {
        guard let url = URL(string: apiURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(UserResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.users = decodedData.records
                        completion() // ✅ Callback after fetch
                    }
                } catch {
                    print("Decoding error:", error)
                }
            }
        }.resume()
    }

    /// **Login User (Fixed)**
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        fetchUsers {
            DispatchQueue.main.async {
                if let user = self.users.first(where: {
                    $0.fields.email.lowercased() == email.lowercased() &&
                    $0.fields.password == password
                }) {
                    self.isAuthenticated = true
                    self.currentUserID = user.fields.id
                    UserDefaults.standard.set(user.fields.id, forKey: "userID")
                    completion(true)
                } else {
                    self.isAuthenticated = false
                    completion(false)
                }
            }
        }
    }
}
