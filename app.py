from flask import Flask, render_template, request
import os

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        ssid = request.form["ssid"]
        password = request.form["password"]
        save_wifi(ssid, password)
        return "Wi-Fi đã lưu! Hệ thống sẽ khởi động lại..."
    return '''
        <h2>Cấu hình Wi-Fi</h2>
        <form method="POST">
            SSID: <input type="text" name="ssid"><br>
            Mật khẩu: <input type="password" name="password"><br>
            <input type="submit" value="Lưu Wi-Fi">
        </form>
    '''

def save_wifi(ssid, password):
    config = f'''
network={{
    ssid="{ssid}"
    psk="{password}"
}}
    '''
    with open("/etc/wpa_supplicant/wpa_supplicant.conf", "a") as f:
        f.write(config)
    os.system("sudo reboot")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
