#!/usr/bin/env python

import sys
import argparse
import ConfigParser
import socket
import time
import json
import requests
from requests.auth import HTTPBasicAuth
import pypuppetdb


def _parse_args():
    """
    Parse all the command line arguments.
    """

    help="""
    Gather monitoring dashboard metrics and send them to graphite.

    >>> collect_dashboard_metrics.py -H graphite.mydomain.com -P 3003 -s ~/conf/collect_dashboard_metrics.ini
    Colleting...
    """

    mp = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter,
                                 description=help)
    mp.add_argument('-H',
                    '--host',
                    dest='host_fqdn',
                    help='Host name of the graphite server.',
                    default='graphite')
    mp.add_argument('-P',
                    '--port',
                    dest='host_port',
                    help='Port number of the graphite server.',
                    default='3003')
    mp.add_argument('-s',
                    '--secrets',
                    dest='secrets_config_file',
                    help='Secret config file to use.',
                    default='/apps/squirrel_web/conf/collect_dashboard_metrics_secrets.ini')
    mp.add_argument('-S',
                    '--ssl',
                    dest='ssl_verify',
                    help='Whether or not the server is using ssl. Can be True, False, or path to ca cert',
                    default=None)
    mp.add_argument('-p',
                    '--puppet',
                    dest='puppet_sites',
                    nargs='+',
                    help='List of sites to check for puppet nodes..')
    mp.add_argument('-d',
                    '--debug',
                    action='store_true',
                    help='Enable debugging.')

    return mp.parse_args()


def get_pagerduty(token):

    headers = {'Content-Type': 'application/json',
               'Authorization': 'Token token={0}'.format(token),
    }

    url = 'https://rubiconproject.pagerduty.com/api/v1/incidents'
    # data = {'status': 'triggered,acknowledged'}
    params = {'status': 'triggered'}

    r = requests.get(url, headers=headers, params=params)
    results = r.json()
    return int(results['total'])


def get_pingdom(username, password, api_key):

    headers = {'Content-Type': 'application/json',
               'App-Key': api_key,
              }
    auth = HTTPBasicAuth(username, password)

    url = 'https://api.pingdom.com/api/2.0/checks'

    r = requests.get(url, headers=headers, auth=auth)
    results = r.json()
    val = 0
    try:
        for c in results['checks']:
            # print c['status']
            if c['status'] == 'down':
                val += 1

        return int(val)
    except:
        print results
        return -1


def get_logicmonitor(username, password):

    headers = {'Content-Type': 'application/json'}

    url = 'https://rubiconproject.logicmonitor.com/santaba/rpc/getAlerts'
    params = {'c': 'rubiconproject',
              'ackFilter': 'nonacked',
              'filterSDT': 'true',
              'u': username,
              'p': password,
             }
    r = requests.get(url, headers=headers, params=params)
    results = r.json()
#    print json.dumps(results['data']['alerts'][0], indent=4, sort_keys=True)
    return int(results['data']['total'])


def get_puppet(sites):

    failed = 0
    unreported = 0

    for site in sites:
        print 'Checking puppet in {0}'.format(site)
        db = pypuppetdb.connect(host='puppetboard.{0}.fanops.net'.format(site), port=8080)

        site_failed = 0
        site_unreported = 0

        for n in db.nodes(with_status=True):
            if n.status == 'failed':
                site_failed += 1
            elif n.status == 'unreported':
                site_unreported += 1

        failed += site_failed
        unreported += site_unreported
        print 'Failed: {0} Unreported: {1}'.format(site_failed, site_unreported)

    return failed, unreported


def send_metric(args, message):

    server_ip = socket.gethostbyname(args.host_fqdn)
    server_port = int(args.host_port)
    
    print 'sending metric - server: {0} port: {1} message: {2}'.format(args.host_fqdn, args.host_port, message)
    try:
        sock = socket.socket()
        sock.connect((server_ip, server_port))
        sock.sendall('{0}\n'.format(message))
        sock.close()
        print 'metric sent'
    except:
        print 'failed to send'
        raise


def main():

    # parse the args
    args = _parse_args()

    # Make sure we have required args
    required = ['secrets_config_file',]
    for r in required:
        if not args.__dict__[r]:
            print >> sys.stderr, \
                "\nERROR - Required option is missing: %s\n" % r
            sys.exit(2)

    # Parse the config
    secrets_config = ConfigParser.ConfigParser()
    secrets_config.read(args.secrets_config_file)
    setattr(args, 'pd_token', secrets_config.get('pagerduty', 'token'))
    setattr(args, 'ping_user', secrets_config.get('pingdom', 'username'))
    setattr(args, 'ping_pass', secrets_config.get('pingdom', 'password'))
    setattr(args, 'ping_app_key', secrets_config.get('pingdom', 'application_key'))
    setattr(args, 'lm_user', secrets_config.get('logicmonitor', 'username'))
    setattr(args, 'lm_pass', secrets_config.get('logicmonitor', 'password'))

    pd_total = get_pagerduty(args.pd_token)
    ping_total = get_pingdom(args.ping_user,
                             args.ping_pass,
                             args.ping_app_key)
    lm_total = get_logicmonitor(args.lm_user,
                                args.lm_pass)
    puppet_failed, puppet_unreported = get_puppet(args.puppet_sites)

    now = int(time.time())
    
    # Send to graphite
    send_metric(args, 'dashboards.squirrel.md.pagerduty.triggered {0} {1}'.format(pd_total, now))
    send_metric(args, 'dashboards.squirrel.md.pingdom.down {0} {1}'.format(ping_total, now))
    send_metric(args, 'dashboards.squirrel.md.logicmonitor.nonacked {0} {1}'.format(lm_total, now))
    send_metric(args, 'dashboards.squirrel.md.puppet.failed {0} {1}'.format(puppet_failed, now))
    send_metric(args, 'dashboards.squirrel.md.puppet.unreported {0} {1}'.format(puppet_unreported, now))

if __name__ == '__main__':
    main()
