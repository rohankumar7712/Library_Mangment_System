<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Booking Details</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        /* Custom Styling */
        .custom-navbar {
            background-color: #212529 !important; /* Dark navbar */
            padding: 15px;
            width: 100%;
        }

        .custom-navbar .navbar-brand {
            color: white !important; 
            font-size: 22px;
        }

        .custom-navbar .form-control {
            color: white !important; 
            background-color: #343a40;
            border: 1px solid #ffffff;
        }

        .custom-navbar .form-control::placeholder {
            color: #bbb !important;
        }

        .table-container {
            width: 95%;
            margin: auto;
        }

        .search-box {
            width: 280px;
        }

        .date-filter {
            width: 180px;
        }
    </style>
    <script>
        function searchTable() {
            let input = document.getElementById("searchInput").value.toLowerCase();
            let table = document.getElementById("bookingTable");
            let rows = table.getElementsByTagName("tr");

            for (let i = 1; i < rows.length; i++) {
                let rowText = rows[i].innerText.toLowerCase();
                rows[i].style.display = rowText.includes(input) ? "" : "none";
            }
        }
        function filterByDate() {
            let selectedDate = document.getElementById("dateFilter").value;
            let table = document.getElementById("bookingTable");
            let rows = table.getElementsByTagName("tr");

            for (let i = 1; i < rows.length; i++) {
                let dateCell = rows[i].getElementsByTagName("td")[4]; // Date column
                if (dateCell) {
                    let rowDate = dateCell.innerText.trim();
                    if (selectedDate === "" || rowDate === selectedDate) {
                        rows[i].style.display = "";
                    } else {
                        rows[i].style.display = "none";
                    }
                }
            }
        }
    </script>

    </script>
</head>
<body class="container-fluid bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark custom-navbar mb-4">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold">Booking System</a>
            <div class="d-flex">
                <input class="form-control search-box me-3" type="search" id="searchInput" onkeyup="searchTable()" placeholder="Search bookings...">
                <label for="dateFilter" class="align-self-center text-white me-2">Filter by Date:</label>
                <input type="date" id="dateFilter" class="form-control date-filter bg-dark text-white border-light" onchange="filterByDate()">

            </div>
        </div>
    </nav>

    <!-- Table Title -->
    <h2 class="text-center text-primary my-4">Booking Details</h2>

    <!-- Booking Table -->
    <div class="table-responsive table-container">
        <table id="bookingTable" class="table table-bordered table-hover table-striped">
            <thead class="bg-dark text-white">
                <tr>
                    <th>Booking ID</th>
                    <th>Customer Name</th>
                    <th>Email</th>
                    <th>Date</th>
                    <th>Reporting Time</th>
                    <th>End Time</th>
                    <th>Members</th>
                    <th>Emails</th>
                    <th>Seat Numbers</th>
                </tr>
            </thead>
            <tbody class="bg-white">
                <%
                    String loggedInUserEmail = (String) session.getAttribute("email");
                    if (loggedInUserEmail == null || loggedInUserEmail.isEmpty()) {
                        out.println("<tr><td colspan='9' class='text-danger text-center'>You are not logged in. Please <a href='login.jsp'>login</a> first.</td></tr>");
                    } else {
                        Connection con = null;
                        PreparedStatement pst = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

                            String query = "SELECT b.id AS booking_id, b.customer_name, b.email, b.booking_date, " +
                                           "b.reporting_time, b.end_time, " +
                                           "COALESCE(GROUP_CONCAT(DISTINCT m.member_name ORDER BY m.member_name SEPARATOR ', '), 'N/A') AS member_names, " +
                                           "COALESCE(GROUP_CONCAT(DISTINCT m.member_email ORDER BY m.member_email SEPARATOR ', '), 'N/A') AS member_emails, " +
                                           "COALESCE(GROUP_CONCAT(DISTINCT s.seat_no ORDER BY s.seat_no SEPARATOR ', '), 'N/A') AS seat_numbers " +
                                           "FROM bookings b " +
                                           "LEFT JOIN members m ON b.id = m.booking_id " +
                                           "LEFT JOIN seatbookings s ON b.id = s.booking_id " +
                                           "WHERE b.email = ? " +
                                           "GROUP BY b.id, b.customer_name, b.email, b.booking_date, b.reporting_time, b.end_time " +
                                           "ORDER BY b.id";

                            pst = con.prepareStatement(query);
                            pst.setString(1, loggedInUserEmail);
                            rs = pst.executeQuery();

                            boolean hasBookings = false;
                            while (rs.next()) {
                                hasBookings = true;
                %>
                <tr>
                    <td><%= rs.getInt("booking_id") %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("booking_date") %></td>
                    <td><%= rs.getString("reporting_time") %></td>
                    <td><%= rs.getString("end_time") %></td>
                    <td><%= rs.getString("member_names") %></td>
                    <td><%= rs.getString("member_emails") %></td>
                    <td><%= rs.getString("seat_numbers") %></td>
                </tr>
                <%
                            }
                            if (!hasBookings) {
                                out.println("<tr><td colspan='9' class='text-warning text-center'>No bookings found.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='9' class='text-danger text-center'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) rs.close();
                            if (pst != null) pst.close();
                            if (con != null) con.close();
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
