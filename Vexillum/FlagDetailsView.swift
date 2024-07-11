//
//  FlagDetailsView.swift
//  Vexillum
//
//
//  Created by Saad Anis on 05/07/2024.

import SwiftUI
import SwiftData
import Charts

struct FlagDetailsView: View {
    
    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.presentationMode) var presentationMode
    
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
                VStack(spacing: 10) {
                    Image(flag.id)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                    
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
                    
//                    CustomListTextRowView(systemName: "scroll.fill", title: "Design", backgroundColors: backgroundColors) {
//                        Text(flag.overview)
//                            .padding(.trailing, 4)
//                    }
                    
                    
                    HStack(spacing:10) {
                        CustomListTextRowView(systemName: "pin.fill", title: "Country", backgroundColors: backgroundColors) {
                            Text(flag.country)
                        }
                        CustomListTextRowView(systemName: "globe.europe.africa.fill", title: "Continent", backgroundColors: backgroundColors) {
                            Text(flag.continent.joined(separator: ", "))
                        }
                        
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    
                    
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
                                //                                .overlay {
                                //                                    RoundedRectangle(cornerRadius: 10)
                                //                                        .stroke(.secondary, lineWidth: 1)
                                //                                }
                            }
                        }
                        .padding(.top, 5)
                    }
                }
                
                .padding()
            }
            .scrollContentBackground(.hidden)
            .background(backgroundColors[0].opacity(0.3))
//            .background {
//                //            Group { backgroundColors.indices.contains(1) ?
//                //                backgroundColors[0] : backgroundColors[0]
//                //            }
//                RadialGradient(colors: [
//                    backgroundColors.indices.contains(3) ?
//                    backgroundColors[1] : backgroundColors[0],
//                    backgroundColors.indices.contains(3) ?
//                    backgroundColors[1].opacity(0.5) : backgroundColors[0].opacity(0.5)
//                ], center: .top, startRadius: 200, endRadius: 500)
//                .opacity(0.3)
//                .ignoresSafeArea()
//            }
//                    .background {
//                        Image(flag.id)
//                            .resizable()
//                            .blur(radius: 100)
//                            .scaleEffect(1.4)
//                            .opacity(0.5)
//                            .ignoresSafeArea()
//                    }
            .navigationTitle(flag.country)
            .toolbarBackground(backgroundColors[0].opacity(0.3), for: .navigationBar)
//            .navigationBarBackButtonHidden()
//            .toolbar {
//                ToolbarItem(placement: .navigation) {
//                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .fontWeight(.semibold)
////                            .foregroundStyle(backgroundColors[0])
//                    }
//                }
//            }
    }
}

struct CustomListTextRowView<Content: View>: View {
    
    var systemName: String
    var title: String
    
    var backgroundColors: [Color]
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack {
            BoxedLabelView(systemName: systemName, title: title, backgroundColors: backgroundColors) {
                content
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(.thinMaterial)
        .background(backgroundColors[0])
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


//    .aspectRatio(aspectRatioWidth/aspectRatioHeight, contentMode: .fit)
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
                                print(oldValue, newValue)
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
    
    var flagCollections: [FlagCollection] = []
    
    do {
        let url = Bundle.main.url(forResource: "flags", withExtension: "json")
        let data = try Data(contentsOf: url!)
        let flags = try JSONDecoder().decode([Flag].self, from: data)
        
        let flag = flags.filter {flag in flag.country == "United Kingdom"}[0]
        
        return NavigationStack {
            FlagDetailsView(flag: flag)
        }
        .modelContainer(DataController.previewContainer)
        
    } catch {
        print("Error: \(error.localizedDescription)")
        return Text("Error")
    }
}
