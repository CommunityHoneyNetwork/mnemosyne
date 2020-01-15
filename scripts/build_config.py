import argparse
import ConfigParser


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--template", required=True)
    parser.add_argument("--config", required=True)
    parser.add_argument("--ident", required=True)
    parser.add_argument("--secret", required=True)
    parser.add_argument("--hpfeeds-host", required=True)
    parser.add_argument("--hpfeeds-port", required=True)
    parser.add_argument("--channels", required=True)
    parser.add_argument("--mongodb-host", required=True)
    parser.add_argument("--mongodb-port", required=True)
    parser.add_argument("--mongodb-ttl", required=True)
    parser.add_argument("--rfc1918", required=True)
    args = parser.parse_args()

    config = ConfigParser.ConfigParser()
    config.read(args.template)

    config.set('hpfriends', 'ident', args.ident)
    config.set('hpfriends', 'secret', args.secret)
    config.set('hpfriends', 'hp_host', args.hpfeeds_host)
    config.set('hpfriends', 'hp_port', args.hpfeeds_port)
    config.set('hpfriends', 'channels', args.channels)

    config.set('mongodb', 'mongo_host', args.mongodb_host)
    config.set('mongodb', 'mongo_port', args.mongodb_port)
    config.set('mongodb', 'mongo_indexttl', args.mongodb_ttl)

    config.set('normalizer', 'ignore_rfc1918',  args.rfc1918)

    with open(args.config, 'w') as configfile:
        config.write(configfile)
    return 0


if __name__ == "__main__":
    main()