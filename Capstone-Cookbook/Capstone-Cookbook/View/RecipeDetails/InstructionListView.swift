//
//  InstructionListView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 18/07/2024.
//

import SwiftUI
import AVKit
import SafariServices

struct InstructionListView: View {
  @State var isVideoPlay = false
  @State private var isYouTubeURL = false
  var instructions: [Instructions]
  var videoURL: String?
  var body: some View {
    ZStack {
      VStack {
        List(instructions) { instruction in
          HStack {
            Text(instruction.getBulletOrNumber())
              .font(.title3)
              .fontWeight(.light)
              .foregroundStyle(Color.accentColor)
            Text(instruction.displayText)
          }
        }
      }

      if !isYouTubeURL && isVideoPlay {
        if let videoURLString = videoURL {
          RecipeVideoPlayer(videoURL: videoURLString)
        }
      }
    }
    .onAppear {
      isVideoPlay = false
      if let videoURL = videoURL {
        if videoURL.contains("youtu") {
          isYouTubeURL = true
        }
      }
    }
    .onDisappear {
      isVideoPlay = false
    }
    .navigationTitle(isVideoPlay ? "" : "Instruction")
    .navigationBarBackButtonHidden(isVideoPlay)
    .toolbar {
      ToolbarItem {
        Button(action: {
          isVideoPlay.toggle()
          if isYouTubeURL {
            showYouTubePlayer()
          }
        }, label: {
          VideoPlayImage(isVideoPlayerPresented: $isVideoPlay)
        })
      }
    }
  }
}

struct RecipeVideoPlayer: View {
  var videoURL: String
  var body: some View {
    if let videoURL = URL(string: videoURL) {
      let player = AVPlayer(url: videoURL)
      VideoPlayer(player: player)
        .onAppear {
          player.play()
          ViewConstants.enableSwipBackGesture = false
        }
        .onDisappear {
          player.pause()
          ViewConstants.enableSwipBackGesture = true
        }
        .ignoresSafeArea(.all)
    }
  }
}

extension InstructionListView {
  func showYouTubePlayer() {
    if let videoURLString = videoURL {
      if let videoURL = URL(string: videoURLString) {
        let configuration = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: videoURL, configuration: configuration)
        UIApplication.shared.firstKeyWindow?.rootViewController?.present(safariViewController, animated: true)
      }
    }
  }
}

#Preview {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    @State var recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    var body: some View {
      NavigationStack {
        InstructionListView(instructions: recipe.tastyRecipe.instructions)
      }
    }
  }
  return Preview()
}
