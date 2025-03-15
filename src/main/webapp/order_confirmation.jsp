<%@ page import="java.sql.*, java.text.DecimalFormat, java.text.SimpleDateFormat, java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <h2 class="text-center">Order Confirmation</h2>

    <%
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        // ✅ Database Connection
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&allowPublicKeyRetrieval=true", "root", "password");

        // ✅ Fetch Order Details
        PreparedStatement orderStmt = con.prepareStatement("SELECT full_name, address, total_price, order_date FROM orders WHERE id = ?");
        orderStmt.setInt(1, orderId);
        ResultSet orderRs = orderStmt.executeQuery();

        String buyerName = "N/A", address = "N/A", orderDate = "N/A";
        double totalPrice = 0.0;
        if (orderRs.next()) {
            buyerName = orderRs.getString("full_name");
            address = orderRs.getString("address");
            totalPrice = orderRs.getDouble("total_price");
            orderDate = orderRs.getString("order_date");
        }

        // ✅ Fetch Order Items
        PreparedStatement itemStmt = con.prepareStatement("SELECT b.title, oi.quantity, oi.price FROM order_items oi JOIN books b ON oi.book_id = b.id WHERE oi.order_id = ?");
        itemStmt.setInt(1, orderId);
        ResultSet itemRs = itemStmt.executeQuery();
    %>

    <div class="card p-4">
        <h4>Buyer: <%= buyerName %></h4>
        <h5>Address: <%= address %></h5>
        <h6>Date & Time: <%= orderDate %></h6>
    </div>

    <!-- Order Summary Table -->
    <table class="table table-bordered mt-3">
        <thead class="bg-dark text-white">
            <tr>
                <th>Sr. No.</th>
                <th>Name of Item</th>
                <th>Quantity</th>
                <th>Price (Rs.)</th>
            </tr>
        </thead>
        <tbody>
            <%
                int srNo = 1;
                while (itemRs.next()) { 
            %>
            <tr>
                <td><%= srNo++ %></td>
                <td><%= itemRs.getString("title") %></td>
                <td><%= itemRs.getInt("quantity") %></td>
                <td><%= new DecimalFormat("#.00").format(itemRs.getDouble("price")) %></td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <h4 class="text-end">Total Price: <%= new DecimalFormat("#.00").format(totalPrice) %> Rs.</h4>

    <p class="text-center mt-3">Thank you for your purchase! We appreciate your support.</p>

    <div class="text-center">
        <a href="user_dashboard.html" class="btn btn-primary">Return to Dashboard</a>
    </div>

</body>
</html>
