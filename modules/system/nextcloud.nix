# Nextcloud
# services.nextcloud = {
# enable = true;
# hostName = "nextcloud.tld";
# database.createLocally = true;
# config = {
# dbtype = "pgsql";
# adminpassFile = "/home/fabian/home-server/nextcloud/adminpass.txt";
# };
# Instead of using pkgs.nextcloud28Packages.apps,
# we'll reference the package version specified above
# extraApps = {
# inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
# };
# extraAppsEnable = true;
# };

