//
//  VexillumApp.swift
//  Vexillum
//
//  Created by Saad Anis on 29/06/2024.
//

import SwiftUI
import SwiftData

@main
struct VexillumApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FlagCollection.self) { result in
            do {
                let container = try result.get()
                
                let descriptor = FetchDescriptor<FlagCollection>()
                let existingFlagCollection = try container.mainContext.fetchCount(descriptor)
                
                guard existingFlagCollection == 0 else { return }
                
                for flagCollection in VexillumApp.generateFlagCollections() {
                    container.mainContext.insert(flagCollection)
                }
                
            } catch {
                print("Failed to pre-seed database.")
                print("Error: \(error)")
            }
        }
    }
    
    static func generateFlagCollections() -> [FlagCollection] {
        do {
            guard let url = Bundle.main.url(forResource: "flags", withExtension: "json") else {
                print("Fatal Error!")
                fatalError("Failed to find flags.json")
            }
            
            let data = try Data(contentsOf: url)
            let flags = try JSONDecoder().decode([Flag].self, from: data)
            
            return [
                FlagCollection(
                    name: "National Flags",
                    overview: "Explore the world’s nations through their flags, each representing the unique identity and heritage of its country.",
                    symbolName: "globe.europe.africa.fill",
                    hex: "FFF",
                    flags: flags
                )
            ]
        } catch {
            print("Error: \(error)")
            return []
        }
    }
    
    static func getFlagByID(id: String) -> Flag {
        
        let flagCollection = VexillumApp.generateFlagCollections()[0]
        
        print(flagCollection)
        
        let flag = flagCollection.flags.filter { flag in
            flag.id == id
        }
        
        return flag[0]
    }
    
    static func getTitleFont(_ textStyle: UIFont.TextStyle) -> UIFont {
        let titleFont = UIFont.preferredFont(forTextStyle: textStyle)
        return UIFont(
            descriptor:
                titleFont.fontDescriptor
                .withDesign(.rounded)?
                .withSymbolicTraits(.traitBold)
            ??
            titleFont.fontDescriptor, size: titleFont.pointSize
        )
    }
}

struct GlobalFontDesign: ViewModifier {
    var fontDesign: Font.Design
    
    func body(content: Content) -> some View {
        content.fontDesign(fontDesign)
    }
}

extension View {
    func globalFontDesign(_ fontDesign: Font.Design) -> some View {
        self.modifier(GlobalFontDesign(fontDesign: fontDesign))
    }
}

extension Font {
    
    static let largeTitleRounded = Font.system(.largeTitle, design: .rounded)
    
    public static var titleRounded: Font {
        return Font.system(.title, design: .rounded)
    }
    
    public static var title2Rounded: Font {
        return Font.system(.title2, design: .rounded)
    }
    
    public static var title3Rounded: Font {
        return Font.system(.title3, design: .rounded)
    }
    
    public static var headlineRounded: Font {
        return Font.system(.headline, design: .rounded)
    }
    
    static let subheadlineRounded = Font.system(.subheadline, design: .rounded)
    
    public static var bodyRounded: Font {
        return Font.system(.body, design: .rounded)
    }
    
    public static var calloutRounded: Font {
        return Font.system(.callout, design: .rounded)
    }
    
    public static var footnoteRounded: Font {
        return Font.system(.footnote, design: .rounded)
    }
    
    public static var captionRounded: Font {
        return Font.system(.caption, design: .rounded)
    }
    
    public static var caption2Rounded: Font {
        return Font.system(.caption2, design: .rounded)
    }
}