<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:choose><c:when test="${not empty student}">Edit Student</c:when><c:otherwise>Add New Student</c:otherwise></c:choose></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        input[type="text"]:focus,
        input[type="email"]:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 5px;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .form-actions {
            text-align: center;
            margin-top: 30px;
        }
        .required {
            color: red;
        }
        .error {
            color: red;
            font-size: 14px;
            display: block;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1><c:choose><c:when test="${not empty student}">Edit Student</c:when><c:otherwise>Add New Student</c:otherwise></c:choose></h1>
        
        <form action="student" method="post">
            <c:if test="${not empty student}">
                <input type="hidden" name="id" value="${student.id}">
                <input type="hidden" name="action" value="update">
            </c:if>
            <c:if test="${empty student}">
                <input type="hidden" name="action" value="insert">
            </c:if>
            
            <div class="form-group">
                <label for="studentCode">Student Code <span class="required">*</span></label>
                <c:choose>
                    <c:when test="${not empty student}">
                        <input type="text"
                               id="studentCode"
                               name="studentCode"
                               value="${student.studentCode}"
                               readonly="readonly"
                               placeholder="Student code">
                    </c:when>
                    <c:otherwise>
                        <input type="text"
                               id="studentCode"
                               name="studentCode"
                               value="${student.studentCode}"
                               required="required"
                               placeholder="e.g. SV001">
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty errorCode}">
                    <span class="error">${errorCode}</span>
                </c:if>
            </div>
            
            <div class="form-group">
                <label for="fullName">Full Name <span class="required">*</span></label>
                <input type="text" 
                       id="fullName" 
                       name="fullName" 
                       value="${student.fullName}" 
                       required 
                       placeholder="Enter full name">
                <c:if test="${not empty errorName}">
                    <span class="error">${errorName}</span>
                </c:if>
            </div>
            
            <div class="form-group">
                <label for="email">Email <span style="font-weight: normal; color: #666;">(optional)</span></label>
                <input type="email"
                       id="email"
                       name="email"
                       value="${student.email}"
                       placeholder="Enter email address if any">
                <c:if test="${not empty errorEmail}">
                    <span class="error">${errorEmail}</span>
                </c:if>
            </div>
            
            <div class="form-group">
                <label for="major">Major <span class="required">*</span></label>
                <input type="text" 
                       id="major" 
                       name="major" 
                       value="${student.major}" 
                       required 
                       placeholder="Enter major">
                <c:if test="${not empty errorMajor}">
                    <span class="error">${errorMajor}</span>
                </c:if>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${not empty student}">Update Student</c:when>
                        <c:otherwise>Add Student</c:otherwise>
                    </c:choose>
                </button>
                <a href="student?action=list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>


