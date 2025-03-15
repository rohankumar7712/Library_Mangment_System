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
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class SeatBookingGridServlet
 */
public class SeatBookingGridServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SeatBookingGridServlet() {
        super();
    }
        // TODO Auto-generated constructor stub
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String action = request.getParameter("action");
            if ("getBookedSeats".equals(action)) {
                getBookedSeats(response);
            }
        }

        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String selectedSeats = request.getParameter("selectedSeats");
            String bookingIdParam = request.getParameter("bookingId");

            if (selectedSeats == null || selectedSeats.isEmpty() || bookingIdParam == null || bookingIdParam.isEmpty()) {
                response.getWriter().println("Invalid seat selection or booking ID.");
                return;
            }

            int bookingId = Integer.parseInt(bookingIdParam);

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&allowPublicKeyRetrieval=true", "root", "password");

                // Check if seats are already booked
                String checkQuery = "SELECT COUNT(*) FROM seatbookings WHERE seat_no = ?";
                PreparedStatement checkPst = con.prepareStatement(checkQuery);

                String query = "INSERT INTO seatbookings (booking_id, seat_no) VALUES (?, ?)";
                PreparedStatement pst = con.prepareStatement(query);

                String[] seats = selectedSeats.split(",");
                for (String seat : seats) {
                    checkPst.setInt(1, Integer.parseInt(seat));
                    ResultSet rs = checkPst.executeQuery();
                    rs.next();

                    if (rs.getInt(1) > 0) {
                        response.getWriter().println("Error: Seat " + seat + " is already booked.");
                        rs.close();
                        return;
                    }
                    rs.close();

                    pst.setInt(1, bookingId);
                    pst.setInt(2, Integer.parseInt(seat));
                    pst.executeUpdate();
                }

                checkPst.close();
                pst.close();
                con.close();

                response.sendRedirect("confirmation.jsp?bookingId=" + bookingId);

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error booking seats.");
            }
        }

        private void getBookedSeats(HttpServletResponse response) throws IOException {
            List<Integer> bookedSeats = new ArrayList<>();
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library?useSSL=false&allowPublicKeyRetrieval=true", "root", "password");

                String query = "SELECT seat_no FROM seatbookings";
                PreparedStatement pst = con.prepareStatement(query);
                ResultSet rs = pst.executeQuery();

                while (rs.next()) {
                    bookedSeats.add(rs.getInt("seat_no"));
                }

                rs.close();
                pst.close();
                con.close();

                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(String.join(",", bookedSeats.stream().map(String::valueOf).toArray(String[]::new)));

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error fetching booked seats.");
            }
       
	}

}
