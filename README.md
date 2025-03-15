# Library Management System (LMS)

## **Introduction**
The Library Management System (LMS) is a web-based application designed to facilitate seamless library operations, including book management, seat booking, user registration, and transaction tracking. The system serves both **users (students/readers)** and **admin (librarians)** by providing an efficient and user-friendly interface.

## **Key Features**
### **User Features:**
1. **User Registration & Login**
   - Secure authentication using username and password.
   - Profile management for user details and activity history.

2. **Book Management**
   - Search, read, and download e-books.
   - Borrow books with a tracking system.
   - Payment-based book download option.

3. **Seat Booking System**
   - Book seats for reading purposes.
   - Set usage time with automatic unbooking after 24 hours.
   - Modify or delete a booking within 1 minute after selection.

4. **User Dashboard**
   - View booking history and reading activity.
   - Download history management.
   - Profile updates.

### **Admin Features:**
1. **Admin Login & Dashboard**
   - Manage all user activities.
   - Track total users and active bookings.

2. **Book Management**
   - Add, edit, and delete books.
   - Set prices for downloadable books.

3. **Seat Management**
   - Monitor seat availability and usage.
   - Approve or reject seat booking requests.

4. **Transaction Management**
   - Track payments for book downloads.
   - Generate reports for transactions and user activity.

## **Technology Stack**
- **Frontend:** HTML, CSS, JavaScript
- **Backend:** Java Servlets, JSP
- **Database:** MySQL
- **Authentication:** Session-based login

## **Database Schema**
### **User Table**
```markdown
| Column Name | Data Type | Description        |
| ----------- | --------- | ------------------ |
| id          | INT (PK)  | Unique User ID     |
| name        | VARCHAR   | Full Name          |
| email       | VARCHAR   | User Email         |
| password    | VARCHAR   | Encrypted Password |
| role        | ENUM      | 'user' or 'admin'  |
```

### **Books Table**
```markdown
| Column Name | Data Type | Description         |
| ----------- | --------- | ------------------- |
| book_id     | INT (PK)  | Unique Book ID      |
| title       | VARCHAR   | Book Title          |
| author      | VARCHAR   | Author Name         |
| price       | DECIMAL   | Book Price          |
| available   | BOOLEAN   | Availability Status |
```

### **Seat Booking Table**
```markdown
| Column Name  | Data Type | Description       |
| ------------ | --------- | ----------------- |
| booking_id   | INT (PK)  | Unique Booking ID |
| user_id      | INT (FK)  | User who booked   |
| seat_number  | VARCHAR   | Seat Identifier   |
| start_time   | TIMESTAMP | Booking Start     |
| end_time     | TIMESTAMP | Booking End       |
```

### **Transaction Table**
```markdown
| Column Name     | Data Type | Description           |
| --------------- | --------- | --------------------- |
| transaction_id  | INT (PK)  | Unique Transaction ID |
| user_id        | INT (FK)  | Buyer ID              |
| book_id        | INT (FK)  | Purchased Book        |
| amount         | DECIMAL   | Payment Amount        |
| date           | TIMESTAMP | Payment Date          |
```

## **Workflow**
1. **User Registration & Login** → Users register and log in to the system.
2. **Book Browsing & Management** → Users browse and read books, with an option to download paid books.
3. **Seat Booking** → Users select and reserve seats for a fixed time.
4. **Admin Monitoring** → Admins track user activity, manage books, and oversee transactions.

## **Installation Instructions**
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo/library-management-system.git
   ```
2. Import the project into an IDE (Eclipse/IntelliJ)
3. Configure the MySQL database:
   - Create a database `library_db`
   - Import `library_db.sql` (provided in the repo)
4. Update database credentials in `dbconfig.properties`
5. Deploy the project using Apache Tomcat
6. Access the system at `http://localhost:8080/LMS`

## **Contributing**
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -m 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Open a Pull Request

## **License**
This project is licensed under the MIT License. Feel free to modify and distribute it.

## **Contact**
For any inquiries, please contact [your-email@example.com].

## **Conclusion**
This **Library Management System** simplifies the library experience by integrating book access, seat booking, and transaction tracking in a single web-based platform. It ensures **efficient management** for both **users and administrators** while enhancing the overall library experience.

