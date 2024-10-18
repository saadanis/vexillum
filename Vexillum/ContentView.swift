//
//  ContentView.swift
//  Vexillum
//
//  Created by Saad Anis on 29/06/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

        @Query(filter: #Predicate<FlagCollection> { flagCollection in
            flagCollection.predefined
        }) var predefinedFlagCollections: [FlagCollection]
    
        @Query(filter: #Predicate<FlagCollection> { flagCollection in
            !flagCollection.predefined
        }) var customFlagCollections: [FlagCollection]
    
        init() {
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: VexillumApp.getTitleFont(.largeTitle)]
            UINavigationBar.appearance().titleTextAttributes = [.font : VexillumApp.getTitleFont(.headline)]
        }
    
    
    @State private var selectedTab: Tab = .directory
    
    @State private var directoryPath = NavigationPath()
    @State private var listsPath = NavigationPath()
    @State private var searchPath = NavigationPath()
    @State private var quizzesPath = NavigationPath()
    @State private var settingsPath = NavigationPath()

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                
                DirectoryView(path: $directoryPath, flagCollections: predefinedFlagCollections, title: "Directory")
                    .tag(Tab.directory)

                DirectoryView(path: $listsPath, flagCollections: customFlagCollections, title: "Lists")
                    .tag(Tab.lists)
                
                Text("")
                    .tag(Tab.search)
                
                Text("")
                    .tag(Tab.quizzes)
                
                Text("")
                    .tag(Tab.settings)
            }
            
            CustomTabView(selectedTab: $selectedTab) {
                if selectedTab == .directory {
                    directoryPath = NavigationPath()
                } else if selectedTab == .lists {
                    listsPath = NavigationPath()
                } else if selectedTab == .search {
                    searchPath = NavigationPath()
                } else if selectedTab == .quizzes {
                    quizzesPath = NavigationPath()
                } else if selectedTab == .settings {
                    settingsPath = NavigationPath()
                }
            }
        }
    }
}

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    let action: () -> Void
    
    @State var effects: [Tab : Bool] = [
        .directory : false,
        .lists : false,
        .search : false,
        .quizzes : false,
        .settings : false,
    ]
    
    @State var colors: [Tab : Color] = [
        .directory : .red,
        .lists : .green,
        .search : .red,
        .quizzes : .orange,
        .settings : .pink,
    ]

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button {
                        if selectedTab == tab {
                            action()
                        }
                        selectedTab = tab
                        print(selectedTab)
                        effects[selectedTab]?.toggle()
                    } label: {
                        VStack(alignment: .center) {
//                            Group {
//                                if tab.rawValue == "magnifyingglass" {
//                                    Image(systemName:
//                                            "\(selectedTab == tab ? "sparkle." : "")\(tab.rawValue)")
//                                    .foregroundStyle(selectedTab == tab ?
//                                                     LinearGradient(colors: [.purple, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing) :
//                                                        LinearGradient(colors: [.secondary], startPoint: .topLeading, endPoint: .bottomTrailing)
//                                    )
//                                } else {
                                    Image(systemName: tab.rawValue)
                                        .symbolVariant(selectedTab == tab ? .fill : .none)
                                        .foregroundStyle(selectedTab == tab ? Color.accentColor : .secondary
                                        )
                                        .frame(height: 49, alignment: .center)
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
//                                }
//                            }
//                            .background(.orange)
                            .imageScale(.large)
                            .fontWeight(.bold)
//                            .padding(.vertical, 11)
//                            .symbolEffect(.bounce.wholeSymbol, options: .speed(1.5), value: effects[tab])
                            .sensoryFeedback(.selection, trigger: effects[tab])
//                            .background(.clear)
                        }
                    }
                    .symbolEffect(.wiggle.byLayer, value: effects[tab])
                    .buttonStyle(NoFadeButtonStyle())
                }
//                .background(.red)
            }
//            .background(.purple.opacity(0.1))
        }
    }
}

struct NoFadeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(1.0)
//            .symbolEffect(.bounce.wholeSymbol.down, value: configuration.isPressed)
    }
}

enum Tab: String, CaseIterable {
    case directory = "text.book.closed"
    case lists = "star.square.on.square"
    case search = "magnifyingglass"
    case quizzes = "puzzlepiece.extension"
    case settings = "gearshape"

    var text: String {
        switch self {
        case .directory:
            "Directory"
        case .lists:
            "Lists"
        case .search:
            "Search"
        case .quizzes:
            "Quizzes"
        case .settings:
            "Settings"
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
