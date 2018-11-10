import sys # import system module (don't ask)

print('\nWhat version of Python?\n', sys.version, '\n', sep='')

if float(sys.version_info[0]) < 3.0:
    raise Exception('Program halted, old version of Python. \n', 'Sorry, you need to install Anaconda again.')
else:
    print('Congratulations, you have Python 3!')

