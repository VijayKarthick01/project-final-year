package com.example.ProjectFinalYear.service;

import com.example.ProjectFinalYear.model.StaffFormField;
import org.springframework.stereotype.Service;
import java.util.Arrays;
import java.util.List;

@Service
public class StaffFormMetadataService {

    // 📌 Attendance Form
    public List<StaffFormField> getAttendanceFormFields() {
        return Arrays.asList(
            new StaffFormField("id1", "studentId", "text", "Enter Student ID", "Student ID", true, null),
            new StaffFormField("id2", "date", "date", "Select Date", "Date", true, null),
            new StaffFormField("id3", "status", "dropdown", "Select Attendance Status", "Status", true,
                Arrays.asList("Present", "Absent", "Late")),
            new StaffFormField("id4", "section", "dropdown", "Select Section", "Section", true,
                Arrays.asList("A", "B", "C")) // Dropdown options for section
        );
    }
    

    // 📌 Complaint Response Form
    public List<StaffFormField> getComplaintResponseFormFields() {
        return Arrays.asList(
            new StaffFormField("id4", "complaintId", "text", "Enter Complaint ID", "Complaint ID", true, null),
            new StaffFormField("id5", "response", "textarea", "Enter Response", "Response", true, null)
        );
    }

    // 📌 Event Creation Form
    public List<StaffFormField> getEventFormFields() {
        return Arrays.asList(
            new StaffFormField("id6", "title", "text", "Enter Event Title", "Title", true, null),
            new StaffFormField("id7", "description", "textarea", "Enter Event Description", "Description", true, null),
            new StaffFormField("id8", "date", "date", "Select Event Date", "Date", true, null)
        );
    }
}
