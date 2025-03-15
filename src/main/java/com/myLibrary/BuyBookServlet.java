package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
/**
 * Servlet implementation class BuyBookServlet
 */
public class BuyBookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BuyBookServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId"); // Get logged-in user ID
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        if (userId == null) {
            response.sendRedirect("login.html");
            return;
        }

        try {
            // Database Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

            // Insert Buy Action into History
            String query = "INSERT INTO book_history (user_id, book_id, action_type) VALUES (?, ?, 'buy')";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, userId);
            pst.setInt(2, bookId);
            pst.executeUpdate();

            pst.close();
            con.close();

            // Redirect to Purchase Confirmation Page
            response.sendRedirect("purchase_success.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
	}

	

}
