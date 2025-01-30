import SwiftUI

struct BookedCourseCard: View {
    let course: CourseFields
    let chefName: String // ✅ Pass chef name

    var body: some View {
        HStack {
            Text(formatDate(timestamp: course.start_date))
                .font(.title)
                .bold()
                .foregroundColor(.brown)

            VStack(alignment: .leading) {
                Text(course.title)
                    .font(.headline)
                    .bold()
                
                HStack {
                    Image(systemName: "person.fill")
                    Text(chefName) // ✅ Display chef's name
                }
                .font(.subheadline)
                .foregroundColor(.gray)

                HStack {
                    Image(systemName: "location.fill")
                    Text(course.location_name)
                }
                .font(.subheadline)
                .foregroundColor(.gray)

                HStack {
                    Image(systemName: "clock")
                    Text(formatDate(timestamp: course.start_date))
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
