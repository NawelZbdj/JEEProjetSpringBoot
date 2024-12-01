package com.jeeprojet.springboot.Repository;

import com.jeeprojet.springboot.Model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;


@Repository
public interface AccountRepository extends JpaRepository<Account,Integer> {
    // Method to find an account by username and password
    @Query("SELECT a FROM Account a WHERE a.username = :username AND a.password = :password")
    Account findByUsernameAndPassword(@Param("username") String username, @Param("password") String password);

    // Method to get all usernames
    @Query("SELECT a.username FROM Account a")
    List<String> getAllUsernames();

}
