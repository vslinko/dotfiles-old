import os
from fabric.api import *


# ensure relative paths will work
os.chdir(os.path.dirname(__file__))


@task(default=True)
def host():
    # start setup under root user
    with settings(user="root", no_keys=True):
        # update packages index
        run("aptitude update")

        # upgrade system
        sudo("aptitude upgrade -y")

        # install missing packages
        run("aptitude install -y sudo zsh git")

        # allow sudo for root user, admin group, and sudo group
        # sudo group can use sudo without password
        put("templates/sudoers", "/etc/sudoers", use_sudo=False, mode=0o440)

        # create my user with zsh and sudo group
        run("useradd -ms /bin/zsh -G sudo vyacheslav")

        # upload authorization key
        keys()

        # fix ownership
        run("chown vyacheslav:vyacheslav -R /home/vyacheslav/.ssh")

    # continue under my user
    # update dotfiles
    dotfiles()

    # disable root password
    sudo("passwd -d root")


@task
def keys():
    with cd("/home/vyacheslav"):
        run("rm -rf .ssh")
        run("mkdir -m 0700 .ssh")
        put("templates/vyacheslav", ".ssh/authorized_keys", use_sudo=False, mode=0o400)


@task
def dotfiles():
    with cd("/home/vyacheslav"):
        run("git init")
        run("git remote add origin git://github.com/vslinko/dotfiles.git")
        run("git pull -u origin master")
        run("git submodule update --init")
