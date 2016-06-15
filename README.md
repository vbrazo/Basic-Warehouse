#Intro

You can access my video on Youtube by clicking in this [link](https://youtu.be/qXR-CLfWwXY). The video contains all the explanations that I wrote below and I try to explain a few things better. You highly recommend you to watch my video. I tried to keep it as short as possible.

If you want to check my LinkedIn profile out, check this [link](https://www.linkedin.com/in/vbrazo) out

#Installation

Grab the latest code version from [GitHub](https://github.com/vbrazo/Discount-Ascii-Warehouse.git):

> git clone https://github.com/vbrazo/Discount-Ascii-Warehouse.git

Or download using [this link](https://github.com/vbrazo/Discount-Ascii-Warehouse/tree/master/Archives/discount_ascii_warehouse.zip)

##Dependencies
To be able to compile this project you need the following installed on your system.

###XCode
To be able to compile the code you need to have XCode 7.2 and iOS (>=) 8.0 installed.

###CocoaPods

This project uses [CocoaPods](https://cocoapods.org) as dependency manager to install and maintain third party libraries.
To [install CocoaPods](https://cocoapods.org/#install) run the following in the OS terminal:

> sudo gem install cocoapods

#Notes

##Core Data
[Core Data](https://developer.apple.com/library/tvos/documentation/Cocoa/Conceptual/CoreData/index.html) is used to manage the model layer objects on the application. With this structure we are able to maintain the view controllers synchronized as quickly as the model is updated.

Core Data can decrease by 50 to 70 percent the amount of code you write to support the model layer. This is primarily due to the following built-in features that you do not have to implement, test, or optimize.

Managed object context used: `main`, `private` and `master`.

In this setup, all background queues are given a brand new private queue context. These contexts are created with the concurrency type .PrivateQueueConcurrencyType. They are temporary and will get destroyed once the background queue is done performing a task. The overhead for creating a new instance of a private queue context is very low. Therefore, we can create as many of them as we need.

The main queue context is a special context that should only be accessed from the main (UI) queue. It is created with the concurrency type .MainQueueConcurrencyType. It acts as a parent for all temporary private queue contexts.

Finally, the master context which also has the concurrency type NSPrivateQueueConcurrencyType acts as a parent for the main queue context itself. The master context is the only one that has access to the persistent store coordinator which is responsible for saving or reading data from an underlying SQLite database.

##Collection View Controller

I chose collection view controller to display the data because of the distinct cell widths and the flexibility it brings to cell arrangement.

##SwiftyJSON
[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) makes it easy to deal with JSON data in Swift. Parsing and deserializing JSON is a little more tedious due to Swift optionals and type-safety. SwiftyJSON helps our project with that and keeps the code clean.

##SwiftHTTP
[SwiftHTTP](https://github.com/daltoniam/SwiftHTTP) is a thin wrapper around NSURLSession in Swift to simplify HTTP requests. It offers a few cool features such as:

- Convenient Closure APIs
- NSOperationQueue Support
- Parameter Encoding
- Custom Response Serializer
- Builtin JSON Response Serialization
- Upload/Download with Progress Closure
- Concise Codebase

##CCBottomRefreshControl
[BottomRefreshControl](https://github.com/vlasov/CCBottomRefreshControl) helped me to add bottomRefreshControl property, that could be assigned to UIRefreshControl class instance. It basically implements an ability to add native iOS bottom pull-up to refresh control to UITableView or UICollectionView.

##XCTest
[XCTest](http://nshipster.com/xctestcase/) is the testing framework. As you may know, tests are codes you write that exercise your app and library code and results in a pass or fail result, measured against a set of expectations. In this project we have a few tests. The name of the functions are:

- testAddWarehouse
- testResetWarehouse
- testResetTag

###UI 

- testInitialStateIsCorrect
- testUserFilterAndSearch
- testBottomPullToRefresh


#What kinds of things do you look for in the code, technology choices, team practices etc. that can help to make a project successful? 

###Things that I look for in codes:
1. Formatting
2. Style
3. Naming
4. Test coverage: Is there a test for this code?
5. Design: How does the code fit with the overall architecture? What design patterns are used in the new code? Does the new code introduce duplication? If so, should we refactor to a more reusable pattern?
6. Readability & Maintainability: Is it possible to understand what the code does by reading it? Are there test cases that haven’t been considered?
7. Functionality: Any potential security problems?

#Technology choices:
In this section, we are going to discuss about mobile app development technology. First you have to decide what kind of app works best for our project: native, hybrid or web.

Type | Description | Advantage | Disadvantage
:-- | :-- | :-- | :-- 
Native apps | Native mobile is one that is developed to be ‘native’ to a specific platform: In my project I am working with Apple’s iOS, but there are other plataforms like Google’s Android and Windows Phone. | It optimizes the user experience; the app will operate more quickly because it’s been designed specifically for that platform. | If you wish to build and launch your app on more than one platform you almost need to start each one from scratch.
Hybrid apps | In 2012, HTML5 appeared to be the future of mobile; leading companies like Facebook, LinkedIn and Xero had jumped in and it was getting a lot of attention but last year many of the companies ditch their apps and start again with native apps. | If your app will primarily deliver content, and if it’s important to the business outcome for the app to be cross-platform, you should still consider it. | The reasons for this are simple—these hybrid apps are not as fast, reliable or smooth as native apps.
Web Apps | There are three types of web apps: traditional, responsive and adaptive. Traditional web apps include any website. A responsive web app takes on a different design when it’s opened on a mobile device, altering its design to suit the device it is viewed on. | A better user experience; Worldwide Access; Client secure login; Easy install; Always up-to-date; Storage Increase | Internet Reliance; Security; Reduced speed; Browser Support.

If this was the beginning of a long-term project, we would need to consider a lot of things but the most important ones are:<BR>
- what features we would implement to decide which type of app would work best for us
- how much money we have in the bank to invest.

#Team practices:

##Building your team:
1. Understand what type of values and culture you would like to implement in your team.<BR>
2. Bring people who are complementary. Don't look only for skills, look in their eyes and look for the brightness.<BR>

##Virtual Teams
1. Understand what the goals of the projects are.<BR>
2. Build and use a communications management plan and team operating agreements.<BR>
3. Select appropriate technologies for team interactions. Use tools like Google Drive (spreadsheets), Slack and Trello to monitor the projects.<BR>
4. Find places where the team looks forward to and can meet for unplanned interactions.<BR>
5. Run effective virtual team meetings.<BR>
6. Implement weekly activities and hackathons.<BR>
7. Get things done and ship them.
