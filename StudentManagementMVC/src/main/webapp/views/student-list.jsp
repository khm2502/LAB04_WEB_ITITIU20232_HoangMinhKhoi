<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .actions {
            white-space: nowrap;
        }
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .filter-box {
            margin: 10px 0;
            padding: 10px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Student Management System</h1>
        
        <!-- Display success/error messages -->
        <c:if test="${not empty param.message}">
            <div class="message success">
                ${param.message}
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="message error">
                ${param.error}
            </div>
        </c:if>

        <!-- Search form and Add button -->
        <div style="margin: 20px 0; display: flex; justify-content: space-between; align-items: center;">
            <form action="student" method="get" style="display: flex; gap: 10px; align-items: center;">
                <input type="hidden" name="action" value="search">
                <input type="text"
                       name="keyword"
                       placeholder="Search by code, name, or email"
                       value="${keyword}"
                       style="padding: 8px; border: 1px solid #ddd; border-radius: 4px; min-width: 250px;">
                <button type="submit" class="btn btn-primary">🔍 Search</button>

                <!-- Clear/Show All button only when a search is active -->
                <c:if test="${not empty keyword}">
                    <a href="student?action=list" class="btn btn-secondary">Show All</a>
                </c:if>
            </form>
            <a href="student?action=new" class="btn btn-success">Add New Student</a>
        </div>

        <!-- Conditional search results message -->
        <c:if test="${not empty keyword}">
            <div class="message" style="border: 1px solid #007bff; background-color: #e9f3ff; color: #004085;">
                Search results for: <strong>${keyword}</strong>
            </div>
        </c:if>

        <!-- Filter by Major -->
        <div class="filter-box">
            <form action="student" method="get" style="display: flex; gap: 10px; align-items: center;">
                <input type="hidden" name="action" value="filter">
                <label for="major">Filter by Major:</label>
                <select id="major" name="major" style="padding: 6px; border-radius: 4px; border: 1px solid #ddd;">
                    <option value="">All Majors</option>
                    <option value="Computer Science"
                        <c:if test="${selectedMajor == 'Computer Science'}">selected</c:if>>
                        Computer Science
                    </option>
                    <option value="Information Technology"
                        <c:if test="${selectedMajor == 'Information Technology'}">selected</c:if>>
                        Information Technology
                    </option>
                    <option value="Software Engineering"
                        <c:if test="${selectedMajor == 'Software Engineering'}">selected</c:if>>
                        Software Engineering
                    </option>
                    <option value="Business Administration"
                        <c:if test="${selectedMajor == 'Business Administration'}">selected</c:if>>
                        Business Administration
                    </option>
                </select>
                <button type="submit" class="btn btn-primary">Apply Filter</button>

                <c:if test="${not empty selectedMajor}">
                    <a href="student?action=list" class="btn btn-secondary">Clear Filter</a>
                </c:if>
            </form>
        </div>
        
        <c:choose>
            <c:when test="${not empty students}">
                <table>
                    <thead>
                        <tr>
                            <th>
                                <a href="student?action=sort&sortBy=id&order=${sortBy == 'id' and order == 'asc' ? 'desc' : 'asc'}">
                                    ID
                                    <c:if test="${sortBy == 'id'}">
                                        ${order == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=student_code&order=${sortBy == 'student_code' and order == 'asc' ? 'desc' : 'asc'}">
                                    Student Code
                                    <c:if test="${sortBy == 'student_code'}">
                                        ${order == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=full_name&order=${sortBy == 'full_name' and order == 'asc' ? 'desc' : 'asc'}">
                                    Full Name
                                    <c:if test="${sortBy == 'full_name'}">
                                        ${order == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=email&order=${sortBy == 'email' and order == 'asc' ? 'desc' : 'asc'}">
                                    Email
                                    <c:if test="${sortBy == 'email'}">
                                        ${order == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=major&order=${sortBy == 'major' and order == 'asc' ? 'desc' : 'asc'}">
                                    Major
                                    <c:if test="${sortBy == 'major'}">
                                        ${order == 'asc' ? '▲' : '▼'}
                                    </c:if>
                                </a>
                            </th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td>${student.studentCode}</td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>
                                <td class="actions">
                                    <a href="student?action=edit&id=${student.id}" class="btn btn-warning">Edit</a>
                                    <a href="student?action=delete&id=${student.id}" 
                                       class="btn btn-danger" 
                                       onclick="return confirm('Are you sure you want to delete this student?')">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-message">
                    <p>No students found. Click "Add New Student" to add one.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>


