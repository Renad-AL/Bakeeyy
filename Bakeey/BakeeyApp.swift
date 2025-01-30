import SwiftUI
@main
struct BakeeyApp: App {
    @StateObject var userViewModel = UserViewModel()
    @StateObject var bookingViewModel = BookingViewModel()
    @StateObject var chefViewModel = ChefViewModel() // ✅ New

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(userViewModel)
                .environmentObject(bookingViewModel)
                .environmentObject(chefViewModel) // ✅ Provide globally
                .onAppear {
                    chefViewModel.fetchChefs() // ✅ Load chefs at start
                }
        }
    }
}
