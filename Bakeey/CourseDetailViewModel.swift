import Foundation

class CourseDetailViewModel: ObservableObject {
    @Published var course: CourseDetailFields?
    
    let apiURL = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/course"
    let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"
    
    func fetchCourseDetails(courseID: String) {
        let urlString = "\(apiURL)?filterByFormula=id=\"\(courseID)\""
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(CourseDetailResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.course = decodedData.records.first?.fields
                        print("✅ Course details fetched: \(String(describing: self.course))")
                    }
                } catch {
                    print("❌ Decoding error:", error)
                }
            }
        }.resume()
    }
}
