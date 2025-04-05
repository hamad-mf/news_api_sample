// To parse this JSON data, do
//
//     final allJobListingModel = allJobListingModelFromJson(jsonString);

import 'dart:convert';

AllJobListingModel allJobListingModelFromJson(String str) => AllJobListingModel.fromJson(json.decode(str));



class AllJobListingModel {
    int? status;
    List<AllJobs>? data;
    int? statusCode;

    AllJobListingModel({
        this.status,
        this.data,
        this.statusCode,
    });

    factory AllJobListingModel.fromJson(Map<String, dynamic> json) => AllJobListingModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<AllJobs>.from(json["data"]!.map((x) => AllJobs.fromJson(x))),
        statusCode: json["status_code"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status_code": statusCode,
    };
}

class AllJobs {
    String? id;
    String? title;
    String? jobCategory;
    String? salary;
    DateTime? jobDate;
    DateTime? jobCreated;

    AllJobs({
        this.id,
        this.title,
        this.jobCategory,
        this.salary,
        this.jobDate,
        this.jobCreated,
    });

    factory AllJobs.fromJson(Map<String, dynamic> json) => AllJobs(
        id: json["id"],
        title: json["title"],
        jobCategory: json["job_category"],
        salary: json["salary"],
        jobDate: json["job_date"] == null ? null : DateTime.parse(json["job_date"]),
        jobCreated: json["job_created"] == null ? null : DateTime.parse(json["job_created"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "job_category": jobCategory,
        "salary": salary,
        "job_date": "${jobDate!.year.toString().padLeft(4, '0')}-${jobDate!.month.toString().padLeft(2, '0')}-${jobDate!.day.toString().padLeft(2, '0')}",
        "job_created": jobCreated?.toIso8601String(),
    };
}
