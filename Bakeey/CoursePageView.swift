import SwiftUI

struct CoursePageView: View {
    @StateObject var viewModel = CourseViewModel()
    @State private var searchText = ""
    
    var filteredCourses: [CourseRecord] {
        if searchText.isEmpty {
            return viewModel.courses
        } else {
            return viewModel.courses.filter {
                $0.fields.title.lowercased().contains(searchText.lowercased()) ||
                $0.fields.level.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Header Section (Centered Title + Divider)
                VStack(spacing: 0) {
                    Text("Courses")
                        .font(.system(size: 20, weight: .semibold)) // Adjusted title size
                        .foregroundColor(.black)
                        .padding(.top, 16) // Space from top
                    
                    Divider()
                        .background(Color.gray.opacity(0.5)) // Light gray divider
                        .frame(height: 1) // Thin divider
                        .padding(.horizontal)
                        .padding(.bottom, 8) // Space below divider
                }
                
                // Search Bar
                SearchBar(text: $searchText)

                // Course List
                ScrollView {
                    LazyVStack {
                        ForEach(filteredCourses, id: \.id) { course in
                            CourseCard(course: course.fields)
                        }
                    }
                }
                
                // Bottom Navigation Bar
                HStack {
                    NavigationLink(destination: Text("Bake")) {
                        VStack {
                            Image("breadicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Bake")
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    NavigationLink(destination: CoursePageView()) {
                        VStack {
                            Image("baticon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                            Text("Course")
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    NavigationLink(destination: Text("Profile")) {
                        VStack {
                            Image(systemName: "person")
                                .foregroundColor(.black)
                            Text("Profile")
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding()
                .background(Color.white)
            }
            .onAppear {
                viewModel.fetchCourses()
            }
        }
    }
}

// ✅ **Fixed formatDate Function**
func formatDate(timestamp: TimeInterval, format: String = "dd MMM - HH:mm") -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

// Keep CourseCard outside CoursePageView so it can access formatDate
struct CourseCard: View {
    let course: CourseFields
    
    var body: some View {
        NavigationLink(destination: CourseDetailView(courseID: course.id)) {
            HStack(spacing: 10) {
                // Course Image
                AsyncImage(url: URL(string: course.image_url)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 80, height: 80) // Match image size
                .cornerRadius(10)
                .clipped()
                
                // Course Details
                VStack(alignment: .leading, spacing: 6) {
                    // Title
                    Text(course.title)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    // Level Badge
                    Text(course.level.capitalized)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.brown.opacity(0.2))
                        .cornerRadius(5)
                    
                    // Duration & Date
                    HStack {
                        Image(systemName: "hourglass")
                        Text("2h")
                        
                        Image(systemName: "calendar")
                        Text(formatDate(timestamp: course.start_date))
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                
                Spacer() // Push content to the left
            }
            .padding() // Padding inside the card
            .background(Color.white) // Card background
            .cornerRadius(15) // Rounded corners
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Subtle shadow
            .padding(.horizontal) // Space between cards
        }}
    
    // ✅ Preview
    struct CoursePageView_Previews: PreviewProvider {
        static var previews: some View {
            CoursePageView()
                .previewDevice("iPhone 16 Pro")
        }
    }
}
