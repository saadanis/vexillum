//
//  FlagDetailsView.swift
//  Vexillum
//
//
//  Created by Saad Anis on 05/07/2024.

import SwiftUI
import SwiftData

struct FlagDetailsView: View {
    
    @Binding var path: NavigationPath
    
    var flag: Flag
    
    @Environment(\.colorScheme) var colorScheme
    
    @Query(filter: #Predicate<FlagCollection> { flagCollection in
        flagCollection.name == "Favorites"
    }) var favoritesList: [FlagCollection]
    
    var favorites: FlagCollection {
        favoritesList[0]
    }
    
    var isFavorited: Bool {
        favorites.flags.contains(flag)
    }
    
    var backgroundColors: [Color] {
        
        let validColors = flag.hexes.filter { Color(hex: $0) != .white && Color(hex: $0) != .black }
        
        return validColors.map { hex in
            Color(hex: hex)
        }
    }

    
    let columns = [GridItem(), GridItem()]
    
    @State var imageHeight: CGFloat = 0

    let headerHeight: CGFloat = 500
    
    let headerContentHeight: CGFloat = 500
    
    let navHeight: CGFloat = 100
    
    @State var navIsHidden: Bool = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Section {
                    Group {
                        CustomListTextRowView(systemName: "pin.fill", title: "Aspect Ratio", backgroundColors: backgroundColors) {
                            Text(flag.aspectRatio)
                        }
                    }
                    .padding(.horizontal)
                } header: {
                    GeometryReader {
                        ZStack(alignment: .bottom) {
                            Color.clear
                            VStack {
                                Image(flag.id)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                                if flag.nickname != nil {
                                    Text(flag.nickname!)
                                        .font(.title2Rounded)
                                        .fontWeight(.semibold)
                                    Text("Flag of the \(flag.country)")
                                        .font(.subheadlineRounded)
                                } else {
                                    Text("Flag of the \(flag.country)")
                                        .font(.title2Rounded)
                                        .fontWeight(.semibold)
                                }
                                Text(flag.overview)
                                    .font(.captionRounded)
//                                    .foregroundColor()
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 10)
                                    .frame(maxWidth: .infinity)
                            }
                                .padding()
                                .frame(maxWidth: .infinity)
                        }.preference(key: ViewOffsetKey.self,
                            value: $0.frame(in: .named("area")).maxY)
                        .opacity((imageHeight-navHeight)/(headerHeight-navHeight))
                    }
                    .frame(height: headerHeight, alignment: .bottom)
                    .onPreferenceChange(ViewOffsetKey.self) { val in
                        imageHeight = val < 0 ? 0 : val
                        
                            withAnimation(.linear) {
                                if val > navHeight {
                                    navIsHidden = true
                                } else
                                if val < navHeight {
                                    navIsHidden = false
                                }
                            }
                    }
                }
            }
        }
        .coordinateSpace(name: "area")
        .background(alignment: .top) {
            Image(flag.id).resizable().scaledToFill()
                .blur(radius: 40)
                .opacity(0.5*((imageHeight-navHeight)/headerHeight))
                .scaleEffect(1.5)
                .frame(height: imageHeight)
                .clipped()
                .allowsHitTesting(false)
        }
        .ignoresSafeArea(edges: .top)
//        .navigationTitle("Nav Title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if isFavorited {
                        favorites.flags.removeAll { flag1 in
                            flag1.id == flag.id
                        }
                    } else {
                        favorites.flags.append(flag)
                    }
                }, label: {
                    Label(
                        title: { Text("Favorite") },
                        icon: { Image(systemName: isFavorited ? "heart.fill" : "heart") }
                    )
                })
            }
        }
        .toolbarBackground(navIsHidden ? .hidden : .visible)
    }
}


struct FlagDetailsViewX: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Query(filter: #Predicate<FlagCollection> { flagCollection in
        flagCollection.name == "Favorites"
    }) var favoritesList: [FlagCollection]
    
    var favorites: FlagCollection {
        favoritesList[0]
    }
    
    var flag: Flag
    
    var backgroundColors: [Color] {
        
        let validColors = flag.hexes.filter { Color(hex: $0) != .white && Color(hex: $0) != .black }
        
        
        return validColors.map { hex in
            Color(hex: hex)
        }
    }

    
    let columns = [GridItem(), GridItem()]
    
    @State var trs: CGFloat = 1
    
    @State var imageHeight: CGFloat = 0

    let headerHeight: CGFloat = 500

    var body: some View {
        ScrollView {
            // just remove .sectionHeaders to make it non-sticky
            LazyVStack(spacing: 0) {
                Section {
                    VStack {
                        VStack {
                            Image(flag.id)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding()
                            Group {
                                if flag.nickname != nil {
                                    Text(flag.nickname!)
                                        .font(.title2Rounded)
                                        .fontWeight(.semibold)
                                    Text(flag.country)
                                        .font(.headlineRounded)
                                        .fontWeight(.regular)
                                } else {
                                    Text("Flag of \(flag.country)")
                                        .font(.title2Rounded)
                                        .fontWeight(.semibold)
                                }
                            }
                            Text(flag.overview)
                                .font(.footnoteRounded)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                        }
                        .opacity((imageHeight/500)>1 ? 1 : (imageHeight/500))
                        .padding(.bottom)
                        .frame(height: 400, alignment: .bottom)
//                        .background(.orange)
                        // >> any content
//                        ForEach(0..<100) {
//                            Text("Item \($0)")
//                                .frame(maxWidth: .infinity, minHeight: 60)
//                                .background(RoundedRectangle(cornerRadius: 12).fill($0%2 == 0 ? .blue : .yellow))
//                        }
                    }
                    .padding(.horizontal)
//                    .offset(y:-400)
                    // << content end
                } header: {
                    // here is only calculable part
                    GeometryReader {
                        // detect current position of header bottom edge
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: $0.frame(in: .named("area")).maxY)
                    }
                    .frame(height: headerHeight)
                    .onPreferenceChange(ViewOffsetKey.self) {
                        // prevent image illegal if header is not pinned
                        imageHeight = $0 < 0 ? 0.001 : $0
                        print(imageHeight/500)
                    }
                }
                Section {
                    ForEach(0..<100) {
                        Text("Item \($0)")
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill($0%2 == 0 ? .blue : .yellow))
                    }
                }
            }
        }
        .coordinateSpace(name: "area")
        .background(alignment: .top) {
            Image(flag.id).resizable().scaledToFill()
                .blur(radius: 40)
                .saturation(1.3)
                .opacity(0.5*(imageHeight/500))
                .scaleEffect(1.5)
                .frame(height: imageHeight)
                .clipped()
                .allowsHitTesting(false)
        }
        .ignoresSafeArea(edges: .top)
//        .navigationTitle(flag.country)
        .toolbarBackground(Material.ultraThin, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
//        .clipped()
    }
}

struct FlagDetailsView3: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Query(filter: #Predicate<FlagCollection> { flagCollection in
        flagCollection.name == "Favorites"
    }) var favoritesList: [FlagCollection]
    
    var favorites: FlagCollection {
        favoritesList[0]
    }
    
    var flag: Flag
    
    var backgroundColors: [Color] {
        
        let validColors = flag.hexes.filter { Color(hex: $0) != .white && Color(hex: $0) != .black }
        
//        let validColors = flag.hexes
        
        return validColors.map { hex in
            Color(hex: hex)
        }
    }

    
    let columns = [GridItem(), GridItem()]
    
    @State var trs: CGFloat = 1
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottom) {
                Image(flag.id)
                    .resizable()
                    .blur(radius: 50)
                    .frame(height: 400)
                    .frame(maxWidth: .infinity)
                    .scaleEffect(1.2*trs)
                    .clipped()
                VStack {
                    Image(flag.id)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300, alignment: .bottom)
                    
                    
                }
                .padding([.horizontal, .bottom])
            }
            ForEach(0..<60) { i in
                Text("Line \(i)")
            }
        }
        .ignoresSafeArea(edges: .top)
        .gesture(DragGesture().onChanged { gesture in
            trs = gesture.translation.height
        })
    }
}

struct FlagDetailsView2: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Query(filter: #Predicate<FlagCollection> { flagCollection in
        flagCollection.name == "Favorites"
    }) var favoritesList: [FlagCollection]
    
    var favorites: FlagCollection {
        favoritesList[0]
    }
    
    var flag: Flag
    
    var backgroundColors: [Color] {
        
        let validColors = flag.hexes.filter { Color(hex: $0) != .white && Color(hex: $0) != .black }
        
//        let validColors = flag.hexes
        
        return validColors.map { hex in
            Color(hex: hex)
        }
    }

    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
            ScrollView {
                    ZStack(alignment: .bottom) {
                        Color.red
                            .frame(maxHeight: 1000)
                            .ignoresSafeArea()
                        Image(flag.id)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300, alignment: .bottom)
                            .padding(.horizontal)
                    }
                VStack(spacing: 10) {
                    Text(flag.overview)
                        .font(.subheadlineRounded)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider()
                        .overlay(.secondary)
                        .padding(.bottom)
                    
                    
                    if (flag.nickname != nil) {
                        CustomListTextRowView(systemName: "signature", title: "Nickname", backgroundColors: backgroundColors) {
                            Text(flag.nickname!)
                        }
                    }
//                    Commented to build only.
//                    HStack(spacing:10) {
//                        CustomListTextRowView(systemName: "pin.fill", title: "Country", backgroundColors: backgroundColors) {
//                            Text(flag.country)
//                        }
//                        CustomListTextRowView(systemName: "globe.europe.africa.fill", title: "Continent", backgroundColors: backgroundColors) {
//                            Text(flag.continent.joined(separator: ", "))
//                        }
//                        
//                    }
//                    .fixedSize(horizontal: false, vertical: true)
                    
                    CustomListTextRowView(systemName: "aspectratio.fill", title: "Aspect Ratio", backgroundColors: backgroundColors) {
                            AspectRatioView(aspectRatio: flag.aspectRatio, imageName: flag.id)
                            .padding(.top, 5)
                    }
                    
                    CustomListTextRowView(systemName: "paintpalette.fill", title: "Colors", backgroundColors: backgroundColors) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(flag.hexes, id: \.self) { hex in
                                Text("#\(hex)")
                                    .fontDesign(.monospaced)
                                    .padding(5)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .frame(height: 80)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: hex))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.top, 5)
                    }
                }
                
                .padding()
            }
            .scrollContentBackground(.hidden)
            .background(!backgroundColors.isEmpty ? backgroundColors[0].opacity(0.3) : Color.gray.opacity(0.3))
            .navigationTitle(flag.country)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        favorites.flags.append(flag)
                    }, label: {
                        Label {
                            Text("Favorite")
                        } icon: {
                            Image(systemName: favorites.flags.contains(flag) ? "heart.fill" : "heart")
                        }
                    }).tint(!backgroundColors.isEmpty ? backgroundColors[0] : Color.gray)
                }
            }
    }
}

struct CustomListTextRowView<Content: View>: View {
    
    var systemName: String
    var title: String
    
    var backgroundColors: [Color]
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            BoxedLabelView(systemName: systemName, title: title, backgroundColors: backgroundColors) {
                content
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
//        .background(.thinMaterial)
//        .background(backgroundColors[0])
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BoxedLabelView<Content: View>: View {
    
    var systemName: String
    var title: String
    var backgroundColors: [Color]
    
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: systemName)
                .font(.subheadlineRounded)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .frame(width: 36, height: 36, alignment: .center)
                .background {
                    Group {
                        backgroundColors.indices.contains(0) ? backgroundColors[0] : Color.gray
                    }
                    .overlay {
                        RadialGradient(
                            gradient: .init(
                                colors: [
                                    .white,
                                    .clear
                                ]),
                            center: .topLeading,
                            startRadius: 1,
                            endRadius: 50)
                        .brightness(0.8)
                        .opacity(0.6)
                        .blendMode(.colorDodge)
                    }
                    .scaleEffect(1.5)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .textCase(.uppercase)
                    .font(.captionRounded)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                content
                    .font(.bodyRounded)
            }
        }
    }
}

struct AspectRatioView2: View {
    
    var aspectRatio: String
    var imageName: String
    
    var frameHeight: Double = 110
    
    var aspectRatioHeight: Double {
        Double(aspectRatio.split(separator: ":")[0])!
    }
    
    var aspectRatioWidth: Double {
        Double(aspectRatio.split(separator: ":")[1])!
    }
    
    var frameWidth: Double {
        return aspectRatioWidth * frameHeight / aspectRatioHeight
    }
    
    let columns = [GridItem(.flexible(maximum: .infinity)), GridItem(.flexible(maximum: 10))]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .saturation(0)
                .opacity(0.5)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(.ultraThinMaterial)
                .background(.green)
            VStack(alignment: .leading) {
                HStack {
                    Divider()
                        .frame(width: 1)
                        .overlay(.primary)
                }
                Text("\(aspectRatioHeight, specifier: "%.0f")")
                HStack {
                    Divider()
                        .frame(width: 1)
                        .overlay(.primary)
                }
            }
            .background(.green)
            HStack {
                VStack {
                    Divider()
                        .frame(height: 1)
                        .overlay(.primary)
                }
                Text("\(aspectRatioWidth, specifier: "%.0f")")
                VStack {
                    Divider()
                        .frame(height: 1)
                        .overlay(.primary)
                }
            }
            .background(.green)
        }
        .background(.red)
    }
}

struct AspectRatioView: View {
    
    var aspectRatio: String
    var imageName: String
    
    var frameHeight: Double = 100
    
    var aspectRatioHeight: Double {
        Double(aspectRatio.split(separator: ":")[0])!
    }
    
    var aspectRatioWidth: Double {
        Double(aspectRatio.split(separator: ":")[1])!
    }
    
    var frameWidth: Double {
        return aspectRatioWidth * frameHeight / aspectRatioHeight
    }
    
    @State var imageWidth: CGFloat = 4
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .blur(radius: 100)
                    .overlay {
                        GeometryReader { geometry in
                            Path { path in
                                let width = geometry.size.width
                                
                                let height = geometry.size.height
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLine(to: CGPoint(x: width-0, y: height-0))
                                path.move(to: CGPoint(x: width-0, y: 0))
                                path.addLine(to: CGPoint(x: 0, y: height-0))
                            }
                            .stroke(.secondary, lineWidth: 1)
                            .onAppear() {
                                imageWidth = geometry.size.width
                            }
                            .onChange(of: geometry.size.width) { oldValue, newValue in
                                imageWidth = max(oldValue, newValue)
//                                print(oldValue, newValue)
                            }
                        }
                        }
                    .clipShape(RoundedRectangle(cornerRadius: 0))
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(.secondary, lineWidth: 1)
                    )
                VStack(alignment: imageName == "Q159741" ? .leading : .center) {
                    HStack {
                        Divider()
                            .frame(width: 1)
                            .overlay(.primary)
                            .padding(.leading, imageName == "Q159741" ? 6 : 0)
                    }
                    Text(imageName == "Q159741" ? "\(aspectRatioHeight, specifier: "%.7f")..." : "\(aspectRatioHeight, specifier: "%.0f")")
                        .font(.calloutRounded)
                    HStack {
                        Divider()
                            .frame(width: 1)
                            .overlay(.primary)
                            .padding(.leading, imageName == "Q159741" ? 6 : 0)
                    }
                }
            }
            HStack {
                VStack {
                    Divider()
                        .frame(height: 1)
                        .overlay(.primary)
                }
                Text("\(aspectRatioWidth, specifier: "%.0f")")
                    .font(.calloutRounded)
                VStack {
                    Divider()
                        .frame(height: 1)
                        .overlay(.primary)
                }
            }
            .frame(width: imageWidth)
        }
        .frame(maxHeight: 200)
        
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlagCollection.self, configurations: config)
    
    for flagCollection in VexillumApp.generateFlagCollections() {
        container.mainContext.insert(flagCollection)
    }
    
    do {

        struct Preview: View {
            
            var flag: Flag {
                do {
                    let url = Bundle.main.url(forResource: "flags", withExtension: "json")
                    let data = try Data(contentsOf: url!)
                    let flags = try JSONDecoder().decode([Flag].self, from: data)
                    
                    print(flags)
                    print(flags.filter {flag in flag.country == "United Kingdom"}[0].country)
                    
                    return flags.filter {flag in flag.country == "United Kingdom"}[0]
                } catch {
                    return Flag(country: "", id: "", continent: ["Europe"], aspectRatio: "1:2", hexes: ["#f00", "#00f"], overview: "", collections: [])
                }
            }
            
            @State var path = NavigationPath()
            var body: some View {
                NavigationStack {
                    FlagDetailsView(path: $path, flag: flag)
                }
            }
        }
        
        return Preview()
            .modelContainer(container)
        
    } catch {
        print("Error: \(error.localizedDescription)")
        return Text("Error")
    }
}
