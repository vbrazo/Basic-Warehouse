#Installation

Grab the latest code version from [GitHub](https://github.com/vbrazo/Discount-Ascii-Warehouse.git):

	$ git clone https://github.com/vbrazo/Discount-Ascii-Warehouse.git

Or download using [this link](https://github.com/vbrazo/Discount-Ascii-Warehouse/tree/master/Archives/discount_ascii_warehouse.zip)

##Dependencies
To be able to compile this project you need the following installed on your system.

###XCode
To be able to compile the code you need to have XCode 7.2 and iOS (>=) 8.0 installed.

###CocoaPods

This project uses [CocoaPods](https://cocoapods.org) as dependency manager to install and maintain third party libraries.
To [install CocoaPods](https://cocoapods.org/#install) run the following in the OS terminal:
	
	$ sudo gem install cocoapods

#Notes

##Core Data
[Core Data](https://developer.apple.com/library/tvos/documentation/Cocoa/Conceptual/CoreData/index.html) is used to manage the model layer objects on the application. With this structure we are able to maintain the view controllers synchronized as quickly as the model is updated.

Managed object context used: 
the `main` context to deal with the UI.
the `private` context to insert/update info in the core data models.

##Collection View Controller

I chose collection view controller to display the data because of the distinct cell widths and the flexibility it brings to cell arrangement.

##SwiftyJSON
[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) makes it easy to deal with JSON data in Swift.

##SwiftHTTP
[SwiftHTTP](https://github.com/daltoniam/SwiftHTTP) is a thin wrapper around NSURLSession in Swift to simplify HTTP requests.

##CCBottomRefreshControl
[BottomRefreshControl](https://github.com/vlasov/CCBottomRefreshControl) helped me to add bottomRefreshControl property, that could be assigned to UIRefreshControl class instance. It basically implements an ability to add native iOS bottom pull-up to refresh control to UITableView or UICollectionView

##XCTest
[XCTest](http://nshipster.com/xctestcase/) is the testing framework. As you may know, tests are codes you write that exercise your app and library code and results in a pass or fail result, measured against a set of expectations. In this project we have a few tests 

#What kinds of things do you look for in the code, technology choices, team practices etc. that can help to make a project successful? 

###Things that I look for in codes:
1. Formatting
2. Style
3. Naming
4. Test coverage: Is there a test for this code?
5. Design
How does the code fit with the overall architecture?
What design patterns are used in the new code?
Does the new code introduce duplication? If so, should we refactor to a more reusable pattern?
6. Readability & Maintainability
Is it possible to understand what the code does by reading it?
Are there test cases that haven’t been considered?
7. Functionality
Any potential security problems?

#Technology choices:
In this section, we are going to discuss about mobile app development technology. First you have to decide what kind of app works best for you: native, hybrid or web.


Type | Description | Advantage | Disadvantage
:-- | :-- | :-- | :-- 
Native apps | Native mobile is one that is developed to be ‘native’ to a specific platform: In my project I am working with Apple’s iOS, but there are other plataforms like Google’s Android and Windows Phone. | It optimizes the user experience; the app will operate more quickly because it’s been designed specifically for that platform. | If you wish to build and launch your app on more than one platform you almost need to start each one from scratch.
Hybrid apps | In 2012, HTML5 appeared to be the future of mobile; leading companies like Facebook, LinkedIn and Xero had jumped in and it was getting a lot of attention but last year many of the companies ditch their apps and start again with native apps. | If your app will primarily deliver content, and if it’s important to the business outcome for the app to be cross-platform, you should still consider it. | The reasons for this are simple—these hybrid apps are not as fast, reliable or smooth as native apps.
Web Apps | There are three types of web apps: traditional, responsive and adaptive. Traditional web apps include any website. A responsive web app takes on a different design when it’s opened on a mobile device, altering its design to suit the device it is viewed on. | A better user experience; Worldwide Access; Client secure login; Easy install; Always up-to-date; Storage Increase | Internet Reliance; Security; Reduced speed; Browser Support.

#Team practices:

##Building your team:
1. Understand what type of values and culture you would like to implement in your team.<BR>
2. Bring people who are complementary. Don't look only for skills, look in their eyes and look for the brightness.<BR>
3. Implement weekly activities or hackathons to join teammates. 

##Routine:
1. Understand what are the goals of the projects.<BR>
2. Always plan by doing weekly and monthly meeting to discuss the roadmap of the projects. These meetings are important to set the main goals and delegate the tasks for each member of the team.<BR>
3. Manage the workplan and monitor the schedule (and budget if you are the head of IT)<BR>
Use tools like Google Drive (spreadsheets), Slack and Trello to monitor the projects.
4. Get things done and ship them.
