//
//  TestView.swift
//  Vexillum
//
//  Created by Saad Anis on 11/07/2024.
//

import SwiftUI

struct TestView: View {
    
    @State var imageHeight: CGFloat = 0

    let headerHeight: CGFloat = 400

    var body: some View {
        ScrollView {
            // just remove .sectionHeaders to make it non-sticky
            LazyVStack(spacing: 8) {
                Section {
                    // >> any content
                    ForEach(0..<100) {
                        Text("Item \($0)")
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(RoundedRectangle(cornerRadius: 12).fill($0%2 == 0 ? .blue : .yellow))
                            .padding(.horizontal)
                    }
                    // << content end
                } header: {
                    // here is only caculable part
                    GeometryReader {
                        // detect current position of header bottom edge
                        Color.clear.preference(key: ViewOffsetKey.self,
                            value: $0.frame(in: .named("area")).maxY)
                    }
                    .frame(height: headerHeight)
                    .onPreferenceChange(ViewOffsetKey.self) {
                        // prevent image illegal if header is not pinned
                        imageHeight = $0 < 0 ? 0.001 : $0
                    }
                }
            }
        }
        .coordinateSpace(name: "area")
//        .overlay(
//            // >> any header
//            Image("Q80110").resizable()
//            // << header end
//                .frame(height: imageHeight)
//                .clipped()
//                .allowsHitTesting(false)
//        , alignment: .top)
        .overlay(alignment: .top) {
            Image("Q80110").resizable()
                .frame(height: imageHeight)
                .clipped()
                .allowsHitTesting(false)
        }
        .ignoresSafeArea(edges: .top)
//        .clipped()
    }
}

#Preview {
    TestView()
}
