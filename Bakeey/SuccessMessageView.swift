import SwiftUI

struct SuccessMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var chefViewModel: ChefViewModel // ✅ Inject ChefViewModel

    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.brown)

            Text("Successful")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.brown)

            Button(action: {
                if let userID = userViewModel.currentUserID {
                    bookingViewModel.fetchBookings(for: userID) {
                        bookingViewModel.fetchBookedCourses() // ✅ Refresh courses
                    }
                }

                // ✅ Navigate to HomeView properly
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: HomeView()
                        .environmentObject(userViewModel)
                        .environmentObject(bookingViewModel)
                        .environmentObject(chefViewModel)) // ✅ Provide ChefViewModel
                    window.makeKeyAndVisible()
                }
            }) {
                Text("Go to Home")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brown)
                    .cornerRadius(10)
            }
            .padding(.top, 16)
        }
        .padding()
    }
}
