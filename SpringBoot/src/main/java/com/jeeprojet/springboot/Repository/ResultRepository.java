package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Result;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ResultRepository extends JpaRepository<Result,Integer> {

}
