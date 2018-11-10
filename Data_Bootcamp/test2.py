x = 5

# we can change this later and see what happens

if x > 6:
    print('x =', x)

print('Done!')


#%%

x = 4

condition = x > 6

if condition:
    print('if branch')
    print(condition)
else:
    print('else branch')
    print(condition)
    
    
name1 = 'Dave'
name2 = 'Glenn'

i_name1 = name1[:1]
i_name2 = name2[:1]

if i_name1>i_name2:
    print(name2)
else:
    print(name1)
    
    

#%%

c = 'something'

print('c[1] is', c[1])

print('c[1:2] is', c[1:2])

print('c[1:3] is', c[1:3])

print('c[1:] is', c[1:])

#%%

lastname='Python'

extract=lastname[2:]

numlist = [1, 7, 4, 3]

middle = numlist[1:3]

allbutfirst=numlist[1:]

allbutlast=numlist[:3]

c = 'something'

print(c[:3]+c[3:])


#%%

namelist = ['Chase', 'Dave', 'Sarah', 'Spencer']

# below, the word "item" is arbitrary. End the line with a colon

for dog in namelist:
    print(dog)
    
    
#    
numlist = [4, -2, 5]

total = 0

for num in numlist:
    total = total + num

print(total)


word= 'anything'
for letter in word:
    print(letter)


vowels = 'aeiouy'

word = 'anything'

for letter in word:
    if letter in vowels:
        print(letter)



for letter in word:
    if letter not in vowels:
        print(letter)

#

stuff = ['cat', 3.7, 5, 'dog']

for list in stuff:
    print(list)
    print(type(list))
    
for list in stuff:
    if type(list) == str:
        print(list)
  
    
#%%

for number in range(5):
    print(number)   
    
for number in range(2,5):
    print(number)
    
for number in range(5):
    square=number**2
    print('Number and its square:', number, square)
    
for num in range(10):
    if num > 5:
        print(num)  
    
#%%

maxnum=100

total=0

for num in range(maxnum):
    total=total+num
    if total > 100:
        break

print('At num =', num, 'we had total =', total)


#%%

namelist = ['Chase', 'Dave', 'Sarah', 'Spencer']

for list in namelist:
    if list[1]=='S':
            break
print(list)
            
#%%

maturity = 20

coupon = 2

ytm = 0.05

# yield to maturity

price = 0

for year in range(1, maturity+1):
    price = price + coupon/(1+ytm)**year
    price = price + 100/(1+ytm)**maturity

print('The price of the bond is', price)


#%% List comprehension

namelist = ['Chase', 'Dave', 'Sarah', 'Spencer']

for item in namelist:
    print(item)
    


def hello(firstname):
    print('Hello,', firstname)
    
hello('Chase')




def double2(n):
    return 2**n

def yearstr(n):
    return str(int(n)+1)

