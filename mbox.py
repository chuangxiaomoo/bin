#! /usr/bin/python3

import smtplib
from email.message import EmailMessage

#张小摩:
#会议将于 2020-10-22 14:23:54 举行，请及时参加。
#谢谢！

textfile = '/tmp/stdo'
with open(textfile) as fp:
    # Create a text/plain message
    msg = EmailMessage()
    msg.set_content(fp.read())

#密码文件可有\n
pswdfile = '/tmp/passwd'
with open(pswdfile) as fp:
    password = fp.read()

#1. 怎么也调不通 changarthur@163.com 
#2. 阿里云上超时 163.com qq.com
#3. 在公司内网用 mail.cnjabsco.com
#4. 收件响应最快 thinkman_j@qq.com，cnjabsco要1分钟

smtp_svr = 'mail.cnjabsco.com'
fromaddr = 'zhangj@cnjabsco.com'
recvaddr = 'thinkman_j@qq.com'

#smtp_svr = 'smtp.qq.com'
#fromaddr = 'thinkman_j@qq.com'
#recvaddr = 'zhangj@cnjabsco.com'

msg['Subject'] = '会议通知'
msg['From'] = fromaddr
msg['To'] = recvaddr

# Send the message via our own SMTP server.
s = smtplib.SMTP(smtp_svr, 25)
s.login(fromaddr, password)
s.send_message(msg)
s.quit()
