package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddToCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
    public AddToCartServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 HttpSession session = request.getSession();
	        Integer userId = (Integer) session.getAttribute("userId");
	        int bookId = Integer.parseInt(request.getParameter("bookId"));

	        if (userId == null) {
	            response.sendRedirect("login.html");
	            return;
	        }

	        try {
	            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");
	            String query = "INSERT INTO cart (user_id, book_id) VALUES (?, ?)";
	            PreparedStatement pst = con.prepareStatement(query);
	            pst.setInt(1, userId);
	            pst.setInt(2, bookId);
	            pst.executeUpdate();
	            con.close();

	            response.sendRedirect("cart.jsp");
	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database Error");
	        }
    }
	}


