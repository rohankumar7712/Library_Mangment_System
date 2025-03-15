<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Read Booking History</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
</head>
<body class="container-fluid mt-4">

    <nav class="navbar navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand">Read Book History</a>
            <a href="user_dashboard.html" class="btn btn-danger">Back</a>
        </div>
    </nav>

    <h2 class="text-center mb-4">Your Reading History</h2>

    <div class="table-responsive">
        <table class="table table-bordered">
            <thead class="bg-dark text-white">
                <tr>
                    <th>Book Title</th>
                    <th>Author</th>
                    <th>Read Date</th>
                    <th>Last Read Time</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

                    // ✅ Corrected SQL Query with JOIN
                    String query = "SELECT b.title, b.author, rh.read_date, rh.last_read_time " +
                                   "FROM reading_history rh " +
                                   "JOIN books b ON rh.book_id = b.id " +
                                   "WHERE rh.user_id = ? " +
                                   "ORDER BY rh.read_date DESC";

                    PreparedStatement pst = con.prepareStatement(query);
                    pst.setInt(1, (Integer) session.getAttribute("userId"));
                    ResultSet rs = pst.executeQuery();

                    boolean hasHistory = false;
                    while (rs.next()) { 
                        hasHistory = true;
                %>
                <tr>
                    <td><%= rs.getString("title") %></td> <!-- ✅ Book Title Fixed -->
                    <td><%= rs.getString("author") %></td> <!-- ✅ Author Fixed -->
                    <td><%= rs.getString("read_date") %></td>
                    <td><%= rs.getString("last_read_time") %></td>
                </tr>
                <% } %>

                <% if (!hasHistory) { %>
                    <tr>
                        <td colspan="4" class="text-center text-warning">No reading history found.</td>
                    </tr>
                <% } %>

                <%
                    rs.close();
                    pst.close();
                    con.close();
                %>
            </tbody>
        </table>
    </div>

</body>
</html>
