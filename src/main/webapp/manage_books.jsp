<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    // Fetch all books from database
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

        String query = "SELECT * FROM books";
        pst = con.prepareStatement(query);
        rs = pst.executeQuery();
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="admin_dashboard.html">Admin Dashboard</a>
        <a href="admin_dashboard.html" class="btn btn-danger">Back</a>
    </div>
</nav>

<!-- Manage Books Section -->
<div class="container mt-4">
    <h2 class="text-center">Manage Books</h2>

    <!-- Add Book Button -->
    <div class="mb-3 text-end">
        <a href="add_book.html" class="btn btn-success">Add New Book</a>
    </div>

    <!-- Books Table -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Author</th>
                <th>Category</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% while (rs.next()) { %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("author") %></td>
                <td><%= rs.getString("category") %></td>
                <td><%= rs.getDouble("price") %> Rs.</td>
                <td>
                    <a href="edit_book.jsp?id=<%= rs.getInt("id") %>" class="btn btn-warning btn-sm"> Edit</a>
                    <a href="DeleteBookServlet?id=<%= rs.getInt("id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>

<%
    // Close database resources
    if (rs != null) rs.close();
    if (pst != null) pst.close();
    if (con != null) con.close();
%>
