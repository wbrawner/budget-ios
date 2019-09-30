//
//  ContentView.swift
//  Budget
//
//  Created by Billy Brawner on 9/29/19.
//  Copyright © 2019 William Brawner. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userData: UserDataStore
    
    var body: some View {
        Group {
            if userData.status == .authenticated {
                TabbedBudgetView(userData)
            } else {
                LoginView(userData)
            }
        }
    }
    
    
    init (_ userData: UserDataStore) {
        self.userData = userData
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
