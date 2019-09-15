import base64


data = open('10006100360002120190905051341.zip', 'rt').read()
d = base64.urlsafe_b64decode(data)
