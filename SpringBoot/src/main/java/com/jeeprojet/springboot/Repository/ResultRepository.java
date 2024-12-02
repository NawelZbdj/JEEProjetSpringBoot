package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Course;
import com.jeeprojet.springboot.Model.Registration;
import com.jeeprojet.springboot.Model.Result;
import com.jeeprojet.springboot.Model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

import java.util.List;

@Repository
public interface ResultRepository extends JpaRepository<Result, Integer> {

    @Query("SELECT res FROM Result res " +
            "JOIN FETCH res.registration reg " +
            "JOIN FETCH reg.course c " +
            "LEFT JOIN FETCH reg.professor p " +
            "LEFT JOIN FETCH reg.student s")
    List<Result> findAllWithDetails();

    @Query("SELECT res FROM Result res " +
            "JOIN FETCH res.registration reg " +
            "JOIN FETCH reg.course c " +
            "LEFT JOIN FETCH reg.professor p " +
            "LEFT JOIN FETCH reg.student s " +
            "WHERE reg.student.id = :studentId")
    List<Result> findByStudentId(@Param("studentId") int studentId);

    @Query("SELECT r FROM Result r " +
            "JOIN FETCH r.registration reg " +
            "JOIN FETCH reg.course c " +
            "WHERE reg.student.id = :studentId " +
            "AND reg.course.id = :courseId")
    List<Result> findByStudentIdAndCourseId(@Param("studentId") int studentId, @Param("courseId") int courseId);
}
