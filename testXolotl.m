% test script for xolotl, to be run on virtual machines

kapalin.init()

kapalin.get('https://github.com/sg-s/srinivas.gs_mtools')
kapalin.get('https://github.com/sg-s/xolotl')
kapalin.get('https://github.com/sg-s/cpplab')
kapalin.get('https://github.com/sg-s/puppeteer')

kapalin.test('xolotl')
