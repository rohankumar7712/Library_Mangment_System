<%@ page import="java.sql.*" %>
<%
    String bookId = request.getParameter("id");
    String title = "";
    String author = "";
    String category = "";
    double price = 0.0;
    String image = "";
    String pdfPath = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

        String query = "SELECT * FROM books WHERE id=?";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setInt(1, Integer.parseInt(bookId));
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            author = rs.getString("author");
            category = rs.getString("category");
            price = rs.getDouble("price");
            image = rs.getString("image");
            pdfPath = rs.getString("pdf_path");
        }
        con.close();
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            max-width: 450px;
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 30px auto;
        }
        .form-control {
            height: 32px; /* Reduce input field height */
            font-size: 14px;
        }
        .btn-warning {
            height: 40px; /* Reduce button height */
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="manage_books.jsp">Back to Manage Books</a>
    </div>
</nav>

<!-- Edit Book Form -->
<div class="form-container">
    <h4 class="text-center">Edit Book</h4>
    <form action="EditBookServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= bookId %>">
        
        <div class="mb-2">
            <label class="form-label">Title</label>
            <input type="text" class="form-control form-control-sm" name="title" value="<%= title %>" required>
        </div>
        <div class="mb-2">
            <label class="form-label">Author</label>
            <input type="text" class="form-control form-control-sm" name="author" value="<%= author %>" required>
        </div>
        <div class="mb-2">
            <label class="form-label">Category</label>
            <input type="text" class="form-control form-control-sm" name="category" value="<%= category %>" required>
        </div>
        <div class="mb-2">
            <label class="form-label">Price (₹)</label>
            <input type="number" class="form-control form-control-sm" name="price" value="<%= price %>" required>
        </div>
        <div class="mb-2">
            <label class="form-label">Book Image</label>
            <input type="file" class="form-control form-control-sm" name="bookImage">
            <% if (!image.isEmpty()) { %>
                <p class="small">Current Image: <img src="uploads/<%= image %>" width="100" alt="Book Image"></p>
            <% } %>
        </div>
        
        <div class="mb-2">
            <label class="form-label">Book PDF</label>
            <input type="file" class="form-control form-control-sm" name="bookPdf">
            <% if (!pdfPath.isEmpty()) { %>
                <p class="small">Current PDF: <a href="uploads/<%= pdfPath %>" target="_blank">View PDF</a></p>
            <% } %>
        </div>

        <button type="submit" class="btn btn-warning w-100">Update Book</button>
    </form>
</div>

</body>
</html>
