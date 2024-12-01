package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Administrator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdministratorRepository extends JpaRepository<Administrator, Integer> {

    // Custom query for searching administrators by keyword and position
    @Query("SELECT a FROM Administrator a WHERE " +
            "(LOWER(a.firstName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
            "OR LOWER(a.lastName) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
            "AND (:position IS NULL OR a.position = :position)")
    List<Administrator> searchByKeywordAndPosition(@Param("keyword") String keyword, @Param("position") String position);

    // Custom query for finding an administrator by associated account ID
    @Query("SELECT a FROM Administrator a WHERE a.account.id = :accountId")
    Administrator findByAccountId(@Param("accountId") int accountId);
}
