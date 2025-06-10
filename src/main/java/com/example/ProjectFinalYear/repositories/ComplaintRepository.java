package com.example.ProjectFinalYear.repositories;

import com.example.ProjectFinalYear.model.Complaint;
import java.util.List;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ComplaintRepository extends MongoRepository<Complaint, String> {
    List<Complaint> findByStudentId(String studentId);
}
