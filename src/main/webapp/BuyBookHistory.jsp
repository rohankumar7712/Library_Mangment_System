<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Book Purchase History</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 40px;
            max-width: 95%; /* Increased width */
        }
        .navbar {
            width: 100%;
            background-color: #212529;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 10px;
        }
        .navbar h2 {
            color: white;
            margin: 0;
            padding-left: 20px;
        }
        .btn-back {
            background-color: #dc3545;
            color: white;
            border-radius: 5px;
            margin-right: 20px;
        }
        .btn-back:hover {
            background-color: #c82333;
        }
        .table-container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        .table {
            width: 100%; /* Make table full width */
            table-layout: auto;
        }
        h2 {
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
        }
        .search-box {
            width: 300px;
            margin-bottom: 15px;
            float: right;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <h2>Buy Book History</h2>
    <a href="dashboard.jsp" class="btn btn-back">Back</a>
</div>

<div class="container">
    <h2>Your Purchased Books</h2>

    <!-- Search Box -->
    <div class="d-flex justify-content-end">
        <input type="text" id="searchInput" class="form-control search-box" placeholder="Search books...">
    </div>

    <!-- Table -->
    <div class="table-container">
        <table class="table table-hover table-bordered text-center">
            <thead class="table-dark">
                <tr>
                    <th>Sr. No</th>
                    <th>Date of Purchase</th>
                    <th>Book Title</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody id="historyTable">
                <%
                    List<String[]> history = (List<String[]>) request.getAttribute("history");
                    if (history != null && !history.isEmpty()) {
                        for (String[] record : history) {
                %>
                <tr>
                    <td><%= record[0] %></td>
                    <td><%= record[1] %></td>
                    <td><%= record[2] %></td>
                    <td><%= record[3] %></td>
                    <td><%= record[4] %></td>
                    <td>$<%= record[5] %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="6" class="text-center">No purchased books found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Search Functionality -->
<script>
    $(document).ready(function () {
        $("#searchInput").on("keyup", function () {
            var value = $(this).val().toLowerCase();
            $("#historyTable tr").filter(function () {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
            });
        });
    });
</script>

</body>
</html>
