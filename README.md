vagrant-geodjango-base
===================

Forked from the @torchbox vagrant-django-base project, modified to work with GeoDjango.  

A Vagrant box based on Ubuntu precise32, configured for GeoDjango development. This box makes it simple to get up and running with the [GeoDjango tutorial](https://docs.djangoproject.com/en/1.5/ref/contrib/gis/tutorial/).

* postgresql 9.1 (with locale fixed to create databases as UTF-8)
* PostGIS 2 and tools
* virtualenv and virtualenvwrapper
* dependencies for PIL, the Python Imaging Library

This will build GEOS and PostGIS from source, so your first vagrant up might take a while.  Port 8000 forwards to 4567 by default.

Getting Started
------------------
This section will take you from cloning the repository to being able to start working on the official [GeoDjango tutorial](https://docs.djangoproject.com/en/1.5/ref/contrib/gis/tutorial/).

### Vagrant up ###

If you don't have it installed already, [install Vagrant](http://docs.vagrantup.com/v2/installation/index.html) and VirtualBox.

After cloning the repository, `cd` to the repo directory, and type `vagrant up`.  Wait a while.

After the build has completed, `vagrant ssh` to get into your machine

### Setup database ###
To create the database for the tutorial:

```sh
sudo su - postgres
createdb geodjango
```
Now, we add the spatial extensions to the "world" database via:

```
psql geodjango
CREATE EXTENSION postgis;
\q
exit
```

### Setup Django Project ###

Now, we have a fairly typical Django project to setup:

```
mkvirtualenv geodjango
workon geodjango
pip install django
pip install psycopg2
```

You are now ready to pick up the GeoDjango tutorial [here](https://docs.djangoproject.com/en/1.5/ref/contrib/gis/tutorial/#create-a-new-project).  You will use 'postgres' as the DB user in the settings, with an empty password, like so:

```python
DATABASES = {
    'default': {
         'ENGINE': 'django.contrib.gis.db.backends.postgis',
         'NAME': 'geodjango',
         'USER': 'postgres',
     }
}
```

Be sure to start the server like so:

```sh
python manage.py runserver 0.0.0.0:8000
```
The default server will bind to the loopback interface, adding the argument will allow it to bind to all interfaces.

Enjoy!


Build instructions
------------------
To generate the .box file:

    ./build.sh

To install locally:

    vagrant box add django-base-v2 django-base-v2.box
