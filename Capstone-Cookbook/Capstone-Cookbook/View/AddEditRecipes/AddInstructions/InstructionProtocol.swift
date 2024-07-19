//
//  InstructionProtocol.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 18/07/2024.
//

import Foundation

protocol InstructionProtocol {
  func saveInstruction(instruction: Instructions, addOrEdit: AddOrEditEnum)
}
