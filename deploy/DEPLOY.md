# Deploying FlexiWork to a VPS

Target: a fresh Ubuntu 22.04 VPS (DigitalOcean/Hetzner/Lightsail/etc). Minimum
2GB RAM (the WhatsApp service launches Chromium via Puppeteer).

## 1. Provision the VPS
- Spin up Ubuntu 22.04, note its public IP.
- (Optional but recommended) point a domain's A record at that IP.
- SSH in as root, then create a non-root user:
  ```bash
  adduser flexiwork
  usermod -aG sudo flexiwork
  su - flexiwork
  ```

## 2. Install dependencies
```bash
sudo apt update && sudo apt install -y openjdk-21-jdk maven nginx mysql-server git \
  chromium-browser libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 \
  libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

## 3. Set up MySQL
```bash
sudo mysql_secure_installation
sudo mysql -u root -p
```
```sql
CREATE DATABASE flexiwork;
CREATE USER 'flexiwork'@'localhost' IDENTIFIED BY 'CHOOSE_A_STRONG_PASSWORD';
GRANT ALL PRIVILEGES ON flexiwork.* TO 'flexiwork'@'localhost';
FLUSH PRIVILEGES;
```

## 4. Get the code onto the server
```bash
sudo mkdir -p /opt/flexiwork
sudo chown flexiwork:flexiwork /opt/flexiwork
cd /opt/flexiwork
git clone <your-repo-url> .          # or scp the project up if it's not in git yet
```

## 5. Build the backend
```bash
cd /opt/flexiwork
mvn clean package -DskipTests        # produces target/*.jar
cp target/*.jar /opt/flexiwork/app.jar
```

## 6. Build the frontend
```bash
cd /opt/flexiwork/frontend
npm install
npm run build                        # produces frontend/dist
cp -r dist /opt/flexiwork/frontend-dist
```

## 7. Configure secrets
Create `/opt/flexiwork/.env` (used by both systemd services — keep it out of git,
`chmod 600`). Spring Boot automatically picks up env vars via relaxed binding,
so no source changes are needed:
```bash
SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/flexiwork?createDatabaseIfNotExist=true&serverTimezone=Asia/Colombo&allowPublicKeyRetrieval=true&useSSL=false
SPRING_DATASOURCE_USERNAME=flexiwork
SPRING_DATASOURCE_PASSWORD=CHOOSE_A_STRONG_PASSWORD
FLEXIWORK_JWT_SECRET=GENERATE_A_LONG_RANDOM_SECRET_AT_LEAST_32_BYTES
FLEXIWORK_PUBLIC_BASE_URL=https://YOUR_DOMAIN_OR_IP
SPRING_MAIL_USERNAME=your-gmail-address@gmail.com
SPRING_MAIL_PASSWORD=your-16-char-gmail-app-password
WHATSAPP_SHARED_SECRET=GENERATE_ANOTHER_RANDOM_SECRET
```
Generate random secrets with: `openssl rand -base64 48`

**Important:** the first run must create the schema. Either run once with
`SPRING_PROFILES_ACTIVE=dev` (uses `ddl-auto: update`) to bootstrap tables, then
switch the systemd unit to `prod` (which uses `ddl-auto: validate` and refuses
to auto-mutate the schema afterward) — or import a schema dump manually.

## 8. Install systemd services
```bash
sudo cp /opt/flexiwork/deploy/flexiwork.service /etc/systemd/system/
sudo cp /opt/flexiwork/deploy/flexiwork-whatsapp.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now flexiwork
sudo systemctl enable --now flexiwork-whatsapp
sudo journalctl -u flexiwork-whatsapp -f   # scan the printed QR with the WhatsApp
                                            # account you want the bot to use
```

## 9. Configure Nginx
```bash
sudo cp /opt/flexiwork/deploy/nginx.conf /etc/nginx/sites-available/flexiwork
sudo sed -i 's/YOUR_DOMAIN_OR_IP/your.actual.domain.or.ip/' /etc/nginx/sites-available/flexiwork
sudo ln -s /etc/nginx/sites-available/flexiwork /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

## 10. Firewall + HTTPS
```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable

# If you have a domain pointed at the server:
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your.actual.domain
```
Without a domain, skip certbot and use plain HTTP via the IP (the prod profile
sets cookies `secure: true`, which requires HTTPS — see note below).

> Note: `application-prod.yml` sets session cookies to `secure: true` +
> `same-site: strict`. If you're serving over plain HTTP (IP only, no TLS),
> the admin login cookie won't be sent and admin login will silently fail.
> Either get a domain + certbot TLS, or temporarily relax `secure` to `false`
> in `application-prod.yml` for an HTTP-only demo.

## 11. Verify
```bash
sudo systemctl status flexiwork flexiwork-whatsapp nginx
curl -I http://localhost:8080/api/health   # if you have a health endpoint, else any /api/* route
```
Visit `http://your.actual.domain` (or IP) in a browser — should load the React app.
`/admin` should load the Thymeleaf admin login.

## Redeploying after code changes
```bash
cd /opt/flexiwork && git pull
mvn clean package -DskipTests && cp target/*.jar app.jar
cd frontend && npm run build && rm -rf ../frontend-dist && cp -r dist ../frontend-dist
sudo systemctl restart flexiwork
```
