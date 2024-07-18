//
//  VideoPlayImage.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 18/07/2024.
//

import SwiftUI

struct VideoPlayImage: View {
  @Binding var isVideoPlayerPresented: Bool
  var body: some View {
    ZStack {
      Image(systemName: "video")
        .font(.title3)
      Image(systemName: isVideoPlayerPresented ? "stop.fill" : "play.fill")
        .font(.caption2)
        .padding(.trailing, isVideoPlayerPresented ? 6 : 4)
    }
  }
}

#Preview {
  VideoPlayImage(isVideoPlayerPresented: .constant(true))
}
