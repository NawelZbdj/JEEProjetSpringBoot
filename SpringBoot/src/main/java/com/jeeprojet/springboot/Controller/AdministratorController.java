package com.jeeprojet.springboot.Controller;

import com.jeeprojet.springboot.Model.Account;
import com.jeeprojet.springboot.Model.Administrator;
import com.jeeprojet.springboot.Repository.AccountRepository;
import com.jeeprojet.springboot.Repository.AdministratorRepository;
import com.jeeprojet.springboot.Utils.AccountUtils.PasswordGenerator;
import com.jeeprojet.springboot.Utils.AccountUtils.UsernameGenerator;
import com.jeeprojet.springboot.Utils.EmailUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdministratorController {

    @Autowired
    private AdministratorRepository administratorRepository;

    @Autowired
    private AccountRepository accountRepository;

    @GetMapping
    public String listAdministrators(Model model) {
        List<Administrator> administrators = administratorRepository.findAll();
        model.addAttribute("administrators", administrators);
        return "admin/AdminManagement";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("admin", new Administrator());
        return "admin/AddAdmin";
    }

    @PostMapping("/add")
    public String addAdministrator(@ModelAttribute Administrator admin, @RequestParam("birthDate") String birthDateStr, Model model) {
        try {
            Date birthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDateStr);
            admin.setBirthDate(birthDate);
        } catch (ParseException e) {
            model.addAttribute("error", "Invalid birth date format.");
            return "admin/AddAdmin";
        }

        // Generate username and password
        String username = UsernameGenerator.generateUsername(admin.getFirstName(), admin.getLastName());
        String password = PasswordGenerator.generateRandomPassword();

        // Create and save the Account entity
        Account adminAccount = new Account();
        adminAccount.setUsername(username);
        adminAccount.setPassword(password);
        adminAccount.setRole("admin");

        accountRepository.save(adminAccount);

        // Associate the Administrator entity with the Account
        admin.setAccount(adminAccount);

        // Save Administrator
        administratorRepository.save(admin);

        // Send email
        String subject = "sColartiY: Account Created!";
        String body = "Welcome " + admin.getFirstName() + ",\n\n" +
                "You are now part of our staff as a " + admin.getPosition() +
                ". Here are your connection details:\n\n" +
                "Username: " + adminAccount.getUsername() +
                "\nPassword: " + adminAccount.getPassword() +
                "\n\nBest Regards,\nAdmin staff.";

        try {
            EmailUtil.sendEmail(admin.getEmail(), subject, body);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/admin";
    }

    @GetMapping("/update/{id}")
    public String showUpdateForm(@PathVariable("id") int id, Model model) {
        Administrator admin = administratorRepository.findById(id).orElse(null);
        if (admin == null) {
            return "redirect:/admin";
        }
        model.addAttribute("admin", admin);
        return "admin/UpdateAdmin";
    }

    @PostMapping("/update/{id}")
    public String updateAdministrator(@PathVariable("id") int id, @ModelAttribute Administrator admin, @RequestParam("birthDate") String birthDateStr, Model model) {
        Administrator existingAdmin = administratorRepository.findById(id).orElse(null);
        if (existingAdmin == null) {
            return "redirect:/admin";
        }

        try {
            Date birthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDateStr);
            admin.setBirthDate(birthDate);
        } catch (ParseException e) {
            model.addAttribute("error", "Invalid birth date format.");
            return "admin/UpdateAdmin";
        }

        existingAdmin.setFirstName(admin.getFirstName());
        existingAdmin.setLastName(admin.getLastName());
        existingAdmin.setEmail(admin.getEmail());
        existingAdmin.setPosition(admin.getPosition());
        existingAdmin.setBirthDate(admin.getBirthDate());

        administratorRepository.save(existingAdmin);
        return "redirect:/admin";
    }

    @GetMapping("/delete/{id}")
    public String deleteAdministrator(@PathVariable("id") int id) {
        administratorRepository.deleteById(id);
        return "redirect:/admin";
    }

    @GetMapping("/search")
    public String searchAdministrators(@RequestParam("keyword") String keyword, @RequestParam("position") String position, Model model) {
        List<Administrator> administrators = administratorRepository.searchByKeywordAndPosition(keyword, position);
        model.addAttribute("administrators", administrators);
        return "admin/AdminManagement";
    }
}
