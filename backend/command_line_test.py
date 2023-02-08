import paramiko
ssh = paramiko.SSHClient()
ssh.connect('unix.ucsc.edu', username='erreeves', password="password")
ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('python3 menu_scraper_test.py')
ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('exit')