moss/selfservicepassword:1.0
===================================


* [Introduction](#introduction)
* [Installation](#installation)
* [Quick start](#quick-start)
* [Available Configuration Parameters](#available-configuration-parameters)

## Introduction

Docker image to a web interface to change and reset password in an LDAP
directory https://github.com/ltb-project/self-service-password

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/moss/selfservicepassword) and is the recommended method of installation.

```bash
docker pull moss/selfservicepassword:1.0
```

You can also pull the `latest` tag which is built from the repository *HEAD*

```bash
docker pull moss/selfservicepassword:latest
```

Alternatively you can build the image locally.

```bash
docker build -t moss/selfservicepassword github.com/moss/docker-selfservicepassword
```

## Quick start

The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/).

```bash
wget https://raw.githubusercontent.com/moss/docker-selfservicepassword/master/docker-compose.yml
wget https://raw.githubusercontent.com/moss/docker-selfservicepassword/master/.env
```
Start Self Service Password using:

```bash
docker-compose up
```

## Available Configuration Parameters
| Parameter | Description |
|-----------|-------------|
| `DEBUG` | Set this to `true` to enable entrypoint debugging. |
| `LDAP_SERVER: ` | Ldap server. No default. |
| `LDAP_STARTTLS: ` | Enable TLS on Ldap bind. No default. |
| `LDAP_BINDDN: ` | Ldap bind dn. No default. |
| `LDAP_BINDPASS: ` | Ldap bind password. No default. |
| `LDAP_BASE_SEARCH: ` | Base where we can search for users. No default. |
| `LDAP_LOGIN_ATTRIBUTE: ` | Ldap property used for user searching. Defaults to `uid` |
| `LDAP_FULLNAME_ATTRIBUTE: ` | Ldap property to get user fullname. Defaults to `cn` |
| `ADMODE: ` | Specifies if LDAP server is Active Directory LDAP server. If your LDAP server is AD, set this to `true`. Defaults to `false`. |
| `AD_OPT_FORCE_UNLOCK: ` | Force account unlock when password is changed.  Default to `false`.|
| `AD_OPT_FORCE_PWD_CHANGE: ` | Force user change password at next login.  Defaults to `false`. |
| `AD_OPT_CHANGE_EXPIRED_PASSWORD: ` | Allow user with expired password to change password. Defaults to `false`. |
| `SAMBA_MODE: ` | Samba mode, if is `true` update sambaNTpassword and sambaPwdLastSet attributes too; if is `false` just update the password. Defaults to `false`. |
| `SHADOW_OPT_UPDATE_SHADOWLASTCHANGE: ` | If `true` update shadowLastChange.  Defaults to `false`. |
| `PASSWORD_HASH: ` |  Hash mechanism for password: `SSHA` `SHA` `SMD5` `MD5` `CRYPT` `clear` (the default) `auto` (will check the hash of current password)  **This option is not used with ad_mode = true** |
| `PASSWORD_MIN_LENGTH: ` | Minimal length. Defaults to `0` (unchecked). |
| `PASSWORD_MAX_LENGTH: ` | Maximal length. Defaults to `0` (unchecked). |
| `PASSWORD_MIN_LOWERCASE: ` | Minimal lower characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_UPPERCASE: ` | Minimal upper characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_DIGIT: ` | Minimal digit characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_SPECIAL: ` | Minimal special characters. Defaults to `0` (unchecked).  |
| `PASSWORD_NO_REUSE: ` | Dont reuse the same password as currently. Defaults to `true`. |
| `PASSWORD_SHOW_POLICY: ` | Show policy constraints message: `always` `never` `onerror`. Defaults to `never` |
| `PASSWORD_SHOW_POLICY_POSITION: ` | Position of password policy constraints message: `above` `below` - the form. Defaults to `above` |
| `WHO_CAN_CHANGE_PASSWORD: ` | Who changes the password?  Also applicable for question/answer save `user`: the user itself `manager`: the above binddn. Defaults to `user` |
| `QUESTIONS_ENABLED: ` | Use questions/answers?  `true` or `false`. Defaults to `true` |
| `LDAP_MAIL_ATTRIBUTE: ` | LDAP mail attribute. Defaults to `mail` |
| `MAIL_FROM: ` | Who the email should come from. Defaults to `admin@example.com` |
| `MAIL_FROM_NAME: ` | Name for `MAIL_FROM`. Defaults to `No Reply`|
| `NOTIFY_ON_CHANGE: ` | Notify users anytime their password is changed. Defaults to `false` |
| `SMTP_DEBUG: ` | SMTP debug mode (following https:////github.com/PHPMailer/PHPMailer instructions). Defaults to `0` |
| `SMTP_HOST: ` | SMTP host. No default. |
| `SMTP_AUTH_ON: ` | Force smtp auth with `SMTP_USER` and `SMTP_PASS`. Defaults to `false` |
| `SMTP_USER: ` | SMTP user. No default. |
| `SMTP_PASS: ` | SMTP password. No default. |
| `SMTP_PORT: ` | SMTP port. Defaults to `587` |
| `SMTP_SECURE_TYPE: ` | SMTP secure type to use. `ssl` or `tls`. Defaults to `tls` |
| `USE_SMS: ` | Enable sms notify. (Disabled on this image). Defaults to `false` |
| `IS_BEHIND_PROXY: ` | Enable reset url parameter to accept reverse proxy. Defaults to `false`  |
| `SHOW_HELP: ` | Display help messages. Defaults to `true`. |
| `LANG: ` | Language (NOT WORKING YET). Defaults to `en`.  |
| `DEBUG_MODE: ` | Debug mode. Defaults to `false`. |
| `SECRETEKEY: ` | Encryption, decryption keyphrase. Defaults to `secret`. |
| `USE_RECAPTCHA: ` | Use Google reCAPTCHA (http://www.google.com/recaptcha). Defaults to `false` |
| `RECAPTCHA_PUB_KEY: ` | Go on the site to get public key |
| `RECAPTCHA_PRIV_KEY: ` | Go on the site to get private key |
| `DEFAULT_ACTION: ` | Default action: `change` `sendtoken` `sendsms`. Defaults to `change` |
