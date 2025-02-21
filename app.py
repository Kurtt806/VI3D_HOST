from flask import Flask, render_template, request
import os

app = Flask(__name__)

def scan_wifi():
    networks = os.popen("sudo iwlist wlan0 scan | grep 'ESSID'").read().split("\n")
    return [net.split(':')[1].replace('"', '') for net in networks if 'ESSID' in net]

@app.route('/')
def index():
    networks = scan_wifi()
    return render_template('index.html', networks=networks)

@app.route('/connect', methods=['POST'])
def connect():
    ssid = request.form['ssid']
    password = request.form['password']
    
    with open("/etc/wpa_supplicant/wpa_supplicant.conf", "w") as f:
        f.write(f'''
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={{
    ssid="{ssid}"
    psk="{password}"
    key_mgmt=WPA-PSK
}}
''')
    os.system("sudo systemctl restart networking.service")
    return "Wi-Fi Updated! Rebooting..."
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
