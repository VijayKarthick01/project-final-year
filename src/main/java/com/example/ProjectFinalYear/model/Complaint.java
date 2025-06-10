// package com.example.ProjectFinalYear.model;

// import lombok.Data;
// import org.springframework.data.annotation.Id;
// import org.springframework.data.mongodb.core.mapping.Document;

// @Document(collection = "complaints")
// @Data
// public class Complaint {
//     @Id
//     private String id;
//     private String studentId;
//     private String message;
//     private String status;    // Add this field
//     private String response;  // Staff's response to the complaint
// }
package com.example.ProjectFinalYear.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "complaints")
@Data
public class Complaint {
    @Id
    private String id;
    private String studentId;
    private String message;
    private String status;       // e.g., "Pending", "Resolved"
    private String response;     // Staff's response to the complaint

    private LocalDateTime submittedAt;  // ✅ Add this field
}
