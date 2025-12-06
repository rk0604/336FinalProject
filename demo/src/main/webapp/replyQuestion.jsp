<%@ page import="com.example.auth.CustomerRepDAO" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reply to Question</title>
    <style>
        body { font-family: sans-serif; padding: 40px; background-color: #f4f4f4; }
        .container { background: white; max-width: 600px; margin: 0 auto; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { margin-top: 0; color: #333; }
        label { display: block; margin-top: 15px; font-weight: bold; color: #555; }
        textarea { width: 100%; height: 150px; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 4px; }
        .btn-submit { background-color: #28a745; color: white; border: none; padding: 10px 20px; font-size: 16px; border-radius: 4px; cursor: pointer; margin-top: 20px; }
        .btn-submit:hover { background-color: #218838; }
        .btn-cancel { color: #666; text-decoration: none; margin-left: 15px; }
    </style>
</head>
<body>

<div class="container">

<%
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect("userQuestions.jsp");
        return;
    }

    CustomerRepDAO dao = new CustomerRepDAO();
    Map<String, Object> question = dao.getQuestionById(Integer.parseInt(idParam));

    if (question == null) {
        response.sendRedirect("userQuestions.jsp");
        return;
    }

    String answer = request.getParameter("answer");
    if (answer != null && !answer.trim().isEmpty()) {
        dao.replyToQuestion(Integer.parseInt(idParam), answer.trim());
        response.sendRedirect("userQuestions.jsp");
        return;
    }
%>

<h2>Reply to User Question</h2>

<p><strong>From:</strong> <%= question.get("email") %></p>
<p><strong>Subject:</strong> <%= question.get("subject") %></p>
<p><strong>Message:</strong> <%= question.get("message") %></p>

<form method="POST">
    <label>Your Answer:</label>
    <textarea name="answer" required></textarea>

    <button type="submit" class="btn-submit">Send Reply</button>
    <a href="userQuestions.jsp" class="btn-cancel">Cancel</a>
</form>

</div>

</body>
</html>
