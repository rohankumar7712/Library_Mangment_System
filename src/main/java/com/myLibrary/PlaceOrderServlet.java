package com.myLibrary;

import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public PlaceOrderServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession(false); // ❌ Don't create a new session
    	System.out.println("Session Exists: " + (session != null));
    	System.out.println("Session UserId: " + session.getAttribute("userId"));

    	Integer userId = (Integer) session.getAttribute("userId");
    	if (userId == null) {
    	    System.out.println("User is not logged in, redirecting to login page...");
    	    response.sendRedirect("login.html");
    	    return;
    	}


        String fullName = request.getParameter("fullName");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&allowPublicKeyRetrieval=true", "root", "password");

            // Get cart total price
            PreparedStatement priceStmt = con.prepareStatement("SELECT SUM(b.price * c.quantity) AS total FROM cart c JOIN books b ON c.book_id = b.id WHERE c.user_id = ?");
            priceStmt.setInt(1, userId);
            ResultSet priceRs = priceStmt.executeQuery();
            double totalPrice = 0.0;
            if (priceRs.next()) {
                totalPrice = priceRs.getDouble("total");
            }

            // Insert order details into orders table
            String insertOrder = "INSERT INTO orders (user_id, full_name, address, payment_method, total_price, order_date) VALUES (?, ?, ?, ?, ?, NOW())";
            PreparedStatement orderStmt = con.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setString(2, fullName);
            orderStmt.setString(3, address);
            orderStmt.setString(4, paymentMethod);
            orderStmt.setDouble(5, totalPrice);
            orderStmt.executeUpdate();

            ResultSet orderRs = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (orderRs.next()) {
                orderId = orderRs.getInt(1);
            }

            // Move cart items to order_items table
            String moveItems = "INSERT INTO order_items (order_id, book_id, quantity, price) SELECT ?, book_id, quantity, (SELECT price FROM books WHERE id = cart.book_id) FROM cart WHERE user_id = ?";
            PreparedStatement moveStmt = con.prepareStatement(moveItems);
            moveStmt.setInt(1, orderId);
            moveStmt.setInt(2, userId);
            moveStmt.executeUpdate();
            
         // Insert purchased books into book_history
            String insertHistory = "INSERT INTO book_history (user_id, book_id) " +
                                   "SELECT ?, book_id FROM cart WHERE user_id = ?";
            PreparedStatement historyStmt = con.prepareStatement(insertHistory);
            historyStmt.setInt(1, userId);
            historyStmt.setInt(2, userId);
            historyStmt.executeUpdate();

            // Clear cart after order
            PreparedStatement clearCartStmt = con.prepareStatement("DELETE FROM cart WHERE user_id = ?");
            clearCartStmt.setInt(1, userId);
            clearCartStmt.executeUpdate();

            con.close();

            // Redirect to confirmation page with parameters
            response.sendRedirect("order_confirmation.jsp?orderId=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp?error=Order processing failed!");
        }
    }
}
