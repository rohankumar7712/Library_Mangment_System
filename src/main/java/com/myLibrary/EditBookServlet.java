package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
maxFileSize = 1024 * 1024 * 10, // 10MB
maxRequestSize = 1024 * 1024 * 50) // 50MB

public class EditBookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditBookServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String price = request.getParameter("price");
        Part filePart = request.getPart("bookImage");

        String uploadPath = "C:\\uploads"; // Change this to your actual upload directory
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileName = filePart.getSubmittedFileName();
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

            // Get the existing image if a new one isn't uploaded
            if (fileName == null) {
                String getImageQuery = "SELECT image FROM books WHERE id=?";
                PreparedStatement imgPst = con.prepareStatement(getImageQuery);
                imgPst.setInt(1, id);
                ResultSet rs = imgPst.executeQuery();
                if (rs.next()) {
                    fileName = rs.getString("image");
                }
                imgPst.close();
            }

            // Update query
            String query = "UPDATE books SET title=?, author=?, category=?, price=?, image=? WHERE id=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, title);
            pst.setString(2, author);
            pst.setString(3, category);
            pst.setString(4, price);
            pst.setString(5, fileName);
            pst.setInt(6, id);

            int rowCount = pst.executeUpdate();
            if (rowCount > 0) {
                response.sendRedirect("manage_books.jsp");
            } else {
                out.println("<h3>Failed to update book.</h3>");
            }

            pst.close();
            con.close();
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
	}

}
