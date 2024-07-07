//
//  FlagsListView.swift
//  Vexillum
//
//  Created by Saad Anis on 02/07/2024.
//

import SwiftUI
import SwiftData

struct FlagsListView: View {
    
    var flagCollection: FlagCollection

    let columns = [GridItem(), GridItem()]
    
    var body: some View {
        ScrollView {
            VStack {
                Text(flagCollection.overview)
                    .foregroundStyle(.secondary) 
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("\(flagCollection.flags.count) flags")
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .background {
                            Image(flagCollection.flags.randomElement()!.id)
                                .resizable()
                                .opacity(0.4)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Spacer()
                }
                    .font(.caption)
                Divider()
                    .overlay(.secondary)
            }
            .padding(.horizontal)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(flagCollection.flags.sorted(by: { flag1, flag2 in
                    flag1.country < flag2.country
                }), id: \.self) { flag in
                    NavigationLink {
                        FlagDetailsView(flag: flag)
                    } label: {
                        FlagListItemView(flagId: flag.id, flagName: flag.country)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(flagCollection.name)
//        .background {
//            LinearGradient(colors: [.secondary, .clear], startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
//        }
    }
}

struct FlagListItemView: View {
    
    var flagId: String
    var flagName: String
    
    var body: some View {
        VStack {
            Image(flagId)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: flagId != "Q159741" ? 7 : 0))
                .frame(height: 110, alignment: .center)
                .shadow(radius: 10)
            Divider()
                .overlay(.primary)
            Text(flagName)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .frame(height: 70, alignment: .top)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .background {
            Image(flagId)
                .resizable()
                .blur(radius: 10)
                .opacity(0.4)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {

//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: FlagCollection.self, configurations: config)
//    
//    for flagCollection in VexillumApp.generateFlagCollections() {
//        container.mainContext.insert(flagCollection)
//    }
//        
//    return NavigationStack {
//        FlagsListView(flagCollection: VexillumApp.generateFlagCollections()[0])
//            .modelContainer(container)
//    }
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FlagCollection.self, configurations: config)
    
    for flagCollection in VexillumApp.generateFlagCollections() {
        container.mainContext.insert(flagCollection)
    }
//    

    let flagCollections = VexillumApp.generateFlagCollections()
    
    return FlagsListView(flagCollection: FlagCollection(name: "", overview: "", symbolName: "", hex: ""))
        .modelContainer(container)
}
