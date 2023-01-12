"""
Created 2/24/2022
@author: Ralph Miller

a setup script to download nessesary external packages using pip
"""


import subprocess
import sys
import os

def startupScript():

    reqs = subprocess.check_output([sys.executable, '-m', 'pip', 'freeze'])
    installed_packages = [r.decode().split('==')[0] for r in reqs.split()]

    if "requests" not in installed_packages:
        os.system('pip install requests')
    if "beautifulsoup4" not in installed_packages:
        os.system('pip install beautifulsoup4')
    if "selenium" not in installed_packages:
        os.system('pip install selenium')
