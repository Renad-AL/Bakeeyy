import SwiftUI
import MapKit

struct BookedCourseDetailView: View {
    let bookingID: String
    let course: CourseFields

    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var chefViewModel: ChefViewModel // ✅ Inject ChefViewModel

    @State private var showCancelConfirmation = false // ✅ Show confirmation dialog

    var body: some View {
        VStack {
            VStack {
                AsyncImage(url: URL(string: course.image_url)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(height: 220)
                .clipped()

                Text(course.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("About the course:")
                    .font(.headline)

                Text(course.description)
                    .font(.body)
                    .foregroundColor(.gray)

                Divider()

                HStack {
                    VStack(alignment: .leading) {
                        Text("Chef:").bold() + Text(" \(chefViewModel.getChefName(by: course.chef_id ?? ""))") // ✅ FIXED
                        Text("Level:").bold() + Text(" \(course.level.capitalized)")
                        Text("Date & time:").bold() + Text(" \(formatDate(timestamp: course.start_date))")
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Duration:").bold() + Text(" 2h")
                        Text("Location:").bold() + Text(" \(course.location_name)")
                    }
                }
                .padding(.top, 4)

                Button(action: {
                    showCancelConfirmation = true
                }) {
                    Text("Cancel Booking")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationBarTitle("", displayMode: .inline)
        .alert(isPresented: $showCancelConfirmation) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you want to cancel this booking?"),
                primaryButton: .destructive(Text("Yes")) {
                    bookingViewModel.deleteBooking(bookingID: bookingID) {
                        // ✅ Navigate back to HomeView after deletion
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: HomeView()
                                .environmentObject(userViewModel)
                                .environmentObject(bookingViewModel)
                                .environmentObject(chefViewModel))
                            window.makeKeyAndVisible()
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}
