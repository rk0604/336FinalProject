<%@ page import="com.example.auth.CustomerRepDAO" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit or Delete Users</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 20px; background-color: #f9f9f9; }
        h1 { color: #333; margin-bottom: 20px; }
        
        table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
        th, td { padding: 12px 15px; border-bottom: 1px solid #ddd; text-align: left; }
        th { background-color: #8B4513; color: white; text-transform: uppercase; font-size: 0.9em; } /* Brown to match button */
        tr:hover { background-color: #f1f1f1; }
        
        .btn-del { 
            background-color: #dc3545; color: white; padding: 6px 12px; 
            text-decoration: none; border-radius: 4px; border: none; cursor: pointer; font-size: 0.9rem;
            transition: background 0.2s;
        }
        .btn-del:hover { background-color: #c82333; }

        .back-btn { 
            display: inline-block; margin-bottom: 20px; padding: 10px 15px; 
            background: #555; color: white; text-decoration: none; border-radius: 4px; 
        }
        .back-btn:hover { background: #333; }

        .message { padding: 10px; margin-bottom: 15px; border-radius: 4px; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <a href="customerRepDashboard.jsp" class="back-btn">&larr; Back to Dashboard</a>
    <h1>Edit or Delete User Accounts</h1>

    <%
        CustomerRepDAO dao = new CustomerRepDAO();
        String msg = "";
        String msgClass = "";

        // Handle Delete Action
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int uid = Integer.parseInt(request.getParameter("id"));
                dao.deleteUser(uid);
                msg = "User deleted successfully.";
                msgClass = "success";
            } catch (Exception e) {
                msg = "Error deleting user: " + e.getMessage();
                msgClass = "error";
            }
        }

        List<Map<String, Object>> users = dao.getAllUsers();
    %>

    <% if (!msg.isEmpty()) { %>
        <div class="message <%= msgClass %>"><%= msg %></div>
    <% } %>

    <table>
        <thead>
            <tr>
                <th>User ID</th>
                <th>Email</th>
                <th>Role</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% for (Map<String, Object> u : users) { %>
            <tr>
                <td><%= u.get("user_id") %></td>
                <td><%= u.get("email") %></td>
                <td><%= u.get("role") %></td>
                <td>
                    <form method="POST" style="margin:0;" onsubmit="return confirm('WARNING: Are you sure you want to delete this user? This will remove ALL their bids, items, and history.');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= u.get("user_id") %>">
                        <button type="submit" class="btn-del">Delete User</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>