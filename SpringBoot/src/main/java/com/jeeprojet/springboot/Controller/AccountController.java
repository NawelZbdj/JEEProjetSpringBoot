package com.jeeprojet.springboot.Controller;

import com.jeeprojet.springboot.Model.Account;
import com.jeeprojet.springboot.Model.Administrator;
import com.jeeprojet.springboot.Model.Professor;
import com.jeeprojet.springboot.Model.Student;
import com.jeeprojet.springboot.Repository.AccountRepository;
import com.jeeprojet.springboot.Repository.AdministratorRepository;
import com.jeeprojet.springboot.Repository.ProfessorRepository;
import com.jeeprojet.springboot.Repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;

@Controller
@SessionAttributes({"user", "role"})
public class AccountController {

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private AdministratorRepository administratorRepository;

    @Autowired
    private ProfessorRepository professorRepository;

    @PostMapping("/login")
    public String loginByRole(@RequestParam String username,
                              @RequestParam String password,
                              @RequestParam(required = false) String role,
                              Model model) {
        Account account = accountRepository.findByUsernameAndPassword(username, password);

        if (account == null) {
            model.addAttribute("errorMessage", "Unknown username or password.");
            return "redirect:/login";
        }

        model.addAttribute("user", account);
        model.addAttribute("role", role);

        switch (role) {
            case "admin":
                Administrator admin = administratorRepository.findByAccountId(account.getId());
                model.addAttribute("user", admin);
                return "redirect:/admin/menu";

            case "professor":
                Professor professor = professorRepository.findByAccountId(account.getId());
                model.addAttribute("user", professor);
                return "redirect:/professor/menu";

            case "student":
                Student student = studentRepository.findByAccountId(account.getId());
                model.addAttribute("user", student);
                return "redirect:/student/menu";

            default:
                return "redirect:/menu";
        }
    }

    @GetMapping("/logout")
    public String logout(SessionStatus sessionStatus) {
        sessionStatus.setComplete(); // Clear session attributes
        return "redirect:/login";
    }
}
