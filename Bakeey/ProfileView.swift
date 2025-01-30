import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel

    @State private var isEditing = false
    @State private var updatedName: String = ""

    var body: some View {
        VStack {
            // Header
            Text("Profile")
                .font(.title2)
                .bold()
                .padding(.top, 16)

            // Profile Editing Section
            VStack {
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.brown)

                    if isEditing {
                        TextField("Enter name", text: $updatedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 40)
                    } else {
                        Text(userViewModel.currentUserName)
                            .font(.headline)
                    }

                    Spacer()

                    Button(isEditing ? "Done" : "Edit") {
                        if isEditing {
                            userViewModel.updateUserName(newName: updatedName)
                        }
                        isEditing.toggle()
                    }
                    .foregroundColor(.brown)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.2), radius: 4)
                .padding(.horizontal)
            }

            Divider()
                .padding(.horizontal)

            // Booked Courses Section
            VStack(alignment: .leading) {
                Text("Booked courses")
                    .font(.headline)
                    .padding(.leading)

                if bookingViewModel.bookedCourses.isEmpty {
                    Text("No booked courses")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(bookingViewModel.bookedCourses, id: \.id) { course in
                                CourseCard(course: course)
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)

            Spacer()
        }
        .onAppear {
            updatedName = userViewModel.currentUserName
            if let userID = userViewModel.currentUserID {
                bookingViewModel.fetchBookings(for: userID) {
                    bookingViewModel.fetchBookedCourses()
                }
            }
        }
    }
}

// ✅ Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserViewModel())
            .environmentObject(BookingViewModel())
            .previewDevice("iPhone 16 Pro")
    }
}
