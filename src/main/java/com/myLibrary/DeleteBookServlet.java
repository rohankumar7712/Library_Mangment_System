package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.*;
/**
 * Servlet implementation class DeleteBookServlet
 */
public class DeleteBookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteBookServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int bookId = Integer.parseInt(request.getParameter("id"));
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Database Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

            // Get Book Image Path from Database
            String selectQuery = "SELECT image FROM books WHERE id=?";
            pst = con.prepareStatement(selectQuery);
            pst.setInt(1, bookId);
            rs = pst.executeQuery();

            String imagePath = null;
            if (rs.next()) {
                imagePath = rs.getString("image");
            }
            rs.close();
            pst.close();

            // Delete the Book from Database
            String deleteQuery = "DELETE FROM books WHERE id=?";
            pst = con.prepareStatement(deleteQuery);
            pst.setInt(1, bookId);
            int rowCount = pst.executeUpdate();

            if (rowCount > 0 && imagePath != null) {
                // Remove the Image File
                String uploadPath = getServletContext().getRealPath("/") + imagePath;
                File imageFile = new File(uploadPath);
                if (imageFile.exists()) {
                    imageFile.delete(); // Delete the file
                }
            }

            response.sendRedirect("manage_books.jsp"); // Redirect back to Manage Books page

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
	}


}
