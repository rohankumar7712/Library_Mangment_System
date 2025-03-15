<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    String userId = request.getParameter("id");
    String name = "";
    String email = "";
    String phone = "";
    String role = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

        String query = "SELECT * FROM users WHERE id=?";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setInt(1, Integer.parseInt(userId));

        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            role = rs.getString("role"); // Fetch role from database
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
    <title>Edit User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .edit-container {
            max-width: 500px; /* Reduced width */
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 50px auto;
        }
        .btn-success {
            background-color: #198754;
            border: none;
        }
        .btn-success:hover {
            background-color: #146c43;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" >Admin Dashboard</a>
       
    </div>
</nav>

<!-- Edit User Form -->
<div class="edit-container">
    <h3 class="text-center">Edit User</h3>
    <form action="EditUserServlet" method="post">
        <input type="hidden" name="id" value="<%= userId %>">
        
        <div class="mb-2">
            <label class="form-label">Full Name</label>
            <input type="text" class="form-control" name="name" value="<%= name %>" required>
        </div>
        <div class="mb-2">
            <label class="form-label">Email Address</label>
            <input type="email" class="form-control" name="email" value="<%= email %>" required readonly>
        </div>
        <div class="mb-2">
            <label class="form-label">Phone Number</label>
            <input type="text" class="form-control" name="phone" value="<%= phone %>" required>
        </div>
        <div class="mb-2">
            <label class="form-label">Role</label>
            <select class="form-control" name="role" required>
                <option value="user" <%= "user".equals(role) ? "selected" : "" %>>User</option>
                <option value="admin" <%= "admin".equals(role) ? "selected" : "" %>>Admin</option>
            </select>
        </div>
        <button type="submit" class="btn btn-success w-100">Update User</button>
    </form>
</div>

</body>
</html>
