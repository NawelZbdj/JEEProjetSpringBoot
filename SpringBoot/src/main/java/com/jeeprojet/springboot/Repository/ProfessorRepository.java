package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Professor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProfessorRepository extends JpaRepository<Professor,Integer> {

}