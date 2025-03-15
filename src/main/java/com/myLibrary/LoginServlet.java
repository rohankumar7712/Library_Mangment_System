package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

            // Check user credentials
            String query = "SELECT id ,name, role FROM users WHERE email=? AND password=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
            	int userId = rs.getInt("id"); 
                String name = rs.getString("name");
                String role = rs.getString("role");

                // Start session
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("email", email);
                session.setAttribute("name", name);
                session.setAttribute("role", role);

                // Redirect based on role
                if (role.equals("admin")) {
                    response.sendRedirect("admin_dashboard.html");
                } else {
                    response.sendRedirect("user_dashboard.html");
                }
            } else {
                response.getWriter().println("<h3>Invalid Email or Password. Try Again!</h3>");
            }

            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }

	}

}
