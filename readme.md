# Auction System - README

This project is a Java-based Auction System built using JSP, Servlets, MySQL, and Tomcat.
The application supports multiple user roles including admin, seller, buyer, customer, and customer representative.

## Login Credentials (Sample Users)

Below are sample accounts preloaded for testing:

Email: seller1@example.com     Password: pass123   Role: seller
Email: seller2@example.com     Password: pass123   Role: seller
Email: buyer1@example.com      Password: pass123   Role: buyer
Email: buyer2@example.com      Password: pass123   Role: buyer
Email: customer1@example.com   Password: pass123   Role: customer
Email: admin@example.com       Password: pass123   Role: admin
Email: rep1@example.com        Password: pass123   Role: rep
Email: rep2@example.com        Password: pass123   Role: rep

## Project Structure

The project follows a standard Java EE layout using JSP and Servlets.

### 1. src/main/java/com/example/auth
Contains all servlet controllers and Data Access Objects:

- AuctionDAO.java  
  Handles auction creation, listing, closing expired auctions, and DB operations.

- ItemDAO.java  
  Inserts and retrieves item entries associated with auctions.

- BidDAO.java  
  Manages manual bids, auto-bid logic, and retrieves bid history.

- UserDAO.java  
  Handles user authentication, account lookup, and role enforcement.

- AlertDAO.java  
  Sends alerts for auction activity including new auctions, winning notifications, reserve warnings, and bid notices.

- RoleFilter.java / AuthFilter.java  
  Protects routes and ensures only authorized roles access specific pages.

### 2. src/main/webapp
Contains all JSP view files:

- login.jsp  
- register.jsp  
- BiddingPage.jsp  
- myAuctions.jsp  
- askQuestion.jsp  
- bidHistory.jsp  
- adminDashboard.jsp  
- result.jsp

### 3. Database Schema (MySQL)

The database name is `auction_app`.

Key tables include:

- User  
- Item  
- Auction  
- Bid  
- customer_question  
- alert

Example SQL for inserting test users:

USE auction_app;

INSERT INTO User (user_id, Email, Password, Role, Is_active, Created_at) VALUES
(1, 'seller1@example.com',   'pass123', 'seller',   1, NOW()),
(2, 'seller2@example.com',   'pass123', 'seller',   1, NOW()),
(3, 'buyer1@example.com',    'pass123', 'buyer',    1, NOW()),
(4, 'buyer2@example.com',    'pass123', 'buyer',    1, NOW()),
(5, 'customer1@example.com', 'pass123', 'customer', 1, NOW()),
(6, 'admin@example.com',     'pass123', 'admin',    1, NOW()),
(7, 'rep1@example.com',      'pass123', 'rep',      1, NOW()),
(8, 'rep2@example.com',      'pass123', 'rep',      1, NOW());

## How to Run

1. Open the project in IntelliJ or Eclipse as a Java Web project.
2. Configure Tomcat 9.0+ as the target server.
3. Update DBUtil.java with your MySQL username, password, and URL.
4. Create the `auction_app` database and execute your schema.sql file.
5. Deploy the WAR file or run via IDE.

## Notes

- Expired auctions auto-close when the browse page loads.
- Auto-bid logic triggers when competing bids are placed.
- Customer representatives can view and answer user-submitted questions.
- Admin users can edit or delete any account in the system.
