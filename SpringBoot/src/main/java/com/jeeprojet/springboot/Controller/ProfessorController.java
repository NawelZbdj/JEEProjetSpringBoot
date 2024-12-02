package com.jeeprojet.springboot.Controller;

import com.jeeprojet.springboot.Model.Account;
import com.jeeprojet.springboot.Model.Professor;
import com.jeeprojet.springboot.Repository.AccountRepository;
import com.jeeprojet.springboot.Repository.ProfessorRepository;
import com.jeeprojet.springboot.Utils.AccountUtils.PasswordGenerator;
import com.jeeprojet.springboot.Utils.AccountUtils.UsernameGenerator;
import com.jeeprojet.springboot.Utils.EmailUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/professor")
public class ProfessorController {

    @Autowired
    private ProfessorRepository professorRepository;

    @Autowired
    private AccountRepository accountRepository;

    @GetMapping
    public String listProfessors(Model model) {
        List<Professor> professors = professorRepository.findAll();
        model.addAttribute("professors", professors);
        return "admin/ProfessorsManagement"; // JSP/HTML view name
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("professor", new Professor());
        return "admin/AddProfessor"; // JSP/HTML view name
    }

    @PostMapping("/add")
    public String addProfessor(@ModelAttribute Professor professor, @RequestParam("birthDate") String birthDateString) {
        Date birthDate;

        try {
            birthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDateString);
            professor.setBirthDate(birthDate);
        } catch (ParseException e) {
            throw new RuntimeException("Invalid birth date format.");
        }

        // Generate username and password
        String username = UsernameGenerator.generateUsername(professor.getFirstName(), professor.getLastName());
        String password = PasswordGenerator.generateRandomPassword();

        // Create and save the Account entity
        Account professorAccount = new Account();
        professorAccount.setUsername(username);
        professorAccount.setPassword(password);
        professorAccount.setRole("professor");

        accountRepository.save(professorAccount);

        professor.setAccount(professorAccount);

        professorRepository.save(professor);

        // Send email
        String subject = "sColartiY: Account created!";
        String body = String.format("Welcome %s,\n\nYou are now part of our teaching team in %s.\n" +
                        "Here are your connection details:\n\nUsername: %s\nPassword: %s\n\nBest Regards,\nAdmin staff.",
                professor.getFirstName(), professor.getSpecialty(), professorAccount.getUsername(), professorAccount.getPassword());

        try {
            EmailUtil.sendEmail(professor.getEmail(), subject, body);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/professor";
    }

    @GetMapping("/edit/{id}")
    public String showUpdateForm(@PathVariable int id, Model model) {
        Professor professor = professorRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid professor ID: " + id));
        model.addAttribute("professor", professor);
        return "admin/UpdateProfessor"; // JSP/HTML view name
    }

    @PostMapping("/edit/{id}")
    public String updateProfessor(@PathVariable int id, @ModelAttribute Professor updatedProfessor,
                                  @RequestParam("birthDate") String birthDateString) {
        Professor professor = professorRepository.findById(id).orElseThrow();

        try {
            Date birthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDateString);
            updatedProfessor.setBirthDate(birthDate);
        } catch (ParseException e) {
            throw new RuntimeException("Invalid birth date format.");
        }

        professor.setFirstName(updatedProfessor.getFirstName());
        professor.setLastName(updatedProfessor.getLastName());
        professor.setEmail(updatedProfessor.getEmail());
        professor.setSpecialty(updatedProfessor.getSpecialty());
        professor.setBirthDate(updatedProfessor.getBirthDate());

        professorRepository.save(professor);
        return "redirect:/professor";
    }

    @GetMapping("/delete/{id}")
    public String deleteProfessor(@PathVariable int id) {
        professorRepository.deleteById(id);
        return "redirect:/professor";
    }

    @GetMapping("/search")
    public String searchProfessors(@RequestParam("keyword") String keyword,
                                   @RequestParam("specialty") String specialty,
                                   Model model) {
        List<Professor> professors = professorRepository.searchByKeywordAndSpecialty(keyword, specialty);
        model.addAttribute("professors", professors);
        return "admin/ProfessorsManagement";
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }
}
