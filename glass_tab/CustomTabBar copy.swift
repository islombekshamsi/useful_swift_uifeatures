import SwiftUI

struct CustomTabBar<TabItemView: View>: UIViewRepresentable{
    var size: CGSize
    var activeTint: Color = .blue
    var barTint: Color = .gray.opacity(0.15)
    @Binding var activeTab: CustomTabParticipant
    @ViewBuilder var tabItemView: (CustomTabParticipant) -> TabItemView
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let items = CustomTabParticipant.allCases.map(\.rawValue)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        
        for (index, tab) in CustomTabParticipant.allCases.enumerated(){
            let renderer = ImageRenderer(content: tabItemView(tab))
            
            renderer.scale = 2
            
            let image = renderer.uiImage
            
            control.setImage(image, forSegmentAt: index)
        }
        
        DispatchQueue.main.async{
            for subview in control.subviews{
                if subview is UIImageView && subview != control.subviews.last{
                    subview.alpha = 0
                }
            }
        }
        
        control.selectedSegmentTintColor = UIColor(barTint)
        control.setTitleTextAttributes([.foregroundColor: UIColor(activeTint)], for: .selected) // if .normal it will be all as .selected, whereas .selected only changes the chosen
        
        control.addTarget(context.coordinator, action:
                            #selector(context.coordinator.tabSelected(_:)), for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
        return size
    }
    
    class Coordinator: NSObject{
        var parent: CustomTabBar
        init(parent: CustomTabBar){
            self.parent = parent
        }
        
        @objc func tabSelected(_ control: UISegmentedControl){
            parent.activeTab = CustomTabParticipant.allCases[control.selectedSegmentIndex]
        }
    }
}

#Preview {
    ContentView()
}
