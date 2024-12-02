package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

import java.util.List;

@Repository
public interface StudentRepository extends JpaRepository<Student, Integer> {

    // Find Student by Account ID
    @Query("SELECT s FROM Student s WHERE s.account.id = :accountId")
    Student findByAccountId(@Param("accountId") int accountId);

    // Search Students by keyword
    @Query("SELECT s FROM Student s WHERE s.firstName LIKE %:keyword% OR s.lastName LIKE %:keyword%")
    List<Student> searchByKeyword(@Param("keyword") String keyword);

    // Find Students by Course ID and Professor ID
    @Query("SELECT DISTINCT s FROM Student s JOIN Registration r ON s.id = r.student.id " +
            "WHERE r.course.id = :courseId AND r.professor.id = :professorId")
    List<Student> findByCourseIdAndProfessorId(@Param("courseId") int courseId, @Param("professorId") int professorId);
}
