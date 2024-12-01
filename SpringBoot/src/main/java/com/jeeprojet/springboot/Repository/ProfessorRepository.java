package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Professor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProfessorRepository extends JpaRepository<Professor, Integer> {

    // Find Professor by Account ID
    @Query("SELECT p FROM Professor p WHERE p.account.id = :accountId")
    Professor findByAccountId(@Param("accountId") int accountId);

    // Search Professors by keyword and specialty
    @Query("SELECT p FROM Professor p WHERE (p.firstName LIKE %:keyword% OR p.lastName LIKE %:keyword%)" +
            " AND (:specialty IS NULL OR :specialty = '' OR p.specialty = :specialty)")
    List<Professor> searchByKeywordAndSpecialty(@Param("keyword") String keyword, @Param("specialty") String specialty);
}
