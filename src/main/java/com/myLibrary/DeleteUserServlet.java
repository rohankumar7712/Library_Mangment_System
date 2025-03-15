package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
/**
 * Servlet implementation class DeleteUserServlet
 */
public class DeleteUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
    public DeleteUserServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int userId = Integer.parseInt(request.getParameter("id"));

        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

            // Delete query
            String query = "DELETE FROM users WHERE id=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, userId);

            int rowCount = pst.executeUpdate();
            if (rowCount > 0) {
                response.sendRedirect("manage_users.jsp");
            } else {
                response.getWriter().println("<h3>User Deletion Failed.</h3>");
            }

            // Close resources
            pst.close();
            con.close();
        } catch (Exception e) {
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
	}

	

}
