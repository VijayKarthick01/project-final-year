package com.example.ProjectFinalYear.controller;



import com.example.ProjectFinalYear.model.Attendance;
import com.example.ProjectFinalYear.model.Complaint;
import com.example.ProjectFinalYear.model.Event;
import com.example.ProjectFinalYear.service.StaffService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/staff")
@PreAuthorize("hasAuthority('STAFF')") // ✅ Use "STAFF"
@CrossOrigin(origins = "http://192.168.201.189:53696")
@RequiredArgsConstructor
public class StaffController {

    private final StaffService staffService;

    // 📌 Attendance Management
    @PostMapping("/attendance/add")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<String> addAttendance(@RequestBody Attendance attendance) {
        staffService.addAttendance(attendance);
        return ResponseEntity.ok("Attendance added successfully");
    }
//fillter
// @GetMapping("/attendance/by-date-section")
// @CrossOrigin(origins = "http://192.168.201.189:53696")
// public ResponseEntity<List<Attendance>> getAttendanceByDateAndSection(
//         @RequestParam String date,
//         @RequestParam String section) {
//     return ResponseEntity.ok(staffService.getAttendanceByDateAndSection(date, section));
// }
@GetMapping("/attendance/by-date-section")
@CrossOrigin(origins = "http://192.168.201.189:53696")
public ResponseEntity<List<Attendance>> getAttendanceByDateAndSection(
        @RequestParam String date,
        @RequestParam String section) {
    return ResponseEntity.ok(staffService.getAttendanceByDateAndSection(date, section));
}

// GET http://192.168.201.189:8080/api/staff/attendance/by-date-section?date=2025-04-03&section=A


    


    @PutMapping("/attendance/update/{id}")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<String> updateAttendance(@PathVariable String id, @RequestBody Attendance attendance) {
        staffService.updateAttendance(id, attendance);
        return ResponseEntity.ok("Attendance updated successfully");
    }

    @GetMapping("/attendance/view/{studentId}")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<List<Attendance>> viewStudentAttendance(@PathVariable String studentId) {
        return ResponseEntity.ok(staffService.getStudentAttendance(studentId));
    }

    // 📌 Complaint Management
    @GetMapping("/complaints")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<List<Complaint>> getAllComplaints() {
        return ResponseEntity.ok(staffService.getAllComplaints());
    }

    @PostMapping("/complaints/respond/{id}")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<String> respondToComplaint(@PathVariable String id, @RequestBody String response) {
        staffService.respondToComplaint(id, response);
        return ResponseEntity.ok("Complaint responded successfully");
    }

    // 📌 Event Management
    @PostMapping("/events/add")

@CrossOrigin(origins = "http://192.168.201.189:53696")   
 public ResponseEntity<String> createEvent(@RequestBody Event event) {
        staffService.createEvent(event);
        return ResponseEntity.ok("Event created successfully");
    }

    @GetMapping("/events")
    
@CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<List<Event>> getAllEvents() {
        return ResponseEntity.ok(staffService.getAllEvents());
    }
}

