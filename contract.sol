Run fortify/github-action@a92347297e02391b857e7015792cd1926a4cd418
  with:
    sast-scan: true
  env:
    JAVA_HOME: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    JAVA_HOME_17_X64: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    FOD_URL: https://ams.fortify.com
    FOD_TENANT: 
    FOD_USER: 
    FOD_PASSWORD: 
Run fortify/github-action/fod-sast-scan@v1.2.2
  env:
    JAVA_HOME: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    JAVA_HOME_17_X64: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    FOD_URL: https://ams.fortify.com
    FOD_TENANT: 
    FOD_USER: 
    FOD_PASSWORD: 
Run fortify/github-action/internal/set-fod-var-defaults@v1.2.2
  env:
    JAVA_HOME: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    JAVA_HOME_17_X64: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    FOD_URL: https://ams.fortify.com
    FOD_TENANT: 
    FOD_USER: 
    FOD_PASSWORD: 
Run export FOD_RELEASE="${APP}:${REL}"
  export FOD_RELEASE="${APP}:${REL}"
  echo FOD_RELEASE=$FOD_RELEASE >> $GITHUB_ENV
  echo "Configured default value for FOD_RELEASE: ${FOD_RELEASE}"
  shell: /usr/bin/bash --noprofile --norc -e -o pipefail {0}
  env:
    JAVA_HOME: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    JAVA_HOME_17_X64: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    FOD_URL: https://ams.fortify.com
    FOD_TENANT: 
    FOD_USER: 
    FOD_PASSWORD: 
    APP: zk4stv/vote
    REL: main
Configured default value for FOD_RELEASE: zk4stv/vote:main
Run fortify/github-action/setup@v1.2.2
  with:
    export-path: false
    fcli: action-default
    sc-client: skip
    fod-uploader: skip
    vuln-exporter: skip
    bugtracker-utility: skip
    debricked-cli: skip
  env:
    JAVA_HOME: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    JAVA_HOME_17_X64: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.12-7/x64
    FOD_RELEASE: zk4stv/vote:main
    FOD_URL: https://ams.fortify.com
    FOD_TENANT: 
    FOD_USER: 
    FOD_PASSWORD: 
/usr/bin/tar xz --warning=no-unknown-keyword --overwrite -C /home/runner/work/_temp/fortify/tools/fcli/aHR0cHM6Ly9naXRodWIuY29tL2ZvcnRpZnkvZmNsaS9yZWxlYXNlcy9kb3dubG9hZC92Mi4zLjAvZmNsaS1saW51eC50Z3o=/bin -f /home/runner/work/_temp/9488ff5a-ad58-439b-9a6b-e89c6edd9a3f
/home/runner/work/_temp/fortify/tools/fcli/aHR0cHM6Ly9naXRodWIuY29tL2ZvcnRpZnkvZmNsaS9yZWxlYXNlcy9kb3dubG9hZC92Mi4zLjAvZmNsaS1saW51eC50Z3o=/bin/fcli tool definitions update --source /home/runner/work/_temp/fortify/tool-definitions/aHR0cHM6Ly9naXRodWIuY29tL2ZvcnRpZnkvdG9vbC1kZWZpbml0aW9ucy9yZWxlYXNlcy9kb3dubG9hZC92MS90b29sLWRlZmluaXRpb25zLnlhbWwuemlw.zip
 Name                       Source                          Last update       Action  
 tool-definitions.yaml.zip  /home/runner/work/_temp         2024-09-25 08:29  UPDATED 
                            /fortify/tool-definitions                                 
                            /aHR0cHM6Ly9naXRodWIuY29tL2Zvc                            
                            /nRpZnkvdG9vbC1kZWZpbml0aW9ucy                            
                            /9yZWxlYXNlcy9kb3dubG9hZC92MS9                            
                            /0b29sLWRlZmluaXRpb25zLnlhbWwu                            
                            /emlw.zip                                                 
 bugtracker-utility.yaml    tool-definitions.yaml.zip       2024-05-02 03:21  UPDATED 
 debricked-cli.yaml         tool-definitions.yaml.zip       2024-09-21 03:25  UPDATED 
 fcli.yaml                  tool-definitions.yaml.zip       2024-09-25 03:32  UPDATED 
 fod-uploader.yaml          tool-definitions.yaml.zip       2024-04-17 03:20  UPDATED 
 sc-client.yaml             tool-definitions.yaml.zip       2024-05-23 18:10  UPDATED 
 vuln-exporter.yaml         tool-definitions.yaml.zip       2024-06-21 13:00  UPDATED 

Run fortify/github-action/internal/fod-login@v1.2.2
Run if [ -z "$FOD_URL" ]; then
ERROR: Either FOD_CLIENT_ID and FOD_CLIENT_SECRET, or FOD_TENANT, FOD_USER and FOD_PASSWORD environment variables must be set
Error: Process completed with exit code 1.