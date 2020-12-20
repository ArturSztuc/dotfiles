#vim filetype=muttrc
#######################################################
#                       OWNER                         #
#######################################################
set realname  = 'Artur Sztuc'   # default: (empty)
set from      = a.sztuc16@imperial.ac.uk
set use_from  = yes

#######################################################
#                 FOLDER OPTIONS                      #
#######################################################
set folder    = '~/.mail/Imperial/' 
set spoolfile = '+INBOX'        # default: (empty)
set record    = '+Sent Items/'  # default: ~/sent
set postponed = '+Drafts/'      # default: ~/postponed

#######################################################
#        IMAP SETTINGS (RECEIVING MESSAGES)           #
#######################################################
unmailboxes *
mailboxes           =INBOX =T2K =T2K/all =T2K/oscanal =T2K/sk =T2K/banff =T2K/T2KElog =SK =SK/superk =SK/superk_uk =SK/suketto_user =SK/kamioka_user =SK/dorm_user =SK/egads_plus =Drafts ='Sent Items'

#######################################################
#         SMTP SETTINGS (SENDING MESSAGES)            #
#######################################################
source "gpg -d ~/.pswd2.gpg |"
set imap_user       = as16@ic.ac.uk # default: (empty)
set smtp_pass=$my_icl_pwd
set smtp_url  = smtp://$imap_user@smtp.office365.com:587 # default: (empty)
set smtp_authenticators="login"
set header_cache = "~/.mutt/com.office.icl/cache/headers"
set message_cachedir= "~/.mutt/com.office.icl/cache/bodies"
