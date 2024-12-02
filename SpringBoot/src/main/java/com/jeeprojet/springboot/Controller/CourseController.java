package com.jeeprojet.springboot.Controller;


import com.jeeprojet.springboot.Model.Course;
import com.jeeprojet.springboot.Model.Professor;
import com.jeeprojet.springboot.Repository.CourseRepository;
import com.jeeprojet.springboot.Repository.ProfessorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/course")
public class CourseController {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private ProfessorRepository professorRepository;

    @GetMapping("/list")
    public String listCourses(Model model) {
        List<Course> courses = courseRepository.findAll();
        model.addAttribute("courses", courses);
        return "admin/SubjectManagement";
    }

    @GetMapping("/listByProfessor/{professorId}")
    public String listCoursesByProfessor(@PathVariable int professorId, Model model) {
        List<Course> coursesList = courseRepository.findByProfessorId(professorId);
        model.addAttribute("coursesList", coursesList);
        return "professor/ProfessorCourses";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable int id, Model model) {
        Course course = courseRepository.findById(id).orElse(null);
        if (course != null) {
            model.addAttribute("course", course);
            return "admin/EditCourse";
        } else {
            return "redirect:/course/list";
        }
    }

    @PostMapping("/update")
    public String updateCourse(@RequestParam int id,
                               @RequestParam String title,
                               @RequestParam String description,
                               @RequestParam double credit,
                               @RequestParam String speciality) {
        Course updatedCourse = new Course();
        updatedCourse.setId(id);
        updatedCourse.setTitle(title);
        updatedCourse.setDescription(description);
        updatedCourse.setCredit(credit);
        updatedCourse.setSpeciality(speciality);
        courseRepository.save(updatedCourse);
        return "redirect:/course/list";
    }

    @GetMapping("/add")
    public String showAddForm() {
        return "admin/AddCourse";
    }

    @PostMapping("/save")
    public String saveCourse(@RequestParam String title,
                             @RequestParam String description,
                             @RequestParam double credit,
                             @RequestParam String speciality) {
        Course newCourse = new Course();
        newCourse.setTitle(title);
        newCourse.setDescription(description);
        newCourse.setCredit(credit);
        newCourse.setSpeciality(speciality);

        courseRepository.save(newCourse);
        return "redirect:/course/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteCourse(@PathVariable int id) {
        courseRepository.deleteById(id);
        return "redirect:/course/list";
    }
}

