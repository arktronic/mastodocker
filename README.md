# mastodocker: Mastodon + Docker Compose

Setting up your own Mastodon instance with Docker Compose and nginx

### _WARNING: This is an experimental repo and guide. Things may not work correctly. You might lose all of your data. YMMV._

## Prerequisites

You will need the following:

- A Linux server environment, ideally a hosted virtual machine, with a public IP address
- A recent version of [Docker with the Docker Compose plugin](https://docs.docker.com/engine/install/ubuntu/) (not the old school `docker-compose`)
- 20GB+ of free disk space, because federated images can easily get pretty big over time
- Your own domain or subdomain
- A working SMTP server (not strictly required, but highly recommended)

## First time installation steps

1. Clone this repo:
```bash
git clone https://github.com/arktronic/mastodocker.git
cd mastodocker
```

2. Run the initial setup script:
```bash
./initial-setup.sh
```
This will create directories and copy `env.production.example` to `.env.production`. If you see a warning about vm.max_map_count, please go to the provided link and follow the directions there to fix the issue before continuing. You can re-run this script afterward to verify that the issue is fixed.

3. Set up new secrets:
```bash
./reset-secrets.sh
```

4. Edit `.env.production` using your favorite text editor and change/fill the variables in it.
    - `LOCAL_DOMAIN` **must** be correct - nothing will work otherwise
    - `SINGLE_USER_MODE` can be changed at any time; you can set it to `false` later if you decide to allow people to join in
    - `SMTP_*` values should reflect your SMTP server settings

5. Initialize the database:
```bash
./db-initialize.sh
```

6. Launch it all:
```bash
docker compose up -d
```
You will need to wait a bit for Mastodon to come up before continuing. You can monitor that using `docker compose logs`.

7. Create your admin user: _(replace `tootadmin` and `tootadmin@example.com` with your preferred choices)_
```bash
./tootctl.sh accounts create tootadmin --email tootadmin@example.com --confirmed --role admin
```
This command will output your new temporary password after creating the user. You can change it after logging in to the web UI.

At this point, Mastodon itself is running on ports 3000 and 4000. Next, you will need to set up nginx to allow proper web access.

## First time nginx setup with Let's Encrypt

The steps below assume that the domain being set up is `chat.example.com`. Replace that with your actual domain.

1. Install nginx. Ubuntu example:
```bash
sudo apt install nginx-full
```

2. Disable the default website:
```bash
sudo rm /etc/nginx/sites-enabled/default
```

3. Copy the example configuration to available sites and enable it:
```bash
cd mastodocker
sudo cp mastodon-nginx-example /etc/nginx/sites-available/mastodon
sudo ln -s ../sites-available/mastodon /etc/nginx/sites-enabled/mastodon
```

4. Edit `/etc/nginx/sites-available/mastodon` using your favorite text editor and make any necessary changes.
    - The `server_name` line **must** be the same as `LOCAL_DOMAIN` in the Mastodon setup above

5. Test the configuration (`sudo nginx -t`) and reload (`sudo systemctl reload nginx`).

6. Follow [this excellent guide](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-22-04), or equivalent for your Linux distro, to set up Let's Encrypt.

You should be good to go!

## Setting up ElasticSearch

TBD... theoretically, you should just be able to run `./es-deploy.sh`, but there appears to be some [bug if you do it immediately after deployment](https://github.com/mastodon/mastodon/issues/18625).

## Maintenance

TBD

## Updating to a newer version

Zero-downtime updates are possible with Mastodon, but that's out of scope.

1. Bring everything down:
```bash
cd mastodocker
docker compose down
```

2. Update the repo (`git pull`) or manually modify `docker-compose.yml` to use a [different version](https://hub.docker.com/r/tootsuite/mastodon/tags).

3. Run all of the DB migrations:
```bash
./migrate-full.sh
```

4. Bring everything back up:
```bash
docker compose up -d
```
