package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Result;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ResultRepository extends JpaRepository<Result, Integer> {

    // Fetch all results with related entities
    @Query("SELECT res FROM Result res " +
            "JOIN FETCH res.registration reg " +
            "JOIN FETCH reg.course c " +
            "LEFT JOIN FETCH reg.professor p " +
            "LEFT JOIN FETCH reg.student s")
    List<Result> findAllWithDetails();

    // Fetch results by student ID
    @Query("SELECT res FROM Result res " +
            "JOIN FETCH res.registration reg " +
            "JOIN FETCH reg.course c " +
            "LEFT JOIN FETCH reg.professor p " +
            "LEFT JOIN FETCH reg.student s " +
            "WHERE reg.student.id = :studentId")
    List<Result> findByStudentId(@Param("studentId") int studentId);

    // Fetch results by student ID and course ID
    @Query("SELECT r FROM Result r " +
            "JOIN FETCH r.registration reg " +
            "JOIN FETCH reg.course c " +
            "WHERE reg.student.id = :studentId " +
            "AND reg.course.id = :courseId")
    List<Result> findByStudentIdAndCourseId(@Param("studentId") int studentId, @Param("courseId") int courseId);
}
