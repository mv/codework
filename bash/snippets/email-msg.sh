
MAIL_TO="marcus.ferreira@abril.com.br,leslie.quintanilla@abril.com.br"
SUBJECT="AGC: Limpeza abc"

email() {
    [ -z "$MAIL_TO" ] && return
    subject="$(hostname) - $SUBJECT - $1"

    mail -s "$subject" $MAIL_TO <<MAIL
From: no-reply@$(hostname)
To: $MAIL_TO
Subject: $subject

Log: $LOG

____________________________________________________________

$( cat -n $LOG | tail -15 )

____________________________________________________________
MAIL
}


