//
//  ClearTextFieldButton.swift
//  KBApp
//
//  Created by Sam Richard on 1/25/23.
//

import SwiftUI

struct ClearTextFieldButton: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
            HStack {
                content
                if !text.isEmpty {
                    Button(
                        action: { self.text = "" },
                        label: {
                            Image(systemName: "delete.left")
                                .foregroundColor(Color(UIColor.opaqueSeparator))
                        }
                    )
                }
            }
        }
}

//struct ClearTextFieldButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ClearTextFieldButton()
//    }
//}
