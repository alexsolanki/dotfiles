## Graphite local_settings.py
# Edit this file to customize the default Graphite webapp settings
#
# Additional customizations to Django settings can be added to this file as well

#####################################
# General Configuration #
#####################################
# Set your local timezone (Django's default is America/Chicago)
# If your graphs appear to be offset by a couple hours then this probably
# needs to be explicitly set to your local timezone.
#TIME_ZONE = 'America/Los_Angeles'

# Override this to provide documentation specific to your Graphite deployment
#DOCUMENTATION_URL = "http://graphite.readthedocs.org/"

# Logging
#LOG_RENDERING_PERFORMANCE = True
#LOG_CACHE_PERFORMANCE = True
#LOG_METRIC_ACCESS = True

# Enable full debug page display on exceptions (Internal Server Error pages)
#DEBUG = True

# If using RRD files and rrdcached, set to the address or socket of the daemon
#FLUSHRRDCACHED = 'unix:/var/run/rrdcached.sock'

# This lists the memcached servers that will be used by this webapp.
# If you have a cluster of webapps you should ensure all of them
# have the *exact* same value for this setting. That will maximize cache
# efficiency. Setting MEMCACHE_HOSTS to be empty will turn off use of
# memcached entirely.
#
# You should not use the loopback address (127.0.0.1) here if using clustering
# as every webapp in the cluster should use the exact same values to prevent
# unneeded cache misses. Set to [] to disable caching of images and fetched data
#MEMCACHE_HOSTS = ['10.10.10.10:11211', '10.10.10.11:11211', '10.10.10.12:11211']
#DEFAULT_CACHE_DURATION = 60 # Cache images and data for 1 minute


#####################################
# Filesystem Paths #
#####################################
# Change only GRAPHITE_ROOT if your install is merely shifted from /opt/graphite
# to somewhere else
#GRAPHITE_ROOT = '/opt/graphite'

# Most installs done outside of a separate tree such as /opt/graphite will only
# need to change these three settings. Note that the default settings for each
# of these is relative to GRAPHITE_ROOT
#CONF_DIR = '/opt/graphite/conf'
#STORAGE_DIR = '/opt/graphite/storage'
#CONTENT_DIR = '/opt/graphite/webapp/content'

# To further or fully customize the paths, modify the following. Note that the
# default settings for each of these are relative to CONF_DIR and STORAGE_DIR
#
## Webapp config files
#DASHBOARD_CONF = '/opt/graphite/conf/dashboard.conf'
#GRAPHTEMPLATES_CONF = '/opt/graphite/conf/graphTemplates.conf'

## Data directories
# NOTE: If any directory is unreadable in DATA_DIRS it will break metric browsing
#WHISPER_DIR = '/opt/graphite/storage/whisper'
#RRD_DIR = '/opt/graphite/storage/rrd'
#DATA_DIRS = [WHISPER_DIR, RRD_DIR] # Default: set from the above variables
#LOG_DIR = '/opt/graphite/storage/log/webapp'
#INDEX_FILE = '/opt/graphite/storage/index'  # Search index file


#####################################
# Email Configuration #
#####################################
# This is used for emailing rendered Graphs
# Default backend is SMTP
#EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
#EMAIL_HOST = 'localhost'
#EMAIL_PORT = 25
#EMAIL_HOST_USER = ''
#EMAIL_HOST_PASSWORD = ''
#EMAIL_USE_TLS = False
# To drop emails on the floor, enable the Dummy backend:
#EMAIL_BACKEND = 'django.core.mail.backends.dummy.EmailBackend'


#####################################
# Authentication Configuration #
#####################################
## LDAP / ActiveDirectory authentication setup
#USE_LDAP_AUTH = True
#LDAP_SERVER = "ldap.mycompany.com"
#LDAP_PORT = 389
#	OR
#LDAP_URI = "ldaps://ldap.mycompany.com:636"
#LDAP_SEARCH_BASE = "OU=users,DC=mycompany,DC=com"
#LDAP_BASE_USER = "CN=some_readonly_account,DC=mycompany,DC=com"
#LDAP_BASE_PASS = "readonly_account_password"
#LDAP_USER_QUERY = "(username=%s)"  #For Active Directory use "(sAMAccountName=%s)"
#
# If you want to further customize the ldap connection options you should
# directly use ldap.set_option to set the ldap module's global options.
# For example:
#
#import ldap
#ldap.set_option(ldap.OPT_X_TLS_REQUIRE_CERT, ldap.OPT_X_TLS_ALLOW)
#ldap.set_option(ldap.OPT_X_TLS_CACERTDIR, "/etc/ssl/ca")
#ldap.set_option(ldap.OPT_X_TLS_CERTFILE, "/etc/ssl/mycert.pem")
#ldap.set_option(ldap.OPT_X_TLS_KEYFILE, "/etc/ssl/mykey.pem")
# See http://www.python-ldap.org/ for further details on these options.

## REMOTE_USER authentication. See: https://docs.djangoproject.com/en/dev/howto/auth-remote-user/
#USE_REMOTE_USER_AUTHENTICATION = True

# Override the URL for the login link (e.g. for django_openid_auth)
#LOGIN_URL = '/account/login'


##########################
# Database Configuration #
##########################
# By default sqlite is used. If you cluster multiple webapps you will need
# to setup an external database (such as MySQL) and configure all of the webapp
# instances to use the same database. Note that this database is only used to store
# Django models such as saved graphs, dashboards, user preferences, etc.
# Metric data is not stored here.
#
# DO NOT FORGET TO RUN 'manage.py syncdb' AFTER SETTING UP A NEW DATABASE
#
# The following built-in database engines are available:
#  django.db.backends.postgresql          # Removed in Django 1.4
#  django.db.backends.postgresql_psycopg2
#  django.db.backends.mysql
#  django.db.backends.sqlite3
#  django.db.backends.oracle
#
# The default is 'django.db.backends.sqlite3' with file 'graphite.db'
# located in STORAGE_DIR
#
# Users with Django 1.2 or greater should use the new dictionary
# specification as the old database specification style is removed in 1.4
#DATABASES = {
#    'default': {
#        'NAME': '/opt/graphite/storage/graphite.db',
#        'ENGINE': 'django.db.backends.sqlite3',
#        'USER': '',
#        'PASSWORD': '',
#        'HOST': '',
#        'PORT': ''
#    }
#}
#
# Users still on Django 1.1 must use the old method instead:
#DATABASE_ENGINE = 'django.db.backends.mysql'
#DATABASE_NAME = 'graphite'      # Or path to the database file if using sqlite3
#DATABASE_USER = 'graphite'
#DATABASE_PASSWORD = 'graphite-is-awesome'
#DATABASE_HOST = 'mysql.mycompany.com'
#DATABASE_PORT = '3306'


#########################
# Cluster Configuration #
#########################
# (To avoid excessive DNS lookups you want to stick to using IP addresses only in this entire section)
#
# This should list the IP address (and optionally port) of the webapp on each
# remote server in the cluster. These servers must each have local access to
# metric data. Note that the first server to return a match for a query will be
# used.
#CLUSTER_SERVERS = ["10.0.2.2:80", "10.0.2.3:80"]

## These are timeout values (in seconds) for requests to remote webapps
#REMOTE_STORE_FETCH_TIMEOUT = 6   # Timeout to fetch series data
#REMOTE_STORE_FIND_TIMEOUT = 2.5  # Timeout for metric find requests
#REMOTE_STORE_RETRY_DELAY = 60    # Time before retrying a failed remote webapp
#REMOTE_FIND_CACHE_DURATION = 300 # Time to cache remote metric find results

## Remote rendering settings
# Set to True to enable rendering of Graphs on a remote webapp
#REMOTE_RENDERING = True
# List of IP (and optionally port) of the webapp on each remote server that
# will be used for rendering. Note that each rendering host should have local
# access to metric data or should have CLUSTER_SERVERS configured
#RENDERING_HOSTS = []
#REMOTE_RENDER_CONNECT_TIMEOUT = 1.0

# If you are running multiple carbon-caches on this machine (typically behind a relay using
# consistent hashing), you'll need to list the ip address, cache query port, and instance name of each carbon-cache
# instance on the local machine (NOT every carbon-cache in the entire cluster). The default cache query port is 7002
# and a common scheme is to use 7102 for instance b, 7202 for instance c, etc.
#
# You *should* use 127.0.0.1 here in most cases
#CARBONLINK_HOSTS = ["127.0.0.1:7002:a", "127.0.0.1:7102:b", "127.0.0.1:7202:c"]
#CARBONLINK_TIMEOUT = 1.0

#####################################
# Additional Django Settings #
#####################################
# Uncomment the following line for direct access to Django settings such as
# MIDDLEWARE_CLASSES or APPS
#from graphite.app_settings import *


#####################################
#   LOCAL CONFIGURATION OPTIONS     #
#####################################

CARBONLINK_HOSTS = [ '127.0.0.1:7002:a' ]
CLUSTER_SERVERS = [
                    '10.83.16.247:80',  # fopp-gra0100.las1 - AMS2
                    '10.83.16.230:80',  # fopp-gra0101.las1 - AMS2 BID
                    '10.83.16.244:80',  # fopp-gra0102.las1 - AMS2 BID
                    '10.83.16.234:80',  # fopp-gra1000.las1 - FRA1
                    '10.83.16.235:80',  # fopp-gra1001.las1 - FRA1 BID
                    '10.83.16.238:80',  # fopp-gra1002.las1 - FRA1 BID
                    '10.83.16.183:80',  # fopp-gra1100.las1 - HKG1
                    '10.83.16.184:80',  # fopp-gra1101.las1 - HKG1 BID
                    '10.83.16.191:80',  # fopp-gra1200.las1 - IAD2
                    '10.83.16.192:80',  # fopp-gra1201.las1 - IAD2 BID
                    '10.83.16.193:80',  # fopp-gra1202.las1 - IAD2 BID
                    '10.83.16.194:80',  # fopp-gra1203.las1 - IAD2 BID
                    '10.83.16.195:80',  # fopp-gra1204.las1 - IAD2 FXP
                    '10.83.16.208:80',  # fopp-gra0300.las1 - LAS1
                    '10.83.16.90:80',   # fopp-gra0500.las1 - LAS2
                    '10.83.16.75:80',   # fopp-gra0600.las1 - LAX2
                    '10.83.16.76:80',   # fopp-gra0800.las1 - SJC1
                    '10.83.16.246:80',  # fopp-gra0801.las1 - SJC1 BID
                    '10.83.16.160:80'   # fopp-gra0802.las1 - SJC1 BID
                  ]
#                    '10.83.16.195:80',  # fopp-gra1204.las1 - IAD2 BID - Unused/Expansion
LEGEND_MAX_ITEMS = 12
MEMCACHE_HOSTS = [ '127.0.0.1:11211' ]
SMTP_SERVER = 'massmailer.las1.fanops.net'
TIME_ZONE = 'America/Los_Angeles'
