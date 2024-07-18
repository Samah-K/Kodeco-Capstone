//
//  TimePicker.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 19/07/2024.
//

import SwiftUI

struct TimePicker: View {
  @State private var hours: Int = 0
  @State private var minutes: Int = 0
  var timePickerTitle: String
  @Binding var time: Int // in minutes: (hours * 60 + minutes)
  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      Text("\(timePickerTitle)")
      HStack {
        VStack(spacing: 3) {
          Picker("Hours", selection: $hours) {
            ForEach(0..<11) { hour in
              Text("\(hour)")
                .tag("\(hour)")
            }
          }
          .pickerStyle(.wheel)
          .frame(maxWidth: 50, maxHeight: 100)
          Text("hours")
            .font(.caption)
            .opacity(0.5)
        }

        VStack(spacing: 3) {
          Picker("Minutes", selection: $minutes) {
            ForEach(0..<60) { minutes in
              Text("\(minutes)")
                .tag("(minutes)")
            }
          }
          .pickerStyle(.wheel)
          .frame(maxWidth: 50, maxHeight: 100)
          Text("minutes")
            .font(.caption)
            .opacity(0.5)
        }
      }
      .onChange(of: hours) {
        calculateTime()
      }
      .onChange(of: minutes) {
        calculateTime()
      }
      .onAppear {
        hours = time / 60
        minutes = time % 60
      }
    }
  }
}

extension TimePicker {
  private func calculateTime() {
    time = hours * 60 + minutes
  }
}

#Preview("TimePicker") {
  struct Preview: View {
    @State var timeInt = 260
    var body: some View {
      TimePicker(timePickerTitle: "Prep Time", time: $timeInt)
    }
  }
  return Preview()
}
