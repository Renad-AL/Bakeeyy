import Foundation

class CourseViewModel: ObservableObject {
    @Published var courses: [CourseRecord] = []
    
    let apiURL = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/course"
    let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    func fetchCourses() {
        guard let url = URL(string: apiURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(CourseResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.courses = decodedData.records
                    }
                } catch {
                    print("Decoding error:", error)
                }
            }
        }.resume()
    }
}
