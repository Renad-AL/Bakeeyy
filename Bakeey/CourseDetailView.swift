import SwiftUI
import MapKit

struct CourseDetailView: View {
    @StateObject var viewModel = CourseDetailViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var chefViewModel: ChefViewModel

    @State private var navigateToSignIn = false
    @State private var showSuccessPopup = false // ✅ Use overlay pop-up instead
    @Environment(\.presentationMode) var presentationMode
    let courseID: String

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack {
            VStack {
                if let course = viewModel.course {
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
                                Text("Chef:").bold() + Text(" \(chefViewModel.getChefName(by: course.chef_id ?? ""))")
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

                        Map(coordinateRegion: $region)
                            .frame(height: 150)
                            .cornerRadius(10)
                            .padding(.top, 8)

                        Button(action: {
                            if userViewModel.isAuthenticated, let userID = userViewModel.currentUserID {
                                bookingViewModel.createBooking(courseID: courseID, userID: userID) { success in
                                    if success {
                                        withAnimation {
                                            showSuccessPopup = true // ✅ Show pop-up
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                showSuccessPopup = false // ✅ Hide pop-up after 2 sec
                                                presentationMode.wrappedValue.dismiss() // ✅ Return to Home
                                            }
                                        }
                                    }
                                }
                            } else {
                                navigateToSignIn = true
                            }
                        }) {
                            Text("Book a space")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brown)
                                .cornerRadius(10)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                } else {
                    ProgressView("Loading Course Details...")
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .onAppear {
                viewModel.fetchCourseDetails(courseID: courseID)
            }
            .onChange(of: viewModel.course) { newCourse in
                if let course = newCourse {
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: course.location_latitude,
                            longitude: course.location_longitude
                        ),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                }
            }
            .sheet(isPresented: $navigateToSignIn) {
                LoginView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }

            // ✅ Success Popup Overlay
            if showSuccessPopup {
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                        .frame(width: 250, height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color.brown)
                                
                                Text("Successful")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.brown)
                            }
                        )
                        .shadow(radius: 10)
                }
                .transition(.scale)
            }
        }
    }
}
