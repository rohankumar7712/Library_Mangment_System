Library Management System Documentation

Introduction

The Library Management System (LMS) is a web-based application designed to facilitate seamless library operations, including book management, seat booking, user registration, and transaction tracking. The system serves both users (students/readers) and admin (librarians) by providing an efficient and user-friendly interface.

Key Features

User Features:

User Registration & Login

Secure authentication using username and password.

Profile management for user details and activity history.

Book Management

Search, read, and download e-books.

Borrow books with a tracking system.

Payment-based book download option.

Seat Booking System

Book seats for reading purposes.

Set usage time with automatic unbooking after 24 hours.

Modify or delete a booking within 1 minute after selection.

User Dashboard

View booking history and reading activity.

Download history management.

Profile updates.

Admin Features:

Admin Login & Dashboard

Manage all user activities.

Track total users and active bookings.

Book Management

Add, edit, and delete books.

Set prices for downloadable books.

Seat Management

Monitor seat availability and usage.

Approve or reject seat booking requests.

Transaction Management

Track payments for book downloads.

Generate reports for transactions and user activity.

Technology Stack

Frontend: HTML, CSS, JavaScript

Backend: Java Servlets, JSP

Database: MySQL

Authentication: Session-based login

Database Schema

User Table

Column Name

Data Type

Description

id

INT (PK)

Unique User ID

name

VARCHAR

Full Name

email

VARCHAR

User Email

password

VARCHAR

Encrypted Password

role

ENUM

'user' or 'admin'

Books Table

Column Name

Data Type

Description

book_id

INT (PK)

Unique Book ID

title

VARCHAR

Book Title

author

VARCHAR

Author Name

price

DECIMAL

Book Price

available

BOOLEAN

Availability Status

Seat Booking Table

Column Name

Data Type

Description

booking_id

INT (PK)

Unique Booking ID

user_id

INT (FK)

User who booked

seat_number

VARCHAR

Seat Identifier

start_time

TIMESTAMP

Booking Start

end_time

TIMESTAMP

Booking End

Transaction Table

Column Name

Data Type

Description

transaction_id

INT (PK)

Unique Transaction ID

user_id

INT (FK)

Buyer ID

book_id

INT (FK)

Purchased Book

amount

DECIMAL

Payment Amount

date

TIMESTAMP

Payment Date

Workflow

User Registration & Login → Users register and log in to the system.

Book Browsing & Management → Users browse and read books, with an option to download paid books.

Seat Booking → Users select and reserve seats for a fixed time.

Admin Monitoring → Admins track user activity, manage books, and oversee transactions.

Conclusion

This Library Management System simplifies the library experience by integrating book access, seat booking, and transaction tracking in a single web-based platform. It ensures efficient management for both users and administrators while enhancing the overall library experience.

