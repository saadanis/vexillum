//
//  ContentView.swift
//  Vexillum
//
//  Created by Saad Anis on 29/06/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var selectedTab : SelectedTab = .directory
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: VexillumApp.getTitleFont(.largeTitle)]
        UINavigationBar.appearance().titleTextAttributes = [.font : VexillumApp.getTitleFont(.headline)]
    }
    
    var body: some View {
        TabView(selection: $selectedTab.animation()) {
            DirectoryView()
                .tabItemTag(systemName: "text.book.closed", tab: .directory, currentTab: selectedTab, tabName: "Directory")
            
            Text("Lists")
                .tabItemTag(systemName: "star", tab: .lists, currentTab: selectedTab, tabName: "Lists")
            
            Text("Quizzes")
                .tabItemTag(systemName: "puzzlepiece", tab: .quizzes, currentTab: selectedTab, tabName: "Quizzes")
            
            Text("Preferences")
                .tabItemTag(systemName: "gearshape", tab: .preferences, currentTab: selectedTab, tabName: "Preferences")
        }
    }
}

struct TabItemTag: ViewModifier {
    
    var systemName: String
    var tab: SelectedTab
    var currentTab: SelectedTab
    var tabName: String
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                Text(tabName)
                Image(systemName: systemName)
                    .symbolVariant(.none)
                    .environment(\.symbolVariants,
                                  tab == currentTab ? .fill : .none)
            }
            .tag(tab)
    }
}

extension View {
    func tabItemTag(systemName: String, tab: SelectedTab, currentTab: SelectedTab, tabName: String) -> some View {
        self.modifier(TabItemTag(systemName: systemName, tab: tab, currentTab: currentTab, tabName: tabName))
    }
}

enum SelectedTab {
    case directory, lists, quizzes, preferences
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlagCollection.self, configurations: config)
    
    for flagCollection in VexillumApp.generateFlagCollections() {
        container.mainContext.insert(flagCollection)
    }
    
    return ContentView()
        .modelContainer(container)
    
    
}
