package com.myLibrary;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
/**
 * Servlet implementation class ManageUsersServlet
 */
public class ManageUsersServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
 
    public ManageUsersServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 try {
	            // Database connection
	            Class.forName("com.mysql.cj.jdbc.Driver");
	            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

	            // Fetch users
	            String query = "SELECT * FROM users";
	            PreparedStatement pst = con.prepareStatement(query);
	            ResultSet rs = pst.executeQuery();

	            // Store results in request scope
	            request.setAttribute("usersData", rs);
	            RequestDispatcher rd = request.getRequestDispatcher("manage_users.jsp");
	            rd.forward(request, response);

	            // Close resources
	            rs.close();
	            pst.close();
	            con.close();
	        } catch (Exception e) {
	            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
	        }
	}

	

}
