package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Administrator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdministratorRepository extends JpaRepository<Administrator,Integer> {

}
