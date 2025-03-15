<%@ page import="java.sql.*" %>

<%
    // ✅ Check if bookId is present in the request
    String bookIdParam = request.getParameter("bookId");
    if (bookIdParam == null || bookIdParam.isEmpty()) {
        out.println("<h3 class='text-danger text-center'>Invalid Request: No Book Selected</h3>");
        return;
    }

    // ✅ Convert bookId to integer safely
    int bookId = Integer.parseInt(bookIdParam);

    // ✅ Database Connection
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");
    PreparedStatement pst = con.prepareStatement("SELECT * FROM books WHERE id = ?");
    pst.setInt(1, bookId);
    ResultSet rs = pst.executeQuery();

    String title = "", author = "";
    double price = 0.0;
    if (rs.next()) {
        title = rs.getString("title");
        author = rs.getString("author");
        price = rs.getDouble("price");
    } else {
        out.println("<h3 class='text-danger text-center'>Error: Book Not Found</h3>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Purchase Book</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
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
<body class="container mt-5">
    <h2 class="text-center">Purchase Book</h2>
    <div class="card p-4 mx-auto" >
    	<img src="<%= request.getContextPath() %>/<%= rs.getString("image") %>" class="book-image" alt="Book Image">
        <div class="card-body">
                    <h6 class="card-title"><%= rs.getString("title") %></h6>
                    <p class="card-text">Author: <%= rs.getString("author") %></p>
                    <p class="card-text">category: <%= rs.getString("category") %></p>
                    <p class="card-text">price: <%= rs.getString("price") %></p>
              
                </div>
        
        
        <form action="AddToCartServlet" method="post">
            <input type="hidden" name="bookId" value="<%= bookId %>">
            <button type="submit" class="btn btn-success w-100">Add to Cart</button>
        </form>
    </div>
</body>
</html>
