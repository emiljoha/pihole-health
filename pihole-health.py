import dns.resolver
import requests
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--pass-url", type=str,
                        help="healthchecks.io url to signal sucess")
    parser.add_argument("--pihole-ip", type=str,
                        help="Ip address of PiHole")
    parser.add_argument("--test-domain", type=str,
                        help="Domain to use in test request.")
    parser.add_argument("--test-domain-ip", type=str,
                        help="Ip address expected for test-domain")
    parser.add_argument("--resolver-timeout", type=float, default=1)
    parser.add_argument("--resolver-lifetime", type=float, default=1)

    args = parser.parse_args()

    def failed():
        requests.get(args.pass_url + "/fail")
        print('fail')

    def passed():
        requests.get(args.pass_url)
        print('passed')

    try:
        resolver = dns.resolver.Resolver()
        resolver.nameservers = [args.pihole_ip]
        resolver.timeout = args.resolver_timeout
        resolver.lifetime = args.resolver_lifetime
        answer = resolver.query(args.test_domain)
        if args.test_domain_ip in answer.response.to_text():
            passed()
        else:
            failed()
    except Exception as e:
        print(str(e))
        failed()

    dns.resolver.Cache().flush()
