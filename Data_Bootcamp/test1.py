"""

Data Bootcamp test program checks to see that we're running Python 3.

Written by Dave Backus, March 2015

Created with Python 3.4

"""

a = 'some'

b = 'thing'

c = a + b

print('c =', c)

#%%

x = 2

y = 3

z = x/y

print('z =', z)

#%%

# everything that appears after this symbol is a comment!

# comments help PEOPLE understand the code, but PYTHON ignores them!

# we're going to add 4 and 5

4 + 5

# here we're doing it

print(4+5)

# here we're printing it

#%%

f = "I don't believe it"

print(f)

#%%
longstring = """

Four score and seven years ago

Our fathers brought forth. """

print(longstring)

bad_string = "Sarah's code"

print(bad_string)

#%%

numberlist = [1, 5, -3]

stringlist = ['hi', 'hello', 'hey']

a = 'some'

b = 'thing'

c = a + b

variablelist = [a, b, c]

randomlist = [1, "hello", a]

biglist = numberlist + stringlist

print(biglist)

mixedlist = [a, b, c, numberlist]

print(mixedlist)

x = [1, 2, 3]



#%% Changing types


s = '12.34'

f = float(s)

print(type(f))



s = '12'

i = int(s)

print(type(i))


s = str(12)

print('s has type', type(s))

t = str(12.34)

print('t has type', type(f))


 