/*
Authorizes the Compute Service Account with
 1. Big Query Data Viewer Role

 Authorizes the Instance Service Account with
 1. Big Query Read Session User Role

 This is for the following reason:
 1. The workbench UI uses the Compute Service Account to list the available Big Query Datasets
 2. The workbench UI uses the Compute Service Account to provide data preview on the available Big Query Datasets
 3. The Spark Clusters(via the Notebook and Workbench) uses the Instance Service Account to read Big Query Datasets

 Caveats
 1. It is the customers responsibility to authorize the Instance Service Account as a Data Viewer on the Individual Big Query Datasets
 2. This is because(as per docs):
                               When applied to a dataset, dataViewer provides permissions to:
                                   i. Read the dataset's metadata and to list tables in the dataset.
                                   ii. Read data and metadata from the dataset's tables.
                               When applied at the project or organization level, this role can also
                                   i. enumerate all datasets in the project.
                                   ii. Additional roles, however, are necessary to allow the running of jobs.
*/


resource "google_project_iam_binding" "auth_big_query_read_session_user_on_isa" {
    project = var.data_lake_project
    role = "roles/bigquery.readSessionUser"

    members = [
        "serviceAccount:${google_service_account.qubole_instance_service_acc.email}"
    ]
}

resource "google_project_iam_binding" "auth_big_query_data_viewer_on_isa" {
    project = var.data_lake_project
    role = "roles/bigquery.dataViewer"

    members = [
        "serviceAccount:${google_service_account.qubole_compute_service_acc.email}"
    ]
}
