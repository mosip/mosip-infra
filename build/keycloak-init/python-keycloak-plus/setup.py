# -*- coding: utf-8 -*-

from setuptools import setup

with open("README.md", "r") as fh:
    long_description = fh.read()

setup(
    name='python-keycloak-plus',
    version='0.0.24',
    url='https://bitbucket.org/umedef/python-keycloak-plus',
    license='The MIT License',
    author='Ume Def',
    author_email='umedef@gmail.com',
    keywords='keycloak openid',
    description=u'python-keycloak-plus is a Python package providing access to the Keycloak API. Based on python-keycloak library',
    long_description=long_description,
    packages=['keycloak', 'keycloak.authorization', 'keycloak.tests'],
    install_requires=['requests>=2.18.4', 'python-jose>=1.4.0'],
    tests_require=['httmock>=1.2.5'],
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Development Status :: 3 - Alpha',
        'Operating System :: MacOS',
        'Operating System :: Unix',
        'Operating System :: Microsoft :: Windows',
        'Topic :: Utilities'
    ]
)
