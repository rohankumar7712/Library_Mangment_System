<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
    // ✅ Check if user is logged in
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null || userEmail.isEmpty()) {
        response.sendRedirect("Login.html"); // Redirect to login page if session is missing
        return;
    }

    // ✅ Get bookId from request
    String bookIdParam = request.getParameter("bookId");
    if (bookIdParam == null || bookIdParam.isEmpty()) {
        response.sendRedirect("book_list.jsp");
        return;
    }

    int bookId = Integer.parseInt(bookIdParam);
    
    // ✅ Database Connection
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    String title = "Unknown Book";
    String author = "Unknown Author";
    String pdfPath = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&allowPublicKeyRetrieval=true", "root", "password");

        String query = "SELECT title, author, pdf_path FROM books WHERE id = ?";
        pst = con.prepareStatement(query);
        pst.setInt(1, bookId);
        rs = pst.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            author = rs.getString("author");
            pdfPath = rs.getString("pdf_path");
        } else {
            response.sendRedirect("book_list.jsp"); // Redirect if book is not found
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %> - Read Now</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* ✅ Full-width Navbar */
        .navbar {
            width: 100%;
        }

        /* ✅ PDF Viewer */
        .pdf-container {
            width: 90%; /* Increased width */
            height: 90vh; /* More height */
            border: 1px solid #ddd;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            display: block;
            margin: 0 auto; /* Centering */
        }
    </style>
</head>
<body>

    <!-- ✅ Full-width Navbar -->
    <nav class="navbar navbar-dark bg-dark mb-4">
        <div class="container-fluid d-flex justify-content-between">
            <a class="navbar-brand ms-3">Library</a>
            <a href="read_books.jsp" class="btn btn-danger me-3">Back to Books</a>
        </div>
    </nav>

    <!-- Book Info -->
    <div class="text-center mb-3">
        <h2><%= title %></h2>
        <p><strong>Author:</strong> <%= author %></p>
    </div>

    <!-- ✅ Centered Wider PDF Viewer -->
    <!-- PDF Viewer -->
    <div class="text-center">
        <% if (!pdfPath.isEmpty()) { %>
            <iframe src="<%= request.getContextPath() %>/<%= pdfPath %>" class="pdf-container"></iframe>
            <br>
            <a href="<%= request.getContextPath() %>/<%= pdfPath %>" class="btn btn-primary mt-3" download>Download PDF</a>
        <% } else { %>
            <p class="text-danger">No PDF available for this book.</p>
        <% } %>
    </div>

</body>
</html>
