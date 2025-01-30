import SwiftUI
@main
struct BakeeyApp: App {
    @StateObject var userViewModel = UserViewModel() // ✅ Proper initialization
    @StateObject var bookingViewModel = BookingViewModel()
    @StateObject var chefViewModel = ChefViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(userViewModel) // ✅ Inject globally
                .environmentObject(bookingViewModel)
                .environmentObject(chefViewModel)
        }
    }
}
