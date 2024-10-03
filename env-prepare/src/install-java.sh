#!/bin/bash
_m_='__@@__'

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  # "--sdkman-version${_m_}${_m_}SDKMan version.${_m_}"
  "--java-version${_m_}${_m_}Java version.${_m_}17.0.12-oracle"
  "--maven-version${_m_}${_m_}Maven version.${_m_}3.9.9"
  "--tomcat-version${_m_}${_m_}Tomcat version.${_m_}10.1.30"

  "--in-china${_m_}${_m_}Use the Chinese mirror.${_m_}false"
)

SUPPORT_OS_LIST=(
  "Ubuntu 20.04 AMD64"
  "Ubuntu 22.04 AMD64"
  "Ubuntu 24.04 AMD64"

  "Debian 11.9 AMD64"
  "Debian 12.2 AMD64"

  "Fedora 40 AMD64"

  "RedHat 8.5 AMD64"
  "RedHat 9.0 AMD64"

  "AlibabaCloudLinux 3.2104 AMD64"
)

SHELL_NAME="Java Installer"
SHELL_DESC="Install 'sdkman' 'java' and 'maven'."

source ./__judge-system.sh

source ./__console.sh

source ./__parse-user-paramter.sh

source ./__parse-paramter.sh

source ./__install.common.sh

print_help_or_param

sdkmanVersion=$(get_param '--sdkman-version')
sdkmanHome="${HOME}/.sdkman"

javaVersion=$(get_param '--java-version')
javaHome="${sdkmanHome}/candidates/java/${javaVersion}"

mavenVersion=$(get_param '--maven-version')
mavenHome="${sdkmanHome}/candidates/maven/${mavenVersion}"

tomcatVersion=$(get_param '--tomcat-version')
tomcatHome="${sdkmanHome}/candidates/tomcat/${tomcatVersion}"

inChina=$(get_param '--in-china')

# ------------------------------------------------------------

console_title "Install SDKMan"

if [[ -f "$sdkmanHome/bin/sdkman-init.sh" ]]; then
  console_content "SDKMan is already installed."
  source "$sdkmanHome/bin/sdkman-init.sh"
else
  console_content_starting "SDKMan is installing..."

  # Check Git is installed
  if ! command -v unzip &>/dev/null; then
    console_content_error "Not found unzip, please install unzip first."
    console_empty_line

    exit 1
  fi

  if ! command -v zip &>/dev/null; then
    console_content_error "Not found zip, please install zip first."
    console_empty_line

    exit 1
  fi

  if [ "$(get_param '--debug')" == 'true' ]; then
    curl -s "https://get.sdkman.io" | bash
  else
    curl -s "https://get.sdkman.io" | bash &>/dev/null
  fi

  console_content_complete
  source "$sdkmanHome/bin/sdkman-init.sh"
fi

console_key_value "SDKMan" "$(sdk version | grep -v 'SDKMAN!' | grep -v '^$' | tr '\n' ' ')"
console_key_value "SDKMan Home" "$sdkmanHome"
console_empty_line

# ------------------------------------------------------------

# Tomcat Version
# local versions="$(sdk list tomcat | awk '/^[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+/ {for(i=1;i<=NF;i++) print $i}'"

console_title "Install Java"

if [[ -f "$javaHome/README" ]]; then
  console_content "Java $javaVersion is already installed."
else
  console_content_starting "Java $javaVersion is installing..."

  support_versions="$(sdk list java | grep '|' | awk -F '|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $6); print $6}')"
  if echo "$support_versions" | grep -q "^${javaVersion}$"; then
    # sdk install java $javaVersion
    eval "sdk install java $javaVersion $(get_redirect_output)"
  else
    console_content_error "Java $javaVersion is not available."
    console_content "Support versions:"
    console_sulines "$support_versions"
    console_empty_line
    exit 1
  fi

  console_content_complete
fi

console_key_value "Java" "$(java --version | awk 'NR==1{print $2}')"
console_empty_line

# ------------------------------------------------------------

console_title "Install Maven"

if [[ -f "$mavenHome/README.txt" ]]; then
  console_content "Maven $mavenVersion is already installed."
else
  console_content_starting "Maven $mavenVersion is installing..."

  support_versions=$(sdk list maven | awk '/^[[:space:]]/ {for(i=1;i<=NF;i++) if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+/) print $i}')

  if echo "$support_versions" | grep -q "^${mavenVersion}$"; then
    # sdk install java $javaVersion
    eval "sdk install maven $mavenVersion $(get_redirect_output)"
  else
    console_content_error "Maven $mavenVersion is not available."
    console_content "Support versions:"
    console_sulines "$support_versions"
    console_empty_line
    exit 1
  fi

  console_content_complete
fi

console_key_value "Maven" "$(mvn -v | awk 'NR==1{print $3}')"
console_empty_line

# ------------------------------------------------------------

console_title "Install Tomcat"

if [[ -f "$tomcatHome/README.md" ]]; then
  console_content "Tomcat $tomcatVersion is already installed."
else
  console_content_starting "Tomcat $tomcatVersion is installing..."

  support_versions=$(sdk list tomcat | awk '/^[[:space:]]/ {for(i=1;i<=NF;i++) if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+/) print $i}')

  if echo "$support_versions" | grep -q "^${tomcatVersion}$"; then
    # sdk install java $javaVersion
    eval "sdk install tomcat $tomcatVersion $(get_redirect_output)"
  else
    console_content_error "Tomcat $tomcatVersion is not available."
    console_content "Support versions:"
    console_sulines "$support_versions"
    console_empty_line
    exit 1
  fi

  console_content_complete
fi

console_key_value "Maven" "$(mvn -v | awk 'NR==1{print $3}')"
console_empty_line

# ------------------------------------------------------------

console_end "Install complete."
