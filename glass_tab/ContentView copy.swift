import SwiftUI

enum CustomTabParticipant: String, CaseIterable{
    case home = "Home"
    case dashboard = "Dashboard"
    case profile = "Profile"
    
    var symbol: String {
        switch self {
            case .home: return "house"
            case .dashboard: return "archivebox"
            case .profile: return "person"
            
        }
    }
    
    var actionSymbol: String {
        switch self{
            case .home: return "bell"
            case .dashboard: return "message"
            case .profile: return "gearshape"
        }
    }
    
    var index: Int{
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

struct ContentView: View {
    @State private var activeTab: CustomTabParticipant = .home
    var body: some View {
        TabView(selection: $activeTab) {
            Tab.init(value: .home){
                Text("Home")
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: .dashboard){
                Text("Dashboard")
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: .profile){
                Text("Profile")
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0){
            CustomTabBarView()
                .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    func CustomTabBarView() -> some View{
        GlassEffectContainer(spacing: 10){
            
            HStack(spacing: 10){
                GeometryReader{
                    CustomTabBar(size: $0.size, activeTab: $activeTab){ tab in
                        VStack(spacing: 3){
                            Image(systemName: tab.symbol)
                                .font(.title3)
                            
                            Text(tab.rawValue)
                                .font(.system(size: 10))
                                .fontWeight(.medium)
                        }
                        .symbolVariant(.fill)
                        .frame(maxWidth: .infinity)
                    }
                    .glassEffect(.regular.interactive(), in: .capsule)
                }
                
                
                ZStack{
                    ForEach(CustomTabParticipant.allCases, id: \.rawValue){ tab in
                        Image(systemName: tab.actionSymbol)
                            .font(.system(size: 22, weight: .medium))
                            .blurFade(activeTab == tab)
                        
                    }
                }
                .frame(width: 55, height: 55)
                .glassEffect(.regular.interactive(), in: .capsule)
                .animation(.smooth(duration: 0.55, extraBounce: 0), value: activeTab)
            }
        }
        .frame(height: 60)
    }
}


extension View{
    @ViewBuilder
    func blurFade(_ status: Bool) -> some View{
        self
            .compositingGroup()
            .blur(radius: status ? 0 : 10)
            .opacity(status ? 1 : 0)
    }
}

#Preview {
    ContentView()
}
