podTemplate(yaml: """
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: IfNotPresent
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: gcp-secret
        mountPath: /secret
    env:
      - name: GOOGLE_APPLICATION_CREDENTIALS
        value: /secret/gcp-key.json
  - name: gcloud
    image: gcr.io/cloud-builders/gcloud
    imagePullPolicy: IfNotPresent
    command:
    - cat
    tty: true
    volumeMounts:
      - name: gcp-secret
        mountPath: /secret
    env:
      - name: GOOGLE_APPLICATION_CREDENTIALS
        value: /secret/gcp-key.json
  - name: kustomize
    image: k8s.gcr.io/kustomize/kustomize:v3.8.7
    imagePullPolicy: IfNotPresent
    command:
    - cat
    tty: true
  volumes:
    - name: gcp-secret
      secret:
        secretName: gcp-secret
"""
  ) {
  node(POD_LABEL) {
    stage("Fetch Code") {
      container('gcloud') {
        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
        sh 'gcloud source repos clone [YOUR REPO] . --project=[your project] <<<'
      }
    }
    stage ("Merge Source Branch into Main Branch") {
      container('gcloud') {
        sh 'git checkout ${MERGE_BRANCH}'
        sh "git fetch origin ${SOURCE_BRANCH}"
        sh "git merge origin/${SOURCE_BRANCH}"
        sh 'git branch'
      }
      env.GIT_COMMIT=sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
    }
    stage('Build and Push Docker Image') {
      container('kaniko') {
        sh "/kaniko/executor -c `pwd` --dockerfile=Dockerfile --destination=\"asia.gcr.io/project/image-name:${BUILD_NUMBER}.${GIT_COMMIT}\"" <<<<
      }
    }
    stage("Push Git Branch and Tags") {
      container('gcloud') {
        sh "git push origin ${MERGE_BRANCH}"
        sh 'git tag -f v${RELEASE_VERSION}'
        sh 'git push -f origin v${RELEASE_VERSION}'
      }
    }
    stage('Render YAML'){
      container('kustomize') {
        sh "PATH=/app:$PATH sh finish.sh -d prod -b ${ARTIFACT_BUCKET}"
      }       
    }
    stage('Upload Artifacts To GCS'){
      env.GCS_DIR = "gs://${ARTIFACT_BUCKET}/${JOB_NAME}/${BUILD_NUMBER}.${GIT_COMMIT}"
      container('gcloud') {
        sh "gsutil cp -r generated/ ${GCS_DIR}"
      }
      archiveArtifacts artifacts: 'generated/*', followSymlinks: false     
    }
  }
}