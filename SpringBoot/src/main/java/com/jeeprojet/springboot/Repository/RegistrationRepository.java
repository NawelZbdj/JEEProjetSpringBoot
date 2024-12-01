package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Registration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RegistrationRepository extends JpaRepository<Registration,Integer> {

    @Query("SELECT r FROM Registration r " +
            "JOIN FETCH r.course " +
            "LEFT JOIN FETCH r.professor " +
            "LEFT JOIN FETCH r.student")
    List<Registration> findAllRegistrations();

    @Query("SELECT r FROM Registration r " +
            "JOIN FETCH r.course c " +
            "LEFT JOIN FETCH r.professor p " +
            "LEFT JOIN FETCH r.student s " +
            "WHERE r.id = :id")
    Registration findByIdWithDetails(int id);

    @Query("SELECT r FROM Registration r " +
            "JOIN FETCH r.course c " +
            "LEFT JOIN FETCH r.professor p " +
            "LEFT JOIN FETCH r.student s " +
            "WHERE r.student.id = :studentId")
    List<Registration> findByStudentId(int studentId);

    @Query("SELECT r FROM Registration r " +
            "JOIN FETCH r.course c " +
            "LEFT JOIN FETCH r.professor p " +
            "LEFT JOIN FETCH r.student s " +
            "WHERE p.id = :professorId")
    List<Registration> findByProfessorId(int professorId);

    @Query("FROM Registration r WHERE r.student.id = :studentId AND r.course.id = :courseId")
    Registration findByStudentAndCourse(int studentId, int courseId);
}