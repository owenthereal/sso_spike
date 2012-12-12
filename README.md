SSO Spike
=========

## DESCRIPTION

A spike to demostrate centralized Single Sign On (SSO) in Rails. We want it to:

* centralized authentication
* SSO

We assume that all web apps are hosted in the same domain with different
subdomains.

## SOLUTION

[OAuth2 draft-10](http://tools.ietf.org/html/draft-ietf-oauth-v2-10)

## SETUP

Use [pow](http://pow.cx/) to setup subdomains like this:

```bash
$ cd ~/.pow
$ ln -s PATH_TO_ACCOUNTS accounts.example.dev
$ ln -s PATH_TO_TODOS todos.example.dev
$ ln -s PATH_TO_ANOTHER_TODOS anothertodos.example.dev
```

Run whatever the standard Rails setup on these 3 projects.

Fun started!
