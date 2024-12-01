package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course,Integer> {

    @Query("SELECT c FROM Course c JOIN Registration r ON c.id = r.course.id WHERE r.professor.id = :professorId")
    List<Course> findByProfessorId(int professorId);
}