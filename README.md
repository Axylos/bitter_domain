# BitterDomain
A Ruby gem for generating domains 1 bit away from a source domain and checking the availability of the generated domains.

### DISCLAIMER###
This project is for *research purposes only*.  So don't use it for malicious nonsense or send nasty stuff in response to legitimate HTTP requests.  If you want to actually register one of these generated domains and set up a server to listen for requests, sending a `404` to all incoming requests if probably a good idea.

### Description
A Ruby gem for generating domains 1 bit away from a source domain and checking the availability of the generated domains.
This project was inspired from a series of Defcon presentations on `bit squatting`.

[The original video](https://www.youtube.com/watch?v=aT7mnSstKGs)
[A second presentation further exploring the vulnerability](https://www.youtube.com/watch?v=IhwE1S4x36s)

`Bit squatting` is a close cousin to `typo squatting`, viz., a user makes a typo when entering a common url in a browser address bar and unintentionally makes a request to a domain including the typo that a malicious user has registered.  Rather than typos, bit squatting leverages common hardware errors (bit errors) that yield domains that are _1 bit off from the source domain_, e.g., `instagram.com` -> `instagbam.com`.  According to the videos above, these errors generate a very high number of potential requests sent to domains with the aforementioned pathological structure.

To exploit this vulnerability, an attacker may generate a list of domains 1 bit off from common domains, then register the "bit-flipped" domains, and finally spin up a web server to send responses to these requests from users who intended to make a request to the common source domain but have been routed to the "bit squatted" domain.

`BitterDomain` is a gem for generating bit-flipped domains.  It does not include a server or other logging utilities.  I wrote a small go server for tracking incoming HTTP requests and headers.  After registering around 5 domains for flipped versions of facebook's cdn and instagram api domains, I received 3-4 _highly probable_ requests that were intended to be sent to facebook.  A high amount of garbage also came in, but that's sufficient evidence for me to conclude that the vulnerability is still exploitable, at least with a minimal amount of set up.

`whois` and `whois-parser` are used for checking the DNS availability of the generated domains.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitter_domain'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitter_domain

## Usage

#### CLI

`BitterDomain` comes with an executable:

```bash
$ bitter_domain --url <source domain>
```

where `source domain` could be something like `google.com` or `apopulardomain.net`.  Notice that subdomains or protocols are unnecessary, since all that is required is the domain name and extension.

The default command prints out a list of available domains that are 1 bit removed from the source url. 

*This may take a few minutes*.  All of the calls to `whois` servers can take some time.

The CLI accepts flags for verbose output or the flips only without checking their availability.

```
Usage:
  bitter_domain get a list of bit flipped domains -u, --url=URL

Options:
  -r, [--retry], [--no-retry]            # retry any domain that errored out; usually due to a connection reset
  -s, [--flips-only], [--no-flips-only]  # limit output to just flips
  -u, --url=URL                          # url to generate shifts for
  -v, [--verbose=VERBOSE]                # print verbose output

```

#### Require

Or require the gem with
```ruby
require "bitter_domain"
```

And instantiate a mapper like so:

```ruby
mapper = BitterDomain::DomainMapper.new("google.com")
```

`DomainMapper` includes a few instance methods for generating and testing domains
- `#gen_shifts` will generate and return a list of shifted domains
- `#print_shifts` will print out just the shifted domains
- `#check_domains` will test the availability of the shifted domains using `whois`
- `#print_verbose` and `#print_availabile` are two little output printers for the tested/available domains


## PS

#### HAVE FUN AND DON'T BE A JERK



## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
