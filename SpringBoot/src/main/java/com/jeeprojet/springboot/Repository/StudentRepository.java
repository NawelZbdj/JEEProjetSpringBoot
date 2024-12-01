package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentRepository extends JpaRepository<Student,Integer> {

    Student findByAccountId(int id);
}
