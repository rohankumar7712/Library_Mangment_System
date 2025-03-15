<%@ page import="java.sql.*, java.text.DecimalFormat, java.text.SimpleDateFormat, java.util.Date" %>



<!DOCTYPE html>
<html lang="en">
<head>
    <title>Checkout</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">

    <h2 class="text-center">Checkout</h2>
    
    <!-- Debugging Session -->
    

    <form action="PlaceOrderServlet" method="post">
        <div class="mb-3">
            <label>Full Name:</label>
            <input type="text" name="fullName" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Address:</label>
            <textarea name="address" class="form-control" required></textarea>
        </div>
        <div class="mb-3">
            <label>Payment Method:</label>
            <select name="paymentMethod" class="form-control">
                <option value="COD">Cash on Delivery</option>
                <option value="Online">Online Payment</option>
            </select>
        </div>
        
        <!-- Hidden Field to Pass userId -->
        <input type="hidden" name="userId" value="<%= session.getAttribute("userId") %>">

        <button type="submit" class="btn btn-success w-100">Confirm Order</button>
    </form>

</body>
</html>
