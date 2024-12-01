package com.jeeprojet.springboot.Controller;

import com.jeeprojet.springboot.Model.Administrator;
import com.jeeprojet.springboot.Repository.AdministratorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdministratorController {

    @Autowired
    private AdministratorRepository administratorRepository;

    @GetMapping("/admin/details")
    public String showAdministratorDetails(Model model) {
        // Récupérer un administrateur de la base de données
        Administrator administrator = administratorRepository.findById(1).orElse(null);

        // Ajouter l'administrateur au modèle
        model.addAttribute("administrator", administrator);

        // Retourner la vue JSP
        return "admin/administratorDetails";
    }
}

