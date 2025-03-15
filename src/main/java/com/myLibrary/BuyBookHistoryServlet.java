package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class BuyBookHistoryServlet
 */
public class BuyBookHistoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BuyBookHistoryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 HttpSession session = request.getSession(false);
	        if (session == null || session.getAttribute("userId") == null) {
	            response.sendRedirect("login.html");
	            return;
	        }

	        int userId = (Integer) session.getAttribute("userId");
	        List<String[]> history = new ArrayList<>();

	        try {
	            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false", "root", "password");

	            // Query to fetch purchase history with book details
	            String query = "SELECT bh.action_date, b.title, b.author, b.category, b.price " +
	                           "FROM book_history bh " +
	                           "JOIN books b ON bh.book_id = b.id " +
	                           "WHERE bh.user_id = ? " +
	                           "ORDER BY bh.action_date DESC";
	            PreparedStatement stmt = con.prepareStatement(query);
	            stmt.setInt(1, userId);
	            ResultSet rs = stmt.executeQuery();

	            int srNo = 1; // Initialize Serial Number
	            while (rs.next()) {
	                history.add(new String[]{
	                    String.valueOf(srNo), // Sr. No
	                    rs.getString("action_date"), // Date of Purchase
	                    rs.getString("title"), // Book Title
	                    rs.getString("author"), // Author
	                    rs.getString("category"), // Category
	                    rs.getString("price") // Price
	                });
	                srNo++;
	            }

	            request.setAttribute("history", history);
	            request.getRequestDispatcher("BuyBookHistory.jsp").forward(request, response);
	            con.close();

	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("error.jsp");
	        }

	}

	

}
