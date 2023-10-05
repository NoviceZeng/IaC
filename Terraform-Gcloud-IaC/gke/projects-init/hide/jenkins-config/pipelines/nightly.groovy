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
    stage('Fetch Code') {
      container('gcloud') {
        sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
        sh 'gcloud source repos clone [REPO-NAME] . --project=[YOUR REPO PROJECT]' <<<<
        sh "git checkout ${SOURCE_BRANCH}"
      }
      env.GIT_COMMIT=sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
    }
    stage('Build Image') {
      container('kaniko') {
      // sh 'printenv' // great for debugging
        sh "/kaniko/executor -c `pwd` --dockerfile=Dockerfile --destination=\"asia.gcr.io/yourproject/image-name:${BUILD_NUMBER}.${GIT_COMMIT}\"" <<<<<
      }
      sh 'printenv'
      sh 'echo $GIT_COMMIT'
    }
    stage('Apply Nightly Tag') {
      container('gcloud') {
        sh 'git tag -f nightly'
        sh 'git push -f origin nightly '
      }
    }
    stage('Render YAML'){
      container('kustomize') {
        sh "PATH=/app:$PATH sh finish.sh -d nightly -b ${ARTIFACT_BUCKET}"
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