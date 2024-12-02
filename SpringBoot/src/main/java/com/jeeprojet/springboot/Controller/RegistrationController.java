package com.jeeprojet.springboot.Controller;

import com.jeeprojet.springboot.Model.Course;
import com.jeeprojet.springboot.Model.Professor;
import com.jeeprojet.springboot.Model.Registration;
import com.jeeprojet.springboot.Model.Student;
import com.jeeprojet.springboot.Repository.CourseRepository;
import com.jeeprojet.springboot.Repository.ProfessorRepository;
import com.jeeprojet.springboot.Repository.RegistrationRepository;
import com.jeeprojet.springboot.Repository.StudentRepository;
import com.jeeprojet.springboot.Utils.EmailUtil;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/registration")
public class RegistrationController {

    @Autowired
    private RegistrationRepository registrationRepository;

    @Autowired
    private ProfessorRepository professorRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private StudentRepository studentRepository;

    @GetMapping("/menu")
    public String showMenu() {
        return "admin/CoursesManagementMenu";
    }

    @GetMapping("/listall")
    public String listRegistrationsAndProfessors(Model model) {
        List<Registration> registrations = registrationRepository.findAllRegistrations();
        List<Professor> professors = professorRepository.findAll();
        model.addAttribute("registrations", registrations);
        model.addAttribute("professors", professors);
        return "admin/CourseAssignment";
    }

    @GetMapping("/listByStudent/{studentId}")
    public String listRegistrationsByStudent(@PathVariable int studentId, Model model) {
        List<Registration> registrations = registrationRepository.findByStudentId(studentId);
        model.addAttribute("registrations", registrations);
        return "student/RegistrationManagement";
    }

    @GetMapping("/add/{studentId}/{courseId}")
    public String addRegistration(@PathVariable int studentId,@PathVariable int courseId) {
        Course course = courseRepository.findById(courseId).orElse(null);
        Student student = studentRepository.findById(studentId).orElse(null);

        Registration registration = new Registration();
        registration.setCourse(course);
        registration.setStudent(student);
        registration.setRegistrationDate(new Date());
        registrationRepository.save(registration);

        return "redirect:/registration/listByStudent/"+studentId;
    }

    @PostMapping("/update")
    public String updateRegistration(@RequestParam int registrationId, @RequestParam int idProfessor) {
        Registration registration = registrationRepository.findById(registrationId).orElse(null);
        Professor professor = professorRepository.findById(idProfessor).orElse(null);

        if (registration != null && professor != null) {
            registration.setProfessor(professor);
            registrationRepository.save(registration);

            String subject = "Registration Update: " + registration.getCourse().getTitle();
            String body = "Hello " + registration.getStudent().getFirstName() + ",\n\n" +
                    "Your registration has been updated. Your professor is now " + professor.getFirstName() + " " + professor.getLastName() + ".\n\nBest Regards, Admin";
            EmailUtil.sendEmail(registration.getStudent().getEmail(), subject, body);
        }
        return "redirect:/registration/listall";
    }

    @PostMapping("/multiupdate")
    public String updateManyRegistrations(@RequestParam("idProfessor") int professorId, @RequestParam("registrationsList") List<Integer> registrationIds) {

        if(professorId == 0){
            return "redirect:/registration/listall";
        }
        Professor professor = professorRepository.findById(professorId).orElse(null);

        if (professor != null) {
            for (Integer registrationId : registrationIds) {
                Registration registration = registrationRepository.findById(registrationId).orElse(null);
                if (registration != null) {
                    registration.setProfessor(professor);
                    registrationRepository.save(registration);

                    String subject = "Registration Update: " + registration.getCourse().getTitle();
                    String body = "Hello " + registration.getStudent().getFirstName() + ",\n\n" +
                            "Your registration has been updated. Your professor is now " + professor.getFirstName() + " " + professor.getLastName() + ".\n\nBest Regards, Admin";
                    EmailUtil.sendEmail(registration.getStudent().getEmail(), subject, body);
                }
            }
        }
        return "redirect:/registration/listall";
    }

    @GetMapping("/delete/{id}/{studentId}")
    public String deleteRegistration(@PathVariable int id,@PathVariable int studentId) {
        registrationRepository.deleteById(id);
        return "redirect:/registration/listByStudent/"+studentId;
    }

    @GetMapping("/listByProfessor/{professorId}")
    public String listRegistrationsByProfessor(Model model, @PathVariable int professorId) {
        List<Registration> registrations = registrationRepository.findByProfessorId(professorId);
        model.addAttribute("registrations", registrations);
        return "professor/CoursesDisplay";
    }

    @GetMapping("/listByStudentWithCourses/{studentId}")
    public String listRegistrationsByStudentWithCourses(@PathVariable int studentId, Model model) {

        List<Course> coursesList = courseRepository.findAll();
        model.addAttribute("courses", coursesList);

        List<Registration> registrationsListByStudentId = registrationRepository.findByStudentId(studentId);
        model.addAttribute("registrations", registrationsListByStudentId);

        return "student/NewRegistration";
    }

}
