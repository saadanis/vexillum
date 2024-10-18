//
//  CreateNewListView.swift
//  Vexillum
//
//  Created by Saad Anis on 17/07/2024.
//

import SwiftUI

struct CreateNewListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var overview: String = ""
    @State var symbolName: String = "star.fill"
//    @State var predefined: Bool
    
    let flagsPerRow = 8
    let numberOfRows = 3
    
    var flags: [Flag] {
        
        let flags = [Flag](repeating: Flag(country: "", id: "placeholder_1.5", continent: [], aspectRatio: "", hexes: [], overview: "", collections: []), count: 10) +
        [Flag](repeating: Flag(country: "", id: "placeholder_1.2", continent: [], aspectRatio: "", hexes: [], overview: "", collections: []), count: 7) +
        [Flag](repeating: Flag(country: "", id: "placeholder_1.4", continent: [], aspectRatio: "", hexes: [], overview: "", collections: []), count: 4) +
        [Flag](repeating: Flag(country: "", id: "placeholder_1.6", continent: [], aspectRatio: "", hexes: [], overview: "", collections: []), count: 3) +
        [Flag](repeating: Flag(country: "", id: "placeholder_1.9", continent: [], aspectRatio: "", hexes: [], overview: "", collections: []), count: 1)
        
        return flags.shuffled()
    }
    
    var tileFlags: [Flag] {
        
        if flags.count >= flagsPerRow*numberOfRows {
            return flags
        } else if flags.count == 0 {
            return flags
        }
        
        var tileFlags: [Flag] = []
        
        while tileFlags.count < flagsPerRow*numberOfRows {
            tileFlags.append(contentsOf: flags)
        }
        
        return tileFlags
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        FlagsTileView(flags: tileFlags, flagsPerRow: flagsPerRow, numberOfRows: numberOfRows, flagHeight: 40, spacing: 10)
                            .padding(.bottom)
                        VStack(alignment: .leading, spacing: 5) {
                            Divider()
                                .overlay(.primary)
                                .padding(.bottom, 10)
                            HStack(alignment: .bottom) {
                                Image(systemName: symbolName)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(width: 54, height: 54, alignment: .center)
                                    .foregroundStyle(.secondary)
                                    .background(.ultraThinMaterial.opacity(1))
                                    .background {
                                        Color.gray.opacity(0.35)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(name == "" ? "List Name" : name)
                                        .font(.title2Rounded)
                                        .fontWeight(.semibold)
                                    HStack {
                                        Label("\(5)", systemImage: "rectangle.on.rectangle.angled")
                                            .padding(5)
                                            .labelStyle(LabelStyleWithSpacing(spacing: 5))
                                            .font(.captionRounded)
                                            .foregroundStyle(.secondary)
                                            .background(.ultraThinMaterial.opacity(0.8))
                                            .background {
                                                Color.gray.opacity(0.35)
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text(overview == "" ? "List Description" : overview)
                                .font(.bodyRounded)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(.thinMaterial)
                .background(
                    LinearGradient(colors: VexillumApp.placeholderColors, startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.4)
                )
//                .background(.gray.opacity(0.3))
//                .background {
//                    HStack(spacing: 0) {
//                        ForEach(VexillumApp.placeholderColors) { color in
//                            color
//                        }
//                    }
//                }
                
                VStack(alignment: .center) {
                    Image(systemName: symbolName)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 135, height: 90, alignment: .center)
                        .background(Material.ultraThickMaterial)
                        .background(.cyan)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .frame(maxWidth: .infinity)
                TextField("Name", text: $name)
                TextField("Description", text: $overview, axis: .vertical)
            }
            .navigationTitle("Create New List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CreateNewListView()
}
