import Foundation

class ChefViewModel: ObservableObject {
    @Published var chefs: [ChefRecord] = []

    let apiURL = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/chef"
    let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    // ✅ Fetch Chefs from API
    func fetchChefs() {
        guard let url = URL(string: apiURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ChefResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.chefs = decodedData.records
                        print("✅ Chefs Fetched: \(self.chefs.count)")
                    }
                } catch {
                    print("❌ Decoding Error:", error)
                }
            } else if let error = error {
                print("❌ API Request Error:", error.localizedDescription)
            }
        }.resume()
    }

    // ✅ Get Chef Name by ID
    func getChefName(by chefID: String) -> String {
        return chefs.first { $0.fields.id == chefID }?.fields.name ?? "Unknown"
    }
}
