package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Student;

public class StudentDAO {

    // Database configuration constants
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234"; // TODO: Update with your MySQL root password
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * Establishes a connection to the database
     * @return Connection object
     * @throws SQLException if database access error occurs
     * @throws ClassNotFoundException if JDBC driver not found
     */
    public Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load the JDBC driver
        Class.forName(DB_DRIVER);
        
        // Create and return the connection
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Retrieves all students from the database
     * @return List of Student objects
     */
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String query = "SELECT * FROM students ORDER BY id";

        // Use try-with-resources for automatic resource management
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            // Iterate through the result set and create Student objects
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                
                students.add(student);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database error occurred: " + e.getMessage());
            e.printStackTrace();
        }

        return students;
    }

    /**
     * Retrieves a student by ID
     * @param id Student ID
     * @return Student object or null if not found
     */
    public Student getStudentById(int id) {
        Student student = null;
        String query = "SELECT * FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
            }

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database error occurred: " + e.getMessage());
            e.printStackTrace();
        }

        return student;
    }

    /**
     * Adds a new student to the database
     * @param student Student object to add
     * @return true if successful, false otherwise
     */
    public boolean addStudent(Student student) {
        String query = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            System.err.println("Database error occurred: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing student in the database
     * @param student Student object with updated information
     * @return true if successful, false otherwise
     */
    public boolean updateStudent(Student student) {
        String query = "UPDATE students SET student_code = ?, full_name = ?, email = ?, major = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            pstmt.setInt(5, student.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            System.err.println("Database error occurred: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a student from the database
     * @param id Student ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteStudent(int id) {
        String query = "DELETE FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (SQLException e) {
            System.err.println("Database error occurred: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Searches students by keyword across student_code, full_name, and email.
     * Results are ordered by id in descending order.
     *
     * @param keyword search keyword
     * @return List of matching Student objects
     */
    public List<Student> searchStudents(String keyword) {
        List<Student> students = new ArrayList<>();

        // If keyword is null or empty, simply return all students
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllStudents();
        }

        String searchPattern = "%" + keyword.trim() + "%";
        String query = "SELECT * FROM students " +
                       "WHERE student_code LIKE ? " +
                       "OR full_name LIKE ? " +
                       "OR email LIKE ? " +
                       "ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            // Set the same pattern for all three searchable columns
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student();
                    student.setId(rs.getInt("id"));
                    student.setStudentCode(rs.getString("student_code"));
                    student.setFullName(rs.getString("full_name"));
                    student.setEmail(rs.getString("email"));
                    student.setMajor(rs.getString("major"));

                    students.add(student);
                }
            }

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database error occurred: " + e.getMessage());
            e.printStackTrace();
        }

        return students;
    }

    // Validate sortBy parameter against allowed column names
    private String validateSortBy(String sortBy) {
        if (sortBy == null) {
            return "id";
        }

        switch (sortBy) {
            case "id":
            case "student_code":
            case "full_name":
            case "email":
            case "major":
                return sortBy;
            default:
                return "id";
        }
    }

    // Validate order parameter ("asc" or "desc")
    private String validateOrder(String order) {
        if (order != null && "desc".equalsIgnoreCase(order)) {
            return "DESC";
        }
        return "ASC";
    }

    /**
     * Retrieves students sorted by a specific column and order.
     *
     * @param sortBy column name to sort by
     * @param order  sort direction ("asc" or "desc")
     * @return List of sorted students
     */
    public List<Student> getStudentsSorted(String sortBy, String order) {
        List<Student> students = new ArrayList<>();

        String validSortBy = validateSortBy(sortBy);
        String validOrder = validateOrder(order);

        String query = "SELECT * FROM students ORDER BY " + validSortBy + " " + validOrder;

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));

                students.add(student);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database error occurred: " + e.getMessage());
            e.printStackTrace();
        }

        return students;
    }

    /**
     * Retrieves students by a specific major.
     *
     * @param major the major to filter by
     * @return List of students with the given major
     */
    public List<Student> getStudentsByMajor(String major) {
        List<Student> students = new ArrayList<>();

        String query = "SELECT * FROM students WHERE major = ? ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, major);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student();
                    student.setId(rs.getInt("id"));
                    student.setStudentCode(rs.getString("student_code"));
                    student.setFullName(rs.getString("full_name"));
                    student.setEmail(rs.getString("email"));
                    student.setMajor(rs.getString("major"));

                    students.add(student);
                }
            }

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database error occurred: " + e.getMessage());
            e.printStackTrace();
        }

        return students;
    }
}
