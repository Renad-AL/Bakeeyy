import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var chefViewModel: ChefViewModel
    @StateObject var courseViewModel = CourseViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                // Header Title
                Text("Home Bakery")
                    .font(.title)
                    .bold()
                    .padding()

                // Search Bar
                SearchBar(text: $searchText)

                // 🔥 Fetch data when HomeView appears
                .onAppear {
                    if let userID = UserDefaults.standard.string(forKey: "userID") {
                        print("🟢 HomeView: Fetching bookings for User ID: \(userID)")
                        bookingViewModel.fetchBookings(for: userID) {
                            bookingViewModel.fetchBookedCourses()
                        }
                    } else {
                        print("🔴 No user ID found!")
                    }
                    courseViewModel.fetchCourses()
                    chefViewModel.fetchChefs() // ✅ Ensure chefs are loaded
                }

                // ✅ Upcoming Booked Courses (Fixed Horizontal Scrolling)
                VStack(alignment: .leading) {
                    Text("Upcoming")
                        .font(.headline)
                        .padding(.leading)

                    if bookingViewModel.bookedCourses.isEmpty {
                        VStack {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            Text("You don’t have any booked courses")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 100)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(bookingViewModel.bookings, id: \.id) { booking in
                                    if let course = bookingViewModel.getCourseDetails(for: booking.fields.course_id) {
                                        NavigationLink(destination: BookedCourseDetailView(bookingID: booking.id, course: course)) {
                                            BookedCourseCard(course: course, chefName: chefViewModel.getChefName(by: course.chef_id ?? ""))
                                        }
                                    }
                                }
                            }
                            .padding(.leading)
                        }
                        .frame(height: 140) // ✅ Adjusted height
                    }
                }
                .padding(.top, 10)

                // ✅ Popular Courses Section
                VStack(alignment: .leading) {
                    Text("Popular courses")
                        .font(.headline)
                        .padding(.leading)

                    if courseViewModel.courses.isEmpty {
                        Text("No courses available")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(courseViewModel.courses, id: \.id) { course in
                                    CourseCard(course: course.fields)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 10)

                Spacer() // Push bottom navigation to the bottom

                // ✅ Bottom Navigation Bar (Fixed Profile Navigation)
                HStack {
                    NavigationLink(destination: HomeView()) {
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

                    NavigationLink(destination: ProfileView()
                        .environmentObject(userViewModel)
                        .environmentObject(bookingViewModel)) { // ✅ FIXED PROFILE NAVIGATION
                        VStack {
                            Image("personicon") // ✅ Your icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                            Text("Profile")
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding()
                .background(Color.white)
            }
        }
    }
}

// ✅ Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserViewModel())
            .environmentObject(BookingViewModel())
            .environmentObject(ChefViewModel()) // ✅ Inject ChefViewModel
            .previewDevice("iPhone 16 Pro")
    }
}
