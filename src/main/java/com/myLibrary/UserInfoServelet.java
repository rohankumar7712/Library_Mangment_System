package com.myLibrary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserInfoServelet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
    public UserInfoServelet() {
        super();
        
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String customerName = request.getParameter("customer_name");
        String email = request.getParameter("email");
        String bookingDate = request.getParameter("date"); // ✅ FIX: Added booking date
        String reportingTime = request.getParameter("reporting_time");
        String endTime = request.getParameter("end_time");

        String[] memberNames = request.getParameterValues("member_name[]");
        String[] memberEmails = request.getParameterValues("member_email[]");

        int bookingId = -1;

        try {
            // ✅ Database Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "password");

            // ✅ FIX: Corrected SQL query to include `booking_date`
            String bookingQuery = "INSERT INTO bookings (customer_name, email, booking_date, reporting_time, end_time) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(bookingQuery, PreparedStatement.RETURN_GENERATED_KEYS);
            pst.setString(1, customerName);
            pst.setString(2, email);
            pst.setString(3, bookingDate); // ✅ Storing `booking_date`
            pst.setString(4, reportingTime);
            pst.setString(5, endTime);
            pst.executeUpdate();

            // ✅ Retrieve generated booking ID
            ResultSet rs = pst.getGeneratedKeys();
            if (rs.next()) {
                bookingId = rs.getInt(1);
            }

            // ✅ Insert members if available
            if (memberNames != null && memberEmails != null && bookingId > 0) {
                String memberQuery = "INSERT INTO members (booking_id, member_name, member_email) VALUES (?, ?, ?)";
                PreparedStatement memberPst = con.prepareStatement(memberQuery);
                for (int i = 0; i < memberNames.length; i++) {
                    memberPst.setInt(1, bookingId);
                    memberPst.setString(2, memberNames[i]);
                    memberPst.setString(3, memberEmails[i]);
                    memberPst.executeUpdate();
                }
                memberPst.close();
            }

            pst.close();
            con.close();

            // ✅ Redirect to seat selection page
            response.sendRedirect("SeatBookingGrid.html?bookingId=" + bookingId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error storing user info.");
        }

	}

}
