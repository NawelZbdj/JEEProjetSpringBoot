package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CourseRepository extends JpaRepository<Course,Integer> {

}