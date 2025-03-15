<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

        String bookQuery = "SELECT * FROM books";
        pst = con.prepareStatement(bookQuery);
        rs = pst.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Read Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
       .book-card {
    height: 450px; /* Adjust card height */
    padding: 15px;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: space-between; /* Ensures spacing */
}

.book-body {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.book-image {
    width: 100%;
    height: 250px; /* Ensures image is properly sized */
    object-fit: contain; /* Prevents cropping */
    border-radius: 5px;
}

.read-btn {
    margin-top: auto; /* Push button to bottom */
    width: 100%; /* Makes it same width as the card */
    padding: 10px;
}
    
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" >Library</a>
        <a href="user_dashboard.html" class="btn btn-danger">back</a>
    </div>
</nav>

<!-- Book List -->
<div class="container">
    <h2 class="text-center my-3">Available Books</h2>
    <div class="row">
        <% while (rs.next()) { %>
        <div class="col-md-3 mb-3">
            <div class="card book-card">
                <img src="<%= request.getContextPath() %>/<%= rs.getString("image") %>" class="book-image" alt="Book Image">
                <div class="card-body">
                    <h6 class="card-title"><%= rs.getString("title") %></h6>
                    <p class="card-text">Author: <%= rs.getString("author") %></p>
                    <p class="card-text">category: <%= rs.getString("category") %></p>
                  <a href="ReadBookServlet?bookId=<%= rs.getInt("id") %>" class="btn btn-primary">Read Now</a>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>

<%
    if (rs != null) rs.close();
    if (pst != null) pst.close();
    if (con != null) con.close();
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    }
%>

