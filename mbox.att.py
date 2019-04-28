#! /usr/bin/python3

import smtplib
from email.message import EmailMessage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

#张小摩:
#会议将于 2020-10-22 14:23:54 举行，请及时参加。
#谢谢！

#密码文件可有\n
#QQ使用授权码，而不是邮箱密码
pswdfile = '/usr/local/passwd'
with open(pswdfile) as fp:
    password = fp.read()

print ("pass: %s hello"%password)
#1. 怎么也调不通 changarthur@163.com 
#2. 阿里云上超时 163.com qq.com
#3. 在公司内网用 mail.cnjabsco.com
#4. 收件响应最快 thinkman_j@qq.com，cnjabsco要1分钟

#smtp_svr = 'mail.cnjabsco.com'
#fromaddr = 'zhangj@cnjabsco.com'
#recvaddr = 'thinkman_j@qq.com'

smtp_svr = 'smtp.qq.com'
fromaddr = 'thinkman_j@qq.com'
recvaddr = 'changarthur@163.com'
#ecvaddr = 'zhangj@cnjabsco.com'

# 构造附件
msgRoot = MIMEMultipart('mixed')
msgRoot['Subject'] = 'attach'
att = MIMEText(open('/root/.vim/.ch/candle.pyc', 'rb').read(), 'base64', 'utf-8')
att["Content-Type"] = 'application/octet-stream'
att["Content-Disposition"] = 'attachment; filename="/root/.vim/.ch/candle.pyc"'
msgRoot.attach(att)

# Send the message via our own SMTP server.
s = smtplib.SMTP(smtp_svr, 25)
s.login(fromaddr, password)
s.sendmail(fromaddr, recvaddr, msgRoot.as_string())     # 附件
s.quit()
