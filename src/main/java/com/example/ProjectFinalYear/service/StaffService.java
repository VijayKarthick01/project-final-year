package com.example.ProjectFinalYear.service;

import com.example.ProjectFinalYear.model.Attendance;
import com.example.ProjectFinalYear.model.Complaint;
import com.example.ProjectFinalYear.model.Event;
import com.example.ProjectFinalYear.repositories.AttendanceRepository;
import com.example.ProjectFinalYear.repositories.ComplaintRepository;
import com.example.ProjectFinalYear.repositories.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import jakarta.annotation.PostConstruct; // Add this import at the top
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor

public class StaffService {

    private final AttendanceRepository attendanceRepository;
    private final ComplaintRepository complaintRepository;
    private final EventRepository eventRepository;

    // 📌 Attendance Management
    // public void addAttendance(Attendance attendance) {
    //     attendanceRepository.save(attendance);
     @PostConstruct
    public void initDummyComplaints() {
        if (complaintRepository.count() == 0) { // Prevents duplicates on restart
            Complaint c1 = new Complaint();
            c1.setId("c1");
            c1.setStudentId("S001");
            c1.setMessage("Fan not working");
            c1.setStatus("Open");
            c1.setResponse(null);

            Complaint c2 = new Complaint();
            c2.setId("c2");
            c2.setStudentId("S002");
            c2.setMessage("Light flickering");
            c2.setStatus("Open");
            c2.setResponse(null);

            complaintRepository.save(c1);
            complaintRepository.save(c2);
        }
    }
    // }
public void addAttendance(Attendance attendance) {
    if (attendance.getId() == null || attendance.getId().isEmpty()) {
        attendance.setId(UUID.randomUUID().toString().replace("-", ""));
    }

    System.out.println("Saving: " + attendance); // Debug
    attendanceRepository.save(attendance);
}


    public void updateAttendance(String id, Attendance updatedAttendance) {
        Optional<Attendance> existingAttendance = attendanceRepository.findById(id);
        if (existingAttendance.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Attendance record not found!");
        }
        Attendance attendance = existingAttendance.get();
        attendance.setStatus(updatedAttendance.getStatus());
        attendanceRepository.save(attendance);
    }
    // public List<Attendance> getAttendanceByDateAndSection(String date, String section) {
    //     return attendanceRepository.findByDateAndSection(date, section);
    // }
    public List<Attendance> getAttendanceByDateAndSection(String date, String section) {
    System.out.println("Querying for date=" + date + ", section=" + section);
    List<Attendance> result = attendanceRepository.findByDateAndSection(date, section);
    System.out.println("Result: " + result);
    return result;
}

    
    
    
    
    
    public List<Attendance> getStudentAttendance(String studentId) {
        return attendanceRepository.findByStudentId(studentId);
    }

    // 📌 Complaint Management
    public List<Complaint> getAllComplaints() {
        return complaintRepository.findAll();
    }

    public void respondToComplaint(String complaintId, String response) {
        Optional<Complaint> complaintOpt = complaintRepository.findById(complaintId);
        if (complaintOpt.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Complaint not found!");
        }
        Complaint complaint = complaintOpt.get();
        complaint.setResponse(response);
        complaintRepository.save(complaint);
    }

    // 📌 Event Management
    public void createEvent(Event event) {
        eventRepository.save(event);
    }

    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }
}

