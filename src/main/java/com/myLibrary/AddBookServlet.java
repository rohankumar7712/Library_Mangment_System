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
import java.util.UUID;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
maxFileSize = 1024 * 1024 * 10, // 10MB
maxRequestSize = 1024 * 1024 * 50) // 50MB

public class AddBookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddBookServlet() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String price = request.getParameter("price");
        Part imagePart = request.getPart("bookImage");
        Part pdfPart = request.getPart("bookPdf");

        // Upload directory
        String uploadPath = getServletContext().getRealPath("/") + "uploads/";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // Save Image
        String imageName = imagePart.getSubmittedFileName();
        String imagePath = "uploads/" + imageName;
        imagePart.write(uploadPath + imageName);

        // Save PDF
        String pdfName = pdfPart.getSubmittedFileName();
        String pdfPath = "uploads/" + pdfName;
        pdfPart.write(uploadPath + pdfName);

        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

            // Insert query
            String query = "INSERT INTO books (title, author, category, price, image, pdf_path) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, title);
            pst.setString(2, author);
            pst.setString(3, category);
            pst.setString(4, price);
            pst.setString(5, imagePath);
            pst.setString(6, pdfPath);

            int rowCount = pst.executeUpdate();
            if (rowCount > 0) {
                response.sendRedirect("manage_books.jsp");
            } else {
                out.println("<h3>Failed to add book.</h3>");
            }

            pst.close();
            con.close();
        } catch (Exception e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
	}

}
