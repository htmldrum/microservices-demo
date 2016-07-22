[![Build Status](https://travis-ci.org/mongrelion/ansible-role-weave.svg?branch=master)](https://travis-ci.org/mongrelion/ansible-role-nomad)

weave
=========

Install [Weave](https://www.weave.works/)

Requirements
------------

Docker must be installed.

Role Variables
--------------

None

Dependencies
------------

None

Example Playbook
----------------
```
- hosts: servers
  roles:
     - mongrelion.weave
```

And here is an example on how ensure that weave is running
```
- hosts: servers
  roles:
    - mongrelion.weave
  tasks:
    - name: check for weave state
      command: docker ps -q -f name=weave
      register: check

    - name: ensure weave is running
      command: weave launch
      when: check.stdout_lines | length == 0
```
License
-------

MIT

Author Information
------------------

You can find me on Twitter: [@mongrelion](https://twitter.com/mongrelion)
