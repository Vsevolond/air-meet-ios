import SwiftUI

private enum SegmentedTab: String, CaseIterable {
    
    case nearBy = "Рядом"
    case requests = "Запросы"
}

private struct ElasticSegmentedControl: View {
    
    var tabs: [SegmentedTab]
    @Binding var activeTab: SegmentedTab
    
    @State private var minX: CGFloat = .zero
    @State private var excessTabWidth: CGFloat = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let containerWidthForEachTab = size.width / CGFloat(tabs.count)
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.rawValue) { tab in
                    Text(tab.rawValue)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(activeTab == tab ? .white : .gray)
                        .animation(.snappy, value: activeTab)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.rect)
                        .onTapGesture {
                            guard let index = tabs.firstIndex(of: tab), let activeIndex = tabs.firstIndex(of: activeTab) else {
                                return
                            }
                            activeTab = tab
                            
                            withAnimation(.snappy(duration: 0.25, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                excessTabWidth = containerWidthForEachTab * CGFloat(index - activeIndex)
                                
                            } completion: {
                                withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                    minX = containerWidthForEachTab * CGFloat(index)
                                    excessTabWidth = 0
                                }
                            }
                        }
                        .background(alignment: .leading) {
                            if tab == tabs.first {
                                GeometryReader {
                                    let size = $0.size
                                    
                                    Rectangle()
                                        .fill(.blue)
                                        .clipShape(.capsule)
                                        .padding(.horizontal, 10)
                                        .frame(width: size.width + (excessTabWidth < 0 ? -excessTabWidth : excessTabWidth), height: size.height)
                                        .frame(width: size.width, alignment: excessTabWidth < 0 ? .trailing : .leading)
                                        .offset(x: minX)
                                }
                            }
                        }
                }
            }
        }
    }
}

