<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List, java.util.ArrayList" %>  
<%
    // Get booking ID from request
    String bookingId = request.getParameter("bookingId");

    if (bookingId == null || bookingId.isEmpty()) {
        out.println("<h3 class='text-danger text-center'>Error: Booking ID is missing.</h3>");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    String customerName = "", email = "", booking_date ="" ,reportingTime = "", endTime = "";
    LocalDate currentDate = LocalDate.now();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&allowPublicKeyRetrieval=true", "root", "password");

        // Fetch customer details from `bookings`
        String query = "SELECT customer_name, email,booking_date, reporting_time, end_time FROM bookings WHERE id = ?";
        pst = con.prepareStatement(query);
        pst.setInt(1, Integer.parseInt(bookingId));
        rs = pst.executeQuery();

        if (rs.next()) {
            customerName = rs.getString("customer_name");
            email = rs.getString("email");
            booking_date=rs.getString("booking_date");
            reportingTime = rs.getString("reporting_time");
            endTime = rs.getString("end_time");
        }
        rs.close();
        pst.close();

        // Fetch members linked to this booking
        String memberQuery = "SELECT member_name FROM members WHERE booking_id = ?";
        pst = con.prepareStatement(memberQuery);
        pst.setInt(1, Integer.parseInt(bookingId));
        rs = pst.executeQuery();

        List<String> members = new ArrayList<>();
        while (rs.next()) {
            members.add(rs.getString("member_name"));
        }
        rs.close();
        pst.close();

        // Fetch booked seats
        String seatQuery = "SELECT seat_no FROM seatbookings WHERE booking_id = ?";
        pst = con.prepareStatement(seatQuery);
        pst.setInt(1, Integer.parseInt(bookingId));
        rs = pst.executeQuery();

        List<Integer> seats = new ArrayList<>();
        while (rs.next()) {
            seats.add(rs.getInt("seat_no"));
        }
        rs.close();
        pst.close();
        con.close();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; }
        .container { max-width: 700px; margin: auto; padding: 30px; }
        table { width: 100%; margin-top: 20px; }
        th, td { text-align: left; padding: 10px; }
        th { background-color: #007bff; color: white; }
        .print-button { margin-top: 20px; }
    </style>
</head>
<body>
<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">Library Dashboard</a>
        <a href="user_dashboard.html" class="btn btn-danger">Go Back To Dashboard</a>
    </div>
</nav>
<div class="container shadow-lg p-4 rounded bg-light">
    <h2 class="text-center text-primary">Booking Confirmation</h2>
    
    <div class="border rounded p-3 my-3 bg-white">
        <p><strong>Date:</strong> <%= currentDate %></p>
        <p><strong>Booking Date:</strong> <%= booking_date %></p>
        <p><strong>Reporting Time:</strong> <%= reportingTime %></p>
        <p><strong>End Time:</strong> <%= endTime %></p>
    </div>

    <table class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Sr.</th>
                <th>Member Name</th>
                <th>Seat No</th>
            </tr>
        </thead>
        <tbody>
            <%
                int count = 1;
                int seatIndex = 0;

                // First row: Customer's details
                if (!seats.isEmpty()) {
            %>
                <tr>
                    <td><%= count++ %></td>
                    <td><%= customerName %></td>
                    <td><%= seats.get(seatIndex++) %></td>
                </tr>
            <%
                }

                // Remaining rows: Members' details
                for (String member : members) {
                    if (seatIndex < seats.size()) {
            %>
                <tr>
                    <td><%= count++ %></td>
                    <td><%= member %></td>
                    <td><%= seats.get(seatIndex++) %></td>
                </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>

    <div class="text-center">
        <button class="btn btn-primary print-button" onclick="window.print()">Print Confirmation</button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3 class='text-danger text-center'>Error retrieving booking details.</h3>");
    }
%>
