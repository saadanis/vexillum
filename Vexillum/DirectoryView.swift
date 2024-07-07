//
//  DirectoryView.swift
//  Vexillum
//
//  Created by Saad Anis on 29/06/2024.
//

import SwiftUI
import SwiftData

struct DirectoryView: View {
    
    @Query var flagCollections: [FlagCollection]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(flagCollections) { flagCollection in
                        DirectoryRowView(flagCollection: flagCollection)
                            .overlay {
                                NavigationLink {
                                    FlagsListView(flagCollection: flagCollection)
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listRowSpacing(12)
            .navigationTitle("Directory")
        }
    }
}

struct DirectoryRowView: View {
    
    var flagCollection: FlagCollection
    
    var name: String { flagCollection.name }
    
    var overview: String { flagCollection.overview }
    
    var flags: [Flag] { flagCollection.flags }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                FlagsTileView(flags: flags.shuffled(), flagsPerRow: 8, numberOfRows: 4, flagHeight: 40, spacing: 10)
                    .padding(.bottom)
            }
            VStack(alignment: .leading, spacing: 5) {
                Divider()
                    .overlay(.primary)
                Text(name)
                    .font(.title2Rounded)
                    .fontWeight(.semibold)
                HStack {
                    Label("Available", systemImage: "checkmark")
                        .padding(5)
                        .labelStyle(LabelStyleWithSpacing(spacing: 5))
                        .font(.captionRounded)
                        .foregroundStyle(.secondary)
                        .background(.ultraThinMaterial.opacity(0.8))
                        .background { Color.green.opacity(0.35) }
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Label("\(flags.count)", systemImage: "rectangle.on.rectangle.angled")
                        .padding(5)
                        .labelStyle(LabelStyleWithSpacing(spacing: 5))
                        .font(.captionRounded)
                        .foregroundStyle(.secondary)
                        .background(.ultraThinMaterial.opacity(0.8))
                        .background {
                            Image(flags.shuffled().first!.id)
                                .resizable()
                                .blur(radius: 5)
                                .opacity(0.35)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                Text(overview)
                    .font(.bodyRounded)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(.thinMaterial)
        .background {
            SquishedHorizontalFlagBackgroundView(flags: flags).opacity(0.5)
        }
    }
}

struct FlagsTileView: View {
    
    var flags: [Flag]
    
    var chosenFlags: [Flag] {
        Array(flags[0..<(numberOfRows*flagsPerRow)])
    }
    
    var flagsPerRow: Int = 10
    
    var numberOfRows: Int
    var flagHeight: CGFloat
    
    var spacing: CGFloat = 10
    var totalHeight: CGFloat {
        let totalSpacingHeight = Int(spacing) * (numberOfRows-1)
        let totalFlagHeight = Int(flagHeight) * numberOfRows
        return CGFloat(totalFlagHeight + totalSpacingHeight)
    }
    
    @State private var offset: CGFloat = 0
    @State private var speed: CGFloat = 0.1
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        
    var body: some View {
        Color.clear
            .frame(height: totalHeight)
            .frame(maxWidth: .infinity)
            .background {
                VStack(spacing: spacing) {
                    ForEach(0..<numberOfRows, id: \.self) { i in
                        AnimatingHStackRowView(flags: flags,
                                               flagsPerRow: flagsPerRow,
                                               numberOfRows: numberOfRows,
                                               flagHeight: flagHeight,
                                               spacing: spacing,
                                               i: i)
                    }
                }
                .frame(width: 1000)
            }
    }
}

struct AnimatingHStackRowView: View {
    
    var flags: [Flag]
    var chosenFlags: [Flag] {
        Array(flags[0..<(numberOfRows*flagsPerRow)])
    }

    var flagsPerRow: Int = 10
    var numberOfRows: Int
    var flagHeight: CGFloat
    var spacing: CGFloat = 10
    
    var i: Int
    
    @State private var offset: CGFloat = 0
    @State private var speed: CGFloat = CGFloat.random(in: 0.07..<0.13)
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<flagsPerRow, id:\.self) { j in
                Image(chosenFlags[i*flagsPerRow+j].id)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: chosenFlags[i*flagsPerRow+j].id != "Q159741" ? 5 : 0))
                    .frame(height: flagHeight)
                    .shadow(radius: 5)
            }
        }
        .offset(x: offset)
        .onReceive(timer) { _ in
            if speed > 0 {
                offset = i%2 == 0 ? offset - speed : offset + speed
                speed -= 0.0001
            }
        }
        .onAppear {
            offset = 0
            speed = CGFloat.random(in: 0.07..<0.13)
        }
    }
}

struct FlagIconView: View {
    
    var symbolName: String
    var width: CGFloat = 120
    var height: CGFloat = 80
    
    var body: some View {
        Image(systemName: symbolName)
            .font(.system(size: height*0.75))
            .foregroundStyle(.secondary)
            .frame(width: width, height: height)
            .background(.ultraThinMaterial.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct SquishedHorizontalFlagBackgroundView: View {
    
    var flags: [Flag]
    
    var numberOfFlags = 5
    
    var startIndex: Int {
        Int.random(in: 0..<flags.count - numberOfFlags)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<numberOfFlags, id: \.self) { i in
                Image(flags[startIndex + i].id)
                    .resizable()
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct LabelStyleWithSpacing: LabelStyle {
    var spacing: Double = 0.0
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
            configuration.title
        }
    }
}


#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlagCollection.self, configurations: config)
    
    for flagCollection in VexillumApp.generateFlagCollections() {
        container.mainContext.insert(flagCollection)
    }
    
    return DirectoryView()
        .modelContainer(container)
}
