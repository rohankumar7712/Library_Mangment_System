<%@ page import="java.sql.*" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.html");
        return;
    }

    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");
    PreparedStatement pst = con.prepareStatement("SELECT c.id, b.title, b.price FROM cart c JOIN books b ON c.book_id = b.id WHERE c.user_id = ?");
    pst.setInt(1, userId);
    ResultSet rs = pst.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Your Cart</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">

    <h2 class="text-center">Your Cart</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Book Title</th>
                <th>Price</th>
                <th>Remove</th>
            </tr>
        </thead>
        <tbody>
            <% while (rs.next()) { %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getDouble("price") %> Rs.</td>
                <td><a href="RemoveFromCartServlet?cartId=<%= rs.getInt("id") %>" class="btn btn-danger">Remove</a></td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <a href="checkout.jsp" class="btn btn-primary w-100">Continue to Checkout</a>

</body>
</html>
