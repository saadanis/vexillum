//
//  FlagDetailsView.swift
//  Vexillum
//
//
//  Created by Saad Anis on 05/07/2024.

import SwiftUI
import SwiftData

struct FlagDetailsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var flag: Flag
    
    var backgroundColor: Color {
        
        let validColors = flag.hexes.filter { $0 != "FFFFFF" && $0 != "000000" }
        
        return Color(hex: validColors.shuffled()[0])
    }
    
    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(flag.id)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                if (flag.nickname != nil) {
                    CustomListTextRowView(systemName: "signature", title: "Nickname", backgroundColor: backgroundColor) {
                        Text(flag.nickname!)
                    }
                }
                
                CustomListTextRowView(systemName: "signature", title: "Overview", backgroundColor: backgroundColor) {
                    Text(flag.overview)
                }
                
                
                Section {
                    BoxedLabelView(systemName: "pin.fill", title: "Country", color: backgroundColor) {
                        Text(flag.country)
                            .font(.body)
                    }
                    BoxedLabelView(systemName: "globe.europe.africa.fill", title: "Continent", color: backgroundColor) {
                        Text(flag.continent.joined(separator: ", "))
                            .font(.body)
                    }
                }
                .listRowBackground(colorScheme == .dark ? Color.black.opacity(0.4) : Color.white.opacity(0.6))
                Section {
                    BoxedLabelView(systemName: "aspectratio.fill", title: "Aspect Ratio", color: backgroundColor) {
                        AspectRatioView(aspectRatio: flag.aspectRatio, imageName: flag.id)
                    }
                }
                .listRowBackground(colorScheme == .dark ? Color.black.opacity(0.4) : Color.white.opacity(0.6))
                
                Section {
                    BoxedLabelView(systemName: "paintpalette.fill", title: "Colors", color: backgroundColor) {
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
                    }
                }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .background {
            Image(flag.id)
                .resizable()
                .blur(radius: 100)
                .scaleEffect(1.4)
                .opacity(0.3)
                .ignoresSafeArea()
        }
        .navigationTitle(flag.country)
    }
}

struct CustomListTextRowView<Content: View>: View {
    
    var systemName: String
    var title: String
    
    var backgroundColor: Color
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack {
            BoxedLabelView(systemName: systemName, title: title, color: backgroundColor) {
                content
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.regularMaterial)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BoxedLabelView<Content: View>: View {
    
    var systemName: String
    var title: String
    var color: Color
    
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: systemName)
                .font(.subheadlineRounded)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .frame(width: 36, height: 36, alignment: .center)
                .background {
                    color
                        .overlay {
                            RadialGradient(gradient: .init(colors: [.white, .clear]), center: .topLeading, startRadius: 1, endRadius: 50)
                                .opacity(0.6)
                                .blendMode(.colorDodge)
                        }
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
            VStack(alignment: .leading) {
                Text(title)
                    .textCase(.uppercase)
                    .font(.captionRounded)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                content
            }
        }
    }
}

struct AspectRatioView: View {
    
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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Color.clear
                    .frame(width: frameWidth, height: frameHeight)
                    .background(.ultraThinMaterial)
                    .background{
                        Image(imageName)
                            .resizable()
                            .saturation(0)
                            .opacity(0.3)
                    }
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
                .frame(height: frameHeight)
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
            .frame(width: frameWidth)
        }
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
        
        let flag = flags.filter {flag in flag.country == "Nepal"}[0]
        
        return NavigationStack {
            FlagDetailsView(flag: flag)
        }
        .modelContainer(DataController.previewContainer)
        
    } catch {
        print("Error: \(error.localizedDescription)")
        return Text("Error")
    }
}
