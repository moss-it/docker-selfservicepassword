#! /bin/bash
#
# entrypoint.sh
# Copyleft (ɔ) 2016 Thiago Almeida <thiagoalmeidasa@gmail.com>
#
# Distributed under terms of the GPLv2 license.
#
set -e

[[ -n $DEBUG_ENTRYPOINT ]] && set -x

## Setting up files and paths

touch /var/log/self-service-password && \
    chown www-data:www-data /var/log/self-service-password

TEMPLATE_PATH=/config.inc.php.template
CONFIG_PATH=/var/www/html/conf/config.inc.php

LDAP_SERVER=${LDAP_SERVER:-}
LDAP_STARTTLS=${LDAP_STARTTLS:-false}
LDAP_BINDDN=${LDAP_BINDDN:-}
LDAP_BINDPASS=${LDAP_BINDPASS:-}
LDAP_BASE_SEARCH=${LDAP_BASE_SEARCH:-}
LDAP_LOGIN_ATTRIBUTE=${LDAP_LOGIN_ATTRIBUTE:-'uid'}
LDAP_FULLNAME_ATTRIBUTE=${LDAP_FULLNAME_ATTRIBUTE:-'cn'}

# Active Directory mode
# true: use unicodePwd as password field
# false: LDAPv3 standard behavior
ADMODE=${ADMODE:-false}
# Force account unlock when password is changed
AD_OPT_FORCE_UNLOCK=${AD_OPT_FORCE_UNLOCK:-false}
# Force user change password at next login
AD_OPT_FORCE_PWD_CHANGE=${AD_OPT_FORCE_PWD_CHANGE:-false}
# Allow user with expired password to change password
AD_OPT_CHANGE_EXPIRED_PASSWORD=${AD_OPT_CHANGE_EXPIRED_PASSWORD:-false}

# Samba mode
# true: update sambaNTpassword and sambaPwdLastSet attributes too
# false: just update the password
SAMBA_MODE=${SAMBA_MODE:-false}

# Shadow options - require shadowAccount objectClass
# Update shadowLastChange
SHADOW_OPT_UPDATE_SHADOWLASTCHANGE=${SHADOW_OPT_UPDATE_SHADOWLASTCHANGE:-false}
# Hash mechanism for password:
# SSHA
# SHA
# SMD5
# MD5
# CRYPT
# clear (the default)
# auto (will check the hash of current password)
# This option is not used with ad_mode = true
PASSWORD_HASH=${PASSWORD_HASH:-'clear'}

# Local password policy
# This is applied before directory password policy
# Minimal length
PASSWORD_MIN_LENGTH=${PASSWORD_MIN_LENGTH:-0}
# Maximal length
PASSWORD_MAX_LENGTH=${PASSWORD_MAX_LENGTH:-0}
# Minimal lower characters
PASSWORD_MIN_LOWERCASE=${PASSWORD_MIN_LOWERCASE:-0}
# Minimal upper characters
PASSWORD_MIN_UPPERCASE=${PASSWORD_MIN_UPPERCASE:-0}
# Minimal digit characters
PASSWORD_MIN_DIGIT=${PASSWORD_MIN_DIGIT:-0}
# Minimal special characters
PASSWORD_MIN_SPECIAL=${PASSWORD_MIN_SPECIAL:-0}
# Dont reuse the same password as currently
PASSWORD_NO_REUSE=${PASSWORD_NO_REUSE:-true}
# Show policy constraints message:
# always
# never
# onerror
PASSWORD_SHOW_POLICY=${PASSWORD_SHOW_POLICY:-'never'}
# Position of password policy constraints message:
# above - the form
# below - the form
PASSWORD_SHOW_POLICY_POSITION=${PASSWORD_SHOW_POLICY_POSITION:-'above'}

# Who changes the password?
# Also applicable for question/answer save
# user: the user itself
# manager: the above binddn
WHO_CAN_CHANGE_PASSWORD=${WHO_CAN_CHANGE_PASSWORD:-'user'}


## Questions/answers
# Use questions/answers?
# true (default)
# false
QUESTIONS_ENABLED=${QUESTIONS_ENABLED:-true}

## Mail
# LDAP mail attribute
LDAP_MAIL_ATTRIBUTE=${LDAP_MAIL_ATTRIBUTE:-'mail'}
# Who the email should come from
MAIL_FROM=${MAIL_FROM:-'admin@example.com'}
MAIL_FROM_NAME=${MAIL_FROM_NAME:-'No Reply'}
# Notify users anytime their password is changed
NOTIFY_ON_CHANGE=${NOTIFY_ON_CHANGE:-false}
# PHPMailer configuration (see https://github.com/PHPMailer/PHPMailer)
SMTP_DEBUG=${SMTP_DEBUG:-0}
SMTP_HOST=${SMTP_HOST:-}
SMTP_AUTH_ON=${SMTP_AUTH_ON:-false}
SMTP_USER=${SMTP_USER:-}
SMTP_PASS=${SMTP_PASS:-}
SMTP_PORT=${SMTP_PORT:-587}
SMTP_SECURE_TYPE=${SMTP_SECURE_TYPE:-tls}

## SMS
# Use sms
USE_SMS=${USE_SMS:-false}

IS_BEHIND_PROXY=${IS_BEHIND_PROXY:-false}

if [[ ${IS_BEHIND_PROXY} == true  ]]; then
    sed  -i '188s .\{1\}  ' $TEMPLATE_PATH
fi

# Display help messages
SHOW_HELP=${SHOW_HELP:-true}

# Language
LANG=${LANG:-'en'}


# Debug mode
DEBUG_MODE=${DEBUG_MODE:-false}

# Encryption, decryption keyphrase
SECRETEKEY=${SECRETEKEY:-'secret'}

## CAPTCHA
# Use Google reCAPTCHA (http://www.google.com/recaptcha)
USE_RECAPTCHA=${USE_RECAPTCHA:-false}
# Go on the site to get public and private key
RECAPTCHA_PUB_KEY=${RECAPTCHA_PUB_KEY:-}
RECAPTCHA_PRIV_KEY=${RECAPTCHA_PRIV_KEY:-}

## Default action
# change
# sendtoken
# sendsms
DEFAULT_ACTION=${DEFAULT_ACTION:-'change'}


sed -i s#LDAP_SERVER#"${LDAP_SERVER}"# $TEMPLATE_PATH
sed -i s/LDAP_STARTTLS/"${LDAP_STARTTLS}"/ $TEMPLATE_PATH
sed -i s/LDAP_BINDDN/"${LDAP_BINDDN}"/ $TEMPLATE_PATH
sed -i s/LDAP_BINDPASS/"${LDAP_BINDPASS}"/ $TEMPLATE_PATH
sed -i s/LDAP_BASE_SEARCH/"${LDAP_BASE_SEARCH}"/ $TEMPLATE_PATH
sed -i s/LDAP_LOGIN_ATTRIBUTE/"${LDAP_LOGIN_ATTRIBUTE}"/ $TEMPLATE_PATH
sed -i s/LDAP_FULLNAME_ATTRIBUTE/"${LDAP_FULLNAME_ATTRIBUTE}"/ $TEMPLATE_PATH
sed -i s/ADMODE/"${ADMODE}"/ $TEMPLATE_PATH
sed -i s/AD_OPT_FORCE_UNLOCK/"${AD_OPT_FORCE_UNLOCK}"/ $TEMPLATE_PATH
sed -i s/AD_OPT_FORCE_PWD_CHANGE/"${AD_OPT_FORCE_PWD_CHANGE}"/ $TEMPLATE_PATH
sed -i s/AD_OPT_CHANGE_EXPIRED_PASSWORD/"${AD_OPT_CHANGE_EXPIRED_PASSWORD}"/ $TEMPLATE_PATH
sed -i s/SAMBA_MODE/"${SAMBA_MODE}"/ $TEMPLATE_PATH
sed -i s/SHADOW_OPT_UPDATE_SHADOWLASTCHANGE/"${SHADOW_OPT_UPDATE_SHADOWLASTCHANGE}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_HASH/"${PASSWORD_HASH}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_MIN_LENGTH/"${PASSWORD_MIN_LENGTH}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_MAX_LENGTH/"${PASSWORD_MAX_LENGTH}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_MIN_LOWERCASE/"${PASSWORD_MIN_LOWERCASE}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_MIN_UPPERCASE/"${PASSWORD_MIN_UPPERCASE}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_MIN_DIGIT/"${PASSWORD_MIN_DIGIT}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_MIN_SPECIAL/"${PASSWORD_MIN_SPECIAL}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_NO_REUSE/"${PASSWORD_NO_REUSE}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_SHOW_POLICY_POSITION/"${PASSWORD_SHOW_POLICY_POSITION}"/ $TEMPLATE_PATH
sed -i s/PASSWORD_SHOW_POLICY/"${PASSWORD_SHOW_POLICY}"/ $TEMPLATE_PATH
sed -i s/WHO_CAN_CHANGE_PASSWORD/"${WHO_CAN_CHANGE_PASSWORD}"/ $TEMPLATE_PATH
sed -i s/QUESTIONS_ENABLED/"${QUESTIONS_ENABLED}"/ $TEMPLATE_PATH
sed -i s/LDAP_MAIL_ATTRIBUTE/"${LDAP_MAIL_ATTRIBUTE}"/ $TEMPLATE_PATH
sed -i s/MAIL_FROM_NAME/"${MAIL_FROM_NAME}"/ $TEMPLATE_PATH
sed -i s/MAIL_FROM/"${MAIL_FROM}"/ $TEMPLATE_PATH
sed -i s/NOTIFY_ON_CHANGE/"${NOTIFY_ON_CHANGE}"/ $TEMPLATE_PATH
sed -i s/SMTP_DEBUG/"${SMTP_DEBUG}"/ $TEMPLATE_PATH
sed -i s/SMTP_HOST/"${SMTP_HOST}"/ $TEMPLATE_PATH
sed -i s/SMTP_AUTH_ON/"${SMTP_AUTH_ON}"/ $TEMPLATE_PATH
sed -i s/SMTP_USER/"${SMTP_USER}"/ $TEMPLATE_PATH
sed -i s/SMTP_PASS/"${SMTP_PASS}"/ $TEMPLATE_PATH
sed -i s/SMTP_PORT/"${SMTP_PORT}"/ $TEMPLATE_PATH
sed -i s/SMTP_SECURE_TYPE/"${SMTP_SECURE_TYPE}"/ $TEMPLATE_PATH
sed -i s/USE_SMS/"${USE_SMS}"/ $TEMPLATE_PATH
sed -i s/IS_BEHIND_PROXY/"${IS_BEHIND_PROXY}"/ $TEMPLATE_PATH
sed -i s/SHOW_HELP/"${SHOW_HELP}"/ $TEMPLATE_PATH
sed -i s/LANG/"${LANG}"/ $TEMPLATE_PATH
sed -i s/DEBUG_MODE/"${DEBUG_MODE}"/ $TEMPLATE_PATH
sed -i s/SECRETEKEY/"${SECRETEKEY}"/ $TEMPLATE_PATH
sed -i s/USE_RECAPTCHA/"${USE_RECAPTCHA}"/ $TEMPLATE_PATH
sed -i s/RECAPTCHA_PUB_KEY/"${RECAPTCHA_PUB_KEY}"/ $TEMPLATE_PATH
sed -i s/RECAPTCHA_PRIV_KEY/"${RECAPTCHA_PRIV_KEY}"/ $TEMPLATE_PATH
sed -i s/DEFAULT_ACTION/"${DEFAULT_ACTION}"/ $TEMPLATE_PATH

cp $TEMPLATE_PATH $CONFIG_PATH

php-fpm
