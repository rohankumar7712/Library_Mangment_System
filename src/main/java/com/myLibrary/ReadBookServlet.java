package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/ReadBookServlet")  // ✅ Ensure the servlet is mapped correctly
public class ReadBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ReadBookServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // ✅ Get existing session (DO NOT create a new session)
        HttpSession session = request.getSession(false);  

        // ✅ Debugging: Print session values
        System.out.println("Session Exists: " + (session != null));
        if (session != null) {
            System.out.println("Session UserID: " + session.getAttribute("userId"));
        }

        // ✅ Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Redirecting to login page...");
            response.sendRedirect("Login.html");
            return;
        }

        // ✅ Retrieve userId from session
        Integer userId = (Integer) session.getAttribute("userId");

        // ✅ Get bookId from request
        String bookIdParam = request.getParameter("bookId");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid book ID");
            return;
        }

        int bookId;
        try {
            bookId = Integer.parseInt(bookIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Book ID must be a number");
            return;
        }

        // ✅ Database connection
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/library?useSSL=false&allowPublicKeyRetrieval=true";
            String dbUser = "root";
            String dbPassword = "password";

            try (Connection con = DriverManager.getConnection(url, dbUser, dbPassword)) {
                // ✅ Check if book is already in history (avoid duplicates)
                String checkQuery = "SELECT * FROM reading_history WHERE user_id = ? AND book_id = ?";
                try (PreparedStatement checkPst = con.prepareStatement(checkQuery)) {
                    checkPst.setInt(1, userId);
                    checkPst.setInt(2, bookId);
                    ResultSet checkRs = checkPst.executeQuery();

                    if (!checkRs.next()) {  // ✅ Insert only if no existing record
                        String insertQuery = "INSERT INTO reading_history (user_id, book_id) VALUES (?, ?)";
                        try (PreparedStatement pst = con.prepareStatement(insertQuery)) {
                            pst.setInt(1, userId);
                            pst.setInt(2, bookId);
                            pst.executeUpdate();
                        }
                    }
                }
            }

            // ✅ Redirect to book reader page
            response.sendRedirect("book_reader.jsp?bookId=" + bookId);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database driver not found");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
