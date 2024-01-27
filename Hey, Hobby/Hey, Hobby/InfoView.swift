//
//  InfoView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 1/26/24.
//

import SwiftUI
import ObjectiveC

struct InfoView: View {
    let profileDoc = """
    From welcome screen, click on Profile button to see details about you
    • From there you should be able to take below actions
    • Edit phone number
    • Reset password
    • Delete your user if you don’t want to use this app any more
    • You can see you list of friends
    • You can remove your friend from friend list
    """
    
    let statusDoc = """
    From welcome screen, click on Status button where you can do below
    • Enter at least  3 characters about your hobby word and app will display a list of matching hobbies
    • You have to select one of the suggested hobbies to set your status
    • Once you set your status, your friends will receive a message about it
    • If one of your friend sets the status, you will receive a notification. Once you click on the notification, it will display in this screen under “My Friends Status History”
    • These messages will be deleted after 2 days since it was received
    """
    
    let friendDoc = """
    From welcome screen, click on Friend button where you can do below
    • Search your friend by phone number or email address
    • Click Add next to friend found to add to your friends list
    """
    
    let troubleshooting = """
    • If you don’t get notification from your friends, then from profile screen, click on “Request NotificationPermissions” button and accept
"""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {

                    Text("Profile")
                        .font(.titleScriptSmall)
                        .foregroundColor(.white)
                    Text(profileDoc)
                    Text("Status")
                        .font(.titleScriptSmall)
                        .foregroundColor(.white)
                    Text(statusDoc)
                    Text("Friend")
                        .font(.titleScriptSmall)
                        .foregroundColor(.white)
                    Text(friendDoc)
                    
                    Seperator(width: 250)
            
                    
                    Text("Troubleshooting")
                        .font(.titleScript)
                        .foregroundColor(.white)
                    
                    Text(troubleshooting)
                        
                }
                .padding([.leading, .trailing])
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("About")
                            .foregroundColor(.white)
                            .font(.titleScript)
                    }
                }
            }
            .background(.themeColor)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
