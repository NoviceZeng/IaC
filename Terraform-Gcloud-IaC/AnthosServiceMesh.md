# ASM Information

## Prepare

1. Ensure that your cluster has the mesh-id label "mesh-id=$PROJECT_ID", eg "mesh-id=123456789". This can be added in the resource_labels section of the cluster terraform as shown [in cluster-a terraform](projects-init/non-prod-shared-clusters.tf).

2. Options:
   1.  Download the install_asm script, up to date instructions can be found [here](https://cloud.google.com/service-mesh/docs/scripted-install/asm-onboarding#downloading_the_script).
   2.  To use account impersonation and not download any keys run the following steps:
    ```sh
    # Configure gcloud to use SA impersonation, remember to use your SA email.
    gcloud config set auth/impersonate_service_account sh-resource-manager-may-2021@sh-resource-manager-may-2021.iam.gserviceaccount.com
    # Use this branch of script for the script to understand SA impersonation, otherwise
    # validation will fail.
    git clone https://github.com/ddlfcloud/anthos-service-mesh-packages.git
    cd anthos-service-mesh-packages
    git checkout handle-sa-impersonation
    ```

3. Create a directory in your $HOME directory called 'asm_output' to store the output of the install_asm script.

4. Run the following in your terminal, also replacing with your specific values:
   ```sh
   export PROJECT_ID=sh-non-prod-resources-may-2021
   export CLUSTER_NAME=cluster-a
   export CLUSTER_LOCATION=asia-east1
   export DIR_PATH=$HOME/asm_output
   ```

5. Validate that your cluster is prepared for ASM.

    ```sh
    ./install_asm \
    --project_id $PROJECT_ID \
    --cluster_name $CLUSTER_NAME \
    --cluster_location $CLUSTER_LOCATION \
    --mode install \
    --output_dir $DIR_PATH \
    --only_validate
    ```

  4. Check your output has a similar successful result:

     ```sh
     install_asm: Successfully validated all requirements to install ASM in this environment.
     ```